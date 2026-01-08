import 'package:flutter/foundation.dart';

import '../../core/models/user.dart';
import '../../core/services/user_service.dart';
import '../../core/services/auth_service.dart';

class UserState extends ChangeNotifier {
  User? _currentUser;
  final UserService _service;
  final AuthService _authService;

  UserState({UserService? service, AuthService? authService}) 
      : _service = service ?? UserService(),
        _authService = authService ?? AuthService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    // First check if we have a valid token for the new API
    final isAuth = await _authService.isAuthenticated();
    if (isAuth) {
      try {
        _currentUser = await _authService.getCurrentUser();
        if (_currentUser != null) {
          notifyListeners();
          return;
        }
      } catch (e) {
        print('Failed to get user from API: $e');
      }
    }
    
    // Fall back to local storage
    _currentUser = await _service.getCurrentUser();
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    // Try new API first
    try {
      final user = await _authService.login(username, password);
      if (user != null) {
        _currentUser = user;
        // Also save to local storage for offline access
        await _service.setCurrentUser(user);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('API login failed, trying local: $e');
    }
    
    // Fall back to local authentication
    final user = await _service.login(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String surname,
    String? phoneNumber,
  }) async {
    try {
      final user = await _authService.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        surname: surname,
        phoneNumber: phoneNumber,
      );
      
      if (user != null) {
        _currentUser = user;
        // Also save to local storage for offline access
        await _service.setCurrentUser(user);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Registration failed: $e');
      rethrow;
    }
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    await _service.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> setCurrent(User user) async {
    await _service.setCurrentUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> changeCurrentUserPassword(
    String oldPassword,
    String newPassword,
  ) async {
    final success = await _service.changeCurrentUserPassword(
      oldPassword,
      newPassword,
    );
    if (success) {
      // Update current user with new password
      _currentUser = await _service.getCurrentUser();
      notifyListeners();
    }
    return success;
  }
}
