import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/services/preference_service.dart';

class ApiService {
  final PreferenceService _prefs = PreferenceService();
  String? _authToken;

  ApiService._();
  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;

  String? get token => _authToken;

  Future<void> initialize() async {
    _authToken = await _prefs.getString(ApiConfig.tokenKey);
  }

  Future<void> setToken(String token) async {
    _authToken = token;
    await _prefs.setString(ApiConfig.tokenKey, token);
  }

  Future<void> setUserId(String userId) async {
    _authToken = userId;
    await _prefs.setString(ApiConfig.userIdKey, userId);
  }

  Future<void> setTokenExpireDate(String tokenExpiryDate) async {
    await _prefs.setString(ApiConfig.tokenExpiryKey, tokenExpiryDate);
  }

  Future<void> clearToken() async {
    _authToken = null;
    await _prefs.remove(ApiConfig.tokenKey);
    await _prefs.remove(ApiConfig.tokenExpiryKey);
    await _prefs.remove(ApiConfig.userIdKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await _prefs.getString(ApiConfig.tokenKey);
    final expiryDate = await _prefs.getString(ApiConfig.tokenExpiryKey);

    if (token == null || expiryDate == null) return false;
    return !ApiConfig.isTokenExpired(expiryDate);
  }

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

  Uri getApiUrl(String url, {Map<String, dynamic>? queryParameters}) {
    return ApiConfig.baseUrl.isEmpty
        ? Uri.https(ApiConfig.baseUrl, url, queryParameters)
        : Uri.https(
            ApiConfig.baseUrl,
            "${ApiConfig.apiPath}$url",
            queryParameters,
          );
  }

  /// GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requireAuth = true,
  }) async {
    if (requireAuth) await initialize();
    final apiUrl = getApiUrl(endpoint, queryParameters: queryParameters);
    try {
      return await http.get(
        apiUrl,
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
    final apiUrl = getApiUrl(endpoint);
    try {
      return await http.post(
        apiUrl,
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
    final apiUrl = getApiUrl(endpoint);
    try {
      return await http.put(
        apiUrl,
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
    final apiUrl = getApiUrl(endpoint);
    try {
      return await http.delete(
        apiUrl,
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
    final apiUrl = getApiUrl(endpoint);
    try {
      return await http.patch(
        apiUrl,
        headers: _getHeaders(includeAuth: requireAuth),
        body: body != null ? json.encode(body) : null,
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
