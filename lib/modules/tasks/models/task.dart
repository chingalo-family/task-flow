class Task {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String? assignedToUserId;
  final String? assignedToUsername;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String? projectId;
  final String? projectName;
  final List<String>? tags;
  final List<String>? attachments;
  final int progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.status = 'pending',
    this.priority = 'medium',
    this.assignedToUserId,
    this.assignedToUsername,
    this.dueDate,
    this.completedAt,
    this.projectId,
    this.projectName,
    this.tags,
    this.attachments,
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
    String? assignedToUserId,
    String? assignedToUsername,
    DateTime? dueDate,
    DateTime? completedAt,
    String? projectId,
    String? projectName,
    List<String>? tags,
    List<String>? attachments,
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
      assignedToUserId: assignedToUserId ?? this.assignedToUserId,
      assignedToUsername: assignedToUsername ?? this.assignedToUsername,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
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
}
