import 'package:flutter/foundation.dart';
import 'package:task_manager/models/user.dart';

class UserState with ChangeNotifier {
  User? _currentUser;

  User get currrentUser => _currentUser ?? User(fullName: '', username: '');

  String get usernameIcon => _currentUser != null && _currentUser!.isLogin
      ? _currentUser!.fullName
          .split(' ')
          .map((name) => '$name'[0])
          .toList()
          .join('')
          .toUpperCase()
      : '';
}
