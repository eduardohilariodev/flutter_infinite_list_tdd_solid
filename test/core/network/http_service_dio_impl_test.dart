import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service_dio_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late HttpServiceDioImpl httpServiceDioImpl;
  setUp(() async {
    mockDio = MockDio();
    httpServiceDioImpl = HttpServiceDioImpl(mockDio);
  });
  final mockData = json.decode(fixture('post.json')) as Map<String, dynamic>;
  final mockResponse = HttpResponse(mockData, 200);

  group('get() | ', () {
    test(
      'SHOULD return a value WHEN [Dio] IS called',
      () async {
        // Arrange
        when(() => mockDio.get<Map<String, dynamic>>(any(named: 'options')))
            .thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: mockData,
            statusCode: 200,
          ),
        );
        // Act
        final result = await httpServiceDioImpl.get<Map<String, dynamic>>('');
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
