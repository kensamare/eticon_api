import 'package:dio/dio.dart' as d;
import 'package:eticon_api/src/api_errors.dart';
import 'package:eticon_api/src/flutter_eticon_api.dart';
import 'package:eticon_api/src/logger.dart';
import 'package:eticon_api/src/token.dart';
import 'package:eticon_api/src/old_api/type.dart';
import 'dart:convert';
import 'dart:developer';

///Api singleton
class DioApiST {
  ///Named constructor
  DioApiST._();

  ///Init singleton
  static DioApiST instance = DioApiST._();

  ///Init state of API class
  static bool _init = false;

  static d.Dio dio = d.Dio();

  static String _authTitle = 'Authorization';

  static Function(APIException error)? _onAllError;

  ///Base url int singletons
  static List<String> _urls = [];

  ///User print in logs
  static bool _usePrint = false;

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

  set usePrint(bool t) => _usePrint = t;

  set onAllError(Function(APIException)? t) => _onAllError = t;

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
  void setBaseUrl(List<String> urls) {
    _urls = urls;
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
  Future<dynamic> request({
    required String type,
    String? baseUrl,
    String? method,
    bool isAuth = false,
    Map<String, String>? headers,
    bool testMode = false,
    int urlIndex = 0,
    ResponseType responseType = ResponseType.map_data,
    d.CancelToken? cancelToken,
    dynamic data,
    Map<String, dynamic>? queries,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
    bool ignoreOnAllError = false,
  }) async {
    String testModeType = type.toString().replaceAll('TYPE.', '');

    ///Генерация параметров
    if (type == 'GET' || type == 'DELETE') {
      if (data != null && data is Map && (testMode || _globalTestMode) && !_disableState) {
        Logger.log(data.toString(), name: 'API TEST $testModeType: Query List', printMode: _usePrint);
      }
    } else if ((testMode || _globalTestMode) && !_disableState && data is Map) {
      Logger.log(jsonEncode(data).toString(), name: 'API TEST $testModeType: Body in JSON', printMode: _usePrint);
    }
    //Формирование ссылки запроса
    String url = '${baseUrl == null ? '${_urls[urlIndex]}$method' : baseUrl}';
    // Делаем запрос
    try {
      Map<String, String> allHeaders;
      allHeaders = isAuth ? getAuthHeader(token: Token.instance.token) : getNoAuthHeader;
      allHeaders.addAll(headers ?? {});
      if ((testMode || _globalTestMode) && !_disableState) {
        if (isAuth) {
          Logger.log(Token.instance.token.toString(), name: 'API TEST $testModeType: Token', printMode: _usePrint);
        }
        Logger.log(allHeaders.toString(), name: 'API TEST $testModeType: Headers', printMode: _usePrint);
      }
      d.ResponseType? responseTypeFinal;
      if (responseType != ResponseType.map_data) {
        responseTypeFinal = d.ResponseType.values[responseType.index];
      }
      d.Response response = await dio.request(
        url,
        queryParameters: queries,
        data: !(type == 'GET' || type == 'DELETE') ? data : null,
        options: d.Options(headers: allHeaders, responseType: responseTypeFinal, method: type),
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      if ((testMode || _globalTestMode) && !_disableState) {
        Logger.log(response.realUri.toString(), name: 'API TEST $testModeType: URL', printMode: _usePrint);
        Logger.log(response.statusCode.toString(), name: 'API TEST $testModeType: Response Code', printMode: _usePrint);
        if (response.data != null) {
          Logger.log(response.data.toString(), name: 'API TEST $testModeType: Response Body', printMode: _usePrint);
        }
      }
      if (responseType == ResponseType.map_data) {
        try {
          if (response.data is! Map<String, dynamic>) {
            if (response.data is String) {
              Map<String, dynamic> result = {};
              if (response.data.toString().isEmpty) {
                return result;
              }
              String responseBody;
              if (_enableUtf8Decoding) {
                responseBody = utf8.decode(response.data.runes.toList());
              } else {
                responseBody = response.data;
              }
              result = jsonDecode(responseBody);
              print(response.data);
              if (response.data[0] != '{') {
                result['key'] = json;
              }
              return result;
            } else {
              return {'key': response.data};
            }
          } else {
            return response.data;
          }
        } catch (e) {
          return response.data;
        }
      }
      return response;
    } on d.DioError catch (error) {
      if ((testMode || _globalTestMode) && !_disableState) {
        if (error.response != null) {
          Logger.log(error.response!.realUri.toString(), name: 'API TEST $testModeType: URL', printMode: _usePrint);
          Logger.log(error.response!.statusCode.toString(),
              name: 'API TEST $testModeType: Response Code', printMode: _usePrint);
          if (error.response!.data != null) {
            Logger.log(error.response!.data.toString(),
                name: 'API TEST $testModeType: Response Body', printMode: _usePrint);
          }
        }
      }
      if (_onAllError != null && !ignoreOnAllError) {
        _onAllError!(APIException.fromDio(error));
      }
      throw APIException.fromDio(error);
    }
  }
}
