import 'package:flutter/material.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/services/user_service.dart';

class UserListState extends ChangeNotifier {
  List<User> _allUsers = [];
  bool _loading = false;

  List<User> get allUsers => _allUsers;
  bool get loading => _loading;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    await _loadUsers();
    _loading = false;
    notifyListeners();
  }

  Future<void> reSyncUserList() async {
    _loading = true;
    notifyListeners();
    User? currentUser = await UserService().getCurrentUser();
    if (currentUser != null) {
      await UserService().syncAvailableUsersInformations();
    }
    await _loadUsers();
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadUsers() async {
    _allUsers = await UserService().getAllUsers();
  }

  List<User> getUsersByIds(List<String> userIds) {
    return _allUsers.where((user) => userIds.contains(user.id)).toList();
  }

  User? getUserById(String userId) {
    try {
      return _allUsers.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  List<User> searchUsers(String query) {
    if (query.isEmpty) return _allUsers;
    final lowerQuery = query.toLowerCase();
    return _allUsers.where((user) {
      return user.username.toLowerCase().contains(lowerQuery) ||
          (user.fullName?.toLowerCase().contains(lowerQuery) ?? false) ||
          (user.email?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList()..sort((a, b) => a.fullName!.compareTo(b.fullName!));
  }
}
