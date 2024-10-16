import 'dart:convert';

import 'package:task_manager/core/constants/dhis2_connection.dart';
import 'package:task_manager/core/offline_db/user_offline_provider/user_offline_provider.dart';
import 'package:task_manager/core/services/http_service.dart';
import 'package:task_manager/core/services/preference_service.dart';
import 'package:task_manager/models/user.dart';

class UserService {
  final String preferenceKey = 'current_user';

  Future<bool> isUserAccountExist({
    required String dhisUsername,
  }) async {
    bool isUserAccountExist = false;
    try {
      var url = 'api/users.json';
      var queryParameters = {
        'fields': 'id,created',
        'filter': 'userCredentials.username:eq:$dhisUsername'
      };
      queryParameters['paging'] = 'false';
      HttpService http = HttpService(
        username: Dhis2Connection.username,
        password: Dhis2Connection.password,
      );
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        List users = body['users'] ?? [];
        isUserAccountExist = users.isNotEmpty;
      } else {
        throw 'Failed to check existance of account';
      }
    } catch (error) {
      rethrow;
    }
    return isUserAccountExist;
  }

  Future createOrUpdateDhis2UserAccount({
    required User user,
    bool shouldUpdate = false,
  }) async {
    try {
      var url = shouldUpdate ? 'api/users/${user.id}' : 'api/users';
      HttpService http = HttpService(
        username: Dhis2Connection.username,
        password: Dhis2Connection.password,
      );
      var response = shouldUpdate
          ? await http.httpPut(url, json.encode(user.toDhis2Json()),
              queryParameters: {})
          : await http.httpPost(url, json.encode(user.toDhis2Json()),
              queryParameters: {});
      var body = json.decode(response.body);
      String status = body['status'] ?? '';
      //@TODO proper handling of error
      if (status.toLowerCase() != 'ok') {
        throw 'Fail to register account into system';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<User?> login({
    required String username,
    required String password,
  }) async {
    User? user;
    try {
      var url = 'api/me.json';
      var queryParameters = {
        'fields':
            'id,name,email,gender,phoneNumber,organisationUnits[id],userGroups[name,id]'
      };
      HttpService http = HttpService(
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
      rethrow;
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
    List<User> filteredUsers =
        users.where((User user) => user.id == userId).toList();
    return filteredUsers.isNotEmpty ? filteredUsers[0] : null;
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
