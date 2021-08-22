

class ApiST {
  ApiST._();

  static ApiST instance = ApiST._();

  static String? _baseUrl;

  static bool _globalTestMode = false;

  ///Sets the base URL for processing requests
  void setBaseUrl(String url){
    print(url);
  }

}