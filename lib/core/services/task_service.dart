import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/offline_db/task_offline_provider/task_offline_provider.dart';

/// Service layer for task management
///
/// Handles business logic, validation, and coordinates between state and data layers.
/// Follows singleton pattern for consistent access across the application.
class TaskService {
  TaskService._();
  static final TaskService _instance = TaskService._();
  factory TaskService() => _instance;

  final _offline = TaskOfflineProvider();

  /// Create a new task
  ///
  /// Validates and saves task to database.
  /// Returns the created task or null if creation fails.
  Future<Task?> createTask(Task task) async {
    try {
      // Validate task has required fields
      if (task.title.trim().isEmpty) {
        throw Exception('Task title cannot be empty');
      }

      // Save to database
      await _offline.addOrUpdateTask(task);
      return task;
    } catch (e) {
      debugPrint('Error creating task: $e');
      return null;
    }
  }

  /// Get task by ID
  Future<Task?> getTaskById(String id) async {
    try {
      return await _offline.getTaskById(id);
    } catch (e) {
      debugPrint('Error getting task by ID: $e');
      return null;
    }
  }

  /// Get all tasks
  Future<List<Task>> getAllTasks() async {
    try {
      return await _offline.getAllTasks();
    } catch (e) {
      debugPrint('Error getting all tasks: $e');
      return [];
    }
  }

  /// Update existing task
  Future<bool> updateTask(Task task) async {
    try {
      await _offline.addOrUpdateTask(task);
      return true;
    } catch (e) {
      debugPrint('Error updating task: $e');
      return false;
    }
  }

  /// Delete task
  Future<bool> deleteTask(String id) async {
    try {
      await _offline.deleteTask(id);
      return true;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return false;
    }
  }

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(String status) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.status == status).toList();
    } catch (e) {
      debugPrint('Error getting tasks by status: $e');
      return [];
    }
  }

  /// Get tasks by priority
  Future<List<Task>> getTasksByPriority(String priority) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.priority == priority).toList();
    } catch (e) {
      debugPrint('Error getting tasks by priority: $e');
      return [];
    }
  }

  /// Get tasks assigned to specific user
  Future<List<Task>> getMyTasks(String userId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) {
        // Check if user is in assignedUserIds or assignedToUserId
        return task.assignedUserIds?.contains(userId) ??
            false || task.assignedToUserId == userId;
      }).toList();
    } catch (e) {
      debugPrint('Error getting my tasks: $e');
      return [];
    }
  }

  /// Get tasks by team
  Future<List<Task>> getTasksByTeam(String teamId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.teamId == teamId).toList();
    } catch (e) {
      debugPrint('Error getting tasks by team: $e');
      return [];
    }
  }

  /// Delete multiple tasks by IDs
  Future<bool> deleteTasksByIds(List<String> ids) async {
    try {
      for (final id in ids) {
        await _offline.deleteTask(id);
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting tasks: $e');
      return false;
    }
  }

  /// Update task status
  Future<bool> updateTaskStatus(String id, String status) async {
    try {
      final task = await getTaskById(id);
      if (task == null) return false;

      final updatedTask = task.copyWith(
        status: status,
        completedAt: status == TaskConstants.statusCompleted
            ? DateTime.now()
            : null,
        progress: status == TaskConstants.statusCompleted ? 100 : task.progress,
      );

      return await updateTask(updatedTask);
    } catch (e) {
      debugPrint('Error updating task status: $e');
      return false;
    }
  }

  /// Mark task as completed
  Future<bool> markAsCompleted(String id) async {
    return await updateTaskStatus(id, TaskConstants.statusCompleted);
  }

  /// Mark task as pending
  Future<bool> markAsPending(String id) async {
    return await updateTaskStatus(id, TaskConstants.statusPending);
  }

  /// Get overdue tasks
  Future<List<Task>> getOverdueTasks() async {
    try {
      final allTasks = await getAllTasks();
      final now = DateTime.now();
      return allTasks.where((task) {
        if (task.dueDate == null) return false;
        return task.dueDate!.isBefore(now) &&
            task.status != TaskConstants.statusCompleted;
      }).toList();
    } catch (e) {
      debugPrint('Error getting overdue tasks: $e');
      return [];
    }
  }

  /// Get tasks due today
  Future<List<Task>> getTasksDueToday() async {
    try {
      final allTasks = await getAllTasks();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      return allTasks.where((task) {
        if (task.dueDate == null) return false;
        return task.dueDate!.isAfter(today) && task.dueDate!.isBefore(tomorrow);
      }).toList();
    } catch (e) {
      debugPrint('Error getting tasks due today: $e');
      return [];
    }
  }

  /// Get upcoming tasks (future due dates)
  Future<List<Task>> getUpcomingTasks() async {
    try {
      final allTasks = await getAllTasks();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      return allTasks.where((task) {
        if (task.dueDate == null) return false;
        return task.dueDate!.isAfter(tomorrow);
      }).toList();
    } catch (e) {
      debugPrint('Error getting upcoming tasks: $e');
      return [];
    }
  }
}
