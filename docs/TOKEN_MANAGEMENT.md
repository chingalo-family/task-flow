# Token Management Flow

This document explains how authentication tokens are managed throughout the application lifecycle.

## Token Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    User Registration/Login                       │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│           API Response with Token                                │
│  {                                                                │
│    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",          │
│    "expiresAt": "2026-01-15T08:23:43.434Z",                     │
│    "user": {...}                                                 │
│  }                                                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              Store Token in SharedPreferences                    │
│  Key: 'auth_token'                                               │
│  Value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."               │
│                                                                   │
│  Key: 'auth_token_expiry'                                        │
│  Value: "2026-01-15T08:23:43.434Z"                              │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              All Future API Requests                             │
│  Headers:                                                        │
│    Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...│
│    Content-Type: application/json                                │
│    Accept: application/json                                      │
└─────────────────────────────────────────────────────────────────┘
```

## Implementation Details

### 1. Registration Flow

**File**: `lib/core/services/auth_service.dart`

```dart
Future<User?> register({...}) async {
  final response = await _api.post(
    ApiConfig.registerEndpoint,
    body: {...},
    requireAuth: false,  // No auth needed for registration
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);
    
    // Extract token from response
    final token = data['token'] as String?;
    final expiresAt = data['expiresAt'] as String?;
    
    // Store token for future requests
    if (token != null) {
      await _api.setToken(token);  // Stores in SharedPreferences
      if (expiresAt != null) {
        await _prefs.setString(ApiConfig.tokenExpiryKey, expiresAt);
      }
    }
    
    // Parse and return user
    final user = User.fromJson(data['user']);
    return user;
  }
}
```

### 2. Login Flow

**File**: `lib/core/services/auth_service.dart`

```dart
Future<User?> login(String username, String password) async {
  final response = await _api.post(
    ApiConfig.loginEndpoint,
    body: {
      'username': username,
      'password': password,
    },
    requireAuth: false,  // No auth needed for login
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    
    // Extract and store token
    final token = data['token'] as String?;
    final expiresAt = data['expiresAt'] as String?;
    
    if (token != null) {
      await _api.setToken(token);  // Stores in SharedPreferences
      if (expiresAt != null) {
        await _prefs.setString(ApiConfig.tokenExpiryKey, expiresAt);
      }
    }
    
    final user = User.fromJson(data['user']);
    return user;
  }
}
```

### 3. Token Storage

**File**: `lib/core/services/task_flow_api_service.dart`

```dart
class TaskFlowApiService {
  final PreferenceService _prefs = PreferenceService();
  String? _authToken;  // In-memory cache

  /// Set the authentication token
  Future<void> setToken(String token) async {
    _authToken = token;  // Cache in memory
    await _prefs.setString(ApiConfig.tokenKey, token);  // Persist to disk
  }

  /// Initialize by loading stored token
  Future<void> initialize() async {
    _authToken = await _prefs.getString(ApiConfig.tokenKey);
  }
}
```

### 4. Using Token in Requests

**File**: `lib/core/services/task_flow_api_service.dart`

```dart
/// Get headers for authenticated requests
Map<String, String> _getHeaders({bool includeAuth = true}) {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  if (includeAuth && _authToken != null) {
    headers['Authorization'] = 'Bearer $_authToken';  // Add token
  }
  
  return headers;
}

/// Example GET request
Future<http.Response> get(
  String endpoint, {
  Map<String, dynamic>? queryParameters,
  bool requireAuth = true,
}) async {
  if (requireAuth) await initialize();  // Load token from storage
  
  final uri = Uri.https(
    ApiConfig.baseUrl,
    '${ApiConfig.apiPath}$endpoint',
    queryParameters,
  );
  
  return await http.get(
    uri,
    headers: _getHeaders(includeAuth: requireAuth),  // Include token
  );
}
```

### 5. Example: Creating a Task

**File**: `lib/core/services/api_task_service.dart`

```dart
Future<Task?> createTask(Task task) async {
  // The TaskFlowApiService will:
  // 1. Load token from SharedPreferences
  // 2. Add it to the Authorization header
  // 3. Make the API request
  final response = await _api.post(
    ApiConfig.tasksEndpoint,
    body: taskJson,
    requireAuth: true,  // Token will be included automatically
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    // Process response
  }
}
```

## Token Lifecycle

### App Startup

```dart
// File: lib/modules/splash/splash.dart

// 1. Check if token exists
final prefs = PreferenceService();
final tokenExpiry = await prefs.getString(ApiConfig.tokenExpiryKey);

// 2. Check if token expired
if (tokenExpiry != null && ApiConfig.isTokenExpired(tokenExpiry)) {
  // Token expired, logout
  await userState.logout();
  destination = const LoginPage();
} else if (userState.isAuthenticated) {
  // Token valid, proceed to home
  destination = const Home();
} else {
  // No token, show login
  destination = const LoginPage();
}
```

### Making Authenticated Requests

```dart
// 1. Service initializes and loads token
final taskService = ApiTaskService();

