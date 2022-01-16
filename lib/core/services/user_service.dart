import 'dart:convert';

import 'package:task_manager/core/offline_db/user_offline_provider/user_offline_provider.dart';
import 'package:task_manager/core/services/http_service.dart';
import 'package:task_manager/core/services/preference_service.dart';
import 'package:task_manager/models/user.dart';

class UserService {
  final String preferenceKey = 'current_user';

  Future<User?> login({
    required String username,
    required String password,
  }) async {
    User? user;
    try {
      var url = 'api/me.json';
      var queryParameters = {
        'fields': 'id,name,email,gender,phoneNumber,organisationUnits[id],userGroups[name,id]'
      };
      HttpService http = new HttpService(
        username: username,
        password: password,
      );
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        user = User.fromJson(
          json.decode(response.body),
          username,
          password,
        );
      }
      return user;
    } catch (error) {
      throw error;
    }
  }

  Future logout() async {
    User? user = await getCurrentUser();
    if (user != null) {
      user.isLogin = false;
      await setCurrentUser(user);
    }
  }

  Future<User?> getCurrentUser() async {
    String? userId = await PreferenceService.getPreferenceValue(preferenceKey);
    List<User> users = await UserOfflineProvider().getUsers();
    List<User> filteredUsers = users.where((User user) => user.id == userId).toList();
    return filteredUsers.length > 0 ? filteredUsers[0] : null;
  }

  setCurrentUser(
    User user,
  ) async {
    await UserOfflineProvider().addOrUpdateUser(user);
    await PreferenceService.setPreferenceValue(
      preferenceKey,
      user.id,
    );
  }
}
