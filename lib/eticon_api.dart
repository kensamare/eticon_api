library eticon_api;

import 'dart:convert';
import 'dart:developer';

import 'package:eticon_api/api_errors.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
//Class of EticonApiError


class Api {

  ///Sets the base url for requests to work
  static void setBaseUrl(String url) {
    if (!url.startsWith('http') || !url.startsWith('http'))
      throw EticonApiError(error: 'The url should start with https or http');
    if(url[url.length - 1] != '/')
      url += '/';
    _ApiST.instance.setBaseUrl(url);
  }

  ///All requests that exist in the project will work in test mode
  static void globalTestMode(bool globalTestMode){
    _ApiST.instance.setGlobalTestMode(globalTestMode);
  }

  ///Disable test mode completely for all requests existing in the project
  static void disableAllTestMode(bool disableState){
    _ApiST.instance.disableAllTestMode(disableState);
  }

  static Future<Map<String, dynamic>> get({required String method,
    bool isAuth = false,
    bool testMode = false,
    Map<String, dynamic>? query}) async {
    if(_ApiST.instance.baseUrl == null) {
      throw EticonApiError(
          error: 'Base url not set, use Api.setBaseUrl (String url)');
    }
    return await _ApiST.instance.getRequest(method: method, isAuth: isAuth, testMode: testMode, query: query);
  }

}

class _Token {
  _Token._();

  static _Token instance = _Token._();
  static String? _t;

  String ?get token => _t;

  void setToken(String t) {
    _t = t;
  }
}

class _ApiST {
  _ApiST._();

  static _ApiST instance = _ApiST._();

  //Base url int singletons
  static String? _baseUrl;

  //enable or disable global test mode for all
  static bool _globalTestMode = false;

  static bool _disableState = false;

  String? get baseUrl => _baseUrl;

  ///Sets the base URL for processing requests
  void setBaseUrl(String url){
    _baseUrl = url;
  }

  void setGlobalTestMode(bool globalTestMode){
    _globalTestMode = globalTestMode;
  }

  void disableAllTestMode(bool disableState){
    _disableState = disableState;
  }

  static Map<String, String> getAuthHeader({required String ?token}) {
    return {"Authorization": '$token',
      "Content-type": 'application/json'};
  }

  static Map <String, String> get getNoAuthHeader{
    return {"Content-type": 'application/json'};
  }

