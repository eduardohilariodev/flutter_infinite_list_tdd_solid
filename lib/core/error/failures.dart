import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  /// If the subclasses have some properties, they'll get passed to this
  /// constructor so that Equatable can perform value comparison.
  const Failure();

  @override
  List<Object?> get props => [];
}

/// Failure returned when there is an error with the server.
final class ServerFailure extends Failure {}

/// Failure returned when there is an error with the cache.
final class CacheFailure extends Failure {}
