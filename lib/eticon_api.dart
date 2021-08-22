library eticon_api;


class Api {
  Api._();

  static Api instance = Api._();

  static String? _baseUrl;

  static bool _globalTestMode = false;

  ///Sets the base URL for processing requests
  void setBaseUrl(String url){
    assert(url.startsWith('http') || url.startsWith('http'), 'The url should start with https or http');
    print('URLLLLL');
  }

}

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
