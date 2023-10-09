import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/network_info.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_local_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/repositories/post_repository_impl.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockPostLocalDataSource extends Mock implements PostLocalDataSource {}

class MockPostRemoteDataSource extends Mock implements PostRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  const tStartIndex = 0;
  const tLimitIndex = 1;
  final tJson = json.decode(fixture('post.json')) as Map<String, dynamic>;
  final tPostModel = PostModel.fromJson(tJson);
  final tPost = tPostModel;

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

  void runTestsOnline(void Function() body) {
    group('Device is online | ', () {
      setUp(() async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(void Function() body) {
    group('Device is offline | ', () {
      setUp(() async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getPosts | ', () {
    setUp(() async {
      when(() => mockRemoteDataSource.fetchPosts(any(), any()))
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
        await repositoryImpl.getPosts(tStartIndex, tLimitIndex);
        // Assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'SHOULD return remote data WHEN the call to remote source IS succesful',
        () async {
          // Act
          final result =
              await repositoryImpl.getPosts(tStartIndex, tLimitIndex);

          // Assert
          verify(
            () => mockRemoteDataSource.fetchPosts(tStartIndex, tLimitIndex),
          );
          final deepCollectionEquality = const DeepCollectionEquality()
              .equals(result.getOrElse((failure) => []), [tPost]);
          expect(deepCollectionEquality, isTrue);
        },
      );

      test(
        'SHOULD cache data locally WHEN the call to remote IS succesful',
        () async {
          // Act
          await repositoryImpl.getPosts(tStartIndex, tLimitIndex);
          // Assert
          verify(
            () => mockRemoteDataSource.fetchPosts(tStartIndex, tLimitIndex),
          );
          verify(() => mockLocalDataSource.cachePosts([tPostModel]));
        },
      );

      test(
        'SHOULD return [ServerFailure] WHEN the call to remote source IS unsuccesful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.fetchPosts(any(), any()))
              .thenThrow(ServerException());
          // Act
          final result =
              await repositoryImpl.getPosts(tStartIndex, tLimitIndex);
          // Assert
          verify(
            () => mockRemoteDataSource.fetchPosts(tStartIndex, tLimitIndex),
          );
          verifyZeroInteractions(mockLocalDataSource);
          expect(
            result,
            equals(Left<Failure, List<PostEntity>>(ServerFailure())),
          );
        },
      );
    });

    runTestsOffline(() {
      test(
        'SHOULD return last cached data WHEN cached data IS present',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastPosts())
              .thenAnswer((_) async => [tPostModel]);
          // Act
          final result =
              await repositoryImpl.getPosts(tStartIndex, tLimitIndex);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastPosts());
          final deepCollectionEquality = const DeepCollectionEquality()
              .equals(result.getOrElse((failure) => []), [tPost]);
          expect(deepCollectionEquality, isTrue);
        },
      );

      test(
        'SHOULD return a [CacheFailure] WHEN cached data IS NOT present',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastPosts())
              .thenThrow(CacheException());
          // Act
          final result =
              await repositoryImpl.getPosts(tStartIndex, tLimitIndex);
          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastPosts());
          expect(
            result,
            equals(Left<Failure, List<PostEntity>>(CacheFailure())),
          );
        },
      );
    });
  });
}
