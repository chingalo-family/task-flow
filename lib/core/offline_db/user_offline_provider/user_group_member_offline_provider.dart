import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/user_group_member.dart';

class UserGroupMemberOfflineProvider extends OfflineDbProvider {
  final String tableName = 'user_group_member';

  final String id = 'id';
  final String groupId = 'groupId';
  final String userId = 'userId';
  final String username = 'username';
  final String fullName = 'fullName';

  addOrUpdateUserGroupMember(List<UserGroupMember> userGroupMembers) async {
    try {
      var dbClient = await db;
      List<List<UserGroupMember>> chunkedUserGroups =
          AppUtil.chunkItems(items: userGroupMembers, size: 100) as List<List<UserGroupMember>>;
      for (List<UserGroupMember> chunkedUserGroupMembers in chunkedUserGroups) {
        var userGroupMemberBatch = dbClient!.batch();
        for (UserGroupMember userGroupMember in chunkedUserGroupMembers) {
          userGroupMemberBatch.insert(
            tableName,
            userGroupMember.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await userGroupMemberBatch.commit(exclusive: true, noResult: true, continueOnError: true);
      }
    } catch (e) {
      throw e;
    }
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
