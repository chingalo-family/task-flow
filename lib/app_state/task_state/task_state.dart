import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart';

class TaskState extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _loading = false;
  String _filterStatus = 'all'; // 'all', 'pending', 'in_progress', 'completed'
  String _filterPriority = 'all'; // 'all', 'high', 'medium', 'low'
  String _sortBy = 'dueDate'; // 'dueDate', 'priority', 'createdAt'
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
      if (task.dueDate == null || task.isCompleted) return false;
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

  List<Task> get tasksDueTodayList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    return _tasks.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      return task.dueDate!.isAfter(today) && task.dueDate!.isBefore(tomorrow);
    }).toList()..sort((a, b) {
      final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
      return (priorityOrder[a.priority] ?? 3).compareTo(
        priorityOrder[b.priority] ?? 3,
      );
    });
  }

  List<Task> get overdueTasks {
    return _tasks
        .where(
          (task) => !task.isCompleted && task.dueDate != null && task.isOverdue,
        )
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  List<Task> get focusTasks {
    return _tasks.where((task) => !task.isCompleted).toList()..sort((a, b) {
      // First sort by priority
      final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
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
          (task) =>
              !task.isCompleted &&
              task.dueDate != null &&
              task.dueDate!.isAfter(tomorrow),
        )
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();

    // TODO: Load tasks from ObjectBox
    await _loadTasks();

    _loading = false;
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    // TODO: Implement ObjectBox loading
    // Load only tasks assigned to current user
    _tasks = [];
  }

  List<Task> _getFilteredTasks() {
    var filtered = List<Task>.from(_tasks);
    if (_filterTeamId != null) {
      filtered = filtered
          .where((task) => task.teamId == _filterTeamId)
          .toList();
    }
    if (_filterStatus != 'all') {
      filtered = filtered
          .where((task) => task.status == _filterStatus)
          .toList();
    }
    // Filter by priority
    if (_filterPriority != 'all') {
      filtered = filtered
          .where((task) => task.priority == _filterPriority)
          .toList();
    }
    // Sort
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'dueDate':
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        case 'priority':
          final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          return (priorityOrder[a.priority] ?? 3).compareTo(
            priorityOrder[b.priority] ?? 3,
          );
        case 'createdAt':
          return b.createdAt.compareTo(a.createdAt);
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
    _tasks.add(task);
    // TODO: Save to ObjectBox
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      // TODO: Update in ObjectBox
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    // TODO: Delete from ObjectBox
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = task.isCompleted ? 'pending' : 'completed';
      final updatedTask = task.copyWith(
        status: newStatus,
        progress: newStatus == 'completed' ? 100 : task.progress,
        completedAt: newStatus == 'completed' ? DateTime.now() : null,
      );
      _tasks[index] = updatedTask;
      // TODO: Update in ObjectBox
      notifyListeners();
    }
  }
}
