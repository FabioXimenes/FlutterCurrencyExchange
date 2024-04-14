import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageClient {
  Future<String?> get(String key);
  Future<bool> set(String key, String value);
}

class SharedPreferencesStorageClient extends LocalStorageClient {
  SharedPreferences? prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<String?> get(String key) async {
    if (prefs == null) {
      await init();
    }
    return prefs!.getString(key);
  }

  @override
  Future<bool> set(String key, String value) async {
    if (prefs == null) {
      await init();
    }
    return prefs!.setString(key, value);
  }
}
