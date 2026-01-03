/// Example Usage of NotificationUtils
/// 
/// This file demonstrates how to use the NotificationUtils to create
/// dynamic notifications in the TaskFlow application.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/utils/notification_utils.dart';

/// Example 1: Create a task assigned notification when a task is assigned to a user
void onTaskAssigned({
  required BuildContext context,
  required String taskTitle,
  required String assignedBy,
  String? taskId,
}) async {
  final notification = NotificationUtils.createTaskAssignedNotification(
    taskTitle: taskTitle,
    assignedBy: assignedBy,
    taskId: taskId,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 2: Create a task completed notification
void onTaskCompleted({
  required BuildContext context,
  required String taskTitle,
  required String completedBy,
  String? taskId,
}) async {
  final notification = NotificationUtils.createTaskCompletedNotification(
    taskTitle: taskTitle,
    completedBy: completedBy,
    taskId: taskId,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 3: Create a team invitation notification
void onTeamInvite({
  required BuildContext context,
  required String teamName,
  required String invitedBy,
  String? teamId,
}) async {
  final notification = NotificationUtils.createTeamInviteNotification(
    teamName: teamName,
    invitedBy: invitedBy,
    teamId: teamId,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 4: Create a mention notification
void onUserMentioned({
  required BuildContext context,
  required String mentionedBy,
  required String contextType,
  String? entityId,
  String? preview,
}) async {
  final notification = NotificationUtils.createMentionNotification(
    mentionedBy: mentionedBy,
    context: contextType,
    entityId: entityId,
    preview: preview,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 5: Create deadline reminder notifications for upcoming tasks
void checkAndCreateDeadlineReminders({
  required BuildContext context,
  required List<Map<String, dynamic>> upcomingTasks,
}) async {
  final notifications = <Notification>[];

  for (var task in upcomingTasks) {
    final dueDate = task['dueDate'] as DateTime;
    final now = DateTime.now();
    final hoursUntilDue = dueDate.difference(now).inHours;

    // Create reminder if task is due within 24 hours
    if (hoursUntilDue > 0 && hoursUntilDue <= 24) {
      final notification = NotificationUtils.createDeadlineReminderNotification(
        taskTitle: task['title'],
        dueDate: dueDate,
        taskId: task['id'],
      );
      notifications.add(notification);
    }
  }

  if (notifications.isNotEmpty) {
    final notificationState = Provider.of<NotificationState>(context, listen: false);
    await notificationState.addNotifications(notifications);
  }
}

/// Example 6: Create a task comment notification
void onTaskCommented({
  required BuildContext context,
  required String taskTitle,
  required String commentedBy,
  String? commentPreview,
  String? taskId,
}) async {
  final notification = NotificationUtils.createTaskCommentNotification(
    taskTitle: taskTitle,
    commentedBy: commentedBy,
    commentPreview: commentPreview,
    taskId: taskId,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 7: Create a task status change notification
void onTaskStatusChanged({
  required BuildContext context,
  required String taskTitle,
  required String newStatus,
  required String changedBy,
  String? taskId,
}) async {
  final notification = NotificationUtils.createTaskStatusChangeNotification(
    taskTitle: taskTitle,
    newStatus: newStatus,
    changedBy: changedBy,
    taskId: taskId,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 8: Create a system notification
void sendSystemNotification({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  final notification = NotificationUtils.createSystemNotification(
    title: title,
    message: message,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 9: Batch create multiple notifications
void onMultipleTasksAssigned({
  required BuildContext context,
  required List<Map<String, String>> tasks,
  required String assignedBy,
}) async {
  final notifications = NotificationUtils.batchCreateNotifications(
    tasks.map((task) => () => NotificationUtils.createTaskAssignedNotification(
      taskTitle: task['title']!,
      assignedBy: assignedBy,
      taskId: task['id'],
    )).toList(),
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotifications(notifications);
}

/// Example 10: Create a custom notification
void onCustomEvent({
  required BuildContext context,
  required String eventTitle,
  required String eventDescription,
  String? actorName,
}) async {
  final notification = NotificationUtils.createCustomNotification(
    title: eventTitle,
    body: eventDescription,
    type: 'custom_event',
    actorUsername: actorName,
  );

  final notificationState = Provider.of<NotificationState>(context, listen: false);
  await notificationState.addNotification(notification);
}

/// Example 11: Integration with task creation
/// This shows how to trigger notifications when creating a task
class TaskCreationExample {
  static Future<void> createTaskWithNotifications({
    required BuildContext context,
    required String taskTitle,
    required List<String> assignedUsers,
    required String createdBy,
  }) async {
    // Create the task (pseudo-code)
    // final task = await TaskService.createTask(...);

    // Create notifications for all assigned users
    final notificationState = Provider.of<NotificationState>(
      context,
      listen: false,
    );

    for (var assignedUser in assignedUsers) {
      final notification = NotificationUtils.createTaskAssignedNotification(
        taskTitle: taskTitle,
        assignedBy: createdBy,
        // taskId: task.id,
      );

      await notificationState.addNotification(notification);
    }
  }
}

/// Example 12: Scheduled notification checker
/// This could run periodically to check for deadline reminders
class NotificationScheduler {
  static Future<void> checkDeadlines(BuildContext context) async {
    // Get tasks from database (pseudo-code)
    // final tasks = await TaskService.getAllTasks();
    
    final tasks = <Map<String, dynamic>>[
      {
        'id': 'task1',
        'title': 'Client Presentation',
        'dueDate': DateTime.now().add(Duration(hours: 23)),
      },
      {
        'id': 'task2',
        'title': 'Submit Budget Report',
        'dueDate': DateTime.now().add(Duration(hours: 10)),
      },
    ];

    await checkAndCreateDeadlineReminders(
      context: context,
      upcomingTasks: tasks,
    );
  }
}
