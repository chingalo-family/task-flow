import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/notification_constants.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/offline_db/notification_offline_provider/notification_offline_provider.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/core/services/notification_preference_service.dart';
import 'package:task_flow/core/services/email_notification_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;

  final _offline = NotificationOfflineProvider();
  final _prefService = NotificationPreferenceService();
  final _emailService = EmailNotificationService();

  Future<Notification?> createNotification(Notification notification) async {
    try {
      // Check if notifications are globally enabled
      final notificationsEnabled = await _prefService.areNotificationsEnabled();
      if (!notificationsEnabled) {
        return null;
      }

      // Check if this notification type is enabled
      final typeEnabled = await _prefService.isNotificationTypeEnabled(
        notification.type,
      );
      if (!typeEnabled) {
        return null;
      }

      return await _saveNotification(notification);
    } catch (e) {
      debugPrint('Error creating notification: $e');
      return null;
    }
  }

  /// Create notification with team-specific preference check
  Future<Notification?> createNotificationForTeam(
    Notification notification,
    String teamId,
  ) async {
    try {
      // Check if notifications are globally enabled
      final notificationsEnabled = await _prefService.areNotificationsEnabled();
      if (!notificationsEnabled) {
        return null;
      }

      // Check team-specific preferences
      final typeEnabled = await _prefService.isTeamNotificationTypeEnabled(
        teamId,
        notification.type,
      );
      if (!typeEnabled) {
        return null;
      }

      return await _saveNotification(notification);
    } catch (e) {
      debugPrint('Error creating team notification: $e');
      return null;
    }
  }

  /// Internal method to save notification without preference checks
  Future<Notification?> _saveNotification(Notification notification) async {
    try {
      final notificationToSave = notification.id.isEmpty
          ? notification.copyWith(
              id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
            )
          : notification;
      await _offline.addOrUpdateNotification(notificationToSave);

      // Send email notification for critical types
      await _sendEmailNotificationIfNeeded(notificationToSave);

      return notificationToSave;
    } catch (e) {
      debugPrint('Error saving notification: $e');
      return null;
    }
  }

  /// Send email notification if enabled and notification is critical
  Future<void> _sendEmailNotificationIfNeeded(Notification notification) async {
    try {
      final userEmail = await _emailService.getUserEmail();
      if (userEmail != null && userEmail.isNotEmpty) {
        await _emailService.sendEmailNotification(
          notification: notification,
          recipientEmail: userEmail,
        );
      }
    } catch (e) {
      debugPrint('Error sending email notification: $e');
      // Don't fail the notification creation if email fails
    }
  }

  Future<Notification?> getNotificationById(String id) async {
    try {
      return await _offline.getNotificationById(id);
    } catch (e) {
      debugPrint('Error getting notification by ID: $e');
      return null;
    }
  }

  Future<List<Notification>> getAllNotifications() async {
    try {
      final notifications = await _offline.getAllNotifications();
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

  Future<bool> deleteNotification(String id) async {
    try {
      await _offline.deleteNotification(id);
      return true;
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      return false;
    }
  }

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

  Future<bool> deleteAll() async {
    try {
      await _offline.deleteAllNotifications();
      return true;
    } catch (e) {
      debugPrint('Error deleting all notifications: $e');
      return false;
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final unread = await getUnreadNotifications();
      return unread.length;
    } catch (e) {
      debugPrint('Error getting unread count: $e');
      return 0;
    }
  }

  Future<Notification?> createTaskAssignedNotification({
    required String taskTitle,
    required String taskId,
    required String actorUsername,
    required String recipientUserId,
    required String recipientUserName,
  }) async {
    final notification = Notification(
      id: AppUtil.getUid(),
      title: 'New Task Assigned',
      body: '$actorUsername assigned you to "$taskTitle"',
      type: NotificationConstants.typeTaskAssigned,
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
    );
    return await createNotification(notification);
  }

  Future<Notification?> createTeamInviteNotification({
    required String teamName,
    required String teamId,
    required String actorUsername,
    required String recipientUserId,
    required String recipientUserName,
  }) async {
    final notification = Notification(
      id: AppUtil.getUid(),
      title: 'Team Invitation',
      body: '$actorUsername invited you to join "$teamName"',
      type: NotificationConstants.typeTeamInvite,
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
    );
    return await createNotification(notification);
  }

  Future<Notification?> createTaskCompletedNotification({
    required String taskTitle,
    required String taskId,
    required String actorUsername,
    required String recipientUserId,
    required String recipientUserName,
  }) async {
    final notification = Notification(
      id: AppUtil.getUid(),
      title: 'Task Completed',
      body: '$actorUsername completed "$taskTitle"',
      type: NotificationConstants.typeTaskCompleted,
      isRead: false,
      actorUsername: actorUsername,
      createdAt: DateTime.now(),
      recipientUserId: recipientUserId,
      recipientUserName: recipientUserName,
    );
    return await createNotification(notification);
  }
}
