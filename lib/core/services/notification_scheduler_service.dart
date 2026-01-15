import 'package:flutter/foundation.dart';
import 'package:task_flow/core/services/task_service.dart';
import 'package:task_flow/core/services/preference_service.dart';

/// Service for scheduling and executing background notification tasks
/// 
/// Note: This service provides the core logic for background tasks.
/// For actual background execution on mobile platforms, integrate with:
/// - workmanager package for Android/iOS background tasks
/// - flutter_local_notifications for local notification scheduling
/// 
/// Example integration:
/// ```dart
/// import 'package:workmanager/workmanager.dart';
/// 
/// void callbackDispatcher() {
///   Workmanager().executeTask((task, inputData) async {
///     await NotificationSchedulerService().executeScheduledCheck();
///     return Future.value(true);
///   });
/// }
/// 
/// // In main.dart
/// Workmanager().initialize(callbackDispatcher);
/// Workmanager().registerPeriodicTask(
///   "notification-check",
///   "notificationCheck",
///   frequency: Duration(hours: 24),
/// );
/// ```
class NotificationSchedulerService {
  NotificationSchedulerService._();
  static final NotificationSchedulerService _instance =
      NotificationSchedulerService._();
  factory NotificationSchedulerService() => _instance;

  final _taskService = TaskService();
  final _prefs = PreferenceService();

  /// Execute all scheduled notification checks
  /// This method should be called by the background task scheduler
  Future<void> executeScheduledCheck() async {
    try {
      debugPrint('Executing scheduled notification check...');

      // Check if scheduled notifications are enabled
      final enabled = await areScheduledNotificationsEnabled();
      if (!enabled) {
        debugPrint('Scheduled notifications are disabled');
        return;
      }

      // Run deadline reminders check
      await _checkDeadlineReminders();

      // Run overdue tasks check
      await _checkOverdueTasks();

      // Update last check timestamp
      await _updateLastCheckTime();

      debugPrint('Scheduled notification check completed');
    } catch (e) {
      debugPrint('Error executing scheduled notification check: $e');
    }
  }

  /// Check and create deadline reminder notifications
  Future<void> _checkDeadlineReminders() async {
    try {
      debugPrint('Checking for deadline reminders...');
      await _taskService.createDeadlineReminders();
    } catch (e) {
      debugPrint('Error checking deadline reminders: $e');
    }
  }

  /// Check and create overdue task notifications
  Future<void> _checkOverdueTasks() async {
    try {
      debugPrint('Checking for overdue tasks...');
      await _taskService.createOverdueTaskNotifications();
    } catch (e) {
      debugPrint('Error checking overdue tasks: $e');
    }
  }

  /// Check if scheduled notifications are enabled
  Future<bool> areScheduledNotificationsEnabled() async {
    return await _prefs.getBool('scheduled_notifications_enabled') ?? true;
  }

  /// Enable or disable scheduled notifications
  Future<void> setScheduledNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('scheduled_notifications_enabled', enabled);
  }

  /// Update the last check timestamp
  Future<void> _updateLastCheckTime() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _prefs.setString('last_notification_check', now.toString());
  }

  /// Get the last check timestamp
  Future<DateTime?> getLastCheckTime() async {
    final timestamp = await _prefs.getString('last_notification_check');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    }
    return null;
  }

  /// Set the preferred check time (hour of day, 0-23)
  Future<void> setPreferredCheckTime(int hour) async {
    if (hour < 0 || hour > 23) {
      throw ArgumentError('Hour must be between 0 and 23');
    }
    await _prefs.setString('preferred_check_time', hour.toString());
  }

  /// Get the preferred check time
  Future<int> getPreferredCheckTime() async {
    final hour = await _prefs.getString('preferred_check_time');
    return hour != null ? int.parse(hour) : 6; // Default: 6 AM
  }

  /// Manual trigger for testing purposes
  /// Use this during development to test notification generation
  Future<void> manualTrigger() async {
    debugPrint('Manual notification check triggered');
    await executeScheduledCheck();
  }

  /// Get statistics about scheduled checks
  Future<Map<String, dynamic>> getCheckStatistics() async {
    final lastCheck = await getLastCheckTime();
    final preferredHour = await getPreferredCheckTime();
    final enabled = await areScheduledNotificationsEnabled();

    return {
      'enabled': enabled,
      'lastCheckTime': lastCheck?.toIso8601String(),
      'preferredHour': preferredHour,
      'nextScheduledCheck': _calculateNextCheck(preferredHour),
    };
  }

  String? _calculateNextCheck(int preferredHour) {
    final now = DateTime.now();
    DateTime nextCheck = DateTime(
      now.year,
      now.month,
      now.day,
      preferredHour,
    );

    // If the preferred time has already passed today, schedule for tomorrow
    if (nextCheck.isBefore(now)) {
      nextCheck = nextCheck.add(const Duration(days: 1));
    }

    return nextCheck.toIso8601String();
  }
}
