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
    bool _isUserAccountExist = false;
    try {
      var url = 'api/users.json';
      var queryParameters = {
        'fields': 'id,created',
        'filter': 'userCredentials.username:eq:$dhisUsername'
      };
      queryParameters['paging'] = 'false';
      HttpService http = new HttpService(
        username: Dhis2Connection.username,
        password: Dhis2Connection.password,
      );
      var response = await http.httpGet(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        List users = body['users'] ?? [];
        _isUserAccountExist = users.isNotEmpty;
      } else {
        throw 'Failed to check existance of account';
      }
    } catch (error) {
      throw error;
    }
    return _isUserAccountExist;
  }

  Future createOrUpdateDhis2UserAccount({
    required User user,
    bool shouldUpdate = false,
  }) async {
    try {
      //@TODO Validate password;
      var url = shouldUpdate ? 'api/users/${user.id}' : 'api/users';
      HttpService http = new HttpService(
        username: Dhis2Connection.username,
        password: Dhis2Connection.password,
      );
      var response = shouldUpdate
          ? await http.httpPut(url, json.encode(user.toDhis2Json()), queryParameters: {})
          : await http.httpPost(url, json.encode(user.toDhis2Json()), queryParameters: {});
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 409) {
      } else if (response.statusCode == 201) {}

      // {"httpStatus":"Created","httpStatusCode":201,"status":"OK","response":{"responseType":"ObjectReport","klass":"org.hisp.dhis.user.User","uid":"FB0vO0UBcBO","errorReports":[]}}
    } catch (error) {
      print(error);
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
