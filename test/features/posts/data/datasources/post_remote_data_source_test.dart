import 'dart:convert';

import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpService extends Mock implements HttpService {}

void main() {
  late PostRemoteDataSourceImpl dataSource;
  late MockHttpService mockHttpService;

  setUp(() async {
    mockHttpService = MockHttpService();
    dataSource = PostRemoteDataSourceImpl(mockHttpService);
  });

  const tStartIndex = 0;
  const tLimitIndex = 1;
  final tJsonList = (json.decode(fixture('posts.json')) as List)
      .map((item) => item as Map<String, dynamic>)
      .toList();
  final tPostModelList = tJsonList.map(PostModel.fromJson).toList();
  final mockResponse = HttpResponse(tJsonList, 200);

  test(
    'should preform a GET request on a URL with number being the endpoint and with application/json header',
    () async {
      //arrange

      when(
        () => mockHttpService.get<List<Map<String, dynamic>>>(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => mockResponse,
      ); // Make sure to return a Future<HttpResponse>

      // act
      await dataSource.fetchPosts(tStartIndex, tLimitIndex);
      // assert
      verify(
        () => mockHttpService.get<List<Map<String, dynamic>>>(
          'https://jsonplaceholder.typicode.com/posts?_start=$tStartIndex&_limit=$tLimitIndex',
          headers: {'Content-Type': 'application/json'},
        ),
      );
    },
  );

  test(
    'SHOULD return List<PostModel> WHEN response code IS 200',
    () async {
      // Arrange
      when(
        () => mockHttpService.get<List<Map<String, dynamic>>>(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => mockResponse,
      );
      // Act
      final result = await dataSource.fetchPosts(tStartIndex, tLimitIndex);
      // Assert
      expect(result, equals(tPostModelList));
    },
  );

  test(
    'SHOULD throw a [ServerException] WHEN the response code IS not 200',
    () async {
      // Arrange
      when(
        () => mockHttpService.get<List<Map<String, dynamic>>>(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => const HttpResponse([], 404),
      );
      // Act
      final call = dataSource.fetchPosts;
      // Assert
      await expectLater(
        () => call(tStartIndex, tLimitIndex),
        throwsA(isA<ServerException>()),
      );
    },
  );
}
