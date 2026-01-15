import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:task_flow/core/services/notification_scheduler_service.dart';
import 'package:task_flow/core/services/task_service.dart';

/// Service for managing background notifications and tasks
class BackgroundNotificationService {
  BackgroundNotificationService._();
  static final BackgroundNotificationService _instance =
      BackgroundNotificationService._();
  factory BackgroundNotificationService() => _instance;

  static const String _taskCheckTaskName = 'task_check_task';
  static const String _uniqueTaskName = 'taskflow_notification_check';

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize background notification service
  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _initializeWorkManager();
  }

  /// Initialize flutter_local_notifications
  Future<void> _initializeLocalNotifications() async {
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    // Request permissions for Android 13+
    if (defaultTargetPlatform == TargetPlatform.android) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Initialize WorkManager for background tasks
  Future<void> _initializeWorkManager() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate to appropriate screen based on payload
  }

  /// Schedule periodic background checks
  Future<void> schedulePeriodicChecks() async {
    final schedulerService = NotificationSchedulerService();
    final enabled = await schedulerService.areScheduledNotificationsEnabled();
    
    if (!enabled) {
      await cancelPeriodicChecks();
      return;
    }

    final preferredHour = await schedulerService.getPreferredCheckTime();

    // Calculate initial delay to preferred time
    final now = DateTime.now();
    var nextRun = DateTime(now.year, now.month, now.day, preferredHour);
    
    if (nextRun.isBefore(now)) {
      nextRun = nextRun.add(const Duration(days: 1));
    }

    final initialDelay = nextRun.difference(now);

    // Register periodic task (runs daily)
    await Workmanager().registerPeriodicTask(
      _uniqueTaskName,
      _taskCheckTaskName,
      frequency: const Duration(days: 1),
      initialDelay: initialDelay,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );

    debugPrint('Scheduled periodic notification checks at $preferredHour:00 daily');
  }

  /// Cancel periodic background checks
  Future<void> cancelPeriodicChecks() async {
    await Workmanager().cancelByUniqueName(_uniqueTaskName);
    debugPrint('Cancelled periodic notification checks');
  }

  /// Show local notification
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.defaultPriority,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'task_flow_channel',
      'Task Flow Notifications',
      channelDescription: 'Notifications for tasks, deadlines, and team updates',
      importance: _mapPriorityToImportance(priority),
      priority: _mapPriorityToAndroidPriority(priority),
      styleInformation: const BigTextStyleInformation(''),
      color: const Color(0xFF2E90FA), // Primary blue
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Map custom priority to Android importance
  Importance _mapPriorityToImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.max:
        return Importance.max;
      default:
        return Importance.defaultImportance;
    }
  }

  /// Map custom priority to Android priority
  Priority _mapPriorityToAndroidPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.max:
        return Priority.max;
      default:
        return Priority.defaultPriority;
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}

/// Priority levels for notifications
enum NotificationPriority {
  low,
  defaultPriority,
  high,
  max,
}

/// Background task callback dispatcher
/// This must be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task started: $task');

    try {
      if (task == BackgroundNotificationService._taskCheckTaskName) {
        await _performNotificationCheck();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Background task error: $e');
      return false;
    }
  });
}

/// Perform the actual notification check in background
Future<void> _performNotificationCheck() async {
  try {
    final schedulerService = NotificationSchedulerService();
    
    // Check if scheduled notifications are enabled
    final enabled = await schedulerService.areScheduledNotificationsEnabled();
    if (!enabled) {
      debugPrint('Scheduled notifications are disabled');
      return;
    }

    // Perform the notification check
    await schedulerService.manualTrigger();
    
    // Show a summary notification if there were any notifications created
    final backgroundService = BackgroundNotificationService();
    await backgroundService.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Task Flow Check Complete',
      body: 'Checked for deadline reminders and overdue tasks',
      priority: NotificationPriority.low,
    );

    debugPrint('Background notification check completed');
  } catch (e) {
    debugPrint('Error in background notification check: $e');
  }
}
