import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/models/user_group.dart';

class UserGroupOfflineProvider extends OfflineDbProvider {
  final String tableName = '';

  final String id = 'id';
  final String name = 'name';
  final String description = 'description';

  addOrUpdateUserGroup(UserGroup userGroup) async {
    var dbClient = await db;
    await dbClient!.insert(
      tableName,
      userGroup.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
