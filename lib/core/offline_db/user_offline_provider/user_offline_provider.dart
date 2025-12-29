import 'dart:convert';

import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/models/user_entity.dart';
import 'package:task_manager/core/services/db_service.dart';
import 'package:task_manager/objectbox.g.dart';

class UserOfflineProvider {
  UserOfflineProvider._();
  static final UserOfflineProvider _instance = UserOfflineProvider._();
  factory UserOfflineProvider() => _instance;

  Future<List<dynamic>> getUsers() async {
    await DBService().init();
    final box = DBService().userBox;
    return box.getAll().map(_toUser).toList();
  }

  Future<User?> getUserById(String apiUserId) async {
    await DBService().init();
    final box = DBService().userBox;
    final q = box.query(UserEntity_.apiUserId.equals(apiUserId)).build();
    final found = q.findFirst();
    q.close();
    return found == null ? null : _toUser(found);
  }

  Future<void> addOrUpdateUser(User user) async {
    await DBService().init();
    final box = DBService().userBox;
    final existing = box
        .query(UserEntity_.apiUserId.equals(user.id))
        .build()
        .findFirst();
    final entity = UserEntity(
      id: existing?.id ?? 0,
      apiUserId: user.id,
      username: user.username,
      fullName: user.fullName,
      password: user.password,
      email: user.email,
      phoneNumber: user.phoneNumber,
      userGroupsJson: user.userGroups == null
          ? null
          : jsonEncode(user.userGroups),
      userOrgUnitIdsJson: user.userOrgUnitIds == null
          ? null
          : jsonEncode(user.userOrgUnitIds),
      isLogin: user.isLogin,
    );
    box.put(entity);
  }

  Future<void> deleteUser(String apiUserId) async {
    await DBService().init();
    final box = DBService().userBox;
    final q = box.query(UserEntity_.apiUserId.equals(apiUserId)).build();
    final found = q.findFirst();
    q.close();
    if (found != null) box.remove(found.id);
  }

  User _toUser(UserEntity e) {
    List<String>? groups;
    List<String>? orgs;
    try {
      if (e.userGroupsJson != null)
        groups = List<String>.from(jsonDecode(e.userGroupsJson!));
      if (e.userOrgUnitIdsJson != null)
        orgs = List<String>.from(jsonDecode(e.userOrgUnitIdsJson!));
    } catch (_) {}
    return User(
      id: e.apiUserId,
      username: e.username,
      fullName: e.fullName,
      password: e.password,
      email: e.email,
      phoneNumber: e.phoneNumber,
      userGroups: groups,
      userOrgUnitIds: orgs,
      isLogin: e.isLogin,
    );
  }
}
