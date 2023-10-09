import 'package:flutter_infinite_list_tdd_solid/core/error/exceptions.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/network_info.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_local_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';
import 'package:fpdart/fpdart.dart';

/// The Repository needs lower level Data Sources to get the actual data from.
final class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final PostRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts(
      int startIndex, int limitIndex,) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts =
            await remoteDataSource.fetchPosts(startIndex, limitIndex);
        await localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getLastPosts();
        return Right(localPosts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
