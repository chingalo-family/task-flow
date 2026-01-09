import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/services/notification_service.dart';
import 'package:task_flow/core/services/preference_service.dart';

@GenerateMocks([NotificationService, PreferenceService])
import 'notification_state_test.mocks.dart';

void main() {
  group('NotificationState', () {
    late MockNotificationService mockNotificationService;
    late MockPreferenceService mockPreferenceService;
    late NotificationState notificationState;

    setUp(() {
      mockNotificationService = MockNotificationService();
      mockPreferenceService = MockPreferenceService();
      notificationState = NotificationState(
        service: mockNotificationService,
        prefs: mockPreferenceService,
      );
    });

    test('should start with empty notifications list', () {
      expect(notificationState.notifications, []);
      expect(notificationState.totalNotifications, 0);
      expect(notificationState.unreadCount, 0);
      expect(notificationState.loading, false);
    });

    test('should initialize with notifications and preferences', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'system'),
        Notification(id: '2', title: 'Test 2', type: 'system', isRead: true),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);

      await notificationState.initialize();

      expect(notificationState.notifications.length, 2);
      expect(notificationState.totalNotifications, 2);
      expect(notificationState.notificationsEnabled, true);
      expect(notificationState.loading, false);
    });

    test('should default notifications enabled to true if preference not set', () async {
      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => null);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => []);

      await notificationState.initialize();

      expect(notificationState.notificationsEnabled, true);
    });

    test('should handle initialization errors gracefully', () async {
      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenThrow(Exception('Preference error'));
      when(mockNotificationService.getAllNotifications())
          .thenThrow(Exception('Network error'));

      await notificationState.initialize();

      expect(notificationState.notifications, []);
      expect(notificationState.notificationsEnabled, true);
      expect(notificationState.loading, false);
    });

    test('should get unread notifications', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'system', isRead: false),
        Notification(id: '2', title: 'Test 2', type: 'system', isRead: true),
        Notification(id: '3', title: 'Test 3', type: 'system', isRead: false),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);

      await notificationState.initialize();

      expect(notificationState.unreadNotifications.length, 2);
      expect(notificationState.unreadCount, 2);
    });

    test('should set notifications enabled preference', () async {
      when(mockPreferenceService.setBool('notifications_enabled', false))
          .thenAnswer((_) async => {});

      await notificationState.setNotificationsEnabled(false);

      expect(notificationState.notificationsEnabled, false);
      verify(mockPreferenceService.setBool('notifications_enabled', false))
          .called(1);
    });

    test('should mark notification as read', () async {
      final notification = Notification(
        id: '1',
        title: 'Test',
        type: 'system',
        isRead: false,
      );

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => [notification]);
      when(mockNotificationService.markAsRead('1'))
          .thenAnswer((_) async => true);

      await notificationState.initialize();
      expect(notificationState.unreadCount, 1);

      await notificationState.markAsRead('1');

      expect(notificationState.notifications[0].isRead, true);
      expect(notificationState.unreadCount, 0);
      verify(mockNotificationService.markAsRead('1')).called(1);
    });

    test('should not mark notification as read if service fails', () async {
      final notification = Notification(
        id: '1',
        title: 'Test',
        type: 'system',
        isRead: false,
      );

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => [notification]);
      when(mockNotificationService.markAsRead('1'))
          .thenAnswer((_) async => false);

      await notificationState.initialize();
      await notificationState.markAsRead('1');

      expect(notificationState.notifications[0].isRead, false);
    });

    test('should mark all notifications as read', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'system', isRead: false),
        Notification(id: '2', title: 'Test 2', type: 'system', isRead: false),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);
      when(mockNotificationService.markAllAsRead())
          .thenAnswer((_) async => true);

      await notificationState.initialize();
      expect(notificationState.unreadCount, 2);

      await notificationState.markAllAsRead();

      expect(notificationState.notifications[0].isRead, true);
      expect(notificationState.notifications[1].isRead, true);
      expect(notificationState.unreadCount, 0);
      verify(mockNotificationService.markAllAsRead()).called(1);
    });

    test('should delete notification', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'system'),
        Notification(id: '2', title: 'Test 2', type: 'system'),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);
      when(mockNotificationService.deleteNotification('1'))
          .thenAnswer((_) async => true);

      await notificationState.initialize();
      expect(notificationState.totalNotifications, 2);

      await notificationState.deleteNotification('1');

      expect(notificationState.totalNotifications, 1);
      expect(notificationState.notifications.any((n) => n.id == '1'), false);
      verify(mockNotificationService.deleteNotification('1')).called(1);
    });

    test('should add notification', () async {
      final notification = Notification(id: '1', title: 'Test', type: 'system');

      when(mockNotificationService.createNotification(notification))
          .thenAnswer((_) async => notification);

      await notificationState.addNotification(notification);

      expect(notificationState.totalNotifications, 1);
      expect(notificationState.notifications[0], notification);
      verify(mockNotificationService.createNotification(notification)).called(1);
    });

    test('should add notifications at the beginning', () async {
      final existing = Notification(id: '1', title: 'Existing', type: 'system');
      final newNotif = Notification(id: '2', title: 'New', type: 'system');

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => [existing]);
      when(mockNotificationService.createNotification(newNotif))
          .thenAnswer((_) async => newNotif);

      await notificationState.initialize();
      await notificationState.addNotification(newNotif);

      expect(notificationState.notifications[0].id, '2');
      expect(notificationState.notifications[1].id, '1');
    });

    test('should add multiple notifications', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'system'),
        Notification(id: '2', title: 'Test 2', type: 'system'),
      ];

      when(mockNotificationService.createNotification(any))
          .thenAnswer((_) async => null);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);

      await notificationState.addNotifications(notifications);

      expect(notificationState.totalNotifications, 2);
    });

    test('should clear all notifications', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'system'),
        Notification(id: '2', title: 'Test 2', type: 'system'),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);
      when(mockNotificationService.deleteAll())
          .thenAnswer((_) async => true);

      await notificationState.initialize();
      expect(notificationState.totalNotifications, 2);

      await notificationState.clearAllNotifications();

      expect(notificationState.totalNotifications, 0);
      verify(mockNotificationService.deleteAll()).called(1);
    });

    test('should get notifications by type', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'task_assigned'),
        Notification(id: '2', title: 'Test 2', type: 'system'),
        Notification(id: '3', title: 'Test 3', type: 'task_assigned'),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);

      await notificationState.initialize();

      final taskNotifs = notificationState.getNotificationsByType('task_assigned');

      expect(taskNotifs.length, 2);
      expect(taskNotifs.every((n) => n.type == 'task_assigned'), true);
    });

    test('should get unread notifications by type', () async {
      final notifications = [
        Notification(id: '1', title: 'Test 1', type: 'task_assigned', isRead: false),
        Notification(id: '2', title: 'Test 2', type: 'task_assigned', isRead: true),
        Notification(id: '3', title: 'Test 3', type: 'task_assigned', isRead: false),
        Notification(id: '4', title: 'Test 4', type: 'system', isRead: false),
      ];

      when(mockPreferenceService.getBool('notifications_enabled'))
          .thenAnswer((_) async => true);
      when(mockNotificationService.getAllNotifications())
          .thenAnswer((_) async => notifications);

      await notificationState.initialize();

      final unreadTaskNotifs = 
          notificationState.getUnreadNotificationsByType('task_assigned');

      expect(unreadTaskNotifs.length, 2);
      expect(unreadTaskNotifs.every(
        (n) => n.type == 'task_assigned' && n.isRead == false
      ), true);
    });
  });
}
