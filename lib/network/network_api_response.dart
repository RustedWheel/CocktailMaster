import 'package:http/http.dart';

class NetworkAPIResponse<T> {
  bool isSuccess;
  int statusCode;
  Response raw;
  T? data;

  NetworkAPIResponse({
    required this.isSuccess,
    required this.statusCode,
    required this.raw,
    this.data
  });
}
