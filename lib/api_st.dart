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