import 'package:dartz/dartz.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/core/platform/network_info.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_local_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';

/// The Repository needs lower level Data Sources to get the actual data from.
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final PostRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Post>>> getPosts(int startIndex) {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}