// 2. When creating a task
final task = await taskService.createTask(myTask);

// Behind the scenes:
// - TaskFlowApiService.initialize() loads token from SharedPreferences
// - Token is added to Authorization header: "Bearer <token>"
// - Request is sent to API
// - API validates token and processes request
```

### Token Expiration

```dart
// File: lib/core/constants/api_config.dart

static bool isTokenExpired(String? expiryDate) {
  if (expiryDate == null || expiryDate.isEmpty) return true;
  try {
    final expiry = DateTime.parse(expiryDate);
    return DateTime.now().isAfter(expiry);
  } catch (e) {
    return true;
  }
}
```

### Logout

```dart
// File: lib/core/services/auth_service.dart

Future<void> logout() async {
  await _api.clearToken();  // Clears token, expiry, and user ID
}

// In TaskFlowApiService:
Future<void> clearToken() async {
  _authToken = null;  // Clear memory cache
  await _prefs.remove(ApiConfig.tokenKey);  // Remove from disk
  await _prefs.remove(ApiConfig.tokenExpiryKey);
  await _prefs.remove(ApiConfig.userIdKey);
}
```

## Security Considerations

### Current Implementation

1. **Storage**: SharedPreferences (unencrypted)
2. **Transmission**: HTTPS only
3. **Format**: JWT (JSON Web Token)
4. **Expiry**: 7 days (604800 seconds)

### Best Practices Implemented

✅ Token stored separately from user data
✅ Token expiry checked on app startup
✅ Automatic logout on token expiry
✅ Token cleared on logout
✅ HTTPS for all API calls
✅ Token included in Authorization header (not URL)

### Recommended Improvements

For production, consider:

1. **Secure Storage**
   ```yaml
   # pubspec.yaml
   dependencies:
     flutter_secure_storage: ^9.0.0
   ```
   
   ```dart
   // Use instead of SharedPreferences
   final storage = FlutterSecureStorage();
   await storage.write(key: 'auth_token', value: token);
   ```

2. **Token Refresh**
   - Implement automatic token refresh before expiry
   - Use refresh token pattern

3. **Certificate Pinning**
   - Pin SSL certificate to prevent MITM attacks

## Testing Token Flow

### Manual Test Steps

1. **Fresh Install**
   ```
   - Install app
   - Verify no token in SharedPreferences
   - Should show login page
   ```

2. **Registration**
   ```
   - Register new user
   - Check SharedPreferences for:
     - 'auth_token': Should contain JWT token
     - 'auth_token_expiry': Should contain future date
     - 'user_id': Should contain user ID
   - Verify redirected to home
   ```

3. **Token Usage**
   ```
   - Create a task
   - Check network logs
   - Verify Authorization header contains: "Bearer <token>"
   ```

4. **Token Persistence**
   ```
   - Close app
   - Reopen app
   - Should remain logged in
   - Should NOT show login page
   ```

5. **Token Expiry**
   ```
   - Manually edit 'auth_token_expiry' to past date
   - Restart app
   - Should auto-logout
   - Should show login page
   ```

6. **Logout**
   ```
   - Logout from app
   - Check SharedPreferences
   - All auth keys should be removed
   - Should show login page
   ```

### Debugging Token Issues

```dart
// Add logging to see token flow
print('Token stored: ${await _prefs.getString(ApiConfig.tokenKey)}');
print('Token expiry: ${await _prefs.getString(ApiConfig.tokenExpiryKey)}');
print('Is expired: ${ApiConfig.isTokenExpired(expiryDate)}');
```

## Common Issues and Solutions

### Issue 1: "Unauthorized" errors after login

**Cause**: Token not being included in requests

**Solution**: Verify `requireAuth: true` in API calls and token is loaded:
```dart
if (requireAuth) await initialize();
```

### Issue 2: Token persists after logout

**Cause**: clearToken() not called or not working

**Solution**: Verify all preference keys are removed:
```dart
await _prefs.remove(ApiConfig.tokenKey);
await _prefs.remove(ApiConfig.tokenExpiryKey);
await _prefs.remove(ApiConfig.userIdKey);
```

### Issue 3: User logged out unexpectedly

**Cause**: Token expired or cleared

**Solution**: Check token expiry logic and storage persistence

## Summary

The token management implementation:

1. ✅ Receives token from login/registration API response
2. ✅ Stores token in SharedPreferences with key `auth_token`
3. ✅ Stores expiry date with key `auth_token_expiry`
4. ✅ Loads token on app startup and before each API request
5. ✅ Includes token in all authenticated requests as `Authorization: Bearer <token>`
6. ✅ Checks token expiry on app startup
7. ✅ Auto-logout on token expiry
8. ✅ Clears token on manual logout

This ensures seamless authentication across the entire application lifecycle.