  // Метод get
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
    if (testMode) log(_queryList.toString(), name: 'API TEST GET: Query List');
    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method?${_queryList.join("&")}');
    if (testMode) log(url.toString(), name: 'API TEST GET: URL');
    // Делаем запрос
    Response response;
    if (testMode) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST GET: Token');
        log(getAuthHeader(token: _Token.instance.token).toString(),
            name: 'API TEST GET: Auth Header');
        response = await http.get(url,
            headers: getAuthHeader(token: _Token.instance.token));
        // log(response.body);
      } else {
        response = await http.get(url, headers: getNoAuthHeader);
      }
      log(response.statusCode.toString(), name: 'API TEST GET: Response Code');
      if(response.body[0] == '{'){
        log(utf8.decode(response.body.runes.toList()),
            name: 'API TEST GET: Response Body');
      }
      else{
        log(json.decode(utf8.decode(response.body.runes.toList())).toString(),
            name: 'API TEST GET: Response Body');
      }

    } else {
      try {
        if (isAuth) {
          response = await http.get(url,
              headers: getAuthHeader(token: _Token.instance.token));
          // log(response.body);
        } else {
          response = await http.get(url, headers: getNoAuthHeader);
        }

        //(utf8.decode(response.body.runes.toList());
        // log(response.body.toString(), name: "XXXX1");
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

    // Десериализация json

    //var responseParams = json.decode(response.body);
    var responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    // Проверка на Map
    if (responseParams is! Map) {
      if (testMode) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST GET: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }

  // Метод post
  Future<Map<String, dynamic>> postRequest(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        required Map<String, dynamic> body}) async {
    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method');
    // log(url.toString(), name: 'URL');
    if (testMode) log(url.toString(), name: 'API TEST POST: URL');
    // Делаем запрос

    Response response;
    if (testMode) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST POST: Token');
        log(getAuthHeader(token: _Token.instance.token).toString(),
            name: 'API TEST POST: Auth Header');
        log(jsonEncode(body).toString(), name: 'API TEST POST: Body in JSON');
        response = await http.post(url,
            headers: getAuthHeader(token: _Token.instance.token),
            body: jsonEncode(body));

        log(response.body);
      } else {
        log(getNoAuthHeader.toString(),
            name: 'API TEST POST: NO Auth Header');
        log(jsonEncode(body).toString(), name: 'API TEST POST: Body in JSON');
        response = await http.post(url,
            body: jsonEncode(body), headers: getNoAuthHeader);
        // log(jsonEncode(body));
        // log(response.body);
      }
      log(response.statusCode.toString(), name: 'API TEST POST: Response Code');
      if(response.body[0] != '{'){
        log(utf8.decode(response.body.runes.toList()),
            name: 'API TEST POST: Response Body');
      }
      else{
        log(json.decode(utf8.decode(response.body.runes.toList())).toString(),
            name: 'API TEST POST: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          // log(jsonEncode(body));
          response = await http.post(url,
              headers: getAuthHeader(token: _Token.instance.token),
              body: jsonEncode(body));

          // log(response.body);
        } else {
          response = await http.post(url,
              body: jsonEncode(body), headers: getNoAuthHeader);
          // log(jsonEncode(body));
          //log(response.body);
        }
      } catch (err) {
        // log(err.toString(), name:"ERROR API");
        throw APIException(0);
      }
    }

    // Если все не ок то отправляем код ответа http
    if (response.statusCode != 200) {
      throw APIException(response.statusCode);
    }

    // Десериализация json
    // var responseParams = json.decode(response.body);
    var responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    // Проверка на Map
    if (responseParams is! Map) {
      if (testMode) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST POST: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }

  // Метод put
  Future<Map<String, dynamic>> putRequest(
      {required String method,
        bool isAuth = false,
        bool testMode = false,
        required Map<String, dynamic> body}) async {
    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method');
    if (testMode) log(url.toString(), name: 'API TEST PUT: URL');
    // Делаем запрос
    Response response;
    if (testMode) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST PUT: Token');
        log(getAuthHeader(token: _Token.instance.token).toString(),
            name: 'API TEST PUT: Auth Header');
        response = await http.put(url,
            headers: getAuthHeader(token: _Token.instance.token),
            body: jsonEncode(body));
        // log('Ответ put ${response.statusCode} - ${response.body}');
      } else {
        log(getNoAuthHeader.toString(), name: 'API TEST PUT: NO Auth Header');
        response = await http.put(url,
            body: jsonEncode(body), headers: getNoAuthHeader);
      }
      log(jsonEncode(body).toString(), name: 'API TEST PUT: Body in JSON');
      log(response.statusCode.toString(), name: 'API TEST PUT: Response Code');
      if(response.body[0] != '{'){
        log(utf8.decode(response.body.runes.toList()),
            name: 'API TEST PUT: Response Body');
      }
      else{
        log(json.decode(utf8.decode(response.body.runes.toList())).toString(),
            name: 'API TEST PUT: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          response = await http.put(url,
              headers: getAuthHeader(token: _Token.instance.token),
              body: jsonEncode(body));
          // log('Ответ put ${response.statusCode} - ${response.body}');
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
    var responseParams = json.decode(utf8.decode(response.body.runes.toList()));
    //log(response.body, name: 'Response');
    // Проверка на Map
    if (responseParams is! Map) {
      if (testMode) {
        log('Response body is not a MAP, convert to {\'key\': response.body}',
            name: 'API TEST PUT: MAP Status');
      }
      Map<String, dynamic> res = {'key': responseParams};
      return res;
    } else {
      return Map<String, dynamic>.from(responseParams);
    }
  }

  // Метод delete
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
    if (testMode)
      log(_queryList.toString(), name: 'API TEST DELETE: Query List');

    //Формирование ссылки запроса
    Uri url = Uri.parse(_baseUrl! + '$method?${_queryList.join("&")}');
    if (testMode) log(url.toString(), name: 'API TEST DELETE: URL');
    // Делаем запрос
    Response response;
    if (testMode) {
      if (isAuth) {
        log(_Token.instance.token.toString(), name: 'API TEST DELETE: Token');
        log(getAuthHeader(token: _Token.instance.token).toString(),
            name: 'API TEST DELETE: Auth Header');
        response = await http.delete(url,
            headers: getAuthHeader(token: _Token.instance.token));
      } else {
        log(getAuthHeader(token: _Token.instance.token).toString(),
            name: 'API TEST DELETE: Auth Header');
        response = await http.delete(url, headers: getNoAuthHeader);
      }
      log(response.statusCode.toString(),
          name: 'API TEST DELETE: Response Code');
      if(response.body[0] != '{'){
        log(utf8.decode(response.body.runes.toList()),
            name: 'API TEST DELETE: Response Body');
      }
      else{
        log(json.decode(utf8.decode(response.body.runes.toList())).toString(),
            name: 'API TEST DELETE: Response Body');
      }
    } else {
      try {
        if (isAuth) {
          response = await http.delete(url,
              headers: getAuthHeader(token: _Token.instance.token));
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
    //var responseParams = json.decode(response.body);
    var responseParams =
    json.decode(utf8.decode(response.body.runes.toList())); //UTF-8
    // Проверка на Map
    if (responseParams is! Map) {
      if (testMode) {
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