import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart' as app_notif;
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/notification_service.dart';

class NotificationState extends ChangeNotifier {
  final _service = NotificationService();
  
  List<app_notif.Notification> _notifications = [];
  bool _loading = false;
  bool _notificationsEnabled = true;

  List<app_notif.Notification> get notifications => _notifications;
  List<app_notif.Notification> get unreadNotifications =>
      _notifications.where((n) => n.isRead == false).toList();
  bool get loading => _loading;
  bool get notificationsEnabled => _notificationsEnabled;

  int get totalNotifications => _notifications.length;
  int get unreadCount => unreadNotifications.length;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    
    // Load notification preference
    await _loadNotificationPreference();
    
    // Load notifications from database via service
    await _loadNotifications();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadNotificationPreference() async {
    try {
      final enabled = await PreferenceService().getBool('notifications_enabled');
      _notificationsEnabled = enabled ?? true;
    } catch (e) {
      _notificationsEnabled = true;
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await PreferenceService().setBool('notifications_enabled', enabled);
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
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final success = await _service.markAllAsRead();
    if (success) {
      for (var i = 0; i < _notifications.length; i++) {
        if (_notifications[i].isRead == false) {
          _notifications[i] = _notifications[i].copyWith(isRead: true);
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

  /// Add a new notification to the list
  /// This is used to dynamically create notifications as events occur
  Future<void> addNotification(app_notif.Notification notification) async {
    final created = await _service.createNotification(notification);
    if (created != null) {
      _notifications.insert(0, created); // Add to the beginning
      notifyListeners();
    }
  }

  /// Add multiple notifications at once
  Future<void> addNotifications(List<app_notif.Notification> notifications) async {
    for (final notification in notifications) {
      await _service.createNotification(notification);
    }
    await _loadNotifications(); // Reload all to ensure proper sorting
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    final success = await _service.deleteAll();
    if (success) {
      _notifications.clear();
      notifyListeners();
    }
  }

  /// Get notifications by type
  List<app_notif.Notification> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  /// Get unread notifications by type
  List<app_notif.Notification> getUnreadNotificationsByType(String type) {
    return _notifications
        .where((n) => n.type == type && n.isRead == false)
        .toList();
  }
}
