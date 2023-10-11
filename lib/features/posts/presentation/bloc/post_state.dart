part of 'post_bloc.dart';

enum PostStatus {
  loading,
  success,
  failure,
}

@freezed
class PostState with _$PostState {
  const factory PostState({
    @Default(PostStatus.loading) PostStatus status,
    @Default([]) List<PostEntity> posts,
    @Default(false) bool hasReachedMax,
    String? message,
  }) = _PostState;
}
