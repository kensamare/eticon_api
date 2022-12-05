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

  ///Private token
  static String _refresh = '';

  ///Get token
  String get refreshToken => _refresh;

  ///Set token
  void setRefreshToken(String t) {
    _refresh = t;
  }

  ///Private token
  static DateTime _expire = DateTime(1970);

  ///Get token
  DateTime get expireDate => _expire;

  ///Get token
  set expireDate(DateTime t) => _expire = t;

  ///Set token
  void setExpire(int seconds) {
    _expire = DateTime.now().add(Duration(seconds: seconds));
  }
}
