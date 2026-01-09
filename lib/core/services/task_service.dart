import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/offline_db/task_offline_provider/task_offline_provider.dart';

class TaskService {
  TaskService._();
  static final TaskService _instance = TaskService._();
  factory TaskService() => _instance;
  final _offline = TaskOfflineProvider();

  Future<Task?> createTask(Task task) async {
    try {
      if (task.title.trim().isEmpty) {
        throw Exception('Task title cannot be empty');
      }
      await _offline.addOrUpdateTask(task);
      return task;
    } catch (e) {
      debugPrint('Error creating task: $e');
      return null;
    }
  }

  Future<Task?> getTaskById(String id) async {
    try {
      return await _offline.getTaskById(id);
    } catch (e) {
      debugPrint('Error getting task by ID: $e');
      return null;
    }
  }

  Future<List<Task>> getAllTasks() async {
    try {
      return await _offline.getAllTasks();
    } catch (e) {
      debugPrint('Error getting all tasks: $e');
      return [];
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      await _offline.addOrUpdateTask(task);
      return true;
    } catch (e) {
      debugPrint('Error updating task: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _offline.deleteTask(id);
      return true;
    } catch (e) {
      debugPrint('Error deleting task: $e');
      return false;
    }
  }

  Future<List<Task>> getTasksByStatus(String status) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.status == status).toList();
    } catch (e) {
      debugPrint('Error getting tasks by status: $e');
      return [];
    }
  }

  Future<List<Task>> getTasksByPriority(String priority) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.priority == priority).toList();
    } catch (e) {
      debugPrint('Error getting tasks by priority: $e');
      return [];
    }
  }

  Future<List<Task>> getMyTasks(String userId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) {
        return task.assignedUserIds?.contains(userId) ??
            false || task.assignedToUserId == userId;
      }).toList();
    } catch (e) {
      debugPrint('Error getting my tasks: $e');
      return [];
    }
  }

  Future<List<Task>> getTasksByTeam(String teamId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.teamId == teamId).toList();
    } catch (e) {
      debugPrint('Error getting tasks by team: $e');
      return [];
    }
  }

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

  Future<bool> markAsCompleted(String id) async {
    return await updateTaskStatus(id, TaskConstants.statusCompleted);
  }

  Future<bool> markAsPending(String id) async {
    return await updateTaskStatus(id, TaskConstants.statusPending);
  }

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
