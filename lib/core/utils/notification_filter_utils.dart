import 'package:task_flow/core/models/models.dart' as app_notif;

/// Utility class for filtering and grouping notifications
class NotificationFilterUtils {
  /// Filter notifications based on the selected filter
  static List<app_notif.Notification> filterNotifications(
    List<app_notif.Notification> notifications,
    String filter,
  ) {
    switch (filter) {
      case 'Unread':
        return notifications.where((n) => !n.isRead).toList();
      case 'Mentions':
        return notifications.where((n) => n.type == 'mention').toList();
      case 'Assigned to Me':
        return notifications.where((n) => n.type == 'task_assigned').toList();
      case 'System':
        return notifications
            .where((n) => n.type == 'system' || n.type == 'deadline_reminder')
            .toList();
      case 'All':
      default:
        return notifications;
    }
  }

  /// Group notifications by time (Recent < 24hrs, Earlier >= 24hrs)
  static Map<String, List<app_notif.Notification>> groupNotificationsByTime(
    List<app_notif.Notification> notifications, {
    int recentHoursThreshold = 24,
  }) {
    final Map<String, List<app_notif.Notification>> grouped = {
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

  /// Get count of unread notifications
  static int getUnreadCount(List<app_notif.Notification> notifications) {
    return notifications.where((n) => !n.isRead).length;
  }

  /// Get notifications by type
  static List<app_notif.Notification> getNotificationsByType(
    List<app_notif.Notification> notifications,
    String type,
  ) {
    return notifications.where((n) => n.type == type).toList();
  }

  /// Get unread notifications by type
  static List<app_notif.Notification> getUnreadNotificationsByType(
    List<app_notif.Notification> notifications,
    String type,
  ) {
    return notifications
        .where((n) => n.type == type && !n.isRead)
        .toList();
  }
}
