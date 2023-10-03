// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/storage/local_persistance_storage.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_local_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockLocalPersistanceStorage extends Mock
    implements LocalPersistanceStorage {}

void main() {
  late MockLocalPersistanceStorage mockLocalPersistanceStorage;
  late PostLocalDataSourceImpl localDataSource;

  final tJsonList = json.decode(fixture('posts_cached.json')) as List<dynamic>;

  final tPostModels = tJsonList
      .map((dynamic item) => PostModel.fromJson(item as Map<String, dynamic>))
      .toList();

  setUp(() {
    mockLocalPersistanceStorage = MockLocalPersistanceStorage();
    localDataSource = PostLocalDataSourceImpl(
      localPersistanceStorage: mockLocalPersistanceStorage,
    );
  });

  group('getLastPosts | ', () {
    test(
      'SHOULD return [List<PostModel>] from LocalPersistanceStorage WHEN there IS data in the cache',
      () async {
        // Arrange
        when(() => mockLocalPersistanceStorage.getString(any()))
            .thenReturn(fixture('posts_cached.json'));
        // Act
        final result = await localDataSource.getLastPosts();
        // Assert
        verify(
          () => mockLocalPersistanceStorage
              .getString(LocalPersistanceStorageKeys.cachedPosts.name),
        ).called(1);

        expect(result, equals(tPostModels));
      },
    );

    test(
      'SHOULD throw [CacheException] WHEN there IS no cached values',
      () async {
        // Arrange
        when(() => mockLocalPersistanceStorage.getString(any()))
            .thenReturn(null);
        // Act
        final call = localDataSource.getLastPosts;
        // Assert
        expect(call, throwsA(isA<CacheException>()));
      },
    );
  });

  group('cachePosts | ', () {
    test(
      'SHOULD call [LocalPersistanceStorage] WHEN data IS cached',
      () async {
        //arrange
        when(
          () => mockLocalPersistanceStorage.setString(
            LocalPersistanceStorageKeys.cachedPosts.name,
            any(),
          ),
        ).thenAnswer((_) async => true);
        // Act
        await localDataSource.cachePosts(tPostModels);
        // Assert
        final expectedJsonString = json.encode(
          tPostModels.map((postModel) => postModel.toJson()).toList(),
        );
        verify(
          () => mockLocalPersistanceStorage.setString(
            LocalPersistanceStorageKeys.cachedPosts.name,
            expectedJsonString,
          ),
        ).called(1);
      },
    );
  });
}
