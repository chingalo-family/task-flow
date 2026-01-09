import 'package:task_flow/core/models/models.dart' as app_notification;

class NotificationUtils {
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static app_notification.Notification createTaskAssignedNotification({
    required String taskTitle,
    required String assignedBy,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: 'New task assigned',
      body: '$assignedBy assigned you to "$taskTitle"',
      type: 'task_assigned',
      isRead: false,
      actorUsername: assignedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTaskCompletedNotification({
    required String taskTitle,
    required String completedBy,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: 'Task completed',
      body: '$completedBy marked "$taskTitle" as complete',
      type: 'task_completed',
      isRead: false,
      actorUsername: completedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTeamInviteNotification({
    required String teamName,
    required String invitedBy,
    String? teamId,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: 'Team invitation',
      body: 'You\'ve been invited to join $teamName',
      type: 'team_invite',
      isRead: false,
      actorUsername: invitedBy,
      createdAt: DateTime.now(),
      relatedEntityId: teamId,
      relatedEntityType: 'team',
    );
  }

  static app_notification.Notification createMentionNotification({
    required String mentionedBy,
    required String context,
    String? entityId,
    String? preview,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: 'Mentioned in $context',
      body: preview ?? '$mentionedBy mentioned you in a $context',
      type: 'mention',
      isRead: false,
      actorUsername: mentionedBy,
      createdAt: DateTime.now(),
      relatedEntityId: entityId,
      relatedEntityType: context,
    );
  }

  static app_notification.Notification createDeadlineReminderNotification({
    required String taskTitle,
    required DateTime dueDate,
    String? taskId,
  }) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);
    String timeText;
    if (difference.inHours < 24) {
      timeText = 'today';
    } else if (difference.inHours < 48) {
      timeText = 'tomorrow';
    } else {
      timeText = 'in ${difference.inDays} days';
    }
    return app_notification.Notification(
      id: _generateId(),
      title: 'Deadline reminder',
      body: '"$taskTitle" is due $timeText',
      type: 'deadline_reminder',
      isRead: false,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTaskCommentNotification({
    required String taskTitle,
    required String commentedBy,
    String? commentPreview,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: '$commentedBy commented',
      body: commentPreview ?? '$commentedBy commented on "$taskTitle"',
      type: 'task_comment',
      isRead: false,
      actorUsername: commentedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTaskStatusChangeNotification({
    required String taskTitle,
    required String newStatus,
    required String changedBy,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: 'Task status updated',
      body: '$changedBy changed "$taskTitle" to $newStatus',
      type: 'task_status_change',
      isRead: false,
      actorUsername: changedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createSystemNotification({
    required String title,
    required String message,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: title,
      body: message,
      type: 'system',
      isRead: false,
      createdAt: DateTime.now(),
    );
  }

  static app_notification.Notification createCustomNotification({
    required String title,
    required String body,
    required String type,
    String? actorUsername,
    String? relatedEntityId,
    String? relatedEntityType,
  }) {
    return app_notification.Notification(
      id: _generateId(),
      title: title,
      body: body,
      type: type,
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      relatedEntityId: relatedEntityId,
      relatedEntityType: relatedEntityType,
    );
  }

  static List<app_notification.Notification> batchCreateNotifications(
    List<app_notification.Notification Function()> notificationFactories,
  ) {
    return notificationFactories.map((factory) => factory()).toList();
  }

  static String getNotificationIcon(String type) {
    switch (type) {
      case 'task_assigned':
        return 'task_alt';
      case 'team_invite':
        return 'people';
      case 'task_completed':
        return 'check_circle';
      case 'mention':
        return 'alternate_email';
      case 'deadline_reminder':
        return 'alarm';
      case 'task_comment':
        return 'comment';
      case 'task_status_change':
        return 'update';
      case 'system':
        return 'info';
      default:
        return 'notifications';
    }
  }

  static String getNotificationColor(String type) {
    switch (type) {
      case 'task_assigned':
        return 'primaryBlue';
      case 'team_invite':
      case 'task_completed':
        return 'successGreen';
      case 'mention':
      case 'task_comment':
        return 'warningOrange';
      case 'deadline_reminder':
        return 'errorRed';
      case 'task_status_change':
        return 'primaryBlue';
      case 'system':
        return 'textSecondary';
      default:
        return 'primaryBlue';
    }
  }
}
