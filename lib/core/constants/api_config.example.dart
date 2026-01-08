class ApiConfig {
  // Base URL for the Task Flow API
  static const String baseUrl = ''; // domain for the api
  static const String apiPath =
      '/task-flow-api'; // if you have pass, you can change with your api path if any

  // Preference keys for token storage
  static const String tokenKey = 'auth_token';
  static const String tokenExpiryKey = 'auth_token_expiry';
  static const String userIdKey = 'user_id';

  // Auth API Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';

  // User API Endpoints
  static const String usersEndpoint = '/api/users';

  // Task API Endpoints
  static const String tasksEndpoint = '/api/tasks';

  // Team API Endpoints
  static const String teamsEndpoint = '/api/teams';

  // Notification API Endpoints
  static const String notificationsEndpoint = '/api/notifications';

  // Check if token is expired
  static bool isTokenExpired(String? tokenExpiryDate) {
    if (tokenExpiryDate == null || tokenExpiryDate.isEmpty) return true;
    try {
      final expiry = DateTime.parse(tokenExpiryDate);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }
}
