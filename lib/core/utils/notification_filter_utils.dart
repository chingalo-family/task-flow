import 'package:task_flow/core/models/models.dart' as app_notification;

class NotificationFilterUtils {
  static List<app_notification.Notification> filterNotifications(
    List<app_notification.Notification> notifications,
    String filter,
  ) {
    switch (filter) {
      case 'Unread':
        return notifications
            .where((notification) => !notification.isRead)
            .toList();
      case 'Mentions':
        return notifications
            .where((notification) => notification.type == 'mention')
            .toList();
      case 'Assigned to Me':
        return notifications
            .where((notification) => notification.type == 'task_assigned')
            .toList();
      case 'System':
        return notifications
            .where(
              (notification) =>
                  notification.type == 'system' ||
                  notification.type == 'deadline_reminder',
            )
            .toList();
      case 'All':
      default:
        return notifications;
    }
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
