import 'package:eticon_api/src/api_errors.dart';
import 'package:eticon_api/src/token.dart';
import 'package:eticon_api/src/old_api/type.dart';

import 'api_st.dart';

@deprecated
class OldApi {
  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> get(
      {required String method,
      bool isAuth = false,
      bool testMode = false,
      Map<String, dynamic>? query,
      int urlIndex = 0}) async {
    if (ApiST.instance.urls.isEmpty) {
      throw APIException(-1, body: 'Base url not set, use Api.init()');
    }
    if (isAuth) {
      if (Token.instance.token.isEmpty) {
        throw APIException(-1,
            body:
                'Authentication token is empty, use Api.setToken (String url)');
      }
    }
    return await ApiST.instance.request(
        type: TYPE.GET,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: query,
        urlIndex: urlIndex);
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
      throw APIException(-1, body: error);
    }
    return await ApiST.instance.request(
        type: TYPE.POST,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: body,
        urlIndex: urlIndex);
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
      throw APIException(-1, body: error);
    }
    return await ApiST.instance.request(
        type: TYPE.PUT,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: body,
        urlIndex: urlIndex);
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
      throw APIException(-1, body: error);
    }
    return await ApiST.instance.request(
        type: TYPE.DEL,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: query,
        urlIndex: urlIndex);
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
      throw APIException(-1, body: error);
    }
    return await ApiST.instance.request(
        type: TYPE.PATCH,
        method: method,
        isAuth: isAuth,
        testMode: testMode,
        query: body,
        urlIndex: urlIndex);
  }

  /// Sends an HTTP GET request.
  static Future<Map<String, dynamic>> rawGet(
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
  static Future<Map<String, dynamic>> rawPost(
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
  static Future<Map<String, dynamic>> rawPut(
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
  static Future<Map<String, dynamic>> rawDelete(
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
  static Future<Map<String, dynamic>> rawPatch(
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
