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
  final tJson = json.decode(fixture('post.json')) as Map<String, dynamic>;
  final tPostModel = PostModel.fromJson(tJson);
  final tPostModelList = [tPostModel];
  final mockResponse = HttpResponse(tJson, 200);
  test(
    'should preform a GET request on a URL with number being the endpoint and with application/json header',
    () async {
      //arrange

      when(() => mockHttpService.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => mockResponse,
      ); // Make sure to return a Future<HttpResponse>

      // act
      await dataSource.fetchPosts(tStartIndex);
      // assert
      verify(
        () => mockHttpService.get(
          'https://jsonplaceholder.typicode.com/posts?_start=$tStartIndex&_limit=1',
          headers: {'Content-Type': 'application/json'},
        ),
      ).called(1);
    },
  );

  test(
    'SHOULD return List<PostModel> WHEN response code IS 200',
    () async {
      // Arrange
      when(() => mockHttpService.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => mockResponse,
      );
      // Act
      final result = await dataSource.fetchPosts(tStartIndex);
      // Assert
      expect(result, equals(tPostModelList));
    },
  );

  test(
    'SHOULD throw a [ServerException] WHEN the response code IS not 200',
    () async {
      // Arrange
      when(() => mockHttpService.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => const HttpResponse({}, 404),
      );
      // Act
      final call = dataSource.fetchPosts;
      // Assert
      await expectLater(
        () => call(tStartIndex),
        throwsA(isA<ServerException>()),
      );
    },
  );
}
