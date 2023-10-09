import 'dart:convert';

import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/usecases/get_posts_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase getPostsUseCase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    getPostsUseCase = GetPostsUseCase(mockPostRepository);
  });

  const tStartIndex = 0;
  const tLimitIndex = 5;
  final tJsonList = (json.decode(fixture('posts.json')) as List)
      .map((item) => item as Map<String, dynamic>)
      .toList();
  final tPostModelList = tJsonList.map(PostModel.fromJson).toList();

  test(
    'SHOULD get a [List<PostEntity>] WHEN the repository IS called',
    () async {
      /// Arrange
      // "On the fly" implementation of the Repository using the Mockito
      // package. When getPosts is called with any argument, always answer with
      // the Right "side" of Either containing a test [List<Post>] object.
      // when(mockPostRepository.getPosts(any))
      //     .thenAnswer((realInvocation) async => const Right(tPost));
      when(() => mockPostRepository.getPosts(any(), any()))
          .thenAnswer((_) async => Right(tPostModelList));

      /// Act
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await getPostsUseCase(
        const Params(startIndex: tStartIndex, limitIndex: tLimitIndex),
      );

      /// Assert
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right<Failure, List<PostEntity>>(tPostModelList));

      // Verify that the method has been called on the Repository
      verify(() => mockPostRepository.getPosts(tStartIndex, tLimitIndex));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
