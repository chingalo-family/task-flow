import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/core/offline_db/offline_db_provider.dart';
import 'package:task_manager/models/sub_task.dart';

class SubTaskOfflineProvider extends OfflineDbProvider {
  String tableName = 'sub_task';

  // columns
  final String id = 'id';
  final String title = 'title';
  final String taskId = 'taskId';
  final String isCompleted = 'isCompleted';
  final String createdOn = 'createdOn';
  final String dueDate = 'dueDate';
  final String status = 'status';
  final String completedOn = 'completedOn';
  final String completedBy = 'completedBy';
  final String createdBy = 'createdBy';
  final String assignedTo = 'assignedTo';

  addOrUpdateSubTask(SubTask subTask) async {
    var dbClient = await db;
    await dbClient!.insert(
      tableName,
      subTask.toMap(subTask),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  deleteSubTask(String subTaskId) async {
    var dbClient = await db;
    return await dbClient!.delete(
      tableName,
      where: '$id = ?',
      whereArgs: [subTaskId],
    );
  }

  Future<List<SubTask>> getAllSubTasks() async {
    List<SubTask> subTaskList = [];
    try {
      var dbClient = await db;
      List<Map> maps = await dbClient!.query(
        tableName,
        columns: [
          id,
          taskId,
          title,
          isCompleted,
          createdOn,
          createdBy,
          dueDate,
          status,
          completedOn,
          completedBy,
          assignedTo,
        ],
        orderBy: 'createdOn',
      );
      if (maps.isNotEmpty) {
        for (Map map in maps) {
          subTaskList.add(SubTask.fromMap(map));
        }
      }
    } catch (e) {
      print(e);
    }
    return subTaskList;
  }
}
