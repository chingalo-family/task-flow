import 'package:flutter/foundation.dart';

import '../../core/models/user.dart';
import '../../core/services/user_service.dart';

class UserState extends ChangeNotifier {
  User? _currentUser;
  final UserService _service = UserService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    _currentUser = await _service.getCurrentUser();
    notifyListeners();
  }

  Future<bool> signIn(
    String username,
    String password, {
    String baseUrl = 'http://localhost:8080',
  }) async {
    final user = await _service.login(username, password, baseUrl: baseUrl);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await _service.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> setCurrent(User user) async {
    await _service.setCurrentUser(user);
    _currentUser = user;
    notifyListeners();
  }
}
