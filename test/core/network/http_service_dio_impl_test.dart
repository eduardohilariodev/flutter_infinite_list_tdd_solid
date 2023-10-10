import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service_dio_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

class MockDioAdapter extends Mock implements DioAdapter {}

void main() {
  late Dio mockDio;
  late HttpServiceDioImpl httpServiceDioImpl;
  late DioAdapter mockDioAdapter;

  final mockData = json.decode(fixture('post.json')) as Map<String, dynamic>;
  final mockResponse = HttpResponse(mockData, 200);
  const path = 'https://jsonplaceholder.typicode.com/posts/1';

  setUp(() async {
    mockDioAdapter = MockDioAdapter();
    mockDio = MockDio()..httpClientAdapter = mockDioAdapter;
    httpServiceDioImpl = HttpServiceDioImpl(mockDio);
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
        final result = await httpServiceDioImpl.get<Map<String, int>>(path);
        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.get<Map<String, dynamic>>(any()));
      },
    );

    test(
      'SHOULD throw a [ServerException] WHEN response code IS not 200',
      () async {
        // Arrange
        when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: {},
            statusCode: 404,
          ),
        );
        // Act
        final call = httpServiceDioImpl.get<Map<String, dynamic>>;
        // Assert
        expect(call(''), throwsA(isA<ServerException>()));
      },
    );
  });
}
