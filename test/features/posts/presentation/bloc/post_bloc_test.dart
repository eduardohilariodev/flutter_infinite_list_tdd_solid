import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/usecases/get_posts_use_case.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/presentation/bloc/post_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

void main() {
  const tStartIndex = 0;
  final tJson = json.decode(fixture('post.json')) as Map<String, dynamic>;
  final tPostModel = PostModel.fromJson(tJson);
  final tPost = tPostModel;

  late PostBloc bloc;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() async {
    mockGetPostsUseCase = MockGetPostsUseCase();

    bloc = PostBloc(
      getPostsUseCase: mockGetPostsUseCase,
    );
  });

  test('initialState is correct', () {
    expect(bloc.state, const PostState());
  });

  group('PostFetched | ', () {
    blocTest<PostBloc, PostState>(
      'SHOULD get data WHEN calling UseCase IS succesful',
      build: () {
        when(() => mockGetPostsUseCase(const Params(startIndex: tStartIndex)))
            .thenAnswer((_) async => Right([tPost]));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      verify: (_) {
        verify(
          () => mockGetPostsUseCase(const Params(startIndex: tStartIndex)),
        );
      },
    );
    blocTest<PostBloc, PostState>(
      'SHOULD emit [loading, success] WHEN getting data IS succesful',
      build: () {
        when(() => mockGetPostsUseCase(const Params(startIndex: tStartIndex)))
            .thenAnswer((_) async => Right([tPost]));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        PostState(status: PostStatus.success, posts: [tPost]),
      ],
    );

    blocTest<PostBloc, PostState>(
      'SHOULD emit [loading, failure] WHEN getting remote data IS NOT succesful',
      build: () {
        when(() => mockGetPostsUseCase(const Params(startIndex: tStartIndex)))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        const PostState(status: PostStatus.failure, message: 'Server Failure'),
      ],
    );

    blocTest<PostBloc, PostState>(
      'SHOULD emit [loading, failure] WHEN getting local data IS NOT succesful',
      build: () {
        when(() => mockGetPostsUseCase(const Params(startIndex: tStartIndex)))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        const PostState(status: PostStatus.failure, message: 'Cache Failure'),
      ],
    );
  });
}
