import 'package:task_flow/core/models/models.dart' as app_notification;
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/core/constants/notification_constants.dart';

class NotificationUtils {
  static app_notification.Notification createTaskAssignedNotification({
    required String taskTitle,
    required String assignedBy,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'New task assigned',
      body: '$assignedBy assigned you to "$taskTitle"',
      type: NotificationConstants.typeTaskAssigned,
      isRead: false,
      actorUsername: assignedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTaskCompletedNotification({
    required String taskTitle,
    required String completedBy,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task completed',
      body: '$completedBy marked "$taskTitle" as complete',
      type: NotificationConstants.typeTaskCompleted,
      isRead: false,
      actorUsername: completedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTeamInviteNotification({
    required String teamName,
    required String invitedBy,
    String? teamId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Team invitation',
      body: 'You\'ve been invited to join $teamName',
      type: NotificationConstants.typeTeamInvite,
      isRead: false,
      actorUsername: invitedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: teamId,
      relatedEntityType: NotificationConstants.entityTypeTeam,
    );
  }

  static app_notification.Notification createMentionNotification({
    required String mentionedBy,
    required String context,
    String? entityId,
    String? preview,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Mentioned in $context',
      body: preview ?? '$mentionedBy mentioned you in a $context',
      type: NotificationConstants.typeMention,
      isRead: false,
      actorUsername: mentionedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: entityId,
      relatedEntityType: context,
    );
  }

  static app_notification.Notification createDeadlineReminderNotification({
    required String taskTitle,
    required DateTime dueDate,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
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
      type: NotificationConstants.typeDeadlineReminder,
      isRead: false,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTaskCommentNotification({
    required String taskTitle,
    required String commentedBy,
    String? commentPreview,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: '$commentedBy commented',
      body: commentPreview ?? '$commentedBy commented on "$taskTitle"',
      type: NotificationConstants.typeTaskComment,
      isRead: false,
      actorUsername: commentedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTaskStatusChangeNotification({
    required String taskTitle,
    required String newStatus,
    required String changedBy,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task status updated',
      body: '$changedBy changed "$taskTitle" to $newStatus',
      type: NotificationConstants.typeTaskStatusChanged,
      isRead: false,
      actorUsername: changedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createSystemNotification({
    required String title,
    required String message,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: title,
      body: message,
      type: NotificationConstants.typeSystem,
      isRead: false,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
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
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: title,
      body: body,
      type: type,
      isRead: false,
      actorUsername: actorUsername,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
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
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'New team member',
      body: '$addedBy added $memberUsername to $teamName',
      type: NotificationConstants.typeTeamMemberAdded,
      isRead: false,
      actorUsername: addedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: teamId,
      relatedEntityType: NotificationConstants.entityTypeTeam,
    );
  }

  static app_notification.Notification createTeamMemberRemovedNotification({
    required String teamName,
    required String memberUsername,
    required String removedBy,
    String? teamId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Team member removed',
      body: '$removedBy removed $memberUsername from $teamName',
      type: NotificationConstants.typeTeamMemberRemoved,
      isRead: false,
      actorUsername: removedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: teamId,
      relatedEntityType: NotificationConstants.entityTypeTeam,
    );
  }

  static app_notification.Notification createTaskPriorityChangeNotification({
    required String taskTitle,
    required String newPriority,
    required String changedBy,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task priority changed',
      body: '$changedBy changed "$taskTitle" priority to $newPriority',
      type: NotificationConstants.typeTaskPriorityChange,
      isRead: false,
      actorUsername: changedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTaskOverdueNotification({
    required String taskTitle,
    required DateTime dueDate,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
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
      type: NotificationConstants.typeTaskOverdue,
      isRead: false,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTaskAssignmentChangeNotification({
    required String taskTitle,
    required String newAssignee,
    required String changedBy,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
  }) {
    return app_notification.Notification(
      id: AppUtil.getUid(),
      title: 'Task reassigned',
      body: '$changedBy reassigned "$taskTitle" to $newAssignee',
      type: NotificationConstants.typeTaskAssignmentChange,
      isRead: false,
      actorUsername: changedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static app_notification.Notification createTaskDueDateChangeNotification({
    required String taskTitle,
    required DateTime newDueDate,
    required String changedBy,
    String? taskId,
    required String recipientUserId,
    required String recipientUserName,
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
      type: NotificationConstants.typeTaskDueDateChange,
      isRead: false,
      actorUsername: changedBy,
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
      createdAt: DateTime.now(),
      relatedEntityId: taskId,
      relatedEntityType: NotificationConstants.entityTypeTask,
    );
  }

  static List<app_notification.Notification> batchCreateNotifications(
    List<app_notification.Notification Function()> notificationFactories,
  ) {
    return notificationFactories.map((factory) => factory()).toList();
  }

  static String getNotificationIcon(String type) {
    switch (type) {
      case NotificationConstants.typeTaskAssigned:
        return 'task_alt';
      case NotificationConstants.typeTeamInvite:
        return 'people';
      case NotificationConstants.typeTaskCompleted:
        return 'check_circle';
      case NotificationConstants.typeMention:
        return 'alternate_email';
      case NotificationConstants.typeDeadlineReminder:
        return 'alarm';
      case NotificationConstants.typeTaskComment:
        return 'comment';
      case NotificationConstants.typeTaskStatusChange:
        return 'update';
      case NotificationConstants.typeSystem:
        return 'info';
      case NotificationConstants.typeTeamMemberAdded:
        return 'person_add';
      case NotificationConstants.typeTeamMemberRemoved:
        return 'person_remove';
      case NotificationConstants.typeTaskPriorityChange:
        return 'priority_high';
      case NotificationConstants.typeTaskOverdue:
        return 'warning';
      case NotificationConstants.typeTaskAssignmentChange:
        return 'swap_horiz';
      case NotificationConstants.typeTaskDueDateChange:
        return 'event';
      default:
        return 'notifications';
    }
  }

  static String getNotificationColor(String type) {
    switch (type) {
      case NotificationConstants.typeTaskAssigned:
        return 'primaryBlue';
      case NotificationConstants.typeTeamInvite:
      case NotificationConstants.typeTaskCompleted:
      case NotificationConstants.typeTeamMemberAdded:
        return 'successGreen';
      case NotificationConstants.typeMention:
      case NotificationConstants.typeTaskComment:
      case NotificationConstants.typeTaskPriorityChange:
        return 'warningOrange';
      case NotificationConstants.typeDeadlineReminder:
      case NotificationConstants.typeTaskOverdue:
        return 'errorRed';
      case NotificationConstants.typeTaskStatusChange:
      case NotificationConstants.typeTaskAssignmentChange:
      case NotificationConstants.typeTaskDueDateChange:
        return 'primaryBlue';
      case NotificationConstants.typeTeamMemberRemoved:
      case NotificationConstants.typeSystem:
        return 'textSecondary';
      default:
        return 'primaryBlue';
    }
  }
}
