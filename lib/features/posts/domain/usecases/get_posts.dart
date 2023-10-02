import 'package:dartz/dartz.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';

class GetPosts {
  GetPosts(this.repository);

  final PostRepository repository;

  Future<Either<Failure, List<Post>>> execute({required int startIndex}) async {
    return repository.getPosts(startIndex);
  }
}
