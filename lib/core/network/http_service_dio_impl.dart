import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';

final class HttpServiceDioImpl implements HttpService {
  HttpServiceDioImpl(this.dio);

  final Dio dio;

  @override
  Future<HttpResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
  }) async {
    final response = await dio.get<T>(
      url,
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
    return HttpResponse(response.data as T, response.statusCode!);
  }
}
