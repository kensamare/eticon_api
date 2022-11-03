import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import 'dart:convert';
import 'dart:developer';

import 'api_errors.dart';
import 'token.dart';
import 'type.dart';

///Api singleton
class ApiST {
  ///Named constructor
  ApiST._();

  ///Init singleton
  static ApiST instance = ApiST._();

  ///Init state of API class
  static bool _init = false;

  static String _authTitle = 'Authorization';

  ///Base url int singletons
  static List<String> _urls = [];

  ///Storage url int singletons
  static String? _storageUrl;

  ///Bearer authentication
  static bool _bearerAuth = true;

  ///Headers
  static Map<String, String>? _headers;

  ///Enable or disable global test mode for all
  static bool _globalTestMode = false;

  ///Disable state of test mode
  static bool _disableState = false;

  ///Enable utf-8 decoding
  static bool _enableUtf8Decoding = false;

  ///Set Init State
  bool setInitState() {
    if (_init) {
      return false;
    }
    _init = true;
    return true;
  }

  bool get initState => _init;

  ///Set Bearer token mode
  void setBearerMode(bool mode) {
    _bearerAuth = mode;
  }

  ///Enable utf-8 decoding
  void enableUtf8Decoding(bool decoding) {
    _enableUtf8Decoding = decoding;
  }

  ///Return baseUrl
  List<String> get urls => _urls;

  ///Return storageUrl
  ///Link to the data store, which is needed to get various data
  String? get storageUrl => _storageUrl;

  ///Set Headers
  void setHeaders(Map<String, String> headers) {
    _headers = headers;
  }

  void setAuthTitle(String title) {
    _authTitle = title;
  }

  ///Sets the base URL for processing requests
  void setUrls(List<String> url) {
    _urls = url;
  }

  ///Sets the storage URL for get data
  void setStorageUrl(String url) {
    _storageUrl = url;
  }

  ///Set globalTestMode
  void setGlobalTestMode(bool globalTestMode) {
    _globalTestMode = globalTestMode;
  }

  ///Disable all testMode
  void disableAllTestMode(bool disableState) {
    _disableState = disableState;
  }

  ///Get authorization headers
  static Map<String, String> getAuthHeader({required String token}) {
    String tokenMSG = '${_bearerAuth ? 'Bearer ' : ''}$token';
    if (_headers != null) {
      _headers![_authTitle] = '${_bearerAuth ? 'Bearer ' : ''}$token';
      return _headers!;
    }
    return {"$_authTitle": '$tokenMSG', "Content-type": 'application/json'};
  }

  ///Get no Authorization headers
  static Map<String, String> get getNoAuthHeader {
    if (_headers != null) {
      return _headers!;
    }
    return {"Content-type": 'application/json'};
  }

  ///All Request method
  Future<Map<String, dynamic>> request({
    required TYPE type,
    String? baseUrl,
    required int urlIndex,
    String? method,
    bool isAuth = false,
    Map<String, String>? rawHeaders,
    bool testMode = false,
    Object? query,
  }) async {
    String testModeType = type.toString().replaceAll('TYPE.', '');

    ///Генерация параметров
    List<String> _queryList = [];
    if (type == TYPE.GET || type == TYPE.DEL) {
      if (query != null && query is Map)
        query.forEach((key, value) {
          if (value is List) {
            for (var el in value) _queryList.add('$key=${Uri.encodeComponent(el.toString())}');
          } else
            _queryList.add('$key=${Uri.encodeComponent(value.toString())}');
        });
      else if (query != null) {
        _queryList.add(query.toString());
      }
      if ((testMode || _globalTestMode) && !_disableState) {
        log(_queryList.toString(), name: 'API TEST $testModeType: Query List');
      }
    } else {
      if ((testMode || _globalTestMode) && !_disableState) {
        log(jsonEncode(query).toString(), name: 'API TEST $testModeType: Body in JSON');
      }
    }
    //Формирование ссылки запроса
    Uri url = Uri.parse('${baseUrl == null ? '${_urls[urlIndex]}$method' : baseUrl}' +
        '${(type == TYPE.GET || type == TYPE.DEL) && _queryList.isNotEmpty ? '?${_queryList.join("&")}' : ''}');
    if ((testMode || _globalTestMode) && !_disableState) log(url.toString(), name: 'API TEST $testModeType: URL');
    // Делаем запрос
    Response response;
    // if ((testMode || _globalTestMode) && !_disableState) {
    try {
      Map<String, String> headers;
      if (rawHeaders == null) {
        headers = isAuth ? getAuthHeader(token: Token.instance.token) : getNoAuthHeader;
      } else {
        headers = rawHeaders;
      }
      if ((testMode || _globalTestMode) && !_disableState) {
        if (isAuth) {
          log(Token.instance.token.toString(), name: 'API TEST $testModeType: Token');
        }
        log(headers.toString(), name: 'API TEST $testModeType: Headers');
      }
      switch (type) {
        case TYPE.GET:
          response = await http.get(url, headers: headers);
          break;
        case TYPE.POST:
          response = await http.post(url, headers: headers, body: query is Map ? jsonEncode(query) : query);
          break;
        case TYPE.DEL:
          response = await http.delete(url, headers: headers);
          break;
        case TYPE.PUT:
          response = await http.put(url, headers: headers, body: query is Map ? jsonEncode(query) : query);
          break;
        case TYPE.PATCH:
          response = await http.patch(url, headers: headers, body: query is Map ? jsonEncode(query) : query);
          break;
      }
      if ((testMode || _globalTestMode) && !_disableState) {
        log(response.statusCode.toString(), name: 'API TEST $testModeType: Response Code');
        if (response.body.isNotEmpty) {
          String responseBody;
          if (_enableUtf8Decoding) {
            responseBody = utf8.decode(response.body.runes.toList());
          } else {
            responseBody = response.body;
          }
          if (response.body[0] != '{') {
            log(responseBody, name: 'API TEST $testModeType: Response Body');
          } else {
            log(json.decode(responseBody).toString(), name: 'API TEST $testModeType: Response Body');
          }
        }
      }
    } catch (error) {
      throw APIException(0, body: error);
      // if (error is SocketException) {
      //   if (error.osError != null) if (error.osError!.errorCode == 7) {
      //     throw APIException(0, body: 'No Internet connection');
      //   }
      // }
      // throw APIException(1, body: error.toString());
    }
    // Если все не ок то отправляем код ответа http
    if (!response.statusCode.toString().startsWith('20')) {
      throw APIException(response.statusCode, body: response.body);
    }
    if (response.body.isNotEmpty) {
      var responseParams;
      try {
        if (_enableUtf8Decoding) {
          responseParams = json.decode(utf8.decode(response.body.runes.toList()));
        } else {
          responseParams = json.decode(response.body);
        }
      } catch (e) {
        responseParams = response.body;
      }
      // Проверка на Map
      if (responseParams is! Map) {
        if ((testMode || _globalTestMode) && !_disableState) {
          log('Response body is not a MAP, convert to {\'key\': response.body}',
              name: 'API TEST $testModeType: MAP Status');
        }
        Map<String, dynamic> res = {'key': responseParams};
        return res;
      } else {
        return Map<String, dynamic>.from(responseParams);
      }
    }
    return {};
  }
}
