import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';

final class DioClient implements HttpService {
  DioClient(this.dio);

  final Dio dio;

  @override
  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? headers,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(url);
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return HttpResponse(response.data!, response.statusCode!);
  }
}
