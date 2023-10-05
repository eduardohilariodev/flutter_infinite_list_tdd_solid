import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list_tdd_solid/core/error/failures.dart';

/// Parameters have to be put into a container object so that they can be
/// included in this abstract base class method definition.
///
/// As you can see, we added two type parameters to the UseCase class. One is
/// for the "no-error" return type, which in the case of our app will be the
/// [Post] entity. The other type parameter, Params, is going to cause some
/// minor code changes in the already present [GetPosts] use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// This will be used by the code calling the use case whenever the use case
/// doesn't accept any parameters.
final class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
