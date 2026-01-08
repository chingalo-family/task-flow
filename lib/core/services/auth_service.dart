import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/task_flow_api_service.dart';

/// Authentication Service for Task Flow API
/// 
/// Handles user authentication, registration, and password recovery
class AuthService {
  final TaskFlowApiService _api = TaskFlowApiService();
  final PreferenceService _prefs = PreferenceService();

  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  /// Login user with username/email and password
  /// Returns user object if successful, null otherwise
  Future<User?> login(String username, String password) async {
    try {
      final response = await _api.post(
        ApiConfig.loginEndpoint,
        body: {
          'username': username,
          'password': password,
        },
        requireAuth: false,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Store token and expiry
        final token = data['token'] as String?;
        final expiresAt = data['expiresAt'] as String?;
        
        if (token != null) {
          await _api.setToken(token);
          if (expiresAt != null) {
            await _prefs.setString(ApiConfig.tokenExpiryKey, expiresAt);
          }
        }
        
        // Parse user data
        final userData = data['user'] ?? data;
        final user = User.fromJson(userData);
        user.password = password;
        user.isLogin = true;
        
        // Store user ID
        await _prefs.setString(ApiConfig.userIdKey, user.id);
        
        return user;
      }
      
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  /// Register a new user
  /// Returns user object if successful and automatically logs in
  Future<User?> register({
    required String username,
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final response = await _api.post(
        ApiConfig.registerEndpoint,
        body: {
          'username': username,
          'email': email,
          'password': password,
          'name': name,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
        },
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        
        // Check for success flag
        if (data['success'] == false) {
          throw Exception(data['message'] ?? 'Registration failed');
        }
        
        // Store token and expiry
        final token = data['token'] as String?;
        final expiresAt = data['expiresAt'] as String?;
        
        if (token != null) {
          await _api.setToken(token);
          if (expiresAt != null) {
            await _prefs.setString(ApiConfig.tokenExpiryKey, expiresAt);
          }
        }
        
        // Parse user data
        final userData = data['user'];
        final user = User.fromJson(userData);
        user.password = password;
        user.isLogin = true;
        
        // Store user ID
        await _prefs.setString(ApiConfig.userIdKey, user.id);
        
        return user;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  /// Request password reset
  /// Sends a password reset email to the user
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _api.post(
        ApiConfig.forgotPasswordEndpoint,
        body: {'email': email},
        requireAuth: false,
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Forgot password error: $e');
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    await _api.clearToken();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _api.isAuthenticated();
  }

  /// Get current user from API
  Future<User?> getCurrentUser() async {
    try {
      final response = await _api.get(ApiConfig.currentUserEndpoint);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }
      
      return null;
    } catch (e) {
      debugPrint('Get current user error: $e');
      return null;
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final response = await _api.post(
        ApiConfig.refreshTokenEndpoint,
        requireAuth: true,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'] as String?;
        final expiresAt = data['expiresAt'] as String?;
        
        if (token != null) {
          await _api.setToken(token);
          if (expiresAt != null) {
            await _prefs.setString(ApiConfig.tokenExpiryKey, expiresAt);
          }
          return true;
        }
      }
      
      return false;
    } catch (e) {
      debugPrint('Refresh token error: $e');
      return false;
    }
  }
}
