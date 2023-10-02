import 'dart:convert';

import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tPostModel = PostModel(id: 1, userId: 1, title: 'title', body: 'body');

  /// Since the relation between the Model and the Entity is very important, we
  /// will test it to be able to have a good night's sleep.
  test(
    'SHOULD be a subclass of the [Post] entity',
    () async {
      // Assert
      expect(tPostModel, isA<Post>());
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

    // test('Invalid JSON', () async {
    //   final jsonMap =
    //       json.decode(fixture('invalid_json.json')) as Map<String, dynamic>;
    //   expect(
    //     () => PostModel.fromJson(jsonMap),
    //     throwsException,
    //   ); // Replace with your actual exception
    // });

    // test('Null values', () async {
    //   final jsonMap =
    //       json.decode(fixture('null_values.json')) as Map<String, dynamic>;
    //   expect(
    //     () => PostModel.fromJson(jsonMap),
    //     throwsException,
    //   ); // Replace with your actual exception
    // });

    // test('Empty values', () async {
    //   final jsonMap =
    //       json.decode(fixture('empty_values.json')) as Map<String, dynamic>;
    //   expect(
    //     () => PostModel.fromJson(jsonMap),
    //     throwsException,
    //   ); // Replace with your actual exception
    // });

    // test('Extra fields', () async {
    //   final jsonMap =
    //       json.decode(fixture('extra_fields.json')) as Map<String, dynamic>;
    //   final result = PostModel.fromJson(jsonMap);
    //   // Assert that your model ignores extra fields, or however you handle this scenario
    // });

    // test('Missing fields', () async {
    //   final jsonMap =
    //       json.decode(fixture('missing_fields.json')) as Map<String, dynamic>;
    //   expect(
    //     () => PostModel.fromJson(jsonMap),
    //     throwsException,
    //   ); // Replace with your actual exception
    // });

    // test('Nested JSON', () async {
    //   final jsonMap =
    //       json.decode(fixture('nested_json.json')) as Map<String, dynamic>;
    //   final result = PostModel.fromJson(jsonMap);
    //   // Assert that your model can handle nested JSON, or however you handle this scenario
    // });

    // test('Array instead of Object', () async {
    //   final jsonArray = json.decode(fixture('array_instead_of_object.json'));
    //   expect(
    //     () => PostModel.fromJson(jsonArray),
    //     throwsException,
    //   ); // Replace with your actual exception
    // });
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
