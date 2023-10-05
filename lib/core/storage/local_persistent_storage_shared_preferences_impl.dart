import 'package:flutter_infinite_list_tdd_solid/core/storage/local_persistent_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPersistentStorageSharedPreferencesImpl
    implements LocalPersistentStorage {
  LocalPersistentStorageSharedPreferencesImpl(this.sharedPreferences);

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
