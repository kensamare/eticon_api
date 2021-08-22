library eticon_api;

import 'package:eticon_api/api_st.dart';

class EticonApiError extends Error implements UnsupportedError {
  String error;
  EticonApiError({required this.error});
  String toString() {
    var message = this.error;
    return "EticonApiError: $message";
  }

  @override
  String? get message => this.error;
}

class Api {
  static void setBaseUrl(String url) {
    if (!url.startsWith('http') || !url.startsWith('http'))
      throw EticonApiError(error: 'The url should start with https or http');
    ApiST.instance.setBaseUrl(url);
  }
}

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
