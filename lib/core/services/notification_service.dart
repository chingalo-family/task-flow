import 'package:flutter/foundation.dart';
import 'package:task_flow/core/models/notification/notification.dart';
import 'package:task_flow/core/offline_db/notification_offline_provider/notification_offline_provider.dart';
import 'package:task_flow/core/utils/utils.dart';

/// Service layer for notification management
///
/// Handles business logic, validation, and coordinates between state and data layers.
/// Follows singleton pattern for consistent access across the application.
class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final _offline = NotificationOfflineProvider();

  /// Create a new notification
  ///
  /// Auto-generates ID if not provided.
  /// Returns the created notification or null if creation fails.
  Future<Notification?> createNotification(Notification notification) async {
    try {
      // Auto-generate ID if not provided
      final notificationToSave = notification.id.isEmpty
          ? notification.copyWith(
              id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
            )
          : notification;

      // Save to database
      await _offline.addOrUpdateNotification(notificationToSave);
      return notificationToSave;
    } catch (e) {
      debugPrint('Error creating notification: $e');
      return null;
    }
  }

  /// Get notification by ID
  Future<Notification?> getNotificationById(String id) async {
    try {
      return await _offline.getNotificationById(id);
    } catch (e) {
      debugPrint('Error getting notification by ID: $e');
      return null;
    }
  }

  /// Get all notifications
  ///
  /// Returns notifications sorted by creation date (newest first).
  Future<List<Notification>> getAllNotifications() async {
    try {
      final notifications = await _offline.getAllNotifications();
      // Sort by creation date, newest first
      notifications.sort((a, b) {
        return b.createdAt.compareTo(a.createdAt);
      });
      return notifications;
    } catch (e) {
      debugPrint('Error getting all notifications: $e');
      return [];
    }
  }

  /// Update existing notification
  Future<bool> updateNotification(Notification notification) async {
    try {
      await _offline.addOrUpdateNotification(notification);
      return true;
    } catch (e) {
      debugPrint('Error updating notification: $e');
      return false;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(String id) async {
    try {
      await _offline.deleteNotification(id);
      return true;
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      return false;
    }
  }

  /// Get unread notifications
  Future<List<Notification>> getUnreadNotifications() async {
    try {
      final notifications = await getAllNotifications();
      return notifications
          .where((notification) => !(notification.isRead))
          .toList();
    } catch (e) {
      debugPrint('Error getting unread notifications: $e');
      return [];
    }
  }

  /// Get notifications by type
  Future<List<Notification>> getNotificationsByType(String type) async {
    try {
      final notifications = await getAllNotifications();
      return notifications
          .where((notification) => notification.type == type)
          .toList();
    } catch (e) {
      debugPrint('Error getting notifications by type: $e');
      return [];
    }
  }

  /// Get unread notifications by type
  Future<List<Notification>> getUnreadNotificationsByType(String type) async {
    try {
      final notifications = await getAllNotifications();
      return notifications
          .where(
            (notification) =>
                notification.type == type && !(notification.isRead),
          )
          .toList();
    } catch (e) {
      debugPrint('Error getting unread notifications by type: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String id) async {
    try {
      final notification = await getNotificationById(id);
      if (notification == null) return false;

      final updatedNotification = notification.copyWith(isRead: true);
      return await updateNotification(updatedNotification);
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final notifications = await getAllNotifications();
      for (final notification in notifications) {
        if (!(notification.isRead)) {
          await markAsRead(notification.id);
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
      return false;
    }
  }

  /// Delete all notifications
  Future<bool> deleteAll() async {
    try {
      await _offline.deleteAllNotifications();
      return true;
    } catch (e) {
      debugPrint('Error deleting all notifications: $e');
      return false;
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    try {
      final unread = await getUnreadNotifications();
      return unread.length;
    } catch (e) {
      debugPrint('Error getting unread count: $e');
      return 0;
    }
  }

  /// Create task assigned notification
  Future<Notification?> createTaskAssignedNotification({
    required String taskTitle,
    required String taskId,
    required String actorUsername,
  }) async {
    final notification = Notification(
      id: AppUtil.getUid(),
      title: 'New Task Assigned',
      body: '$actorUsername assigned you to "$taskTitle"',
      type: 'task_assigned',
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      metadata: {'taskId': taskId},
    );
    return await createNotification(notification);
  }

  /// Create team invite notification
  Future<Notification?> createTeamInviteNotification({
    required String teamName,
    required String teamId,
    required String actorUsername,
  }) async {
    final notification = Notification(
      id: AppUtil.getUid(),
      title: 'Team Invitation',
      body: '$actorUsername invited you to join "$teamName"',
      type: 'team_invite',
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      metadata: {'teamId': teamId},
    );
    return await createNotification(notification);
  }

  /// Create task completed notification
  Future<Notification?> createTaskCompletedNotification({
    required String taskTitle,
    required String taskId,
    required String actorUsername,
  }) async {
    final notification = Notification(
      id: AppUtil.getUid(),
      title: 'Task Completed',
      body: '$actorUsername completed "$taskTitle"',
      type: 'task_completed',
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      metadata: {'taskId': taskId},
    );
    return await createNotification(notification);
  }
}
