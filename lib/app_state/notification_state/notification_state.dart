import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart' as app_notification;
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/notification_service.dart';

class NotificationState extends ChangeNotifier {
  final NotificationService _service;
  final PreferenceService _prefs;

  NotificationState({NotificationService? service, PreferenceService? prefs})
    : _service = service ?? NotificationService(),
      _prefs = prefs ?? PreferenceService();

  List<app_notification.Notification> _notifications = [];
  bool _loading = false;
  bool _notificationsEnabled = true;

  List<app_notification.Notification> get notifications => _notifications;
  List<app_notification.Notification> get unreadNotifications => _notifications
      .where((notification) => notification.isRead == false)
      .toList();
  bool get loading => _loading;
  bool get notificationsEnabled => _notificationsEnabled;

  int get totalNotifications => _notifications.length;
  int get unreadCount => unreadNotifications.length;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    await _loadNotificationPreference();
    await _loadNotifications();
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadNotificationPreference() async {
    try {
      final enabled = await _prefs.getBool('notifications_enabled');
      _notificationsEnabled = enabled ?? true;
    } catch (e) {
      _notificationsEnabled = true;
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefs.setBool('notifications_enabled', enabled);
    notifyListeners();
  }

  Future<void> _loadNotifications() async {
    try {
      _notifications = await _service.getAllNotifications();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      _notifications = [];
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final success = await _service.markAsRead(notificationId);
    if (success) {
      final index = _notifications.indexWhere(
        (notification) => notification.id == notificationId,
      );
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final success = await _service.markAllAsRead();
    if (success) {
      for (
        var notificationIndex = 0;
        notificationIndex < _notifications.length;
        notificationIndex++
      ) {
        if (_notifications[notificationIndex].isRead == false) {
          _notifications[notificationIndex] = _notifications[notificationIndex]
              .copyWith(isRead: true);
        }
      }
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final success = await _service.deleteNotification(notificationId);
    if (success) {
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    }
  }

  Future<void> addNotification(
    app_notification.Notification notification,
  ) async {
    //TODO sync the notification with API if needed later
    final created = await _service.createNotification(notification);
    if (created != null) {
      _notifications.insert(0, created);
      notifyListeners();
    }
  }

  Future<void> addNotifications(
    List<app_notification.Notification> notifications,
  ) async {
    for (final notification in notifications) {
      await _service.createNotification(notification);
    }
    await _loadNotifications();
  }

  Future<void> clearAllNotifications() async {
    final success = await _service.deleteAll();
    if (success) {
      _notifications.clear();
      notifyListeners();
    }
  }

  List<app_notification.Notification> getNotificationsByType(String type) {
    return _notifications
        .where((notification) => notification.type == type)
        .toList();
  }

  /// Get unread notifications by type
  List<app_notification.Notification> getUnreadNotificationsByType(
    String type,
  ) {
    return _notifications
        .where(
          (notification) =>
              notification.type == type && notification.isRead == false,
        )
        .toList();
  }
}
