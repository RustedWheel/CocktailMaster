import 'package:http/http.dart';

class NetworkAPIResponse<T> {
  bool isSuccess;
  int? statusCode;
  Response? raw;
  String error;
  T? data;

  NetworkAPIResponse(
      {required this.isSuccess,
      this.statusCode,
      this.raw,
      this.error = "",
      this.data});
}
