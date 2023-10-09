import 'package:equatable/equatable.dart';

base class PostEntity extends Equatable {
  const PostEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final String body;
  final int id;
  final String title;
  final int userId;

  @override
  List<Object?> get props => [id, userId, title, body];
}
