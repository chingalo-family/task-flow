import 'package:flutter/foundation.dart';
import 'package:task_flow/core/entities/notification_entity.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/services/db_service.dart';

/// Offline provider for notification persistence
///
/// Handles all ObjectBox database operations for notifications.
/// Follows singleton pattern for efficient database access.
class NotificationOfflineProvider {
  NotificationOfflineProvider._();
  static final NotificationOfflineProvider _instance =
      NotificationOfflineProvider._();
  factory NotificationOfflineProvider() => _instance;

  /// Add or update notification in database
  Future<void> addOrUpdateNotification(Notification notification) async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return;

      // Convert Notification model to NotificationEntity
      final entity = _toEntity(notification);

      // Check if notification already exists by iterating through all notifications
      // (This is a temporary solution until ObjectBox code generation is run)
      if (notification.id.isNotEmpty) {
        final allEntities = box.getAll();
        for (var e in allEntities) {
          if (e.notificationId == notification.id) {
            entity.id = e.id;
            break;
          }
        }
      }

      // Save to database
      box.put(entity);
    } catch (e) {
      debugPrint('Error adding/updating notification: $e');
      rethrow;
    }
  }

  /// Get notification by API notification ID
  Future<Notification?> getNotificationById(String apiNotificationId) async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return null;

      // Find notification by iterating through all notifications
      // (This is a temporary solution until ObjectBox code generation is run)
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.notificationId == apiNotificationId) {
          return _toNotification(entity);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting notification by ID: $e');
      return null;
    }
  }

  /// Get all notifications
  Future<List<Notification>> getAllNotifications() async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return [];

      final entities = box.getAll();

      return entities.map((entity) => _toNotification(entity)).toList();
    } catch (e) {
      debugPrint('Error getting all notifications: $e');
      return [];
    }
  }

  /// Delete notification by API notification ID
  Future<void> deleteNotification(String apiNotificationId) async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return;

      // Find and delete notification by iterating through all notifications
      // (This is a temporary solution until ObjectBox code generation is run)
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.notificationId == apiNotificationId) {
          box.remove(entity.id);
          break;
        }
      }
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      rethrow;
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return;

      box.removeAll();
    } catch (e) {
      debugPrint('Error deleting all notifications: $e');
      rethrow;
    }
  }

  /// Get notifications count
  Future<int> getNotificationsCount() async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return 0;

      return box.count();
    } catch (e) {
      debugPrint('Error getting notifications count: $e');
      return 0;
    }
  }

  /// Convert NotificationEntity to Notification model
  Notification _toNotification(NotificationEntity entity) {
    return Notification(
      id: entity.notificationId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      isRead: entity.isRead,
      actorUsername: entity.actorUsername,
      createdAt: entity.createdAt,
    );
  }

  /// Convert Notification model to NotificationEntity
  NotificationEntity _toEntity(Notification notification) {
    return NotificationEntity(
      notificationId: notification.id,
      title: notification.title,
      body: notification.body,
      type: notification.type,
      isRead: notification.isRead,
      actorUsername: notification.actorUsername,
      createdAt: notification.createdAt,
    );
  }
}
