import 'package:flutter/material.dart';
import 'package:task_flow/core/models/user.dart';

class UserListState extends ChangeNotifier {
  List<User> _allUsers = [];
  bool _loading = false;

  List<User> get allUsers => _allUsers;
  bool get loading => _loading;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    
    // TODO: Load users from ObjectBox or API
    await _loadUsers();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadUsers() async {
    // TODO: Implement ObjectBox/API loading
    // For now, create some sample users
    _allUsers = _generateSampleUsers();
  }

  List<User> _generateSampleUsers() {
    return [
      User(
        id: 'user1',
        username: 'john.doe',
        fullName: 'John Doe',
        email: 'john.doe@taskflow.com',
      ),
      User(
        id: 'user2',
        username: 'jane.smith',
        fullName: 'Jane Smith',
        email: 'jane.smith@taskflow.com',
      ),
      User(
        id: 'user3',
        username: 'bob.johnson',
        fullName: 'Bob Johnson',
        email: 'bob.johnson@taskflow.com',
      ),
      User(
        id: 'user4',
        username: 'alice.williams',
        fullName: 'Alice Williams',
        email: 'alice.williams@taskflow.com',
      ),
      User(
        id: 'user5',
        username: 'charlie.brown',
        fullName: 'Charlie Brown',
        email: 'charlie.brown@taskflow.com',
      ),
      User(
        id: 'user6',
        username: 'diana.prince',
        fullName: 'Diana Prince',
        email: 'diana.prince@taskflow.com',
      ),
      User(
        id: 'user7',
        username: 'evan.davis',
        fullName: 'Evan Davis',
        email: 'evan.davis@taskflow.com',
      ),
      User(
        id: 'user8',
        username: 'frank.miller',
        fullName: 'Frank Miller',
        email: 'frank.miller@taskflow.com',
      ),
      User(
        id: 'user9',
        username: 'grace.lee',
        fullName: 'Grace Lee',
        email: 'grace.lee@taskflow.com',
      ),
      User(
        id: 'user10',
        username: 'henry.wilson',
        fullName: 'Henry Wilson',
        email: 'henry.wilson@taskflow.com',
      ),
    ];
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
    }).toList();
  }
}
