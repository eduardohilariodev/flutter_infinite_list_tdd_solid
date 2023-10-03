import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';

class DioClient implements HttpService {
  DioClient(this.dio);

  final Dio dio;

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, dynamic>? headers,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(url);
    return response.data!;
  }
}
