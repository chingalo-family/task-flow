import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/constants/notification_constants.dart';
import 'package:task_flow/core/models/notification.dart';

void main() {
  group('Notification', () {
    test('should create notification with required fields', () {
      final notification = Notification(
        id: '1',
        title: 'Test Notification',
        type: NotificationConstants.typeTaskAssigned,
      );

      expect(notification.id, '1');
      expect(notification.title, 'Test Notification');
      expect(notification.type, NotificationConstants.typeTaskAssigned);
      expect(notification.isRead, false);
      expect(notification.body, null);
    });

    test('should create notification with all fields', () {
      final createdAt = DateTime(2024, 1, 1);
      final notification = Notification(
        id: '1',
        title: 'Test Notification',
        body: 'This is a test',
        type: NotificationConstants.typeTaskAssigned,
        isRead: true,
        relatedEntityId: 'task123',
        relatedEntityType: 'task',
        actorUserId: 'user123',
        actorUsername: 'testuser',
        actorAvatarUrl: 'https://example.com/avatar.png',
        createdAt: createdAt,
      );

      expect(notification.id, '1');
      expect(notification.title, 'Test Notification');
      expect(notification.body, 'This is a test');
      expect(notification.type, NotificationConstants.typeTaskAssigned);
      expect(notification.isRead, true);
      expect(notification.relatedEntityId, 'task123');
      expect(notification.relatedEntityType, 'task');
      expect(notification.actorUserId, 'user123');
      expect(notification.actorUsername, 'testuser');
      expect(notification.actorAvatarUrl, 'https://example.com/avatar.png');
      expect(notification.createdAt, createdAt);
    });

    test('should default isRead to false', () {
      final notification = Notification(id: '1', title: 'Test', type: 'system');

      expect(notification.isRead, false);
    });

    test('should default createdAt to current time if not provided', () {
      final before = DateTime.now();
      final notification = Notification(id: '1', title: 'Test', type: 'system');
      final after = DateTime.now();

      expect(
        notification.createdAt.isAfter(before) ||
            notification.createdAt.isAtSameMomentAs(before),
        true,
      );
      expect(
        notification.createdAt.isBefore(after) ||
            notification.createdAt.isAtSameMomentAs(after),
        true,
      );
    });

    test('should copy notification with updated fields', () {
      final original = Notification(
        id: '1',
        title: 'Original',
        type: NotificationConstants.typeTaskAssigned,
      );

      final copied = original.copyWith(title: 'Updated', isRead: true);

      expect(copied.id, '1');
      expect(copied.title, 'Updated');
      expect(copied.type, NotificationConstants.typeTaskAssigned);
      expect(copied.isRead, true);
    });

    test('should copy notification without changes', () {
      final original = Notification(
        id: '1',
        title: 'Test',
        type: 'system',
        isRead: true,
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.title, original.title);
      expect(copied.type, original.type);
      expect(copied.isRead, original.isRead);
    });

    test('should get time ago string', () {
      final notification = Notification(
        id: '1',
        title: 'Test',
        type: 'system',
        createdAt: DateTime.now(),
      );

      final timeAgo = notification.getTimeAgo();

      expect(timeAgo, isNotNull);
      expect(timeAgo, isA<String>());
    });

    test('should handle null optional fields in copyWith', () {
      final original = Notification(
        id: '1',
        title: 'Test',
        type: 'system',
        body: 'Original body',
        actorUsername: 'user1',
      );

      final copied = original.copyWith(body: 'New body');

      expect(copied.body, 'New body');
      expect(copied.actorUsername, 'user1');
    });
  });
}
