library eticon_api;

import 'package:eticon_api/api_st.dart';
//Class of EticonApiError
class EticonApiError extends Error{
  String error;
  EticonApiError({required this.error});
  String toString() {
    var message = this.error;
    return "$message";
  }

  @override
  String? get message => this.error;
}

class Api {
  static void setBaseUrl(String url) {
    if (!url.startsWith('http') || !url.startsWith('http'))
      throw EticonApiError(error: 'The url should start with https or http');
    _ApiST.instance.setBaseUrl(url);
  }
}

//
class _ApiST {
  _ApiST._();

  static _ApiST instance = _ApiST._();

  //Base url int singletons
  static String? _baseUrl;

  //enable or disable global test mode for all
  static bool _globalTestMode = false;

  ///Sets the base URL for processing requests
  void setBaseUrl(String url){
    print(url);
  }

}