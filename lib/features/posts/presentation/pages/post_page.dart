import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/entities/post_entity.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/presentation/bloc/post_bloc.dart';
import 'package:flutter_infinite_list_tdd_solid/injection_container.dart';

part '../widgets/__post_list.dart';
part '../widgets/__post_list_item.dart';
part '../widgets/__bottom_loader.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostsPagePage'),
        centerTitle: true,
      ),
      body: BlocProvider<PostBloc>(
        create: (context) => sl<PostBloc>()..add(PostFetchedEvent()),
        child: const _PostList(),
      ),
    );
  }
}
