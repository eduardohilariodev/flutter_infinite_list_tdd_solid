import 'package:dartz/dartz.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPosts getPosts;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    getPosts = GetPosts(mockPostRepository);
  });

  const tStartIndex = 1;
  const tId = 1;
  const tUserId = 1;
  const tTitle = 'title';
  const tBody = 'body';
  const tPost = Post(id: tId, userId: tUserId, title: tTitle, body: tBody);

  test(
    'SHOULD get a [List<Post>] WHEN the repository IS called',
    () async {
      /// Arrange
      // "On the fly" implementation of the Repository using the Mockito
      // package. When getPosts is called with any argument, always answer with
      // the Right "side" of Either containing a test [List<Post>] object.
      // when(mockPostRepository.getPosts(any))
      //     .thenAnswer((realInvocation) async => const Right(tPost));
      when(() => mockPostRepository.getPosts(any()))
          .thenAnswer((_) async => const Right([tPost]));

      /// Act
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await getPosts.execute(startIndex: tStartIndex);

      /// Assert
      // UseCase should simply return whatever was returned from the Repository
      expect(result, const Right<Failure, List<Post>>([tPost]));

      // Verify that the method has been called on the Repository
      verify(() => mockPostRepository.getPosts(tStartIndex)).called(1);
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockPostRepository);
    },
  );
}
