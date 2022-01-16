import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/user_group.dart';

class UserGroupOfflineProvider extends OfflineDbProvider {
  final String tableName = 'user_group';

  final String id = 'id';
  final String name = 'name';
  final String description = 'description';

  addOrUpdateUserGroup(List<UserGroup> userGroups) async {
    try {
      var dbClient = await db;
      List<List<UserGroup>> chunkedUserGroups =
          AppUtil.chunkItems(items: userGroups, size: 100) as List<List<UserGroup>>;
      for (List<UserGroup> chunkedUserGroup in chunkedUserGroups) {
        var userGroupBatch = dbClient!.batch();
        for (UserGroup userGroup in chunkedUserGroup) {
          userGroupBatch.insert(
            tableName,
            userGroup.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await userGroupBatch.commit(exclusive: true, noResult: true, continueOnError: true);
      }
    } catch (e) {
      throw e;
    }
  }

  deleteUserGroup(String groupId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      tableName,
      where: '$id = ?',
      whereArgs: [groupId],
    );
  }

  Future<List<UserGroup>> getUserGroups() async {
    List<UserGroup> userGroups = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
        ],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          UserGroup userGroup = UserGroup.fromMap(map as Map<String, dynamic>);
          userGroups.add(userGroup);
        }
      }
    } catch (e) {}
    return userGroups;
  }
}
