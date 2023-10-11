part of '../pages/post_page.dart';

class _PostList extends StatefulWidget {
  const _PostList();

  @override
  State<_PostList> createState() => _PostsListState();
}

class _PostsListState extends State<_PostList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostBloc>().add(PostFetchedEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.success:
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              itemBuilder: (context, index) {
                return index >= state.posts.length
                    ? const _BottomLoader()
                    : _PostListItem(post: state.posts[index]);
              },
            );
          case PostStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case PostStatus.failure:
            return Center(child: Text('${state.message}'));
        }
      },
    );
  }
}
