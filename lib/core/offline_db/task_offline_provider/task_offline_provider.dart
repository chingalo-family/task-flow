import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/models/task.dart';

class TaskOfflineProvider extends OfflineDbProvider {
  String tableName = 'task';

  // columns
  final String id = 'id';
  final String title = 'title';
  final String description = 'description';
  final String createdOn = 'createdOn';
  final String dueDate = 'dueDate';
  final String completedOn = 'completedOn';
  final String completedBy = 'completedBy';
  final String createdBy = 'createdBy';
  final String assignedTo = 'assignedTo';
  final String groupId = 'groupId';

  addOrUpdateTask(Task task) async {
    var dbClient = await db;
    await dbClient!.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  deleteTask(String taskId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      tableName,
      where: '$id = ?',
      whereArgs: [taskId],
    );
  }

  Future<List<Task>> getAllTasks() async {
    List<Task> taskList = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          title,
          description,
          createdOn,
          createdBy,
          dueDate,
          completedOn,
          completedBy,
          assignedTo,
          groupId
        ],
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          taskList.add(Task.fromMap(map));
        }
      }
    } catch (e) {
      print(e);
    }
    return taskList.reversed.toList();
  }
}
