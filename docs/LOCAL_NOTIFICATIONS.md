# Local Notification Implementation Guide

This document outlines the suggested areas where local notifications should be implemented in the Task Flow app.

## Overview

Local notifications are essential for keeping users informed about important events and changes in the app, even when the app is not actively being used. This guide identifies key areas where notifications should be triggered.

## Notification Areas

### 1. Task Notifications

#### Task Assignment
- **Trigger**: When a task is assigned to the current user
- **Type**: `task_assigned`
- **Title**: "New Task Assigned"
- **Message**: "You've been assigned: [Task Title]"
- **Action**: Open task details when tapped
- **API Endpoint**: Triggered from backend when task is assigned

#### Task Due Date Reminder
- **Trigger**: 24 hours before task due date, and 1 hour before due date
- **Type**: `task_due_reminder`
- **Title**: "Task Due Soon"
- **Message**: "[Task Title] is due in [time]"
- **Action**: Open task details
- **Implementation**: Local scheduled notification based on task due date

#### Task Status Change
- **Trigger**: When a task status changes (especially tasks you created or are watching)
- **Type**: `task_status_changed`
- **Title**: "Task Status Updated"
- **Message**: "[Task Title] is now [status]"
- **Action**: Open task details
- **API Endpoint**: Triggered from backend on status change

#### Task Completed
- **Trigger**: When a task you assigned is completed
- **Type**: `task_completed`
- **Title**: "Task Completed"
- **Message**: "[User] completed: [Task Title]"
- **Action**: Open task details
- **API Endpoint**: Triggered from backend on completion

#### Task Comment/Mention
- **Trigger**: When someone comments on your task or mentions you
- **Type**: `task_comment` or `task_mention`
- **Title**: "New Comment" or "You were mentioned"
- **Message**: "[User] commented on [Task Title]"
- **Action**: Open task details and scroll to comment
- **API Endpoint**: Triggered from backend on comment/mention

### 2. Team Notifications

#### Team Invitation
- **Trigger**: When invited to join a team
- **Type**: `team_invitation`
- **Title**: "Team Invitation"
- **Message**: "You've been invited to join [Team Name]"
- **Action**: Open team invitation screen
- **API Endpoint**: Triggered from backend on invitation

#### Team Member Added
- **Trigger**: When a new member joins your team
- **Type**: `team_member_added`
- **Title**: "New Team Member"
- **Message**: "[User] joined [Team Name]"
- **Action**: Open team details
- **API Endpoint**: Triggered from backend on member addition

#### Team Task Created
- **Trigger**: When a new task is created in your team
- **Type**: `team_task_created`
- **Title**: "New Team Task"
- **Message**: "New task in [Team Name]: [Task Title]"
- **Action**: Open task details
- **API Endpoint**: Triggered from backend on task creation

### 3. User Notifications

#### Password Changed
- **Trigger**: When password is successfully changed
- **Type**: `password_changed`
- **Title**: "Password Changed"
- **Message**: "Your password has been updated successfully"
- **Action**: None
- **Implementation**: Local notification after successful password change

#### Account Security Alert
- **Trigger**: When there's a login from a new device/location
- **Type**: `security_alert`
- **Title**: "New Login Detected"
- **Message**: "New login from [location/device]"
- **Action**: Open security settings
- **API Endpoint**: Triggered from backend on new login

### 4. General Notifications

#### Daily Summary
- **Trigger**: Daily at a specific time (e.g., 9 AM)
- **Type**: `daily_summary`
- **Title**: "Daily Task Summary"
- **Message**: "You have [count] tasks due today"
- **Action**: Open tasks view
- **Implementation**: Local scheduled notification

#### Sync Complete
- **Trigger**: When offline data is successfully synced with server
- **Type**: `sync_complete`
- **Title**: "Sync Complete"
- **Message**: "Your data has been synced successfully"
- **Action**: None
- **Implementation**: Local notification after successful sync

#### Offline Mode
- **Trigger**: When app goes offline or comes back online
- **Type**: `offline_status`
- **Title**: "You're Offline" / "Back Online"
- **Message**: "Changes will sync when connected" / "Syncing changes..."
- **Action**: None
- **Implementation**: Local notification based on connectivity status

## Implementation Details

### Local Notification Setup

The app should use the `flutter_local_notifications` package for local notifications. Here's the recommended setup:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(settings);
  }

  // Show notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'task_flow_channel',
      'Task Flow Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }

  // Schedule notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Implementation for scheduled notifications
  }
}
```

### API Notification Integration

For notifications triggered by the backend:

1. **WebSocket Connection**: Establish a WebSocket connection for real-time notifications
2. **Polling**: Periodically fetch new notifications from the API
3. **Push Notifications**: Integrate Firebase Cloud Messaging (FCM) for push notifications

### Notification Preferences

Users should be able to control notification settings:

- Enable/disable notifications for each category
- Choose notification sound
- Set quiet hours
- Configure notification frequency
- Choose which events trigger notifications

## Suggested Integration Points

### 1. Task Creation/Update
```dart
// In ApiTaskService.createTask
final task = await _api.post(...);
if (task != null) {
  // If task is assigned to someone else, notify them
  if (task.assignedToUserId != currentUserId) {
    await ApiNotificationService().sendNotification(
      type: 'task_assigned',
      title: 'New Task Assigned',
      message: 'You\'ve been assigned: ${task.title}',
      taskId: task.id,
      userId: task.assignedToUserId,
    );
  }
}
```

### 2. Task Due Date Monitoring
```dart
// In TaskState or a background service
Future<void> scheduleTaskDueReminders(Task task) async {
  if (task.dueDate != null) {
    final oneDayBefore = task.dueDate!.subtract(Duration(days: 1));
    final oneHourBefore = task.dueDate!.subtract(Duration(hours: 1));
    
    if (oneDayBefore.isAfter(DateTime.now())) {
      await LocalNotificationService.scheduleNotification(
        id: task.id.hashCode + 1,
        title: 'Task Due Tomorrow',
        body: '${task.title} is due tomorrow',
        scheduledDate: oneDayBefore,
      );
    }
    
    if (oneHourBefore.isAfter(DateTime.now())) {
      await LocalNotificationService.scheduleNotification(
        id: task.id.hashCode + 2,
        title: 'Task Due Soon',
        body: '${task.title} is due in 1 hour',
        scheduledDate: oneHourBefore,
      );
    }
  }
}
```

### 3. Real-time Notification Listener
```dart
// In main app initialization
class NotificationListener {
  static void startListening() {
    // Poll for notifications every 30 seconds when app is active
    Timer.periodic(Duration(seconds: 30), (timer) async {
      final notifications = await ApiNotificationService().getAllNotifications();
      for (var notification in notifications) {
        if (!notification.isRead) {
          await LocalNotificationService.showNotification(
            id: notification.id.hashCode,
            title: notification.title,
            body: notification.body ?? '',
            payload: notification.id,
          );
        }
      }
    });
  }
}
```

## Next Steps

1. Add `flutter_local_notifications` package to `pubspec.yaml`
2. Implement `LocalNotificationService` class
3. Integrate notification triggers in appropriate services
4. Add notification permission requests in app initialization
5. Create notification settings UI
6. Test notification behavior on different platforms
7. Implement push notification support with FCM (future enhancement)

## Notes

- All notifications should respect user preferences
- Notifications should be batched to avoid overwhelming users
- Consider implementing notification channels on Android for better organization
- Test notifications thoroughly on both iOS and Android
- Ensure notifications work properly when app is in background/terminated state
