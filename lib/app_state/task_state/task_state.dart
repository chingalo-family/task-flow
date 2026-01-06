import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/services/task_service.dart';

class TaskState extends ChangeNotifier {
  final TaskService _service;

  TaskState({TaskService? service}) : _service = service ?? TaskService();

  List<Task> _tasks = [];
  bool _loading = false;
  String _filterStatus = TaskConstants.defaultFilterStatus;
  String _filterPriority = TaskConstants.defaultFilterPriority;
  String _sortBy = TaskConstants.defaultSortBy;
  String? _filterTeamId; // Filter tasks by team

  List<Task> get tasks => _getFilteredTasks();
  List<Task> get allTasks => _tasks;
  bool get loading => _loading;
  String get filterStatus => _filterStatus;
  String get filterPriority => _filterPriority;
  String get sortBy => _sortBy;
  String? get filterTeamId => _filterTeamId;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get inProgressTasks => _tasks.where((task) => task.isInProgress).length;
  int get tasksDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(today) && task.dueDate!.isBefore(tomorrow);
    }).length;
  }

  int get tasksCompletedToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    return _tasks.where((task) {
      if (task.completedAt == null) return false;
      return task.completedAt!.isAfter(today) &&
          task.completedAt!.isBefore(tomorrow);
    }).length;
  }

  /// Get all tasks assigned to a specific user
  /// Includes both personal tasks and team tasks where the user is assigned
  List<Task> getMyTasks(String userId) {
    return _tasks.where((task) {
      // Check if user is in assignedUserIds
      if (task.assignedUserIds != null &&
          task.assignedUserIds!.contains(userId)) {
        return true;
      }
      return false;
    }).toList();
  }

  /// Get completed tasks for a specific user
  int getMyCompletedTasksCount(String userId) {
    return getMyTasks(userId).where((task) => task.isCompleted).length;
  }

  /// Get total tasks assigned to a specific user
  int getMyTotalTasksCount(String userId) {
    return getMyTasks(userId).length;
  }

  /// Get completion percentage for a specific user (0.0 to 1.0)
  double getMyCompletionProgress(String userId) {
    final myTasks = getMyTasks(userId);
    if (myTasks.isEmpty) return 0.0;
    final completed = myTasks.where((task) => task.isCompleted).length;
    return completed / myTasks.length;
  }

  List<Task> get tasksDueTodayList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(today) && task.dueDate!.isBefore(tomorrow);
    }).toList()..sort((a, b) {
      // Sort by completion status first (uncompleted first)
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Then by priority
      final priorityOrder = {
        TaskConstants.priorityHigh: 0,
        TaskConstants.priorityMedium: 1,
        TaskConstants.priorityLow: 2,
      };
      final priorityCompare = (priorityOrder[a.priority] ?? 3).compareTo(
        priorityOrder[b.priority] ?? 3,
      );
      if (priorityCompare != 0) return priorityCompare;
      // Then by due date/time
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      return 0;
    });
  }

  List<Task> get overdueTasks {
    return _tasks
        .where((task) => task.dueDate != null && task.isOverdue)
        .toList()
      ..sort((a, b) {
        // Sort by completion status first (uncompleted first)
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        // Then by due date
        return a.dueDate!.compareTo(b.dueDate!);
      });
  }

  List<Task> get focusTasks {
    return _tasks.where((task) => !task.isCompleted).toList()..sort((a, b) {
      // First sort by priority
      final priorityOrder = {
        TaskConstants.priorityHigh: 0,
        TaskConstants.priorityMedium: 1,
        TaskConstants.priorityLow: 2,
      };
      final priorityCompare = (priorityOrder[a.priority] ?? 3).compareTo(
        priorityOrder[b.priority] ?? 3,
      );
      if (priorityCompare != 0) return priorityCompare;
      // Then by due date
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
  }

  List<Task> get upcomingTasks {
    final now = DateTime.now();
    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: 1));
    return _tasks
        .where(
          (task) => task.dueDate != null && task.dueDate!.isAfter(tomorrow),
        )
        .toList()
      ..sort((a, b) {
        // Sort by completion status first (uncompleted first)
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        // Then by due date
        return a.dueDate!.compareTo(b.dueDate!);
      });
  }

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();

    // Load tasks from service
    await _loadTasks();

    _loading = false;
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    try {
      _tasks = await _service.getAllTasks();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      _tasks = [];
    }
  }

  List<Task> _getFilteredTasks() {
    var filtered = List<Task>.from(_tasks);
    if (_filterTeamId != null) {
      filtered = filtered
          .where((task) => task.teamId == _filterTeamId)
          .toList();
    }
    if (_filterStatus != TaskConstants.statusAll) {
      filtered = filtered
          .where((task) => task.status == _filterStatus)
          .toList();
    }
    // Filter by priority
    if (_filterPriority != TaskConstants.priorityAll) {
      filtered = filtered
          .where((task) => task.priority == _filterPriority)
          .toList();
    }
    // Sort
    filtered.sort((a, b) {
      // Always sort by completion status first (uncompleted first)
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }

      // Then by the selected sort option
      switch (_sortBy) {
        case TaskConstants.sortByDueDate:
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        case TaskConstants.sortByPriority:
          final priorityOrder = {
            TaskConstants.priorityHigh: 0,
            TaskConstants.priorityMedium: 1,
            TaskConstants.priorityLow: 2,
          };
          return (priorityOrder[a.priority] ?? 3).compareTo(
            priorityOrder[b.priority] ?? 3,
          );
        case TaskConstants.sortByCreatedAt:
          return b.createdAt.compareTo(a.createdAt);
        case TaskConstants.sortByStatus:
          final statusOrder = {
            TaskConstants.statusInProgress: 0,
            TaskConstants.statusPending: 1,
            TaskConstants.statusCompleted: 2,
          };
          return (statusOrder[a.status] ?? 3).compareTo(
            statusOrder[b.status] ?? 3,
          );
        default:
          return 0;
      }
    });

    return filtered;
  }

  List<Task> getTasksByTeamId(String teamId) {
    return _tasks.where((task) => task.teamId == teamId).toList();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void setFilterTeamId(String? teamId) {
    _filterTeamId = teamId;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final createdTask = await _service.createTask(task);
    if (createdTask != null) {
      _tasks.add(createdTask);
      notifyListeners();
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    final success = await _service.updateTask(updatedTask);
    if (success) {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTask(String taskId) async {
    final success = await _service.deleteTask(taskId);
    if (success) {
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = task.isCompleted
          ? TaskConstants.statusPending
          : TaskConstants.statusCompleted;

      // If completing the task, also complete all subtasks
      List<Subtask>? updatedSubtasks = task.subtasks;
      if (newStatus == TaskConstants.statusCompleted && task.subtasks != null) {
        updatedSubtasks = task.subtasks!
            .map((st) => st.copyWith(isCompleted: true))
            .toList();
      }

      final updatedTask = task.copyWith(
        status: newStatus,
        progress: newStatus == TaskConstants.statusCompleted
            ? 100
            : task.progress,
        completedAt: newStatus == TaskConstants.statusCompleted
            ? DateTime.now()
            : null,
        subtasks: updatedSubtasks,
        updatedAt: DateTime.now(),
      );

      final success = await _service.updateTask(updatedTask);
      if (success) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    }
  }
}
