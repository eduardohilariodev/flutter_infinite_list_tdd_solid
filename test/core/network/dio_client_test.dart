import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/dio_client.dart';
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
        when(() => mockDio.get<Map<String, dynamic>>(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(),
            data: mockData,
          ),
        );
        // Act
        final result = await dioClient.get('');
        // Assert
        expect(result, equals(mockData));
        verify(() => mockDio.get<Map<String, dynamic>>(any())).called(1);
      },
    );
  });
}
