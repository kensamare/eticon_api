///Main Api error class
class EticonApiError implements Exception {
  ///Error String
  String error;

  EticonApiError({required this.error});

  @override
  String toString() {
    var message = this.error;
    return "\n[EticonApiError]: $message";
  }

  ///Get error
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
    return '\n[APIException] Error code: $code, Error body: ${body.toString()}';
  }
}
