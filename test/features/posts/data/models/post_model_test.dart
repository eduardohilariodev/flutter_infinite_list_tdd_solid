import 'dart:convert';

import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tPost = PostEntity(id: 1, userId: 1, title: 'title', body: 'body');
  const tPostModel = PostModel(id: 1, userId: 1, title: 'title', body: 'body');

  /// Since the relation between the Model and the Entity is very important, we
  /// will test it to be able to have a good night's sleep.
  test(
    'SHOULD be a subclass of the [Post] entity',
    () async {
      // Assert
      expect(tPostModel, isA<PostEntity>());
    },
  );
  test(
    'SHOULD have the same properties as the [Post] entity',
    () async {
      // Assert

      expect(tPostModel.id, tPost.id);
      expect(tPostModel.userId, tPost.userId);
      expect(tPostModel.title, tPost.title);
      expect(tPostModel.body, tPost.body);
    },
  );


  group('fromJson | ', () {
    test(
      'SHOULD return a valid [PostModel] WHEN the JSON IS valid',
      () async {
        // Arrange
        final jsonMap =
            json.decode(fixture('post.json')) as Map<String, dynamic>;
        // Act
        final result = PostModel.fromJson(jsonMap);
        // Assert
        expect(result, tPostModel);
      },
    );
  });
  group('toJSON | ', () {
    test(
      'SHOULD return a JSON map WHEN a valid [PostModel] IS serialized',
      () async {
        // Act
        final result = tPostModel.toJson();
        // Assert
        final expectedJsonMap = {
          'id': 1,
          'userId': 1,
          'title': 'title',
          'body': 'body',
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
