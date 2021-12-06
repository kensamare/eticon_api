import 'package:get_storage/get_storage.dart';

import 'api_errors.dart';
import 'api_st.dart';
import 'token.dart';
import 'type.dart';

class Api {
  ///Initialization API class
  static Future<void> init(
      {required String baseUrl,
      bool globalTestMode = false,
      bool bearerToken = true,
      disableAllTestMode = false,
      bool enableUtf8Decoding = false,
      String? storageUrl}) async {
    if (!ApiST.instance.setInitState()) {
      throw EticonApiError(error: 'API class already initialization');
    }
    if (baseUrl.isEmpty) {
      throw EticonApiError(error: 'URL is empty');
    }
    if (!baseUrl.startsWith('http'))
      throw EticonApiError(error: 'The url should start with https or http');
    if (baseUrl[baseUrl.length - 1] != '/') baseUrl += '/';
    await GetStorage.init();

    ///LoadTokenFromMemory now here
    String token = GetStorage().read('ApiEticonMainAuthToke2312') ?? '';
    if (token.isNotEmpty) {
      Token.instance.setToken(token);
    }
    ApiST.instance.setBaseUrl(baseUrl);
    ApiST.instance.setGlobalTestMode(globalTestMode);
    ApiST.instance.disableAllTestMode(disableAllTestMode);
    ApiST.instance.enableUtf8Decoding(enableUtf8Decoding);
    ApiST.instance.setBearerMode(bearerToken);
    if (storageUrl != null) {
      ApiST.instance.setStorageUrl(storageUrl);
    }
  }

  ///Checks token storage for emptiness
  static bool tokenIsNotEmpty() {
    if (Token.instance.token.isNotEmpty) {
      return true;
    }
    return false;
  }

  static bool tokenIsEmpty() {
    if (Token.instance.token.isEmpty) {
      return true;
    }
    return false;
  }

  ///Help to get url to resource in server storage
  static String dataFromStorage(String path) {
    if (ApiST.instance.storageUrl == null) {
      throw EticonApiError(
          error: 'Storage url is null, set storageUrl in Api.init()');
    } else {
      return '${ApiST.instance.storageUrl}$path';
    }
  }

  ///Set headers. Default is only "Content-type": application/json
  static void setHeaders(Map<String, String> headers) {
    ApiST.instance.setHeaders(headers);
  }

  ///Loads a token from device memory, return true if the token is in memory, else return false;
  // static Future<bool> loadTokenFromMemory() async {
  @Deprecated(
      'Now token automatic load when you use Api.init. ATTENTION! In future version this method will removed')
  static bool loadTokenFromMemory() {
    if (!ApiST.instance.initState) {
      throw EticonApiError(error: 'Need Api.init() before loadTokenFromMemory');
    }
    String token = GetStorage().read('ApiEticonMainAuthToke2312') ?? '';
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      Token.instance.setToken(token);
      return true;
    }
    return false;
  }

  ///Return Authorization token
  static String? get token => Token.instance.token;

  ///Set Authorization token
  // static Future<void> setToken(String token) async {
  static void setToken(String token) {
    if (!ApiST.instance.initState) {
      throw EticonApiError(error: 'Need Api.init() before setToken');
    }
    GetStorage().write('ApiEticonMainAuthToke2312', token);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('token', token);
    Token.instance.setToken(token);
  }

  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> get(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    if (ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await ApiST.instance.request(
        type: TYPE.GET,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: query);
  }

  /// Sends an HTTP POST request.
  static Future<Map<String, dynamic>> post(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    if (ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await ApiST.instance.request(
        type: TYPE.POST,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: body);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> put(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    if (ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await ApiST.instance.request(
        type: TYPE.PUT,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: body);
  }

  /// Sends an HTTP DELETE request.
  static Future<Map<String, dynamic>> delete(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    if (ApiST.instance.baseUrl == null) {
      throw EticonApiError(error: 'Base url not set, use Api.init(String url)');
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        throw EticonApiError(
            error:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await ApiST.instance.request(
        type: TYPE.DEL,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: query);
  }

  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> rawGet(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    return await ApiST.instance.request(
        type: TYPE.GET,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: query);
  }

  /// Sends an HTTP POST request.
  static Future<Map<String, dynamic>> rawPost(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    return await ApiST.instance.request(
        type: TYPE.POST, baseUrl: url, testMode: testMode, query: body);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> rawPut(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      required Map<String, dynamic> body}) async {
    return await ApiST.instance
        .request(type: TYPE.PUT, baseUrl: url, testMode: testMode, query: body);
  }

  /// Sends an HTTP DELETE request.
  static Future<Map<String, dynamic>> rawDelete(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      Map<String, dynamic>? query}) async {
    return await ApiST.instance.request(
        type: TYPE.DEL,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: query);
  }
}
