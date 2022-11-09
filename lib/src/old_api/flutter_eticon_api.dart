import 'package:eticon_api/src/token.dart';
import 'package:eticon_api/src/type.dart';
import 'package:get_storage/get_storage.dart';

import 'api_errors.dart';
import 'api_st.dart';


class OldApi {
  ///Initialization API class
  static Future<void> init(
      {required List<String> urls,
        bool globalTestMode = false,
        bool bearerToken = true,
        disableAllTestMode = false,
        bool enableUtf8Decoding = false,
        bool loadTokenFromMemory = true,
        String? authTitle,
        String? storageUrl}) async {
    if (!ApiST.instance.setInitState()) {
      throw EticonApiError(error: 'API class already initialization');
    }
    if (urls.isEmpty) {
      throw EticonApiError(error: 'URLs list is empty');
    }
    if (!urls[0].startsWith('http')) throw EticonApiError(error: 'The url should start with https or http');
    for (int i = 0; i < urls.length; i++) {
      if (!urls[i].endsWith('/')){
        urls[i] += '/';
      }
    }
    await GetStorage.init();

    ///LoadTokenFromMemory now here
    if (loadTokenFromMemory) {
      String token = GetStorage().read('ApiEticonMainAuthToken2312') ?? '';
      if (token.isNotEmpty) {
        Token.instance.setToken(token);
      }
      token = GetStorage().read('ApiEticonMainRefreshToken2312') ?? '';
      if (token.isNotEmpty) {
        Token.instance.setRefreshToken(token);
      }
      String expireTimeString = GetStorage().read('ApiEticonMainExpireDate2312') ?? '';
      if (expireTimeString.isNotEmpty) {
        DateTime expireTime = DateTime.parse(GetStorage().read('ApiEticonMainExpireDate2312'));
        Token.instance.expireDate = expireTime;
      }
    } else {
      Token.instance.setToken('');
      Token.instance.setRefreshToken('');
    }
    if (authTitle != null) {
      ApiST.instance.setAuthTitle(authTitle);
    }
    ApiST.instance.setUrls(urls);
    ApiST.instance.setGlobalTestMode(globalTestMode);
    ApiST.instance.disableAllTestMode(disableAllTestMode);
    ApiST.instance.enableUtf8Decoding(enableUtf8Decoding);
    ApiST.instance.setBearerMode(bearerToken);
    if (storageUrl != null) {
      ApiST.instance.setStorageUrl(storageUrl);
    }
  }

  // static get baseUrl => ApiST.instance.baseUrl;

  ///Help to get url to resource in server storage
  static String dataFromStorage(String path) {
    if (ApiST.instance.storageUrl == null) {
      throw EticonApiError(error: 'Storage url is null, set storageUrl in Api.init()');
    } else {
      return '${ApiST.instance.storageUrl}$path';
    }
  }

  ///Set headers. Default is only "Content-type": application/json
  static void setHeaders(Map<String, String> headers) {
    ApiST.instance.setHeaders(headers);
  }

  ///Return Authorization token
  static String? get token => Token.instance.token;

  ///Checks token storage for emptiness
  static bool tokenIsNotEmpty() {
    return Token.instance.token.isNotEmpty;
  }

  ///Checks token storage for emptiness
  static bool tokenIsEmpty() {
    return Token.instance.token.isEmpty;
  }

  ///Clear Token
  static void clearToken() => Token.instance.setToken('');

  ///Set Authorization token
  static void setToken(String token) {
    if (!ApiST.instance.initState) {
      throw EticonApiError(error: 'Need Api.init() before setToken');
    }
    GetStorage().write('ApiEticonMainAuthToken2312', token);
    Token.instance.setToken(token);
  }

  ///Return refresh token
  static String? get refreshToken => Token.instance.refreshToken;

  ///Return Authorization token
  static DateTime? get expireDate => Token.instance.expireDate.year == 1970 ? null : Token.instance.expireDate;

  ///Clear Token
  static void clearRefreshToken() => Token.instance.setRefreshToken('');

  ///Checks token storage for emptiness
  static bool refreshTokenIsNotEmpty() {
    return Token.instance.token.isNotEmpty;
  }

  ///Checks token storage for emptiness
  static bool refreshTokenIsEmpty() {
    return Token.instance.token.isEmpty;
  }

