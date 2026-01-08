import 'dart:convert';

import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/offline_db/user_offline_provider/user_offline_provider.dart';
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/api_service.dart';
import 'package:task_flow/core/utils/app_util.dart';

class UserService {
  UserService._();
  static final UserService _instance = UserService._();
  factory UserService() => _instance;

  final _offline = UserOfflineProvider();
  final _prefs = PreferenceService();

  Future<User?> signUpUser({
    required String name,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
  }) async {
    User? user;
    final apiService = ApiService();
    try {
      final response = await apiService.post(
        ApiConfig.registerEndpoint,
        body: {
          'username': username,
          'password': password,
          'email': email,
          'name': name,
          'phoneNumber': phoneNumber,
        },
        requireAuth: false,
      );
      final body = jsonDecode(response.body);
      final success = body['success'] as bool;
      final message = body['message'] as String;
      if (success) {
        final token = body['token'] as String;
        final expiresAt = body['expiresAt'] as String;
        final userData = body['user'] as Map<String, dynamic>;
        await apiService.setToken(token);
        await apiService.setTokenExpireDate(expiresAt);
        user = User.fromJson(userData);
        user.isLogin = true;
        await _offline.addOrUpdateUser(user);
        await apiService.setUserId(user.id);
      }
      if (message.isNotEmpty) {
        AppUtil.showToastMessage(message: message);
      }
    } catch (e) {
      ///
    }
    return user;
  }

  Future<User?> login(String username, String password) async {
    User? user;
    final apiService = ApiService();
    try {
      final response = await apiService.post(
        ApiConfig.loginEndpoint,
        body: {'username': username, 'password': password},
        requireAuth: false,
      );
      final body = jsonDecode(response.body);
      final success = body['success'] as bool;
      final message = body['message'] as String;
      if (success) {
        final token = body['token'] as String;
        final expiresAt = body['expiresAt'] as String;
        final userData = body['user'] as Map<String, dynamic>;
        await apiService.setToken(token);
        await apiService.setTokenExpireDate(expiresAt);
        user = User.fromJson(userData);
        user.isLogin = true;
        await _offline.addOrUpdateUser(user);
        await apiService.setUserId(user.id);
      }
      if (message.isNotEmpty && !success) {
        AppUtil.showToastMessage(message: message);
      }
    } catch (e) {
      //
    }
    return user;
  }

  Future<void> syncAvailableUsersInformations({int page = 1}) async {
    final apiService = ApiService();
    try {
      final response = await apiService.get(ApiConfig.usersEndpoint);
      final body = jsonDecode(response.body);
      final success = body['success'] as bool;
      if (success) {
        final meta = body['meta'] as Map<String, dynamic>;
        final totalPages = meta['totalPages'] as int;
        final userData = body['users'] as List;
        for (var userMap in userData) {
          final user = User.fromJson(userMap);
          await _offline.addOrUpdateUser(user);
        }
        if (page < totalPages) {
          await syncAvailableUsersInformations(page: page + 1);
        }
      }
    } catch (e) {
      //
    }
  }

  Future<User?> getCurrentUser() async {
    final id = await _prefs.getString(ApiConfig.userIdKey);
    if (id == null) return null;
    return _offline.getUserById(id);
  }

  Future<void> setCurrentUser(User user) async {
    await _offline.addOrUpdateUser(user);
    await _prefs.setString(ApiConfig.userIdKey, user.id);
  }

  Future<void> logout() async {
    final apiService = ApiService();
    User? currentUser = await getCurrentUser();
    if (currentUser != null) {
      currentUser.isLogin = false;
      await _offline.addOrUpdateUser(currentUser);
    }
    apiService.clearToken();
  }

  Future<bool> changeCurrentUserPassword(String newPassword) async {
    final apiService = ApiService();
    final response = await apiService.post(
      ApiConfig.resetPasswordEndpoint,
      body: {'password': newPassword},
    );
    final body = jsonDecode(response.body);
    final success = body['success'] as bool;
    final message = body['message'] as String;
    if (message.isNotEmpty) {
      AppUtil.showToastMessage(message: message);
    }
    return success;
  }

  Future<bool> requestForgetPassword(String email) async {
    final apiService = ApiService();
    final response = await apiService.post(
      ApiConfig.forgotPasswordEndpoint,
      body: {'email': email},
      requireAuth: false,
    );
    final body = jsonDecode(response.body);
    final success = body['success'] as bool;
    return success;
  }

  Future<List<User>> getAllUsers() async {
    return await _offline.getUsers() as List<User>;
  }
}
