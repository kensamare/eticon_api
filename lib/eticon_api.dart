library eticon_api;

import 'package:eticon_api/api_st.dart';


class Api {
  static void setBaseUrl(String url) {
    if (!url.startsWith('http') || !url.startsWith('http'))
      assert(false, 'NOT CORRECT URL');
    ApiST.instance.setBaseUrl(url);
  }
}

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
