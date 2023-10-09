import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/usecases/get_posts_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_event.dart';
part 'post_state.dart';
part 'post_bloc.freezed.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required GetPostsUseCase getPostsUseCase})
      : _getPostsUseCase = getPostsUseCase,
        super(const PostState()) {
    on<PostFetchedEvent>((event, emit) async {
      if (state.hasReachedMax) return;
      emit(state.copyWith(status: PostStatus.loading));
      final failureOrPosts = await _getPostsUseCase(
        Params(
          startIndex: state.posts.length,
        ),
      );

      failureOrPosts.fold(
        (failure) {
          emit(
            state.copyWith(
              status: PostStatus.failure,
              message: switch (failure) {
                ServerFailure() => 'Server Failure',
                CacheFailure() => 'Cache Failure',
              },
            ),
          );
        },
        (posts) => emit(
          state.copyWith(
            status: PostStatus.success,
            posts: List.from(state.posts)..addAll(posts),
            hasReachedMax: posts.isEmpty,
          ),
        ),
      );
    });
  }

  final GetPostsUseCase _getPostsUseCase;
}
