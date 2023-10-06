import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/network_info.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_local_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/repositories/post_repository_impl.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockPostLocalDataSource mockLocalDataSource;
  late MockPostRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late PostRepositoryImpl repositoryImpl;

  setUp(() {
    mockLocalDataSource = MockPostLocalDataSource();
    mockRemoteDataSource = MockPostRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = PostRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getPosts | ', () {
    const tStartIndex = 0;
    final tJson = json.decode(fixture('post.json')) as Map<String, dynamic>;
    final tPostModel = PostModel.fromJson(tJson);
    final tPost = tPostModel;
    setUp(() async {
      when(() => mockRemoteDataSource.fetchPosts(any()))
          .thenAnswer((_) async => [tPostModel]);
      when(() => mockLocalDataSource.cachePosts(any()))
          .thenAnswer((_) async => Future<void>.value());
    });
    test(
      'SHOULD check WHEN device IS online',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // Act
        await repositoryImpl.getPosts(tStartIndex);
        // Assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );
    group('Device is online | ', () {
      setUp(() async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'SHOULD return remote data WHEN the call to remote source IS succesful',
        () async {
          when(() => mockRemoteDataSource.fetchPosts(any()))
              .thenAnswer((_) async => [tPostModel]);
          when(() => mockLocalDataSource.cachePosts(any()))
              .thenAnswer((_) async => Future<void>.value());
          // Act
          final result = await repositoryImpl.getPosts(tStartIndex);
          // Assert
          verify(() => mockRemoteDataSource.fetchPosts(tStartIndex));
          expect(result, equals(Right<Failure, List<Post>>([tPost])));
        },
      );
    });
  });
}
