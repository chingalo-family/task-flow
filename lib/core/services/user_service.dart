import 'dart:convert';

import 'package:task_flow/core/constants/dhis2_connection.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/offline_db/user_offline_provider/user_offline_provider.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/core/utils/entry_form_util.dart';

import 'dhis2_http_service.dart';
import 'preference_service.dart';

class UserService {
  static const _kCurrentUserKey = 'current_user_id';
  final String apiFields = 'fields=id,username,displayName,email,phoneNumber';

  UserService._();
  static final UserService _instance = UserService._();
  factory UserService() => _instance;

  final _offline = UserOfflineProvider();
  final _prefs = PreferenceService();

  Future<User?> signUpUser({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String surname,
    required String phoneNumber,
  }) async {
    var url = 'api/users';
    User? user;
    final dhis = Dhis2HttpService(
      username: Dhis2Connection.username,
      password: Dhis2Connection.password,
    );
    var payload = EntryFormUtil.getUserAccountPayload(
      username: username,
      password: password,
      email: email,
      firstName: firstName,
      surname: surname,
      phoneNumber: phoneNumber,
    );
    var response = await dhis.httpPost(url, json.encode(payload));
    if (response.statusCode == 200 || response.statusCode == 201) {
      user = await login(username, password);
    } else {
      throw ('Failed to sign up user, kindly reach out to support.');
    }
    return user;
  }

  Future<User?> login(String username, String password) async {
    final dhis = Dhis2HttpService(username: username, password: password);
    final res = await dhis.httpGet('/api/me.json?$apiFields');
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

  Future<void> syncAvailableUsersInformations({
    required String username,
    required String password,
  }) async {
    const url = '/api/users.json';
    final dhis = Dhis2HttpService(username: username, password: password);
    final response = await dhis.httpGetPagination(url, {});
    var paginationFilter = AppUtil.getPaginationFilters(response);
    for (var filter in paginationFilter) {
      final res = await dhis.httpGet(url, queryParameters: filter);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final users = body['users'] as List<dynamic>;
        for (var userMap in users) {
          final user = User.fromJson(userMap);
          await _offline.addOrUpdateUser(user);
        }
      }
    }
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
    var url = 'api/me/changePassword';
    baseUrl = baseUrl.isEmpty ? Dhis2Connection.baseUrl : baseUrl;
    final cur = await getCurrentUser();
    if (cur == null) return false;
    final dhis = Dhis2HttpService(
      username: cur.username,
      password: oldPassword,
    );
    var response = await dhis.httpPut(
      url,
      json.encode({'oldPassword': oldPassword, 'newPassword': newPassword}),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      cur.password = newPassword;
      await _offline.addOrUpdateUser(cur);
      return true;
    }
    return false;
  }

  Future<List<User>> getAllUsers() async {
    return await _offline.getUsers() as List<User>;
  }
}
