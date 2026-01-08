/// API Configuration for Task Flow Backend
/// 
/// This file contains the configuration for the Task Flow API
/// hosted at https://vmi2503861.contaboserver.net/task-flow-api/
class ApiConfig {
  // Base URL for the Task Flow API
  static const String baseUrl = 'vmi2503861.contaboserver.net';
  static const String apiPath = '/task-flow-api';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String refreshTokenEndpoint = '/auth/refresh';
  
  // User endpoints
  static const String usersEndpoint = '/users';
  static const String currentUserEndpoint = '/users/me';
  
  // Task endpoints
  static const String tasksEndpoint = '/tasks';
  
  // Team endpoints
  static const String teamsEndpoint = '/teams';
  
  // Notification endpoints
  static const String notificationsEndpoint = '/notifications';
  
  // Preference keys for token storage
  static const String tokenKey = 'auth_token';
  static const String tokenExpiryKey = 'auth_token_expiry';
  static const String userIdKey = 'user_id';
  
  // Get full URL for an endpoint
  static String getUrl(String endpoint) {
    return 'https://$baseUrl$apiPath$endpoint';
  }
  
  // Check if token is expired
  static bool isTokenExpired(String? expiryDate) {
    if (expiryDate == null || expiryDate.isEmpty) return true;
    try {
      final expiry = DateTime.parse(expiryDate);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }
}
