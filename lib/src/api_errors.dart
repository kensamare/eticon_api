import 'package:dio/dio.dart';

///ApiException class show http error
class APIException implements Exception {
  ///Error code
  late int code;

  ///Error body
  dynamic body;

  DioError? error;

  APIException.fromDio(this.error){
    code = error!.response?.statusCode ?? 0;
    body = error!.error?.toString() ?? '';
  }

  APIException(this.code, {this.body});

  ///GetError
  @override
  String toString() {
    return '\n[APIException] Error code: $code, Error: ${body.toString()}, ${error != null ? 'Data: ${error!.response?.data.toString()}' : ''}';
  }
}
