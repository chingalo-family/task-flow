import 'package:flutter/foundation.dart';
import 'package:task_flow/core/entities/task_entity.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/services/db_service.dart';
import 'package:task_flow/core/utils/task_entity_mapper.dart';

/// Offline provider for task persistence
///
/// Handles all ObjectBox database operations for tasks.
/// Follows singleton pattern for efficient database access.
class TaskOfflineProvider {
  TaskOfflineProvider._();
  static final TaskOfflineProvider _instance = TaskOfflineProvider._();
  factory TaskOfflineProvider() => _instance;

  /// Add or update task in database
  Future<void> addOrUpdateTask(Task task) async {
    try {
      await DBService().init();
      final box = DBService().taskBox;
      if (box == null) return;

      // Convert Task model to TaskEntity
      final entity = TaskEntityMapper.toEntity(task);

      // Check if task already exists by iterating through all tasks
      // (This is a temporary solution until ObjectBox code generation is run)
      final allEntities = box.getAll();
      TaskEntity? existing;
      for (var e in allEntities) {
        if (e.taskId == task.id) {
          existing = e;
          break;
        }
      }

      if (existing != null) {
        // Update existing task
        entity.id = existing.id;
      }

      // Save to database
      box.put(entity);
    } catch (e) {
      debugPrint('Error adding/updating task: $e');
      rethrow;
    }
  }

  /// Get task by API task ID
  Future<Task?> getTaskById(String apiTaskId) async {
    try {
      await DBService().init();
      final box = DBService().taskBox;
      if (box == null) return null;

      // Find task by iterating through all tasks
      // (This is a temporary solution until ObjectBox code generation is run)
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.taskId == apiTaskId) {
          return TaskEntityMapper.fromEntity(entity);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting task by ID: $e');
      return null;
    }
  }

  /// Get all tasks
  Future<List<Task>> getAllTasks() async {
    try {
      await DBService().init();
      final box = DBService().taskBox;
      if (box == null) return [];

      final entities = box.getAll();

      return entities
          .map((entity) => TaskEntityMapper.fromEntity(entity))
          .toList();
    } catch (e) {
      debugPrint('Error getting all tasks: $e');
      return [];
    }
  }

  /// Delete task by API task ID
  Future<void> deleteTask(String apiTaskId) async {
    try {
      await DBService().init();
      final box = DBService().taskBox;
      if (box == null) return;

      // Find and delete task by iterating through all tasks
      // (This is a temporary solution until ObjectBox code generation is run)
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.taskId == apiTaskId) {
          box.remove(entity.id);
          break;
        }
      }
    } catch (e) {
      debugPrint('Error deleting task: $e');
      rethrow;
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      await DBService().init();
      final box = DBService().taskBox;
      if (box == null) return;

      box.removeAll();
    } catch (e) {
      debugPrint('Error deleting all tasks: $e');
      rethrow;
    }
  }

  /// Get tasks count
  Future<int> getTasksCount() async {
    try {
      await DBService().init();
      final box = DBService().taskBox;
      if (box == null) return 0;

      return box.count();
    } catch (e) {
      debugPrint('Error getting tasks count: $e');
      return 0;
    }
  }
}
