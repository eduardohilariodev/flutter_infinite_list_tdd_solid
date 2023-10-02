import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/usecases.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';

class GetPosts extends UseCase<List<Post>, Params> {
  GetPosts(this.repository);

  final PostRepository repository;

  /// Did you know that in Dart, a method named call can be run both by calling
  /// `object.call()` but also by `object()`? That's the perfect method to use
  /// in the Use Cases! After all, their class names are already verbs like
  /// GetPosts, so using them as "fake methods" fits perfectly.
  ///
  /// When it comes to Use Cases, every single one of them should have a
  /// `call()` method. It doesn't matter if the logic inside the Use Case gets
  /// us a [List<Post>] or sends a space shuttle to the Moon, the interface
  /// should be the same to prevent any confusion.
  @override
  Future<Either<Failure, List<Post>>> call(Params params) async {
    return repository.getPosts(params.startIndex);
  }
}

class Params extends Equatable {
  const Params({required this.startIndex});

  final int startIndex;

  @override
  List<Object?> get props => [startIndex];
}