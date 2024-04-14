import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageClient {
  Future<String?> get(String key);
  Future<bool> set(String key, String value);
}

class SharedPreferencesStorageClient extends LocalStorageClient {
  SharedPreferences sharedPreferences;

  SharedPreferencesStorageClient(this.sharedPreferences);

  @override
  Future<String?> get(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<bool> set(String key, String value) async {
    return sharedPreferences.setString(key, value);
  }
}
