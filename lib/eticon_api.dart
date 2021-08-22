library eticon_api;

import 'package:eticon_api/api_st.dart';

class EticonApiError implements Exception {
  String error;

  EticonApiError({required this.error});
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
