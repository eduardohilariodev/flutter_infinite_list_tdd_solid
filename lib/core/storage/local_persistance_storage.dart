import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalPersistanceStorage {
  String? getString(String key);

  Future<void> setString(String key, String value);
}

class LocalPersistanceStorageImpl implements LocalPersistanceStorage {
  LocalPersistanceStorageImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }
}

/// ### Usage:
/// ```
/// LocalPersistanceStorageKeys.<key>.name,
/// ```
enum LocalPersistanceStorageKeys { cachedPosts }
