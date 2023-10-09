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
  const tLimitIndex = 5;
  final tJsonList = (json.decode(fixture('posts.json')) as List)
      .map((item) => item as Map<String, dynamic>)
      .toList();
  final tPostModelList = tJsonList.map(PostModel.fromJson).toList();

  late PostBloc bloc;
  late MockGetPostsUseCase mockGetPostsUseCase;

  setUp(() async {
    mockGetPostsUseCase = MockGetPostsUseCase();
    bloc = PostBloc(
      getPostsUseCase: mockGetPostsUseCase,
    );
    registerFallbackValue(
      const Params(startIndex: tStartIndex, limitIndex: tLimitIndex),
    );
  });

  group('PostFetched | ', () {
    test('initialState is correct', () {
      expect(bloc.state, const PostState());
    });
    blocTest<PostBloc, PostState>(
      'SHOULD get data WHEN calling UseCase IS succesful',
      build: () {
        when(
          () => mockGetPostsUseCase( any()),
        ).thenAnswer((_) async => Right(tPostModelList));
        return bloc;
      },
      act: (bloc) {
        bloc.add(PostFetchedEvent());
      },
      expect: () => [
        const PostState(status: PostStatus.loading),
        PostState(status: PostStatus.success, posts: tPostModelList),
      ],
    );
    blocTest<PostBloc, PostState>(
      'SHOULD emit [loading, success] WHEN getting data IS succesful',
      build: () {
        when(
          () => mockGetPostsUseCase(any()),
        ).thenAnswer((_) async => Right(tPostModelList));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        PostState(status: PostStatus.success, posts: tPostModelList),
      ],
    );

    blocTest<PostBloc, PostState>(
      'SHOULD emit [loading, failure] WHEN getting remote data IS NOT succesful',
      build: () {
        when(
          () => mockGetPostsUseCase(any()),
        ).thenAnswer((_) async => Left(ServerFailure()));
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
        when(
          () => mockGetPostsUseCase(any()),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        const PostState(status: PostStatus.failure, message: 'Cache Failure'),
      ],
    );

    blocTest<PostBloc, PostState>(
      'SHOULD return no more data WHEN hasReachedMax IS true',
      build: () {
        when(
          () => mockGetPostsUseCase(any()),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(PostFetchedEvent()),
      expect: () => [
        const PostState(status: PostStatus.loading),
        const PostState(status: PostStatus.success, hasReachedMax: true),
      ],
    );

    Future<void> addFiveEvents() async {
      for (var i = 0; i < 5; i++) {
        bloc.add(PostFetchedEvent());
        await Future<Duration>.delayed(
          const Duration(milliseconds: 20),
          () => Duration.zero,
        );
      }
    }

    blocTest<PostBloc, PostState>(
      'SHOULD throttle and drop events WHEN events are fired rapidly',
      build: () {
        when(
          () => mockGetPostsUseCase(any()),
        ).thenAnswer((_) async => Right(tPostModelList));
        return bloc;
      },
      act: (bloc) async => addFiveEvents(),
      expect: () => [
        const PostState(status: PostStatus.loading),
        PostState(status: PostStatus.success, posts: tPostModelList),
      ],
    );
  });
}
