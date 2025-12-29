import 'dart:convert';

import 'package:task_manager/core/constants/dhis2_connection.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/offline_db/user_offline_provider/user_offline_provider.dart';

import 'dhis2_http_service.dart';
import 'preference_service.dart';

class UserService {
  static const _kCurrentUserKey = 'current_user_id';

  UserService._();
  static final UserService _instance = UserService._();
  factory UserService() => _instance;

  final _offline = UserOfflineProvider();
  final _prefs = PreferenceService();

  Future<User?> login(
    String username,
    String password, {
    String baseUrl = '',
  }) async {
    baseUrl = baseUrl.isEmpty ? Dhis2Connection.baseUrl : baseUrl;
    final dhis = Dhis2HttpService(
      username: username,
      password: password,
      baseUri: Uri.parse(baseUrl),
    );
    final res = await dhis.httpGet(
      '/api/me.json?fields=id,username,displayName,email,phone,userGroups,organisationUnits',
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final user = User.fromJson(body);
      user.password = password;
      user.isLogin = true;
      await _offline.addOrUpdateUser(user);
      await _prefs.setString(_kCurrentUserKey, user.id);
      return user;
    }
    return null;
  }

  Future<User?> getCurrentUser() async {
    final id = await _prefs.getString(_kCurrentUserKey);
    if (id == null) return null;
    return _offline.getUserById(id);
  }

  Future<void> setCurrentUser(User user) async {
    await _offline.addOrUpdateUser(user);
    await _prefs.setString(_kCurrentUserKey, user.id);
  }

  Future<void> logout() async {
    final cur = await getCurrentUser();
    if (cur != null) {
      cur.isLogin = false;
      await _offline.addOrUpdateUser(cur);
    }
    await _prefs.remove(_kCurrentUserKey);
  }

  Future<bool> changeCurrentUserPassword(
    String oldPassword,
    String newPassword, {
    String baseUrl = '',
  }) async {
    baseUrl = baseUrl.isEmpty ? Dhis2Connection.baseUrl : baseUrl;
    final cur = await getCurrentUser();
    if (cur == null) return false;
    final dhis = Dhis2HttpService(
      username: cur.username,
      password: oldPassword,
      baseUri: Uri.parse(baseUrl),
    );
    final res = await dhis.httpPost(
      '/api/me/changePassword',
      body: {'password': newPassword},
    );
    if (res.statusCode == 200 || res.statusCode == 204) {
      cur.password = newPassword;
      await _offline.addOrUpdateUser(cur);
      return true;
    }
    return false;
  }
}
