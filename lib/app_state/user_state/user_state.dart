import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  Future<User?> signUp({
    required String name,
    required String email,
    required String username,
    required String phoneNumber,
    required String password,
    BuildContext? context,
  }) async {
    User? user = await _service.signUpUser(
      username: username,
      password: password,
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      context: context,
    );
    return user;
  }

  Future<bool> signIn({
    required String username,
    required String password,
    BuildContext? context,
  }) async {
    final user = await _service.login(username, password, context: context);
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

  Future<bool> requestForgetPassword(String email) async {
    return await _service.requestForgetPassword(email);
  }

  Future<bool> changeCurrentUserPassword(
    String newPassword, {
    BuildContext? context,
  }) async {
    return await _service.changeCurrentUserPassword(
      newPassword,
      context: context,
    );
  }
}
