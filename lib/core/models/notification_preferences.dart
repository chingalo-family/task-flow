class NotificationPreferences {
  final bool taskAssigned;
  final bool taskCompleted;
  final bool taskStatusChange;
  final bool taskComment;
  final bool taskMention;
  final bool deadlineReminder;
  final bool teamInvite;
  final bool teamMemberAdded;
  final bool teamMemberRemoved;
  final bool systemNotifications;
  final bool taskPriorityChange;
  final bool taskOverdue;

  NotificationPreferences({
    this.taskAssigned = true,
    this.taskCompleted = true,
    this.taskStatusChange = true,
    this.taskComment = true,
    this.taskMention = true,
    this.deadlineReminder = true,
    this.teamInvite = true,
    this.teamMemberAdded = true,
    this.teamMemberRemoved = true,
    this.systemNotifications = true,
    this.taskPriorityChange = true,
    this.taskOverdue = true,
  });

  NotificationPreferences copyWith({
    bool? taskAssigned,
    bool? taskCompleted,
    bool? taskStatusChange,
    bool? taskComment,
    bool? taskMention,
    bool? deadlineReminder,
    bool? teamInvite,
    bool? teamMemberAdded,
    bool? teamMemberRemoved,
    bool? systemNotifications,
    bool? taskPriorityChange,
    bool? taskOverdue,
  }) {
    return NotificationPreferences(
      taskAssigned: taskAssigned ?? this.taskAssigned,
      taskCompleted: taskCompleted ?? this.taskCompleted,
      taskStatusChange: taskStatusChange ?? this.taskStatusChange,
      taskComment: taskComment ?? this.taskComment,
      taskMention: taskMention ?? this.taskMention,
      deadlineReminder: deadlineReminder ?? this.deadlineReminder,
      teamInvite: teamInvite ?? this.teamInvite,
      teamMemberAdded: teamMemberAdded ?? this.teamMemberAdded,
      teamMemberRemoved: teamMemberRemoved ?? this.teamMemberRemoved,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      taskPriorityChange: taskPriorityChange ?? this.taskPriorityChange,
      taskOverdue: taskOverdue ?? this.taskOverdue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskAssigned': taskAssigned,
      'taskCompleted': taskCompleted,
      'taskStatusChange': taskStatusChange,
      'taskComment': taskComment,
      'taskMention': taskMention,
      'deadlineReminder': deadlineReminder,
      'teamInvite': teamInvite,
      'teamMemberAdded': teamMemberAdded,
      'teamMemberRemoved': teamMemberRemoved,
      'systemNotifications': systemNotifications,
      'taskPriorityChange': taskPriorityChange,
      'taskOverdue': taskOverdue,
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      taskAssigned: json['taskAssigned'] ?? true,
      taskCompleted: json['taskCompleted'] ?? true,
      taskStatusChange: json['taskStatusChange'] ?? true,
      taskComment: json['taskComment'] ?? true,
      taskMention: json['taskMention'] ?? true,
      deadlineReminder: json['deadlineReminder'] ?? true,
      teamInvite: json['teamInvite'] ?? true,
      teamMemberAdded: json['teamMemberAdded'] ?? true,
      teamMemberRemoved: json['teamMemberRemoved'] ?? true,
      systemNotifications: json['systemNotifications'] ?? true,
      taskPriorityChange: json['taskPriorityChange'] ?? true,
      taskOverdue: json['taskOverdue'] ?? true,
    );
  }

  bool isNotificationTypeEnabled(String type) {
    switch (type) {
      case 'task_assigned':
        return taskAssigned;
      case 'task_completed':
        return taskCompleted;
      case 'task_status_change':
        return taskStatusChange;
      case 'task_comment':
        return taskComment;
      case 'mention':
        return taskMention;
      case 'deadline_reminder':
        return deadlineReminder;
      case 'team_invite':
        return teamInvite;
      case 'team_member_added':
        return teamMemberAdded;
      case 'team_member_removed':
        return teamMemberRemoved;
      case 'system':
        return systemNotifications;
      case 'task_priority_change':
        return taskPriorityChange;
      case 'task_overdue':
        return taskOverdue;
      default:
        return true;
    }
  }
}
