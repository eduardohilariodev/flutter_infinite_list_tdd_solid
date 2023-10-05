import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/dio_client.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late DioClient dioClient;
  setUp(() async {
    mockDio = MockDio();
    dioClient = DioClient(mockDio);
  });
  group('get() | ', () {
    test(
      'SHOULD return a value WHEN [Dio] IS called',
      () async {
        // Arrange
        final mockData = {'data': 'some_data'};
        final mockResponse = HttpResponse(mockData, 200);
        when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: mockData,
            statusCode: 200,
          ),
        );
        // Act
        final result = await dioClient.get('');
        // Assert
        expect(result, equals(mockResponse));
        verify(() => mockDio.get<Map<String, dynamic>>(any())).called(1);
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
        final call = dioClient.get;
        // Assert
        expect(call(''), throwsA(isA<ServerException>()));
      },
    );
  });
}
