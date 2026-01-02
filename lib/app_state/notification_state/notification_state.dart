import 'package:flutter/material.dart';
import 'package:task_flow/modules/notifications/models/notification.dart' as app_notif;

class NotificationState extends ChangeNotifier {
  List<app_notif.Notification> _notifications = [];
  bool _loading = false;

  List<app_notif.Notification> get notifications => _notifications;
  List<app_notif.Notification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  bool get loading => _loading;

  int get totalNotifications => _notifications.length;
  int get unreadCount => unreadNotifications.length;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    
    // TODO: Load notifications from ObjectBox
    await _loadNotifications();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadNotifications() async {
    // TODO: Implement ObjectBox loading
    // For now, create some sample data
    _notifications = _generateSampleNotifications();
  }

  List<app_notif.Notification> _generateSampleNotifications() {
    final now = DateTime.now();
    return [
      app_notif.Notification(
        id: '1',
        title: 'New task assigned',
        body: 'John assigned you to "Complete project proposal"',
        type: 'task_assigned',
        isRead: false,
        actorUsername: 'John Doe',
        createdAt: now.subtract(Duration(minutes: 5)),
      ),
      app_notif.Notification(
        id: '2',
        title: 'Team invitation',
        body: 'You\'ve been invited to join Product Team',
        type: 'team_invite',
        isRead: false,
        actorUsername: 'Sarah Smith',
        createdAt: now.subtract(Duration(hours: 2)),
      ),
      app_notif.Notification(
        id: '3',
        title: 'Task completed',
        body: 'Mike marked "Update documentation" as complete',
        type: 'task_completed',
        isRead: true,
        actorUsername: 'Mike Johnson',
        createdAt: now.subtract(Duration(hours: 5)),
      ),
      app_notif.Notification(
        id: '4',
        title: 'Mentioned in comment',
        body: 'Lisa mentioned you in a comment',
        type: 'mention',
        isRead: true,
        actorUsername: 'Lisa Chen',
        createdAt: now.subtract(Duration(days: 1)),
      ),
      app_notif.Notification(
        id: '5',
        title: 'Deadline reminder',
        body: '"Fix critical bugs" is due tomorrow',
        type: 'deadline_reminder',
        isRead: true,
        createdAt: now.subtract(Duration(days: 2)),
      ),
    ];
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      // TODO: Update in ObjectBox
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    // TODO: Update in ObjectBox
    notifyListeners();
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    // TODO: Delete from ObjectBox
    notifyListeners();
  }
}
