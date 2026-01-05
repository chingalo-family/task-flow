# Authentication Guide

This document provides comprehensive information about authentication and authorization in Task Flow.

## 🔐 Overview

Task Flow supports multiple authentication methods to provide flexible and secure user access:

1. **Email/Password Authentication** (Current)
2. **Google OAuth** (Planned - v1.1.0)
3. **Apple Sign-In** (Planned - v1.1.0)

## 📋 Current Implementation

### Email/Password Authentication

The current version uses traditional email/password authentication with the following features:

#### User Registration

**Process**:
1. User provides registration details
2. System validates input
3. Account created in backend (DHIS2 or custom API)
4. User automatically logged in
5. User credentials stored locally (encrypted)

**Required Fields**:
- Username (unique)
- Email address
- Password (minimum 8 characters)
- First name
- Surname
- Phone number

**Implementation**:
```dart
// User registration
final user = await UserService().signUpUser(
  username: 'johndoe',
  email: 'john@example.com',
  password: 'SecurePass123!',
  firstName: 'John',
  surname: 'Doe',
  phoneNumber: '+1234567890',
);
```

#### User Login

**Process**:
1. User enters username and password
2. Credentials validated against backend
3. On success, user data fetched from API
4. User entity stored in ObjectBox
5. User marked as logged in
6. Session maintained locally

**Implementation**:
```dart
// User login
final user = await UserService().login(
  'johndoe',
  'SecurePass123!',
);

if (user != null) {
  // Login successful
  await UserState().setCurrentUser(user);
} else {
  // Login failed
  showError('Invalid credentials');
}
```

#### Password Management

**Change Password**:
```dart
await UserService().changeCurrentUserPassword(
  currentPassword: 'OldPass123!',
  newPassword: 'NewSecurePass456!',
);
```

### Local Storage

#### User Data Storage

User data is persisted using **ObjectBox** with the following entity:

```dart
@Entity()
class UserEntity {
  int id;                    // ObjectBox ID
  String apiUserId;          // API user ID
  String username;           // Unique username
  String? fullName;          // Display name
  String? password;          // Encrypted password
  String? email;             // Email address
  String? phoneNumber;       // Phone number
  bool isLogin;              // Login status
  DateTime createdAt;        // Account creation
  DateTime updatedAt;        // Last update
}
```

#### Secure Credentials Storage

Sensitive data is stored using **Flutter Secure Storage**:

```dart
// Store credentials securely
await FlutterSecureStorage().write(
  key: 'user_token',
  value: token,
);

// Retrieve credentials
final token = await FlutterSecureStorage().read(
  key: 'user_token',
);
```

### Session Management

#### Current User State

The app maintains current user state using **Provider**:

```dart
class UserState extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> initialize() async {
    _currentUser = await UserService().getCurrentUser();
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    await UserService().setCurrentUser(user);
    notifyListeners();
  }

  Future<void> logout() async {
    await UserService().logout();
    _currentUser = null;
    notifyListeners();
  }
}
```

#### Session Persistence

Sessions persist across app restarts:
1. User credentials stored in ObjectBox
2. Login status maintained
3. Auto-login on app launch
4. Manual logout clears session

### Logout

**Process**:
1. User initiates logout
2. Current user marked as logged out
3. Local session cleared
4. User redirected to login screen

**Implementation**:
```dart
await UserService().logout();
// Optionally clear local data
await UserService().clearAllLocalData();
```

## 🚀 Planned Authentication Methods

### Google OAuth (v1.1.0)

**Features**:
- One-tap sign-in
- No password required
- Faster registration
- Trusted authentication

**Flow**:
```
1. User taps "Sign in with Google"
   ↓
2. Google OAuth consent screen
   ↓
3. User grants permissions
   ↓
4. App receives ID token
   ↓
5. Backend validates token
   ↓
6. User account created/retrieved
   ↓
7. User logged in
```

**Implementation (Planned)**:
```dart
// Google Sign-In
final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
if (googleUser != null) {
  final GoogleSignInAuthentication auth = await googleUser.authentication;
  final user = await AuthService().authenticateWithGoogle(
    idToken: auth.idToken!,
  );
}
```

### Apple Sign-In (v1.1.0)

**Features**:
- Privacy-focused
- Hide email option
- Native iOS/macOS integration
- Secure authentication

**Flow**:
```
1. User taps "Sign in with Apple"
   ↓
2. Apple ID authentication
   ↓
3. User approves (Face ID/Touch ID)
   ↓
4. App receives identity token
   ↓
5. Backend validates token
   ↓
6. User account created/retrieved
   ↓
7. User logged in
```

**Implementation (Planned)**:
```dart
// Apple Sign-In
final credential = await SignInWithApple.getAppleIDCredential(
  scopes: [
    AppleIDAuthorizationScopes.email,
    AppleIDAuthorizationScopes.fullName,
  ],
);
final user = await AuthService().authenticateWithApple(
  identityToken: credential.identityToken!,
  authorizationCode: credential.authorizationCode!,
);
```

## 🔒 Security Best Practices

### Password Requirements

**Current Requirements**:
- Minimum 8 characters
- No maximum length enforced (API dependent)

**Recommended Requirements** (for backend implementation):
- Minimum 12 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number
- At least one special character
- Not in common password list
- Different from username

**Validation Example**:
```dart
bool isPasswordStrong(String password) {
  if (password.length < 12) return false;
  if (!password.contains(RegExp(r'[A-Z]'))) return false;
  if (!password.contains(RegExp(r'[a-z]'))) return false;
  if (!password.contains(RegExp(r'[0-9]'))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}
```

