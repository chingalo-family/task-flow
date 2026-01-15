class NotificationConstants {
  // Notification types
  static const String typeTaskAssigned = 'task_assigned';
  static const String typeTaskCompleted = 'task_completed';
  static const String typeTaskStatusChange = 'task_status_change';
  static const String typeTaskComment = 'task_comment';
  static const String typeMention = 'mention';
  static const String typeDeadlineReminder = 'deadline_reminder';
  static const String typeTeamInvite = 'team_invite';
  static const String typeTeamMemberAdded = 'team_member_added';
  static const String typeTeamMemberRemoved = 'team_member_removed';
  static const String typeSystem = 'system';
  static const String typeTaskPriorityChange = 'task_priority_change';
  static const String typeTaskOverdue = 'task_overdue';
  static const String typeTaskAssignmentChange = 'task_assignment_change';
  static const String typeTaskDueDateChange = 'task_due_date_change';
  static const String typeTaskStatusChanged = 'task_status_changed';

  // Preference keys
  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefTaskAssigned = 'notif_pref_task_assigned';
  static const String prefTaskCompleted = 'notif_pref_task_completed';
  static const String prefTaskStatusChange = 'notif_pref_task_status_change';
  static const String prefTaskComment = 'notif_pref_task_comment';
  static const String prefTaskMention = 'notif_pref_task_mention';
  static const String prefDeadlineReminder = 'notif_pref_deadline_reminder';
  static const String prefTeamInvite = 'notif_pref_team_invite';
  static const String prefTeamMemberAdded = 'notif_pref_team_member_added';
  static const String prefTeamMemberRemoved = 'notif_pref_team_member_removed';
  static const String prefSystemNotifications =
      'notif_pref_system_notifications';
  static const String prefTaskPriorityChange =
      'notif_pref_task_priority_change';
  static const String prefTaskOverdue = 'notif_pref_task_overdue';

  // Related entity types
  static const String entityTypeTask = 'task';
  static const String entityTypeTeam = 'team';
  static const String entityTypeUser = 'user';
  static const String entityTypeComment = 'comment';
}
