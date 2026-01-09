import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/entities/user_entity.dart';
import 'package:task_flow/core/services/db_service.dart';
import 'package:task_flow/objectbox.g.dart';

class UserOfflineProvider {
  UserOfflineProvider._();
  static final UserOfflineProvider _instance = UserOfflineProvider._();
  factory UserOfflineProvider() => _instance;

  Future<List<dynamic>> getUsers() async {
    await DBService().init();
    final box = DBService().userBox;
    if (box == null) return [];
    return box.getAll().map(_toUser).toList()
      ..sort((a, b) => a.fullName!.compareTo(b.fullName!));
  }

  Future<User?> getUserById(String apiUserId) async {
    await DBService().init();
    final box = DBService().userBox;
    if (box == null) return null;
    final query = box
        .query(
          UserEntity_.apiUserId.equals(apiUserId) as Condition<UserEntity>?,
        )
        .build();
    final found = query.findFirst();
    query.close();
    return found == null ? null : _toUser(found);
  }

  Future<void> addOrUpdateUser(User user) async {
    await DBService().init();
    final box = DBService().userBox;
    if (box == null) return;
    final existing = box
        .query(UserEntity_.apiUserId.equals(user.id) as Condition<UserEntity>?)
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
    );
    box.put(entity);
  }

  Future<void> deleteUser(String apiUserId) async {
    await DBService().init();
    final box = DBService().userBox;
    if (box == null) return;
    final query = box
        .query(
          UserEntity_.apiUserId.equals(apiUserId) as Condition<UserEntity>?,
        )
        .build();
    final found = query.findFirst();
    query.close();
    if (found != null) box.remove(found.id);
  }

  User _toUser(UserEntity entity) {
    return User(
      id: entity.apiUserId,
      username: entity.username,
      fullName: entity.fullName,
      password: entity.password,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
    );
  }
}
