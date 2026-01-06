import 'package:flutter/foundation.dart';

import '../../core/models/user.dart';
import '../../core/services/user_service.dart';

class UserState extends ChangeNotifier {
  User? _currentUser;
  final UserService _service;

  UserState({UserService? service}) : _service = service ?? UserService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    _currentUser = await _service.getCurrentUser();
    notifyListeners();
  }

  Future<bool> signIn(String username, String password) async {
    final user = await _service.login(username, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
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
