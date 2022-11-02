import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/models/user.dart';

class UserOfflineProvider extends OfflineDbProvider {
  final String tableName = 'user';

  final String id = 'id';
  final String username = 'username';
  final String fullName = 'fullName';
  final String password = 'password';
  final String email = 'email';
  final String gender = 'gender';
  final String phoneNumber = 'phoneNumber';
  final String isLogin = 'isLogin';

  addOrUpdateUser(User user) async {
    var dbClient = await db;
    await dbClient!.insert(
      tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  deleteUser(String userId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      tableName,
      where: '$id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<User>> getUsers() async {
    List<User> users = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          username,
          fullName,
          password,
          email,
          gender,
          phoneNumber,
          isLogin,
        ],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          User user = User.fromMap(map as Map<String, dynamic>);
          users.add(user);
        }
      }
    } catch (e) {
      //
    }
    return users;
  }
}
