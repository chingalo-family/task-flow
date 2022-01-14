import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/models/user_group_member.dart';

class UserGroupMemberOfflineProvider extends OfflineDbProvider {
  final String tableName = 'user_group_member';

  final String id = 'id';
  final String groupId = 'groupId';
  final String userId = 'userId';
  final String username = 'username';
  final String fullName = 'fullName';

  //@TODO support of adding in batches
  addOrUpdateUserGroupMember(UserGroupMember userGroupMember) async {
    var dbClient = await db;
    await dbClient!.insert(
      tableName,
      userGroupMember.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  deleteUserGroupMember(String selectedUserId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      tableName,
      where: '$userId = ?',
      whereArgs: [selectedUserId],
    );
  }

  Future<List<UserGroupMember>> getUserGroupMembersByGroup(String selectedGroupId) async {
    List<UserGroupMember> userGroupMembers = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          groupId,
          userId,
          username,
          fullName,
        ],
        where: '$groupId = ?',
        whereArgs: [selectedGroupId],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          UserGroupMember userGroupMember = UserGroupMember.fromMap(map as Map<String, dynamic>);
          userGroupMembers.add(userGroupMember);
        }
      }
    } catch (e) {}
    return userGroupMembers;
  }
}
