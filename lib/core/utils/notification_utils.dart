import 'package:task_flow/core/models/models.dart' as appNotification;

/// Utility class for creating and managing dynamic notifications
/// Supports different notification types that can be triggered by various events
class NotificationUtils {
  /// Generate a unique notification ID
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Create a task assigned notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createTaskAssignedNotification(
  ///   taskTitle: 'Complete project proposal',
  ///   assignedBy: 'John Doe',
  ///   taskId: 'task123',
  /// );
  /// ```
  static appNotification.Notification createTaskAssignedNotification({
    required String taskTitle,
    required String assignedBy,
    String? taskId,
  }) {
    return appNotification.Notification(
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

  /// Create a task completed notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createTaskCompletedNotification(
  ///   taskTitle: 'Update documentation',
  ///   completedBy: 'Mike Johnson',
  ///   taskId: 'task456',
  /// );
  /// ```
  static appNotification.Notification createTaskCompletedNotification({
    required String taskTitle,
    required String completedBy,
    String? taskId,
  }) {
    return appNotification.Notification(
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

  /// Create a team invitation notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createTeamInviteNotification(
  ///   teamName: 'Product Team',
  ///   invitedBy: 'Sarah Smith',
  ///   teamId: 'team789',
  /// );
  /// ```
  static appNotification.Notification createTeamInviteNotification({
    required String teamName,
    required String invitedBy,
    String? teamId,
  }) {
    return appNotification.Notification(
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

  /// Create a mention notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createMentionNotification(
  ///   mentionedBy: 'Lisa Chen',
  ///   context: 'comment',
  ///   entityId: 'comment123',
  /// );
  /// ```
  static appNotification.Notification createMentionNotification({
    required String mentionedBy,
    required String context,
    String? entityId,
    String? preview,
  }) {
    return appNotification.Notification(
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

  /// Create a deadline reminder notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createDeadlineReminderNotification(
  ///   taskTitle: 'Fix critical bugs',
  ///   dueDate: DateTime.now().add(Duration(days: 1)),
  ///   taskId: 'task999',
  /// );
  /// ```
  static appNotification.Notification createDeadlineReminderNotification({
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

    return appNotification.Notification(
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

  /// Create a task comment notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createTaskCommentNotification(
  ///   taskTitle: 'Q3 Marketing Plan',
  ///   commentedBy: 'Sarah J.',
  ///   commentPreview: 'I\'ve uploaded the new assets...',
  ///   taskId: 'task111',
  /// );
  /// ```
  static appNotification.Notification createTaskCommentNotification({
    required String taskTitle,
    required String commentedBy,
    String? commentPreview,
    String? taskId,
  }) {
    return appNotification.Notification(
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

  /// Create a task status change notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createTaskStatusChangeNotification(
  ///   taskTitle: 'Update Homepage Hero',
  ///   newStatus: 'In Progress',
  ///   changedBy: 'Alex M.',
  ///   taskId: 'task222',
  /// );
  /// ```
  static appNotification.Notification createTaskStatusChangeNotification({
    required String taskTitle,
    required String newStatus,
    required String changedBy,
    String? taskId,
  }) {
    return appNotification.Notification(
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

  /// Create a system notification
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createSystemNotification(
  ///   title: 'System Maintenance',
  ///   message: 'Scheduled maintenance on Sunday at 2 AM',
  /// );
  /// ```
  static appNotification.Notification createSystemNotification({
    required String title,
    required String message,
  }) {
    return appNotification.Notification(
      id: _generateId(),
      title: title,
      body: message,
      type: 'system',
      isRead: false,
      createdAt: DateTime.now(),
    );
  }

  /// Create a custom notification with any type
  ///
  /// Example usage:
  /// ```dart
  /// final notification = NotificationUtils.createCustomNotification(
  ///   title: 'Custom Event',
  ///   body: 'Something happened',
  ///   type: 'custom_event',
  ///   actorUsername: 'User Name',
  /// );
  /// ```
  static appNotification.Notification createCustomNotification({
    required String title,
    required String body,
    required String type,
    String? actorUsername,
    String? relatedEntityId,
    String? relatedEntityType,
  }) {
    return appNotification.Notification(
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

  /// Batch create multiple notifications at once
  ///
  /// Example usage:
  /// ```dart
  /// final notifications = NotificationUtils.batchCreateNotifications([
  ///   () => NotificationUtils.createTaskAssignedNotification(...),
  ///   () => NotificationUtils.createDeadlineReminderNotification(...),
  /// ]);
  /// ```
  static List<appNotification.Notification> batchCreateNotifications(
    List<appNotification.Notification Function()> notificationFactories,
  ) {
    return notificationFactories.map((factory) => factory()).toList();
  }

  /// Get notification icon based on type
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

  /// Get notification color based on type
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
