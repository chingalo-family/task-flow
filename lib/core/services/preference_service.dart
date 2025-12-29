import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  PreferenceService._();
  static final PreferenceService _instance = PreferenceService._();
  factory PreferenceService() => _instance;

  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
