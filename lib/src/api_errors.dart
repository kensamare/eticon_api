///Main Api error class
class EticonApiError implements Exception {
  ///Error String
  String error;

  EticonApiError({required this.error});

  String toString() {
    var message = this.error;
    return "$message";
  }

  ///Get error
  @override
  String? get message => this.error;
}

///ApiException class show http error
class APIException implements Exception {
  ///Error code
  int code;

  ///Error body
  dynamic body;

  APIException(this.code, {this.body});

  ///GetError
  @override
  String toString() {
    return 'Error code: $code \nError body: ${body.toString()}';
  }
}
