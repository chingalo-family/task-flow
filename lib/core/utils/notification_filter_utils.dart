import 'package:task_flow/core/models/models.dart' as app_notification;
import 'package:task_flow/core/constants/notification_constants.dart';

class NotificationFilterUtils {
  /// Filter notifications by category and optionally by current user
  static List<app_notification.Notification> filterNotifications(
    List<app_notification.Notification> notifications,
    String filter, {
    String? currentUserId,
  }) {
    // First filter by user if specified (for multi-user devices)
    var filteredNotifications = notifications;
    if (currentUserId != null && currentUserId.isNotEmpty) {
      filteredNotifications = notifications
          .where(
            (notification) => notification.recipientUserId == currentUserId,
          )
          .toList();
    }
    switch (filter) {
      case 'Unread':
        return filteredNotifications
            .where((notification) => !notification.isRead)
            .toList();
      case 'Mentions':
        return filteredNotifications
            .where(
              (notification) =>
                  notification.type == NotificationConstants.typeMention,
            )
            .toList();
      case 'Assigned to Me':
        return filteredNotifications
            .where(
              (notification) =>
                  notification.type == NotificationConstants.typeTaskAssigned,
            )
            .toList();
      case 'System':
        return filteredNotifications
            .where(
              (notification) =>
                  notification.type == NotificationConstants.typeSystem ||
                  notification.type ==
                      NotificationConstants.typeDeadlineReminder,
            )
            .toList();
      case 'All':
      default:
        return filteredNotifications;
    }
  }

  static List<app_notification.Notification> filterNotificationsForCurrentUser(
    List<app_notification.Notification> notifications,
    String currentUserId,
  ) {
    return notifications
        .where((notification) => notification.recipientUserId == currentUserId)
        .toList();
  }

  static Map<String, List<app_notification.Notification>>
  groupNotificationsByTime(
    List<app_notification.Notification> notifications, {
    int recentHoursThreshold = 24,
  }) {
    final Map<String, List<app_notification.Notification>> grouped = {
      'Recent': [],
      'Earlier': [],
    };
    final now = DateTime.now();
    for (var notification in notifications) {
      final difference = now.difference(notification.createdAt);
      if (difference.inHours < recentHoursThreshold) {
        grouped['Recent']!.add(notification);
      } else {
        grouped['Earlier']!.add(notification);
      }
    }

    return grouped;
  }

  static int getUnreadCount(List<app_notification.Notification> notifications) {
    return notifications.where((notification) => !notification.isRead).length;
  }

  static List<app_notification.Notification> getNotificationsByType(
    List<app_notification.Notification> notifications,
    String type,
  ) {
    return notifications
        .where((notification) => notification.type == type)
        .toList();
  }

  static List<app_notification.Notification> getUnreadNotificationsByType(
    List<app_notification.Notification> notifications,
    String type,
  ) {
    return notifications
        .where(
          (notification) => notification.type == type && !notification.isRead,
        )
        .toList();
  }
}
