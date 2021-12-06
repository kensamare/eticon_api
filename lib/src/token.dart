///Token singleton
class Token {
  ///Named constructor
  Token._();

  ///Init singleton
  static Token instance = Token._();

  ///Private token
  static String _t = '';

  ///Get token
  String get token => _t;

  ///Set token
  void setToken(String t) {
    _t = t;
  }
}
