class EticonApiError extends Error{
  String error;
  EticonApiError({required this.error});
  String toString() {
    var message = this.error;
    return "$message";
  }

  @override
  String? get message => this.error;
}

class APIException implements Exception {
  int code;
  String? message;

  APIException(this.code, [this.message]);

  @override
  String toString() {
    print(message);
    return '$code ${message ?? ""}';
  }

  int toInt() {
    return code;
  }
}