  ///Set refresh token
  static void setRefreshToken(String token) {
    if (!ApiST.instance.initState) {
      throw EticonApiError(error: 'Need Api.init() before setRefreshToken');
    }
    GetStorage().write('ApiEticonMainRefreshToken2312', token);
    Token.instance.setRefreshToken(token);
  }

  ///Set refresh token expire in seconds. Fro check you can use Api.isRefreshTokenExpire
  static void setExpire({required int seconds}) {
    if (!ApiST.instance.initState) {
      throw EticonApiError(error: 'Need Api.init() before setRefreshToken');
    }
    Token.instance.setExpire(seconds);
    GetStorage().write('ApiEticonMainExpireDate2312', Token.instance.expireDate.toString());
  }

  ///Check token for expire
  static bool get isTokenExpire => DateTime.now().isAfter(Token.instance.expireDate);

  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> get(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        Map<String, dynamic>? query,
        int urlIndex = 0}) async {
    if (ApiST.instance.urls.isEmpty) {
      throw EticonApiError(error: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        throw EticonApiError(error: 'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await ApiST.instance
        .request(type: TYPE.GET, method: method, isAuth: isAuth, testMode: testMode, query: query, urlIndex: urlIndex);
  }

  /// Sends an HTTP POST request.
  static Future<Map<String, dynamic>> post(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        required Map<String, dynamic> body,
        int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw EticonApiError(error: error);
    }
    return await ApiST.instance
        .request(type: TYPE.POST, method: method, isAuth: isAuth, testMode: testMode, query: body, urlIndex: urlIndex);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> put(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        required Map<String, dynamic> body,
        int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw EticonApiError(error: error);
    }
    return await ApiST.instance
        .request(type: TYPE.PUT, method: method, isAuth: isAuth, testMode: testMode, query: body, urlIndex: urlIndex);
  }

  /// Sends an HTTP DELETE request.
  static Future<Map<String, dynamic>> delete(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        Map<String, dynamic>? query,
        int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw EticonApiError(error: error);
    }
    return await ApiST.instance
        .request(type: TYPE.DEL, method: method, isAuth: isAuth, testMode: testMode, query: query, urlIndex: urlIndex);
  }

  /// Sends an HTTP PATCH request.
  static Future<Map<String, dynamic>> patch(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        required Map<String, dynamic> body,
        int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw EticonApiError(error: error);
    }
    return await ApiST.instance
        .request(type: TYPE.PATCH, method: method, isAuth: isAuth, testMode: testMode, query: body, urlIndex: urlIndex);
  }

  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> rawGet(
      {required String url,
        Map<String, String> headers = const {"Content-type": 'application/json'},
        bool testMode = false,
        Map<String, dynamic>? query,
        int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.GET, baseUrl: url, rawHeaders: headers, testMode: testMode, query: query, urlIndex: urlIndex);
  }

  /// Sends an HTTP POST request.
  static Future<Map<String, dynamic>> rawPost(
      {required String url,
        Map<String, String> headers = const {"Content-type": 'application/json'},
        bool testMode = false,
        required Object body,
        int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.POST, baseUrl: url, rawHeaders: headers, testMode: testMode, query: body, urlIndex: urlIndex);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> rawPut(
      {required String url,
        Map<String, String> headers = const {"Content-type": 'application/json'},
        bool testMode = false,
        required Map<String, dynamic> body,
        int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.PUT, baseUrl: url, rawHeaders: headers, testMode: testMode, query: body, urlIndex: urlIndex);
  }

  /// Sends an HTTP DELETE request.
  static Future<Map<String, dynamic>> rawDelete(
      {required String url,
        Map<String, String> headers = const {"Content-type": 'application/json'},
        bool testMode = false,
        Map<String, dynamic>? query,
        int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.DEL, baseUrl: url, rawHeaders: headers, testMode: testMode, query: query, urlIndex: urlIndex);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> rawPatch(
      {required String url,
        Map<String, String> headers = const {"Content-type": 'application/json'},
        bool testMode = false,
        required Map<String, dynamic> body,
        int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.PATCH, baseUrl: url, rawHeaders: headers, testMode: testMode, query: body, urlIndex: urlIndex);
  }

  static String _checkBeforeRequest(bool isAuth, int index) {
    if (ApiST.instance.urls.isEmpty) {
      return 'Base url not set, use Api.init(String url)';
    }
    if (ApiST.instance.urls.length <= index) {
      return 'The index is greater than the number of urls in the list';
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        return 'Authentication token is empty, use Api.setToken (String url)';
      }
    }
    return '';
  }
}
