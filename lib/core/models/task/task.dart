class Subtask {
  final String id;
  final String title;
  final bool isCompleted;
  
  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
  
  Subtask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Subtask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Task {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? category; // e.g., 'design', 'dev', 'marketing', 'research', 'bug'
  final String? assignedToUserId;
  final String? assignedToUsername;
  final List<String>? assignedUserIds; // Multiple assignees
  final String? teamId; // Team this task belongs to
  final String? teamName;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String? projectId;
  final String? projectName;
  final List<String>? tags;
  final List<String>? attachments;
  final List<Subtask>? subtasks;
  final bool? remindMe;
  final int progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.status = 'pending',
    this.priority = 'medium',
    this.category,
    this.assignedToUserId,
    this.assignedToUsername,
    this.assignedUserIds,
    this.teamId,
    this.teamName,
    this.dueDate,
    this.completedAt,
    this.projectId,
    this.projectName,
    this.tags,
    this.attachments,
    this.subtasks,
    this.remindMe,
    this.progress = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? priority,
    String? category,
    String? assignedToUserId,
    String? assignedToUsername,
    List<String>? assignedUserIds,
    String? teamId,
    String? teamName,
    DateTime? dueDate,
    DateTime? completedAt,
    String? projectId,
    String? projectName,
    List<String>? tags,
    List<String>? attachments,
    List<Subtask>? subtasks,
    bool? remindMe,
    int? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      assignedToUsername: assignedToUsername ?? this.assignedToUsername,
      assignedUserIds: assignedUserIds ?? this.assignedUserIds,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      subtasks: subtasks ?? this.subtasks,
      remindMe: remindMe ?? this.remindMe,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';
  
  bool get isHighPriority => priority == 'high';
  bool get isMediumPriority => priority == 'medium';
  bool get isLowPriority => priority == 'low';
  
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }
  
  int get subtasksCompleted {
    if (subtasks == null || subtasks!.isEmpty) return 0;
    return subtasks!.where((s) => s.isCompleted).length;
  }
  
  int get subtasksTotal {
    return subtasks?.length ?? 0;
  }
  
  double get subtasksProgress {
    if (subtasksTotal == 0) return 0;
    return subtasksCompleted / subtasksTotal;
  }
}
