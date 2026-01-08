import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/services/preference_service.dart';

/// HTTP Service for Task Flow API
/// 
/// This service handles all HTTP requests to the Task Flow backend API
/// with token-based authentication
class TaskFlowApiService {
  final PreferenceService _prefs = PreferenceService();
  String? _authToken;

  TaskFlowApiService._();
  static final TaskFlowApiService _instance = TaskFlowApiService._();
  factory TaskFlowApiService() => _instance;

  /// Initialize the service by loading the stored token
  Future<void> initialize() async {
    _authToken = await _prefs.getString(ApiConfig.tokenKey);
  }

  /// Set the authentication token
  Future<void> setToken(String token) async {
    _authToken = token;
    await _prefs.setString(ApiConfig.tokenKey, token);
  }

  /// Clear the authentication token
  Future<void> clearToken() async {
    _authToken = null;
    await _prefs.remove(ApiConfig.tokenKey);
    await _prefs.remove(ApiConfig.tokenExpiryKey);
    await _prefs.remove(ApiConfig.userIdKey);
  }

  /// Get the current authentication token
  String? get token => _authToken;

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _prefs.getString(ApiConfig.tokenKey);
    final expiryDate = await _prefs.getString(ApiConfig.tokenExpiryKey);
    
    if (token == null || expiryDate == null) return false;
    return !ApiConfig.isTokenExpired(expiryDate);
  }

  /// Get headers for authenticated requests
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  /// GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await initialize();
    
    final uri = Uri.https(
      ApiConfig.baseUrl,
      '${ApiConfig.apiPath}$endpoint',
      queryParameters,
    );
    
    try {
      return await http.get(
        uri,
        headers: _getHeaders(includeAuth: requireAuth),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await initialize();
    
    final uri = Uri.https(
      ApiConfig.baseUrl,
      '${ApiConfig.apiPath}$endpoint',
    );
    
    try {
      return await http.post(
        uri,
        headers: _getHeaders(includeAuth: requireAuth),
        body: body != null ? json.encode(body) : null,
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// PUT request
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await initialize();
    
    final uri = Uri.https(
      ApiConfig.baseUrl,
      '${ApiConfig.apiPath}$endpoint',
    );
    
    try {
      return await http.put(
        uri,
        headers: _getHeaders(includeAuth: requireAuth),
        body: body != null ? json.encode(body) : null,
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// DELETE request
  Future<http.Response> delete(
    String endpoint, {
    bool requireAuth = true,
  }) async {
    if (requireAuth) await initialize();
    
    final uri = Uri.https(
      ApiConfig.baseUrl,
      '${ApiConfig.apiPath}$endpoint',
    );
    
    try {
      return await http.delete(
        uri,
        headers: _getHeaders(includeAuth: requireAuth),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// PATCH request
  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await initialize();
    
    final uri = Uri.https(
      ApiConfig.baseUrl,
      '${ApiConfig.apiPath}$endpoint',
    );
    
    try {
      return await http.patch(
        uri,
        headers: _getHeaders(includeAuth: requireAuth),
        body: body != null ? json.encode(body) : null,
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
