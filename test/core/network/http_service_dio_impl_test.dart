import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service_dio_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  late Dio dio;
  late DioAdapter mockDioAdapter;
  late HttpServiceDioImpl httpServiceDioImpl;

  final mockData = json.decode(fixture('post.json')) as Map<String, dynamic>;
  final mockResponse = HttpResponse(mockData, 200);
  const path = 'https://jsonplaceholder.typicode.com/posts/1';

  setUp(() async {
    dio = Dio();
    mockDioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = mockDioAdapter;
    httpServiceDioImpl = HttpServiceDioImpl(dio);
  });

  group('get() | ', () {
    test(
      'SHOULD return a value WHEN [Dio] IS called',
      () async {
        // Arrange
        mockDioAdapter.onGet(
          path,
          (server) => server.reply(200, mockData),
        );

        // Act
        final result = await httpServiceDioImpl.get<Map<String, dynamic>>(path);
        // Assert
        expect(result, equals(mockResponse));
      },
    );

    test(
      'SHOULD throw a [ServerException] WHEN response code IS NOT succesful',
      () async {
        // Arrange
        mockDioAdapter.onGet(
          path,
          (server) => server.reply(404, mockData),
        );
        // Act
        final call = httpServiceDioImpl.get<Map<String, dynamic>>;
        // Assert
        expect(call(''), throwsA(isA<ServerException>()));
      },
    );
  });
}
