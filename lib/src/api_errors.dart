import 'package:dio/dio.dart';
//
// ///Main Api error class
// class APIException implements Exception {
//   ///Error String
//   String error;
//
//   APIException({required this.error});
//
//   @override
//   String toString() {
//     var message = this.error;
//     return "\n[APIException]: $message";
//   }
//
//   ///Get error
//   String? get message => this.error;
// }

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
