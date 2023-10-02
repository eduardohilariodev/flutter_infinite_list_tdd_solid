import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  /// Calls the https://jsonplaceholder.typicode.com/posts?_start={startIndex}&_limit={limitIndex}
  /// endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PostModel>> fetchPosts(int startIndex);
}
