import 'package:dartz/dartz.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';

import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts(int startIndex);
}
