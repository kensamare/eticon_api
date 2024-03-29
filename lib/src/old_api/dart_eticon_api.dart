import 'package:eticon_api/src/old_api/type.dart';

import 'api_st.dart';

class DartApi {
  // ///Initialization API class
  // static Future<void> init(
  //     {required String baseUrl,
  //       bool globalTestMode = false,
  //       bool bearerToken = true,
  //       disableAllTestMode = false,
  //       bool enableUtf8Decoding = false,
  //       String? storageUrl}) async {
  //   if (!ApiST.instance.setInitState()) {
  //     throw APIException(error: 'API class already initialization');
  //   }
  //   if (baseUrl.isEmpty) {
  //     throw APIException(error: 'URL is empty');
  //   }
  //   if (!baseUrl.startsWith('http'))
  //     throw APIException(error: 'The url should start with https or http');
  //   if (baseUrl[baseUrl.length - 1] != '/') baseUrl += '/';
  //   ApiST.instance.setBaseUrl(baseUrl);
  //   ApiST.instance.setGlobalTestMode(globalTestMode);
  //   ApiST.instance.disableAllTestMode(disableAllTestMode);
  //   ApiST.instance.enableUtf8Decoding(enableUtf8Decoding);
  //   ApiST.instance.setBearerMode(bearerToken);
  //   if (storageUrl != null) {
  //     ApiST.instance.setStorageUrl(storageUrl);
  //   }
  // }
  // ///Help to get url to resource in server storage
  // static String dataFromStorage(String path) {
  //   if (ApiST.instance.storageUrl == null) {
  //     throw APIException(
  //         error: 'Storage url is null, set storageUrl in Api.init()');
  //   } else {
  //     return '${ApiST.instance.storageUrl}$path';
  //   }
  // }
  //
  // ///Set headers. Default is only "Content-type": application/json
  // static void setHeaders(Map<String, String> headers) {
  //   ApiST.instance.setHeaders(headers);
  // }
  //
  // /// Sends an HTTP GET request.
  // static Future<Map<String, dynamic>> get(
  //     {required String method,
  //       bool isAuth = false,
  //       bool testMode = false,
  //       Map<String, dynamic>? query}) async {
  //   if (ApiST.instance.baseUrl == null) {
  //     throw APIException(error: 'Base url not set, use Api.init()');
  //   }
  //   if (isAuth) {
  //     if (Token.instance.token.isEmpty) {
  //       throw APIException(
  //           error:
  //           'Authentication token is empty, use Api.setToken (String url)');
  //     }
  //   }
  //   return await ApiST.instance.request(
  //       type: TYPE.GET,
  //       method: method,
  //       isAuth: isAuth,
  //       testMode: testMode,
  //       query: query);
  // }
  //
  // /// Sends an HTTP POST request.
  // static Future<Map<String, dynamic>> post(
  //     {required String method,
  //       bool isAuth = false,
  //       bool testMode = false,
  //       required Map<String, dynamic> body}) async {
  //   if (ApiST.instance.baseUrl == null) {
  //     throw APIException(error: 'Base url not set, use Api.init()');
  //   }
  //   if (isAuth) {
  //     if (Token.instance.token.isEmpty) {
  //       throw APIException(
  //           error:
  //           'Authentication token is empty, use Api.setToken (String url)');
  //     }
  //   }
  //   return await ApiST.instance.request(
  //       type: TYPE.POST,
  //       method: method,
  //       isAuth: isAuth,
  //       testMode: testMode,
  //       query: body);
  // }
  //
  // /// Sends an HTTP PUT request.
  // static Future<Map<String, dynamic>> put(
  //     {required String method,
  //       bool isAuth = false,
  //       bool testMode = false,
  //       required Map<String, dynamic> body}) async {
  //   if (ApiST.instance.baseUrl == null) {
  //     throw APIException(error: 'Base url not set, use Api.init()');
  //   }
  //   if (isAuth) {
  //     if (Token.instance.token.isEmpty) {
  //       throw APIException(
  //           error:
  //           'Authentication token is empty, use Api.setToken (String url)');
  //     }
  //   }
  //   return await ApiST.instance.request(
  //       type: TYPE.PUT,
  //       method: method,
  //       isAuth: isAuth,
  //       testMode: testMode,
  //       query: body);
  // }
  //
  // /// Sends an HTTP DELETE request.
  // static Future<Map<String, dynamic>> delete(
  //     {required String method,
  //       bool isAuth = false,
  //       bool testMode = false,
  //       Map<String, dynamic>? query}) async {
  //   if (ApiST.instance.baseUrl == null) {
  //     throw APIException(error: 'Base url not set, use Api.init(String url)');
  //   }
  //   if (isAuth) {
  //     if (Token.instance.token.isEmpty) {
  //       throw APIException(
  //           error:
  //           'Authentication token is empty, use Api.setToken (String url)');
  //     }
  //   }
  //   return await ApiST.instance.request(
  //       type: TYPE.DEL,
  //       method: method,
  //       isAuth: isAuth,
  //       testMode: testMode,
  //       query: query);
  // }

  /// Sends an HTTP GET request.
  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> get(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      Map<String, dynamic>? query,
      int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.GET,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: query,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP POST request.
  static Future<Map<String, dynamic>> post(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      required Object body,
      int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.POST,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: body,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> put(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      required Map<String, dynamic> body,
      int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.PUT,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: body,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP DELETE request.
  static Future<Map<String, dynamic>> delete(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      Map<String, dynamic>? query,
      int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.DEL,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: query,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP PUT request.
  static Future<Map<String, dynamic>> patch(
      {required String url,
      Map<String, String> headers = const {"Content-type": 'application/json'},
      bool testMode = false,
      required Map<String, dynamic> body,
      int urlIndex = 0}) async {
    return await ApiST.instance.request(
        type: TYPE.PATCH,
        baseUrl: url,
        rawHeaders: headers,
        testMode: testMode,
        query: body,
        urlIndex: urlIndex);
  }
}
