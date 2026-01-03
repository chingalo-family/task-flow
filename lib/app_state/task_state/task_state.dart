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

  int get tasksDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    return _tasks.where((t) {
      if (t.dueDate == null || t.isCompleted) return false;
      return t.dueDate!.isAfter(today) && t.dueDate!.isBefore(tomorrow);
    }).length;
  }
  
  int get tasksCompletedToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    return _tasks.where((t) {
      if (t.completedAt == null) return false;
      return t.completedAt!.isAfter(today) && t.completedAt!.isBefore(tomorrow);
    }).length;
  }

  List<Task> get tasksDueTodayList {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    return _tasks
        .where((t) {
          if (t.dueDate == null || t.isCompleted) return false;
          return t.dueDate!.isAfter(today) && t.dueDate!.isBefore(tomorrow);
        })
        .toList()
      ..sort((a, b) {
        final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
        return (priorityOrder[a.priority] ?? 3)
            .compareTo(priorityOrder[b.priority] ?? 3);
      });
  }

  List<Task> get overdueTasks {
    final now = DateTime.now();
    return _tasks
        .where((t) => !t.isCompleted && t.dueDate != null && t.isOverdue)
        .toList()
      ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  List<Task> get focusTasks {
    // Tasks that are in progress or pending, sorted by priority and due date
    return _tasks.where((t) => !t.isCompleted).toList()..sort((a, b) {
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
          (t) =>
              !t.isCompleted &&
              t.dueDate != null &&
              t.dueDate!.isAfter(tomorrow),
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

  List<Task> _generateSampleTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        title: 'Implement Auth API',
        description: 'Build authentication endpoints with JWT tokens',
        status: 'in_progress',
        priority: 'high',
        category: 'dev',
        dueDate: now.add(Duration(days: 2)),
        progress: 65,
        tags: ['backend', 'urgent'],
        teamId: '1',
        teamName: 'Product Team',
        assignedToUserId: 'user2',
        assignedToUsername: 'Jane Smith',
        assignedUserIds: ['user2'],
      ),
      Task(
        id: '2',
        title: 'Review Design System',
        description: 'Go through all feedback from last sprint',
        status: 'pending',
        priority: 'medium',
        category: 'design',
        dueDate: now.add(Duration(days: 5)),
        progress: 0,
        tags: ['review'],
        teamId: '2',
        teamName: 'Design Squad',
      ),
      Task(
        id: '3',
        title: 'Weekly Team Sync',
        description: 'Organize weekly sync meeting',
        status: 'pending',
        priority: 'low',
        category: 'meeting',
        dueDate: now.add(Duration(hours: 26)),
        progress: 0,
        tags: ['meeting'],
        teamId: '1',
        teamName: 'Product Team',
      ),
      Task(
        id: '4',
        title: 'Fix Navigation Bug',
        description: 'Address high-priority bugs from issue tracker',
        status: 'pending',
        priority: 'low',
        category: 'bug',
        dueDate: now.add(Duration(days: 1)),
        progress: 0,
        tags: ['bugs'],
        teamId: '3',
        teamName: 'Engineering',
        assignedToUserId: 'user1',
        assignedToUsername: 'John Doe',
        assignedUserIds: ['user1'],
      ),
      Task(
        id: '5',
        title: 'Redesign Landing Page Hero Section',
        description:
            'Update the main hero image and H1 copy to reflect the new Q4 branding guidelines. Ensure the CTA button has the new gradient style and links to the campaign dashboard.',
        status: 'in_progress',
        priority: 'medium',
        category: 'marketing',
        dueDate: DateTime(2024, 10, 24, 17, 0),
        progress: 50,
        tags: ['campaign'],
        teamId: '4',
        teamName: 'Marketing',
        assignedUserIds: ['user5', 'user6', 'user7'],
        subtasks: [
          Subtask(
            id: 's1',
            title: 'Review new brand assets',
            isCompleted: true,
          ),
          Subtask(id: 's2', title: 'Draft new copy', isCompleted: true),
          Subtask(
            id: 's3',
            title: 'Create high-fidelity mockups',
            isCompleted: false,
          ),
          Subtask(
            id: 's4',
            title: 'Get approval from Lead',
            isCompleted: false,
          ),
        ],
      ),
    ];
  }

  List<Task> _getFilteredTasks() {
    var filtered = List<Task>.from(_tasks);

    // Filter by team
    if (_filterTeamId != null) {
      filtered = filtered
          .where((task) => task.teamId == _filterTeamId)
          .toList();
    }

    // Filter by status
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
