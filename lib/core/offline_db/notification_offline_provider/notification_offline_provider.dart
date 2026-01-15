import 'package:flutter/foundation.dart';
import 'package:task_flow/core/entities/notification_entity.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/services/db_service.dart';

class NotificationOfflineProvider {
  NotificationOfflineProvider._();
  static final NotificationOfflineProvider _instance =
      NotificationOfflineProvider._();
  factory NotificationOfflineProvider() => _instance;

  Future<void> addOrUpdateNotification(Notification notification) async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return;
      final entity = _toEntity(notification);
      if (notification.id.isNotEmpty) {
        final allEntities = box.getAll();
        for (var entity in allEntities) {
          if (entity.notificationId == notification.id) {
            entity.id = entity.id;
            break;
          }
        }
      }
      box.put(entity);
    } catch (e) {
      debugPrint('Error adding/updating notification: $e');
      rethrow;
    }
  }

  Future<Notification?> getNotificationById(String apiNotificationId) async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return null;
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

  Future<void> deleteNotification(String apiNotificationId) async {
    try {
      await DBService().init();
      final box = DBService().notificationBox;
      if (box == null) return;
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

  Notification _toNotification(NotificationEntity entity) {
    return Notification(
      id: entity.notificationId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      isRead: entity.isRead,
      actorUsername: entity.actorUsername,
      recipientUserId: entity.recipientUserId,
      createdAt: entity.createdAt,
    );
  }

  NotificationEntity _toEntity(Notification notification) {
    return NotificationEntity(
      notificationId: notification.id,
      title: notification.title,
      body: notification.body,
      type: notification.type,
      isRead: notification.isRead,
      actorUsername: notification.actorUsername,
      recipientUserId: notification.recipientUserId,
      createdAt: notification.createdAt,
    );
  }
}
