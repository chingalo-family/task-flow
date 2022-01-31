import 'package:flutter/foundation.dart';
import 'package:task_manager/models/user_group.dart';

class UserGroupState with ChangeNotifier {
  List<UserGroup>? _currentUserGroups;

  List<UserGroup> get currentUserGroups => _currentUserGroups ?? [];

  void setCurrentUserGroups(List<UserGroup> userGroups) {
    _currentUserGroups = userGroups;
    notifyListeners();
  }

  void resetCurrentUserGroups() {
    _currentUserGroups = null;
    notifyListeners();
  }
}
