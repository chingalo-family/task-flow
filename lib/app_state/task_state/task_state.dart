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
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get inProgressTasks => _tasks.where((t) => t.isInProgress).length;
  int get pendingTasks => _tasks.where((t) => t.isPending).length;
  int get overdueTasks => _tasks.where((t) => t.isOverdue).length;

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
    // For now, create some sample data
    _tasks = _generateSampleTasks();
  }

  List<Task> _generateSampleTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        title: 'Complete project proposal',
        description: 'Finish the Q1 project proposal document',
        status: 'in_progress',
        priority: 'high',
        dueDate: now.add(Duration(days: 2)),
        progress: 65,
        tags: ['proposal', 'urgent'],
        teamId: '1',
        teamName: 'Product Team',
        assignedToUserId: 'user2',
        assignedToUsername: 'Jane Smith',
      ),
      Task(
        id: '2',
        title: 'Review team feedback',
        description: 'Go through all feedback from last sprint',
        status: 'pending',
        priority: 'medium',
        dueDate: now.add(Duration(days: 5)),
        progress: 0,
        tags: ['review'],
        teamId: '1',
        teamName: 'Product Team',
      ),
      Task(
        id: '3',
        title: 'Update documentation',
        description: 'Update API documentation with new endpoints',
        status: 'completed',
        priority: 'low',
        completedAt: now.subtract(Duration(days: 1)),
        progress: 100,
        tags: ['docs'],
        teamId: '2',
        teamName: 'Design Squad',
      ),
      Task(
        id: '4',
        title: 'Fix critical bugs',
        description: 'Address high-priority bugs from issue tracker',
        status: 'in_progress',
        priority: 'high',
        dueDate: now.add(Duration(days: 1)),
        progress: 40,
        tags: ['bugs', 'urgent'],
        teamId: '3',
        teamName: 'Engineering',
        assignedToUserId: 'user1',
        assignedToUsername: 'John Doe',
      ),
      Task(
        id: '5',
        title: 'Schedule team meeting',
        description: 'Organize weekly sync meeting',
        status: 'pending',
        priority: 'low',
        dueDate: now.add(Duration(days: 7)),
        progress: 0,
        tags: ['meeting'],
        teamId: '4',
        teamName: 'Marketing',
      ),
    ];
  }

  List<Task> _getFilteredTasks() {
    var filtered = List<Task>.from(_tasks);

    // Filter by team
    if (_filterTeamId != null) {
      filtered = filtered.where((task) => task.teamId == _filterTeamId).toList();
    }

    // Filter by status
    if (_filterStatus != 'all') {
      filtered = filtered.where((task) => task.status == _filterStatus).toList();
    }

    // Filter by priority
    if (_filterPriority != 'all') {
      filtered = filtered.where((task) => task.priority == _filterPriority).toList();
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
          return (priorityOrder[a.priority] ?? 3).compareTo(priorityOrder[b.priority] ?? 3);
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

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      // TODO: Update in ObjectBox
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    // TODO: Delete from ObjectBox
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
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
