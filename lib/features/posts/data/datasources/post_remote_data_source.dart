import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';

abstract interface class PostRemoteDataSource {
  /// Calls the https://jsonplaceholder.typicode.com/posts?_start={startIndex}&_limit={limitIndex}
  /// endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PostModel>> fetchPosts(int startIndex, int limitIndex);
}

final class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  PostRemoteDataSourceImpl(this.httpService);

  final HttpService httpService;

  @override
  Future<List<PostModel>> fetchPosts(int startIndex, int limitIndex) async {
    final response = await httpService.get<List<Map<String, dynamic>>>(
      'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limitIndex',
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonList = response.data;
      final postModelList = jsonList.map(PostModel.fromJson).toList();
      return postModelList;
    } else {
      throw ServerException();
    }
  }
}
