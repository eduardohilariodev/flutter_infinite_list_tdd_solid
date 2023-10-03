import 'package:dio/dio.dart';

abstract class HttpService {
  Future<Map<String, dynamic>> get(String url, {Map<String, dynamic>? headers});
}
