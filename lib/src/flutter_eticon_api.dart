import 'package:eticon_api/eticon_api.dart';
import 'package:eticon_api/src/api_errors.dart';
import 'package:eticon_api/src/dio_api_st.dart';
import 'package:eticon_api/src/old_api/api_st.dart';
import 'package:eticon_api/src/token.dart';
import 'package:get_storage/get_storage.dart';

class Api {
  ///Initialization API class
  static Future<void> init(
      {required List<String> urls,
      bool globalTestMode = false,
      bool bearerToken = true,
      disableAllTestMode = false,
      bool enableUtf8Decoding = false,
      bool loadTokenFromMemory = true,
      String? authTitle,
      bool usePrintInLogs = false,
      Function(APIException error)? onAllError,
      String? storageUrl}) async {
    if (!DioApiST.instance.setInitState()) {
      throw APIException(-1, body: 'API class already initialization');
    }
    if (urls.isEmpty) {
      throw APIException(-1, body: 'URLs list is empty');
    }
    if (!urls[0].startsWith('http')) throw APIException(-1, body: 'The url should start with https or http');
    for (int i = 0; i < urls.length; i++) {
      if (!urls[i].endsWith('/')) {
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

    ///Init new Version
    if (authTitle != null) {
      DioApiST.instance.setAuthTitle(authTitle);
    }
    DioApiST.instance.usePrint = usePrintInLogs;
    DioApiST.instance.onAllError = onAllError;
    DioApiST.instance.setBaseUrl(urls);
    DioApiST.instance.setGlobalTestMode(globalTestMode);
    DioApiST.instance.disableAllTestMode(disableAllTestMode);
    DioApiST.instance.enableUtf8Decoding(enableUtf8Decoding);
    DioApiST.instance.setBearerMode(bearerToken);
    if (storageUrl != null) {
      DioApiST.instance.setStorageUrl(storageUrl);
    }

    ///Init OldVersion
    if (authTitle != null) {
      ApiST.instance.setAuthTitle(authTitle);
    }
    ApiST.instance.setUrls(urls);
    ApiST.instance.setGlobalTestMode(globalTestMode);
    ApiST.instance.disableAllTestMode(disableAllTestMode);
    // ApiST.instance.enableUtf8Decoding(enableUtf8Decoding);
    ApiST.instance.setBearerMode(bearerToken);
    if (storageUrl != null) {
      ApiST.instance.setStorageUrl(storageUrl);
    }
  }

  static get urls => DioApiST.instance.urls;

  ///Help to get url to resource in server storage
  static String dataFromStorage(String path) {
    if (DioApiST.instance.storageUrl == null) {
      throw APIException(-1, body: 'Storage url is null, set storageUrl in Api.init()');
    } else {
      return '${DioApiST.instance.storageUrl}$path';
    }
  }

  ///Set headers. Default is only "Content-type": application/json
  static void setHeaders(Map<String, String> headers) {
    DioApiST.instance.setHeaders(headers);
  }

  ///Return Authorization token
  static String? get token => Token.instance.token;

  ///Checks token storage for emptiness
  static bool get tokenIsNotEmpty => Token.instance.token.isNotEmpty;

  ///Checks token storage for emptiness
  static bool get tokenIsEmpty => Token.instance.token.isEmpty;

  ///Clear Token
  static void get clearToken => Token.instance.setToken('');

  ///Set Authorization token
  static void setToken(String token) {
    if (!DioApiST.instance.initState) {
      throw APIException(-1, body: 'Need Api.init() before setToken');
    }
    GetStorage().write('ApiEticonMainAuthToken2312', token);
    Token.instance.setToken(token);
  }

  ///Return refresh token
  static String? get refreshToken => Token.instance.refreshToken;

  ///Return Authorization token
  static DateTime? get expireDate => Token.instance.expireDate.year == 1970 ? null : Token.instance.expireDate;

  ///Clear Token
  static void get clearRefreshToken => Token.instance.setRefreshToken('');

  ///Checks token storage for emptiness
  static bool get refreshTokenIsNotEmpty => Token.instance.token.isNotEmpty;

  ///Checks token storage for emptiness
  static bool get refreshTokenIsEmpty => Token.instance.token.isEmpty;

  ///Set refresh token
  static void setRefreshToken(String token) {
    if (!DioApiST.instance.initState) {
      throw APIException(-1, body: 'Need Api.init() before setRefreshToken');
    }
    GetStorage().write('ApiEticonMainRefreshToken2312', token);
    Token.instance.setRefreshToken(token);
  }

  ///Set refresh token expire in seconds. Fro check you can use Api.isRefreshTokenExpire
  static void setExpire({required int seconds}) {
    if (!DioApiST.instance.initState) {
      throw APIException(-1, body: 'Need Api.init() before setRefreshToken');
    }
    Token.instance.setExpire(seconds);
    GetStorage().write('ApiEticonMainExpireDate2312', Token.instance.expireDate.toString());
  }

  ///Check token for expire
  static bool get isTokenExpire => DateTime.now().isAfter(Token.instance.expireDate);

  /// Sends an HTTP GET request.
  static Future<dynamic> get(String path,
      {bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query,
      Map<String, String>? headers,
      CancelToken? cancelToken,
      ResponseType responseType = ResponseType.map_data,
      Function(int, int)? onReceiveProgress,
      bool ignoreOnAllError = false,
      int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw APIException(-1, body: error);
    }
    bool isUrl = path.startsWith('http');
    return await DioApiST.instance.request(
        type: 'GET',
        method: !isUrl ? path : null,
        baseUrl: isUrl ? path : null,
        isAuth: isAuth,
        testMode: testMode,
        headers: headers,
        responseType: responseType,
        cancelToken: cancelToken,
        queries: query,
        //data: query,
        onReceiveProgress: onReceiveProgress,
        ignoreOnAllError: ignoreOnAllError,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP POST request.
  static Future<dynamic> post(String path,
      {bool isAuth = false,
      bool testMode = false,
      dynamic body,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      CancelToken? cancelToken,
      ResponseType responseType = ResponseType.map_data,
      Function(int, int)? onSendProgress,
      Function(int, int)? onReceiveProgress,
      bool ignoreOnAllError = false,
      int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw APIException(-1, body: error);
    }
    bool isUrl = path.startsWith('http');
    return await DioApiST.instance.request(
        type: 'POST',
        method: !isUrl ? path : null,
        baseUrl: isUrl ? path : null,
        isAuth: isAuth,
        testMode: testMode,
        headers: headers,
        queries: query,
        responseType: responseType,
        cancelToken: cancelToken,
        data: body,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        ignoreOnAllError: ignoreOnAllError,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP PUT request.
  static Future<dynamic> put(String path,
      {bool isAuth = false,
      bool testMode = false,
      dynamic body,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      CancelToken? cancelToken,
      ResponseType responseType = ResponseType.map_data,
      Function(int, int)? onSendProgress,
      Function(int, int)? onReceiveProgress,
      bool ignoreOnAllError = false,
      int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw APIException(-1, body: error);
    }
    bool isUrl = path.startsWith('http');
    return await DioApiST.instance.request(
        type: 'PUT',
        method: !isUrl ? path : null,
        baseUrl: isUrl ? path : null,
        isAuth: isAuth,
        testMode: testMode,
        headers: headers,
        queries: query,
        responseType: responseType ?? ResponseType.map_data,
        cancelToken: cancelToken,
        data: body,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        ignoreOnAllError: ignoreOnAllError,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP DELETE request.
  static Future<dynamic> delete(String path,
      {bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query,
      Map<String, String>? headers,
      CancelToken? cancelToken,
      ResponseType responseType = ResponseType.map_data,
      bool ignoreOnAllError = false,
      int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw APIException(-1, body: error);
    }
    bool isUrl = path.startsWith('http');
    return await DioApiST.instance.request(
        type: 'DELETE',
        method: !isUrl ? path : null,
        baseUrl: isUrl ? path : null,
        isAuth: isAuth,
        testMode: testMode,
        headers: headers,
        responseType: responseType,
        cancelToken: cancelToken,
        queries: query,
        // data: query,
        ignoreOnAllError: ignoreOnAllError,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP PATCH request.
  static Future<dynamic> patch(String path,
      {bool isAuth = false,
      bool testMode = false,
      dynamic body,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      CancelToken? cancelToken,
      ResponseType responseType = ResponseType.map_data,
      Function(int, int)? onSendProgress,
      Function(int, int)? onReceiveProgress,
      bool ignoreOnAllError = false,
      int urlIndex = 0}) async {
    String error = _checkBeforeRequest(isAuth, urlIndex);
    if (error.isNotEmpty) {
      throw APIException(-1, body: error);
    }
    bool isUrl = path.startsWith('http');
    return await DioApiST.instance.request(
        type: 'PATCH',
        method: !isUrl ? path : null,
        baseUrl: isUrl ? path : null,
        isAuth: isAuth,
        testMode: testMode,
        headers: headers,
        responseType: responseType,
        cancelToken: cancelToken,
        data: body,
        queries: query,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        ignoreOnAllError: ignoreOnAllError,
        urlIndex: urlIndex);
  }

  static String _checkBeforeRequest(bool isAuth, int index) {
    if (DioApiST.instance.urls.isEmpty) {
      return 'Base url not set, use Api.init(String url)';
    }
    if (DioApiST.instance.urls.length <= index) {
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

enum ResponseType { jsonResponse, stream, plain, byte, map_data }