### Password Storage

**Never store passwords in plain text!**

**Client-side**:
- Passwords temporarily stored in memory only
- Encrypted when stored locally (if needed)
- Cleared after successful authentication

**Server-side** (Recommended):
- Use bcrypt, Argon2, or PBKDF2
- Salt passwords before hashing
- Use appropriate work factor
- Never log passwords

### Token Security

**JWT Tokens** (for API authentication):

**Best Practices**:
- Short expiration time (1 hour recommended)
- Use refresh tokens for extended sessions
- Rotate refresh tokens
- Revoke tokens on logout
- Store tokens securely (Flutter Secure Storage)

**Example Token Structure**:
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "usr_123abc",
    "username": "johndoe",
    "iat": 1704632400,
    "exp": 1704636000
  }
}
```

### Secure Communication

**HTTPS/TLS**:
- All API calls must use HTTPS
- Certificate validation enabled
- Certificate pinning (planned)

**Request Validation**:
- Validate all inputs
- Sanitize user data
- Check for SQL injection
- Prevent XSS attacks

## 🔑 Authorization

### User Roles (Planned)

**Role Types**:
- `user` - Standard user (default)
- `admin` - Administrator
- `team_lead` - Team leader
- `manager` - Project manager

**Permissions**:
```dart
enum Permission {
  createTask,
  editTask,
  deleteTask,
  createTeam,
  editTeam,
  deleteTeam,
  manageUsers,
  viewAnalytics,
}

class Role {
  final String name;
  final List<Permission> permissions;
  
  const Role(this.name, this.permissions);
}
```

### Access Control

**Current Implementation**:
- Users can only modify their own data
- Team members can view team data
- Task assignees can edit their tasks

**Planned Implementation**:
- Role-based access control (RBAC)
- Fine-grained permissions
- Team-level permissions
- Organization-level permissions

## 🔄 Session Management

### Token Lifecycle

**Access Token**:
- Short-lived (1 hour)
- Used for API authentication
- Included in request headers
- Refreshed automatically

**Refresh Token**:
- Long-lived (30 days)
- Used to obtain new access tokens
- Stored securely
- Rotated on use

### Auto-Login

**Current Behavior**:
1. App checks for stored user on launch
2. If found and isLogin=true, auto-login
3. User taken directly to home screen

**Implementation**:
```dart
class SplashScreen extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = await UserService().getCurrentUser();
    
    if (user != null && user.isLogin) {
      // User is logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else {
      // User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    }
  }
}
```

### Logout Behavior

**Actions on Logout**:
1. Mark user as logged out in ObjectBox
2. Clear secure storage tokens
3. Clear sensitive in-memory data
4. Optionally clear all local data
5. Navigate to login screen

## 🛡️ Security Features

### Current Security Measures

1. **Encrypted Storage**
   - Flutter Secure Storage for tokens
   - ObjectBox for user data

2. **Secure Communication**
   - HTTPS ready
   - Basic authentication for API

3. **Input Validation**
   - Email format validation
   - Password strength check
   - Username validation

### Planned Security Enhancements

1. **Two-Factor Authentication (2FA)**
   - TOTP (Time-based One-Time Password)
   - SMS verification
   - Email verification

2. **Biometric Authentication**
   - Fingerprint
   - Face ID / Touch ID
   - Device biometrics

3. **Advanced Security**
   - Certificate pinning
   - API request signing
   - Anomaly detection
   - Rate limiting

## 📱 Platform-Specific Considerations

### iOS
- Keychain for secure storage
- Face ID / Touch ID integration
- Sign in with Apple

### Android
- Keystore for secure storage
- Fingerprint authentication
- Google Play Integrity

### Web
- LocalStorage encryption
- CORS handling
- Session cookies (HttpOnly, Secure)

### Desktop
- OS credential manager
- Hardware security modules

## 🧪 Testing Authentication

### Unit Tests

```dart
test('should login successfully with valid credentials', () async {
  final user = await UserService().login('testuser', 'password123');
  expect(user, isNotNull);
  expect(user!.username, equals('testuser'));
});

test('should return null with invalid credentials', () async {
  final user = await UserService().login('testuser', 'wrongpassword');
  expect(user, isNull);
});
```

### Integration Tests

```dart
testWidgets('should navigate to home after successful login', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // Enter credentials
  await tester.enterText(find.byKey(Key('username')), 'testuser');
  await tester.enterText(find.byKey(Key('password')), 'password123');
  
  // Tap login button
  await tester.tap(find.byKey(Key('loginButton')));
  await tester.pumpAndSettle();
  
  // Should be on home screen
  expect(find.byType(Home), findsOneWidget);
});
```

## 🔍 Troubleshooting

### Common Issues

**Issue**: Login fails with valid credentials
- Check network connection
- Verify API endpoint configuration
- Check backend logs
- Ensure password is correct

**Issue**: Auto-login not working
- Check if user entity exists in ObjectBox
- Verify isLogin flag is true
- Check secure storage permissions

**Issue**: Token expired
- Implement token refresh
- Check token expiration time
- Verify system time is correct

## 📚 Additional Resources

- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [ObjectBox Documentation](https://docs.objectbox.io/flutter)
- [OAuth 2.0 Specification](https://oauth.net/2/)
- [JWT.io](https://jwt.io/)
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)

---

For more information, see:
- [API Specification](API_SPECIFICATION.md)
- [Architecture Overview](ARCHITECTURE.md)
- [Security Best Practices](#security-best-practices)
