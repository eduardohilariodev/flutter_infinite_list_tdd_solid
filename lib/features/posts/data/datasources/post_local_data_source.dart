import 'package:flutter_infinite_list_tdd_solid/features/posts/data/models/post_model.dart';

/// Up until now, the methods we created were always about getting data, whether
/// the Entity or the Model. They were also split into getting concrete or
/// random number trivia. We're going to break this pattern with the
/// [PostLocalDataSource]. Here, we will also need to get the data into the
/// cache and **we're also not going to care whether we're dealing with a
/// post**. That's because the caching policy (implemented inside the
/// `Repository`) will be simple - always cache and retrieve the last posts
/// gotten from the remote Data Source.
///
/// Notice that in neither of the Data Sources had we written code which seems
/// to be dependent on some outer layer of the app. The URL for the API will
/// have to be a String, yet, the type of the number parameter for the remote
/// Data Source is an integer `Future<List<PostModel>> getPosts(int
/// startIndex);` This coding practice allows you to swap the low-level http
/// package for something like chopper without any significant issues.
abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> postsToCache);

  /// Gets the cached [List<PostModel>] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws a [NoLocalDataException] if no cached data is present.
  Future<List<PostModel>> getLastPosts();
}
