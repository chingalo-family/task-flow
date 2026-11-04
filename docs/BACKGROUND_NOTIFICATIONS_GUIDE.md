# Background Notifications Integration Guide

This document explains how to integrate and initialize the background notification system in the Task Flow application.

## Overview

The background notification system uses two key packages:
- **workmanager**: For executing background tasks on Android and iOS
- **flutter_local_notifications**: For showing local notifications to users

## Architecture

```
BackgroundNotificationService
├── FlutterLocalNotificationsPlugin (local notifications)
└── Workmanager (background task execution)
    └── NotificationSchedulerService (business logic)
        ├── TaskService (deadline & overdue checks)
        └── NotificationService (create notifications)
```

## Initialization

### 1. Main App Initialization

In your `main.dart`, initialize the background notification service:

```dart
import 'package:flutter/material.dart';
import 'package:task_flow/core/services/background_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background notifications
  await BackgroundNotificationService().initialize();
  
  runApp(const MyApp());
}
```

### 2. Android Configuration

Add permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application ...>
        <!-- Add receiver for workmanager -->
        <receiver 
            android:name="androidx.work.impl.background.systemalarm.ConstraintProxy$BatteryNotLowProxy"
            android:enabled="false"
            tools:replace="android:enabled"/>
    </application>
</manifest>
```

### 3. iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
</array>
```

Request notification permissions in `AppDelegate.swift`:

```swift
import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Usage

### Schedule Background Checks

Background checks are automatically scheduled when users enable them in settings:

```dart
// Automatically done when toggle is enabled
// Settings → Advanced Notifications → Scheduled Checks → Toggle ON
```

Programmatically:

```dart
final backgroundService = BackgroundNotificationService();

// Enable scheduled checks
await backgroundService.schedulePeriodicChecks();

// Cancel scheduled checks
await backgroundService.cancelPeriodicChecks();
```

### Show Local Notifications

Show a local notification immediately:

```dart
final backgroundService = BackgroundNotificationService();

await backgroundService.showLocalNotification(
  id: 1,
  title: 'Task Due Soon',
  body: 'Complete project proposal by 5 PM today',
  payload: 'task_id_123',
  priority: NotificationPriority.high,
);
```

### Handle Notification Taps

Currently handled in `BackgroundNotificationService._onNotificationTapped()`.
You can customize this to navigate to specific screens:

```dart
void _onNotificationTapped(NotificationResponse response) {
  final payload = response.payload;
  // TODO: Navigate to task detail screen
  // Example: Navigator.push(context, TaskDetailPage(taskId: payload));
}
```

## Background Task Flow

1. **User enables scheduled notifications** in Settings → Advanced Notifications
2. **BackgroundNotificationService.schedulePeriodicChecks()** is called
3. **Workmanager** registers a periodic task to run daily at the preferred time
4. **callbackDispatcher()** is invoked by Workmanager in the background
5. **_performNotificationCheck()** executes:
   - Calls `NotificationSchedulerService.manualTrigger()`
   - Checks for deadline reminders (tasks due within 24 hours)
   - Checks for overdue tasks
   - Creates in-app notifications via `NotificationService`
6. **Local notification** is shown to user with summary

## Testing

### Test Background Tasks

1. Enable scheduled notifications in the app
2. Use WorkManager test tools:
   - **Android**: Use `adb shell am broadcast` to trigger background tasks immediately
   - **iOS**: Use background fetch simulation in Xcode

### Test Local Notifications

```dart
// In your test code
final backgroundService = BackgroundNotificationService();

