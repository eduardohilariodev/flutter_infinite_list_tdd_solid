import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';

abstract interface class PostRemoteDataSource {
  /// Calls the https://jsonplaceholder.typicode.com/posts?_start={startIndex}&_limit={limitIndex}
  /// endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PostModel>> fetchPosts(int startIndex);
}

final class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  PostRemoteDataSourceImpl(this.httpService);

  final HttpService httpService;

  @override
  Future<List<PostModel>> fetchPosts(int startIndex) async {
    final response = await httpService.get(
      'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=1',
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final json = response.data;
      final postModel = PostModel.fromJson(json);
      return [postModel];
    } else {
      throw ServerException();
    }
  }
}
