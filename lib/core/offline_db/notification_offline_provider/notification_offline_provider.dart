import 'dart:convert';

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

  final _dbService = DbService();

  /// Add or update notification in database
  Future<void> addOrUpdateNotification(Notification notification) async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<NotificationEntity>();

      // Convert Notification model to NotificationEntity
      final entity = _toEntity(notification);

      // Check if notification already exists
      if (notification.id != null && notification.id!.isNotEmpty) {
        final existingQuery = box
            .query(NotificationEntity_.notificationId
                .equals(notification.id!))
            .build();
        final existing = existingQuery.findFirst();
        existingQuery.close();

        if (existing != null) {
          // Update existing notification
          entity.id = existing.id;
        }
      }

      // Save to database
      box.put(entity);
    } catch (e) {
      print('Error adding/updating notification: $e');
      rethrow;
    }
  }

  /// Get notification by API notification ID
  Future<Notification?> getNotificationById(String apiNotificationId) async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<NotificationEntity>();

      final query = box
          .query(NotificationEntity_.apiNotificationId
              .equals(apiNotificationId))
          .build();
      final entity = query.findFirst();
      query.close();

      if (entity == null) return null;

      return _toNotification(entity);
    } catch (e) {
      print('Error getting notification by ID: $e');
      return null;
    }
  }

  /// Get all notifications
  Future<List<Notification>> getAllNotifications() async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<NotificationEntity>();

      final entities = box.getAll();

      return entities.map((entity) => _toNotification(entity)).toList();
    } catch (e) {
      print('Error getting all notifications: $e');
      return [];
    }
  }

  /// Delete notification by API notification ID
  Future<void> deleteNotification(String apiNotificationId) async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<NotificationEntity>();

      final query = box
          .query(NotificationEntity_.apiNotificationId
              .equals(apiNotificationId))
          .build();
      final entity = query.findFirst();
      query.close();

      if (entity != null) {
        box.remove(entity.id);
      }
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<NotificationEntity>();
      box.removeAll();
    } catch (e) {
      print('Error deleting all notifications: $e');
      rethrow;
    }
  }

  /// Get notifications count
  Future<int> getNotificationsCount() async {
    try {
      final store = await _dbService.getObjectBoxStore();
      final box = store.box<NotificationEntity>();
      return box.count();
    } catch (e) {
      print('Error getting notifications count: $e');
      return 0;
    }
  }

  /// Convert NotificationEntity to Notification model
  Notification _toNotification(NotificationEntity entity) {
    Map<String, dynamic>? metadata;
    if (entity.metadataJson != null && entity.metadataJson!.isNotEmpty) {
      try {
        metadata = Map<String, dynamic>.from(
            jsonDecode(entity.metadataJson!) as Map);
      } catch (e) {
        print('Error parsing metadata JSON: $e');
      }
    }

    return Notification(
      id: entity.notificationId,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      isRead: entity.isRead,
      actorUsername: entity.actorUsername,
      createdAt: entity.createdAt,
      metadata: metadata,
    );
  }

  /// Convert Notification model to NotificationEntity
  NotificationEntity _toEntity(Notification notification) {
    String? metadataJson;
    if (notification.metadata != null && notification.metadata!.isNotEmpty) {
      try {
        metadataJson = jsonEncode(notification.metadata);
      } catch (e) {
        print('Error encoding metadata to JSON: $e');
      }
    }

    return NotificationEntity(
      notificationId: notification.id ?? '',
      title: notification.title,
      body: notification.body,
      type: notification.type,
      isRead: notification.isRead ?? false,
      actorUsername: notification.actorUsername,
      createdAt: notification.createdAt ?? DateTime.now(),
      metadataJson: metadataJson,
    );
  }
}
