import 'package:task_flow/core/entities/task_entity.dart';
import 'package:task_flow/core/models/task/task.dart';
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

  final _dbService = DbService();

  /// Add or update task in database
  Future<void> addOrUpdateTask(Task task) async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<TaskEntity>();

      // Convert Task model to TaskEntity
      final entity = TaskEntityMapper.toEntity(task);

      // Check if task already exists
      final existingQuery = box
          .query(TaskEntity_.apiTaskId.equals(task.id))
          .build();
      final existing = existingQuery.findFirst();
      existingQuery.close();

      if (existing != null) {
        // Update existing task
        entity.id = existing.id;
      }

      // Save to database
      box.put(entity);
    } catch (e) {
      print('Error adding/updating task: $e');
      rethrow;
    }
  }

  /// Get task by API task ID
  Future<Task?> getTaskById(String apiTaskId) async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<TaskEntity>();

      final query = box
          .query(TaskEntity_.apiTaskId.equals(apiTaskId))
          .build();
      final entity = query.findFirst();
      query.close();

      if (entity == null) return null;

      return TaskEntityMapper.fromEntity(entity);
    } catch (e) {
      print('Error getting task by ID: $e');
      return null;
    }
  }

  /// Get all tasks
  Future<List<Task>> getAllTasks() async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<TaskEntity>();

      final entities = box.getAll();

      return entities
          .map((entity) => TaskEntityMapper.fromEntity(entity))
          .toList();
    } catch (e) {
      print('Error getting all tasks: $e');
      return [];
    }
  }

  /// Delete task by API task ID
  Future<void> deleteTask(String apiTaskId) async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<TaskEntity>();

      final query = box
          .query(TaskEntity_.apiTaskId.equals(apiTaskId))
          .build();
      final entity = query.findFirst();
      query.close();

      if (entity != null) {
        box.remove(entity.id);
      }
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  /// Delete all tasks
  Future<void> deleteAllTasks() async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<TaskEntity>();
      box.removeAll();
    } catch (e) {
      print('Error deleting all tasks: $e');
      rethrow;
    }
  }

  /// Get tasks count
  Future<int> getTasksCount() async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<TaskEntity>();
      return box.count();
    } catch (e) {
      print('Error getting tasks count: $e');
      return 0;
    }
  }
}
