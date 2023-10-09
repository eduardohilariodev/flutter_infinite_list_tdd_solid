import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';

/// It's the job of the Repository to get fresh data from the API when there is
/// an Internet connection (and then to cache it locally), or to get the cached
/// data when the user is offline.
abstract interface class PostRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts(int startIndex);
}
