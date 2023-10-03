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

  setUp(() {
    mockLocalPersistanceStorage = MockLocalPersistanceStorage();
    localDataSource = PostLocalDataSourceImpl(
      localPersistanceStorage: mockLocalPersistanceStorage,
    );
  });

  group('getLastPosts | ', () {
// Step 1: Decode the JSON to a List<dynamic>
    final tJsonList =
        json.decode(fixture('posts_cached.json')) as List<dynamic>;

// Step 2: Map through the list and convert each Map to a PostModel
    final tPostModels = tJsonList
        .map((dynamic item) => PostModel.fromJson(item as Map<String, dynamic>))
        .toList();
    test(
      'SHOULD return [List<Post] from LocalPersistanceStorage WHEN there IS one in the cache',
      () async {
        // Arrange
        when(() => mockLocalPersistanceStorage.getString(any()))
            .thenReturn(fixture('posts_cached.json'));
        // Act
        final result = await localDataSource.getLastPosts();
        // Assert
        verify(() => mockLocalPersistanceStorage.getString('CACHED_POSTS'))
            .called(1);

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
}
