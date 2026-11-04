import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/core/constants/api_config.dart';

class PreferenceService {
  PreferenceService._();
  static final PreferenceService _instance = PreferenceService._();
  factory PreferenceService() => _instance;

  /// Get current user ID for user-specific keys
  Future<String?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ApiConfig.userIdKey);
  }

  /// Create user-specific key
  String _userKey(String key, String? userId) {
    if (userId != null && userId.isNotEmpty) {
      return 'user_${userId}_$key';
    }
    return key; // Fallback to global key if no user
  }

  /// Set string value (user-specific by default)
  Future<void> setString(
    String key,
    String value, {
    bool global = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = global ? null : await _getCurrentUserId();
    final finalKey = _userKey(key, userId);
    await prefs.setString(finalKey, value);
  }

  /// Get string value (user-specific by default)
  Future<String?> getString(String key, {bool global = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = global ? null : await _getCurrentUserId();
    final finalKey = _userKey(key, userId);
    return prefs.getString(finalKey);
  }

  /// Set bool value (user-specific by default)
  Future<void> setBool(String key, bool value, {bool global = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = global ? null : await _getCurrentUserId();
    final finalKey = _userKey(key, userId);
    await prefs.setBool(finalKey, value);
  }

  /// Get bool value (user-specific by default)
  Future<bool?> getBool(String key, {bool global = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = global ? null : await _getCurrentUserId();
    final finalKey = _userKey(key, userId);
    return prefs.getBool(finalKey);
  }

  /// Remove value (user-specific by default)
  Future<void> remove(String key, {bool global = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = global ? null : await _getCurrentUserId();
    final finalKey = _userKey(key, userId);
    await prefs.remove(finalKey);
  }
}
