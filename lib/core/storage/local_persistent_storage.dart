abstract interface class LocalPersistentStorage {
  String? getString(String key);

  Future<void> setString(String key, String value);
}

/// ### Usage:
/// ```
/// LocalPersistentStorageKeys.<key>.name,
/// ```
enum LocalPersistentStorageKeys { cachedPosts }
