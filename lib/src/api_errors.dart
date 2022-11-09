import 'package:dio/dio.dart';

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
class APIException extends DioError {
  ///Error code
  late int code;

  ///Error body
  dynamic body;

  APIException(this.code, RequestOptions options, Response response, DioErrorType type, dynamic error, {this.body})
      : super(
          requestOptions: options,
          response: response,
          type: type,
          error: error,
        );

  APIException.fromDioError(DioError err)
      : super(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          error: err.error,
        ) {
    code = err.response?.statusCode ?? 0;
    body = err.error?.toString() ?? '';
  }

  ///GetError
  @override
  String toString() {
    return '\n[APIException] Error code: $code, Error body: ${body.toString()}';
  }
}
