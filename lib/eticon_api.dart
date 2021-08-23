library eticon_api;

import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/api_errors.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  ///Initialization API class
  static void init(
      {required String baseUrl,
      bool globalTestMode = false,
      bool bearerToken = true,
      disableAllTestMode = false,
      bool enableUtf8Decoding = false}) {
    if (!_ApiST.instance.setInitState(true)) {
      throw EticonApiError(error: 'API class already initialization');
    }
    if (baseUrl.isEmpty) {
      throw EticonApiError(error: 'URL is empty');
    }
    if (!baseUrl.startsWith('https') || !baseUrl.startsWith('http'))
      throw EticonApiError(error: 'The url should start with https or http');
    if (baseUrl[baseUrl.length - 1] != '/') baseUrl += '/';
    _ApiST.instance.setBaseUrl(baseUrl);
    _ApiST.instance.setGlobalTestMode(globalTestMode);
    _ApiST.instance.disableAllTestMode(disableAllTestMode);
    _ApiST.instance.enableUtf8Decoding(enableUtf8Decoding);
    _ApiST.instance.setBearerMode(bearerToken);
  }

  ///Checks token storage for emptiness
  static bool tokenIsNotEmpty() {
    if (_Token.instance.token != null) {
      if (_Token.instance.token!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  ///Set headers. Default is only "Content-type": application/json
  static void setHeaders(Map<String, String> headers) {
    _ApiST.instance.setHeaders(headers);
  }

  ///Loads a token from device memory, return true if the token is in memory, else return false;
  static Future<bool> loadTokenFromMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      _Token.instance.setToken(token);
      return true;
    }
    return false;
  }

  ///Return Authorization token
  static String? get token => _Token.instance.token;

  ///Set Authorization token
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _Token.instance.setToken(token);
  }

  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> get(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    if (_ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (_Token.instance.token == null) {
        throw EticonApiError(
            error:
                'Authentication token is not set, use Api.setToken (String url)');
      }
      if (_Token.instance.token!.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await _ApiST.instance.getRequest(
        method: method, isAuth: isAuth, testMode: testMode, query: query);
  }

  /// Sends an HTTP POST request.
  static Future<Map<String, dynamic>> post(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    if (_ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (_Token.instance.token == null) {
        throw EticonApiError(
            error:
                'Authentication token is not set, use Api.setToken (String url)');
      }
      if (_Token.instance.token!.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await _ApiST.instance.postRequest(
        method: method, isAuth: isAuth, testMode: testMode, body: body);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> put(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    if (_ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (_Token.instance.token == null) {
        throw EticonApiError(
            error:
                'Authentication token is not set, use Api.setToken (String url)');
      }
      if (_Token.instance.token!.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await _ApiST.instance.putRequest(
        method: method, isAuth: isAuth, testMode: testMode, body: body);
  }

  /// Sends an HTTP DELETE request.
  static Future<Map<String, dynamic>> delete(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    if (_ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init(String url)');
    }
    if (isAuth) {
      if (_Token.instance.token == null) {
        throw EticonApiError(
            error:
                'Authentication token is not set, use Api.setToken (String url)');
      }
      if (_Token.instance.token!.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await _ApiST.instance.deleteRequest(
        method: method, isAuth: isAuth, testMode: testMode, query: query);
  }
}

///Token singleton
class _Token {
  ///Named constructor
  _Token._();

  ///Init singleton
  static _Token instance = _Token._();

  ///Private token
  static String? _t;

  ///Get token
  String? get token => _t;

  ///Set token
  void setToken(String t) {
    _t = t;
  }
}

///Api singleton
class _ApiST {
  ///Named constructor
  _ApiST._();

  ///Init singleton
  static _ApiST instance = _ApiST._();

  ///Init state of API class
  static bool _init = false;

  ///Base url int singletons
  static String? _baseUrl;

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

  bool setInitState(bool initState) {
    if (_init) {
      return false;
    }
    _init = true;
    return true;
  }

  ///Set Bearer token mode
  void setBearerMode(bool mode) {
    _bearerAuth = mode;
  }

  ///Enable utf-8 decoding
  void enableUtf8Decoding(bool decoding) {
    _enableUtf8Decoding = decoding;
  }

  ///Set base url int singletons
  String? get baseUrl => _baseUrl;

  ///Set Headers
  void setHeaders(Map<String, String> headers) {
    _headers = headers;
  }

  ///Sets the base URL for processing requests
  void setBaseUrl(String url) {
    _baseUrl = url;
  }

  ///Set globalTestMode
  void setGlobalTestMode(bool globalTestMode) {
    _globalTestMode = globalTestMode;
  }

  ///Disable all testMode
  void disableAllTestMode(bool disableState) {
    _disableState = disableState;
  }

  ///Get no authorization headers
  static Map<String, String> getAuthHeader({required String token}) {
    String tokenMSG = '${_bearerAuth ? 'Bearer ' : ''}$token';
    if (_headers != null) {
      _headers!["Authorization"] = '${_bearerAuth ? 'Bearer ' : ''}$token';
      return _headers!;
    }
    return {"Authorization": '$tokenMSG', "Content-type": 'application/json'};
  }

  ///Get Authorization headers
  static Map<String, String> get getNoAuthHeader {
    if (_headers != null) {
      return _headers!;
    }
    return {"Content-type": 'application/json'};
  }

  // Метод get

  ///Method HTTP GET
  Future<Map<String, dynamic>> getRequest(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    // Генерация списка параметром
    List<String> _queryList = [];
    if (query != null)
      query.forEach((key, value) {
        if (value is List) {
          for (var el in value) _queryList.add('$key=$el');
        } else
          _queryList.add('$key=$value');
      });
    if ((testMode || _globalTestMode) && !_disableState) {
      log(_queryList.toString(), name: 'API TEST GET: Query List');
    }
    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method?${_queryList.join("&")}');
    if ((testMode || _globalTestMode) && !_disableState)
      log(url.toString(), name: 'API TEST GET: URL');
    // Делаем запрос
    Response response;
    if ((testMode || _globalTestMode) && !_disableState) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST GET: Token');
        log(getAuthHeader(token: _Token.instance.token!).toString(),
            name: 'API TEST GET: Auth Header');
        response = await http.get(url,
            headers: getAuthHeader(token: _Token.instance.token!));
        // log(response.body);
      } else {
        response = await http.get(url, headers: getNoAuthHeader);
      }
      log(response.statusCode.toString(), name: 'API TEST GET: Response Code');
      String responseBody;
      if (_enableUtf8Decoding) {
        responseBody = utf8.decode(response.body.runes.toList());
      } else {
        responseBody = response.body;
      }
      if (response.body[0] == '{') {
        log(responseBody, name: 'API TEST GET: Response Body');
      } else {
        log(json.decode(responseBody).toString(),
            name: 'API TEST GET: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          response = await http.get(url,
              headers: getAuthHeader(token: _Token.instance.token!));
        } else {
          response = await http.get(url, headers: getNoAuthHeader);
        }
      } catch (err) {
        // Отсутствие интернета
        print(err);
        throw APIException(0);
      }
    }
    // Если все не ок то отправляем код ответа http
    if (response.statusCode != 200) {
      throw APIException(response.statusCode);
    }
    var responseParams;
    if (_enableUtf8Decoding) {
      responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    } else {
      responseParams = json.decode(response.body);
    }
    // Проверка на Map
    if (responseParams is! Map) {
      if ((testMode || _globalTestMode) && !_disableState) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST GET: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }

  ///Method HTTP POST
  Future<Map<String, dynamic>> postRequest(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method');
    // log(url.toString(), name: 'URL');
    if ((testMode || _globalTestMode) && !_disableState)
      log(url.toString(), name: 'API TEST POST: URL');
    // Делаем запрос
    Response response;
    if ((testMode || _globalTestMode) && !_disableState) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST POST: Token');
        log(getAuthHeader(token: _Token.instance.token!).toString(),
            name: 'API TEST POST: Auth Header');
        log(jsonEncode(body).toString(), name: 'API TEST POST: Body in JSON');
        response = await http.post(url,
            headers: getAuthHeader(token: _Token.instance.token!),
            body: jsonEncode(body));
      } else {
        log(getNoAuthHeader.toString(), name: 'API TEST POST: NO Auth Header');
        log(jsonEncode(body).toString(), name: 'API TEST POST: Body in JSON');
        response = await http.post(url,
            body: jsonEncode(body), headers: getNoAuthHeader);
        // log(jsonEncode(body));
        // log(response.body);
      }
      log(response.statusCode.toString(), name: 'API TEST POST: Response Code');
      String responseBody;
      if (_enableUtf8Decoding) {
        responseBody = utf8.decode(response.body.runes.toList());
      } else {
        responseBody = response.body;
      }
      if (response.body[0] == '{') {
        log(responseBody, name: 'API TEST GET: Response Body');
      } else {
        log(json.decode(responseBody).toString(),
            name: 'API TEST GET: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          response = await http.post(url,
              headers: getAuthHeader(token: _Token.instance.token!),
              body: jsonEncode(body));
        } else {
          response = await http.post(url,
              body: jsonEncode(body), headers: getNoAuthHeader);
        }
      } catch (err) {
        throw APIException(0);
      }
    }

    // Если все не ок то отправляем код ответа http
    if (response.statusCode != 200) {
      throw APIException(response.statusCode);
    }
    var responseParams;
    if (_enableUtf8Decoding) {
      responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    } else {
      responseParams = json.decode(response.body);
    }
    // Проверка на Map
    if (responseParams is! Map) {
      if ((testMode || _globalTestMode) && !_disableState) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST POST: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }

  ///Method HTTP PUT
  Future<Map<String, dynamic>> putRequest(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method');
    if ((testMode || _globalTestMode) && !_disableState)
      log(url.toString(), name: 'API TEST PUT: URL');
    // Делаем запрос
    Response response;
    if ((testMode || _globalTestMode) && !_disableState) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST PUT: Token');
        log(getAuthHeader(token: _Token.instance.token!).toString(),
            name: 'API TEST PUT: Auth Header');
        response = await http.put(url,
            headers: getAuthHeader(token: _Token.instance.token!),
            body: jsonEncode(body));
        // log('Ответ put ${response.statusCode} - ${response.body}');
      } else {
        log(getNoAuthHeader.toString(), name: 'API TEST PUT: NO Auth Header');
        response = await http.put(url,
            body: jsonEncode(body), headers: getNoAuthHeader);
      }
      log(jsonEncode(body).toString(), name: 'API TEST PUT: Body in JSON');
      log(response.statusCode.toString(), name: 'API TEST PUT: Response Code');
      String responseBody;
      if (_enableUtf8Decoding) {
        responseBody = utf8.decode(response.body.runes.toList());
      } else {
        responseBody = response.body;
      }
      if (response.body[0] == '{') {
        log(responseBody, name: 'API TEST GET: Response Body');
      } else {
        log(json.decode(responseBody).toString(),
            name: 'API TEST GET: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          response = await http.put(url,
              headers: getAuthHeader(token: _Token.instance.token!),
              body: jsonEncode(body));
        } else {
          response = await http.put(url,
              body: jsonEncode(body), headers: getNoAuthHeader);
        }
      } catch (err) {
        // Отсутствие интернета
        throw APIException(0);
      }
    }

    // Если все не ок то отправляем код ответа http
    if (response.statusCode != 200) {
      throw APIException(response.statusCode);
    }

    // Десериализация json
    //var responseParams = json.decode(response.body);
    var responseParams;
    if (_enableUtf8Decoding) {
      responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    } else {
      responseParams = json.decode(response.body);
    }
    // Проверка на Map
    if (responseParams is! Map) {
      if ((testMode || _globalTestMode) && !_disableState) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST PUT: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }

  ///Method HTTP DELETE
  Future<Map<String, dynamic>> deleteRequest(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    // Генерация списка параметром
    List<String> _queryList = [];
    if (query != null)
      query.forEach((key, value) {
        if (value is List) {
          for (var el in value) _queryList.add('$key=$el');
        } else
          _queryList.add('$key=$value');
      });
    if ((testMode || _globalTestMode) && !_disableState)
      log(_queryList.toString(), name: 'API TEST DELETE: Query List');

    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method?${_queryList.join("&")}');
    if ((testMode || _globalTestMode) && !_disableState)
      log(url.toString(), name: 'API TEST DELETE: URL');
    // Делаем запрос
    Response response;
    if ((testMode || _globalTestMode) && !_disableState) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST DELETE: Token');
        log(getAuthHeader(token: _Token.instance.token!).toString(),
            name: 'API TEST DELETE: Auth Header');
        response = await http.delete(url,
            headers: getAuthHeader(token: _Token.instance.token!));
      } else {
        log(getAuthHeader(token: _Token.instance.token!).toString(),
            name: 'API TEST DELETE: Auth Header');
        response = await http.delete(url, headers: getNoAuthHeader);
      }
      log(response.statusCode.toString(),
          name: 'API TEST DELETE: Response Code');
      String responseBody;
      if (_enableUtf8Decoding) {
        responseBody = utf8.decode(response.body.runes.toList());
      } else {
        responseBody = response.body;
      }
      if (response.body[0] == '{') {
        log(responseBody, name: 'API TEST GET: Response Body');
      } else {
        log(json.decode(responseBody).toString(),
            name: 'API TEST GET: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          response = await http.delete(url,
              headers: getAuthHeader(token: _Token.instance.token!));
        } else {
          response = await http.delete(url, headers: getNoAuthHeader);
        }
      } catch (err) {
        // Отсутствие интернета
        throw APIException(0);
      }
    }

    // Если все не ок то отправляем код ответа http
    if (response.statusCode != 200) {
      throw APIException(response.statusCode);
    }

    // Десериализация json
    var responseParams;
    if (_enableUtf8Decoding) {
      responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    } else {
      responseParams = json.decode(response.body);
    }
    // Проверка на Map
    if (responseParams is! Map) {
      if ((testMode || _globalTestMode) && !_disableState) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST DELETE: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }
}
