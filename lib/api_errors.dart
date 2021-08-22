
///Main Api error class
class EticonApiError extends Error{
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
  ///Error message
  String? message;

  APIException(this.code, [this.message]);

  ///GetError
  @override
  String toString() {
    print(message);
    return '$code ${message ?? ""}';
  }

}