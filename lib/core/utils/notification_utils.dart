import 'package:task_flow/core/models/models.dart' as app_notification;
import 'package:task_flow/core/utils/utils.dart';

class NotificationUtils {
  static app_notification.Notification createTaskAssignedNotification({
    required String taskTitle,
    required String assignedBy,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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
      id: AppUtil.getUid(),
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

  static app_notification.Notification createTeamMemberAddedNotification({
    required String teamName,
    required String memberUsername,
    required String addedBy,
    String? teamId,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'New team member',
      body: '$addedBy added $memberUsername to $teamName',
      type: 'team_member_added',
      isRead: false,
      actorUsername: addedBy,
      createdAt: DateTime.now(),
      relatedEntityId: teamId,
      relatedEntityType: 'team',
    );
  }

  static app_notification.Notification createTeamMemberRemovedNotification({
    required String teamName,
    required String memberUsername,
    required String removedBy,
    String? teamId,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Team member removed',
      body: '$removedBy removed $memberUsername from $teamName',
      type: 'team_member_removed',
      isRead: false,
      actorUsername: removedBy,
      createdAt: DateTime.now(),
      relatedEntityId: teamId,
      relatedEntityType: 'team',
    );
  }

  static app_notification.Notification createTaskPriorityChangeNotification({
    required String taskTitle,
    required String newPriority,
    required String changedBy,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task priority changed',
      body: '$changedBy changed "$taskTitle" priority to $newPriority',
      type: 'task_priority_change',
      isRead: false,
      actorUsername: changedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTaskOverdueNotification({
    required String taskTitle,
    required DateTime dueDate,
    String? taskId,
  }) {
    final now = DateTime.now();
    final difference = now.difference(dueDate);
    String timeText;
    if (difference.inDays == 0) {
      timeText = 'today';
    } else if (difference.inDays == 1) {
      timeText = '1 day ago';
    } else {
      timeText = '${difference.inDays} days ago';
    }
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task overdue',
      body: '"$taskTitle" was due $timeText',
      type: 'task_overdue',
      isRead: false,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTaskAssignmentChangeNotification({
    required String taskTitle,
    required String newAssignee,
    required String changedBy,
    String? taskId,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task reassigned',
      body: '$changedBy reassigned "$taskTitle" to $newAssignee',
      type: 'task_assignment_change',
      isRead: false,
      actorUsername: changedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
    );
  }

  static app_notification.Notification createTaskDueDateChangeNotification({
    required String taskTitle,
    required DateTime newDueDate,
    required String changedBy,
    String? taskId,
  }) {
    final now = DateTime.now();
    final difference = newDueDate.difference(now);
    String timeText;
    if (difference.inHours < 24) {
      timeText = 'today';
    } else if (difference.inHours < 48) {
      timeText = 'tomorrow';
    } else {
      timeText = 'in ${difference.inDays} days';
    }
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Due date changed',
      body: '$changedBy changed "$taskTitle" due date to $timeText',
      type: 'task_due_date_change',
      isRead: false,
      actorUsername: changedBy,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: 'task',
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
      case 'team_member_added':
        return 'person_add';
      case 'team_member_removed':
        return 'person_remove';
      case 'task_priority_change':
        return 'priority_high';
      case 'task_overdue':
        return 'warning';
      case 'task_assignment_change':
        return 'swap_horiz';
      case 'task_due_date_change':
        return 'event';
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
      case 'team_member_added':
        return 'successGreen';
      case 'mention':
      case 'task_comment':
      case 'task_priority_change':
        return 'warningOrange';
      case 'deadline_reminder':
      case 'task_overdue':
        return 'errorRed';
      case 'task_status_change':
      case 'task_assignment_change':
      case 'task_due_date_change':
        return 'primaryBlue';
      case 'team_member_removed':
      case 'system':
        return 'textSecondary';
      default:
        return 'primaryBlue';
    }
  }
}