await backgroundService.showLocalNotification(
  id: 999,
  title: 'Test Notification',
  body: 'This is a test',
  priority: NotificationPriority.max,
);
```

### Manual Trigger

Use the "Run Check Now" button in Advanced Notifications settings to test the notification check logic without waiting for the scheduled time.

## Notification Channels

### Android Notification Channel

- **ID**: `task_flow_channel`
- **Name**: Task Flow Notifications
- **Description**: Notifications for tasks, deadlines, and team updates
- **Importance**: Varies by notification priority

### Notification Types & Colors

- **Task Assigned**: Blue (#2E90FA)
- **Deadline Reminder**: Red (#EF4444)
- **Task Overdue**: Red (#EF4444)
- **Task Completed**: Green (#10B981)
- **Team Events**: Blue (#2E90FA)

## Frequency & Timing

- **Default Check Time**: 6:00 AM
- **Frequency**: Once per day
- **Customizable**: Users can change the preferred check time (0-23 hours)
- **Initial Delay**: Calculated to run at next occurrence of preferred time

## Constraints

Background tasks run with the following constraints:
- **Network**: Connected (to sync with server if needed)
- **Battery**: No specific constraint
- **Storage**: No specific constraint

## Troubleshooting

### Background Tasks Not Running

1. **Check if scheduled notifications are enabled**
   ```dart
   final enabled = await NotificationSchedulerService()
       .areScheduledNotificationsEnabled();
   print('Scheduled notifications: $enabled');
   ```

2. **Verify WorkManager registration**
   - Check logs for "Scheduled periodic notification checks"

3. **Android Battery Optimization**
   - Some devices aggressively kill background tasks
   - Advise users to disable battery optimization for the app

4. **iOS Background Refresh**
   - Ensure Background App Refresh is enabled in iOS settings

### Notifications Not Showing

1. **Check permissions**
   - Android 13+: Requires notification permission
   - iOS: Requires notification permission

2. **Verify initialization**
   ```dart
   await BackgroundNotificationService().initialize();
   ```

3. **Check notification channel** (Android)
   - Users can disable specific channels in system settings

## Best Practices

1. **Initialize early**: Call `initialize()` in `main()` before `runApp()`
2. **Handle errors gracefully**: Background tasks should never crash
3. **Keep tasks lightweight**: Complete checks quickly to avoid being killed
4. **Respect user preferences**: Always check if notifications are enabled
5. **Test on real devices**: Emulators may not accurately simulate background behavior

## Platform-Specific Notes

### Android

- Uses WorkManager for periodic tasks
- Minimum interval: 15 minutes (enforced by Android)
- We use 24 hours (daily checks)
- Survives app restarts and device reboots

### iOS

- Uses Background Tasks framework
- More restrictive than Android
- System decides when to run based on usage patterns
- Not guaranteed to run at exact time

## Security & Privacy

- Background tasks run with same permissions as the app
- No sensitive data is processed in background
- All data access follows app's security model
- Background tasks use user-specific preferences (multi-user support)

## Future Enhancements

Potential improvements:
- Push notifications for real-time updates
- Smart notification grouping
- Notification history persistence
- Action buttons on notifications (Mark as done, Snooze, etc.)
- Adaptive check frequency based on user activity
- Team-specific notification sounds

## API Reference

### BackgroundNotificationService

```dart
// Initialize the service
await BackgroundNotificationService().initialize();

// Schedule periodic background checks
await BackgroundNotificationService().schedulePeriodicChecks();

// Cancel all background checks
await BackgroundNotificationService().cancelPeriodicChecks();

// Show a local notification
await BackgroundNotificationService().showLocalNotification(
  id: int,
  title: String,
  body: String,
  payload: String?,
  priority: NotificationPriority,
);

// Cancel a specific notification
await BackgroundNotificationService().cancelNotification(int id);

// Cancel all notifications
await BackgroundNotificationService().cancelAllNotifications();
```

### NotificationPriority

```dart
enum NotificationPriority {
  low,           // Low importance, minimal sound
  defaultPriority, // Default importance
  high,          // High importance, makes sound
  max,           // Urgent, heads-up notification
}
```

## Support

For issues or questions:
1. Check the logs for error messages
2. Verify all initialization steps are completed
3. Test on a real device (not emulator)
4. Check platform-specific documentation:
   - [workmanager package](https://pub.dev/packages/workmanager)
   - [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
