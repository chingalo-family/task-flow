import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/notification_preferences.dart';

void main() {
  group('NotificationPreferences', () {
    test('should create default preferences with all enabled', () {
      final prefs = NotificationPreferences();

      expect(prefs.taskAssigned, true);
      expect(prefs.taskCompleted, true);
      expect(prefs.taskStatusChange, true);
      expect(prefs.taskComment, true);
      expect(prefs.taskMention, true);
      expect(prefs.deadlineReminder, true);
      expect(prefs.teamInvite, true);
      expect(prefs.teamMemberAdded, true);
      expect(prefs.teamMemberRemoved, true);
      expect(prefs.systemNotifications, true);
      expect(prefs.taskPriorityChange, true);
      expect(prefs.taskOverdue, true);
    });

    test('should create preferences with custom values', () {
      final prefs = NotificationPreferences(
        taskAssigned: false,
        taskCompleted: false,
        taskStatusChange: true,
        taskComment: false,
        taskMention: true,
        deadlineReminder: true,
        teamInvite: false,
        teamMemberAdded: true,
        teamMemberRemoved: false,
        systemNotifications: true,
        taskPriorityChange: false,
        taskOverdue: true,
      );

      expect(prefs.taskAssigned, false);
      expect(prefs.taskCompleted, false);
      expect(prefs.taskStatusChange, true);
      expect(prefs.taskComment, false);
      expect(prefs.taskMention, true);
      expect(prefs.deadlineReminder, true);
      expect(prefs.teamInvite, false);
      expect(prefs.teamMemberAdded, true);
      expect(prefs.teamMemberRemoved, false);
      expect(prefs.systemNotifications, true);
      expect(prefs.taskPriorityChange, false);
      expect(prefs.taskOverdue, true);
    });

    test('should copy with updated values', () {
      final prefs = NotificationPreferences();
      final updated = prefs.copyWith(taskAssigned: false, taskCompleted: false);

      expect(updated.taskAssigned, false);
      expect(updated.taskCompleted, false);
      expect(updated.taskStatusChange, true); // Unchanged
      expect(updated.taskComment, true); // Unchanged
    });

    test('should convert to JSON', () {
      final prefs = NotificationPreferences(
        taskAssigned: false,
        taskCompleted: true,
      );
      final json = prefs.toJson();

      expect(json['taskAssigned'], false);
      expect(json['taskCompleted'], true);
      expect(json['taskStatusChange'], true);
      expect(json.containsKey('taskComment'), true);
    });

    test('should create from JSON', () {
      final json = {
        'taskAssigned': false,
        'taskCompleted': true,
        'taskStatusChange': false,
        'taskComment': true,
        'taskMention': false,
        'deadlineReminder': true,
        'teamInvite': false,
        'teamMemberAdded': true,
        'teamMemberRemoved': false,
        'systemNotifications': true,
        'taskPriorityChange': false,
        'taskOverdue': true,
      };
      final prefs = NotificationPreferences.fromJson(json);

      expect(prefs.taskAssigned, false);
      expect(prefs.taskCompleted, true);
      expect(prefs.taskStatusChange, false);
      expect(prefs.taskComment, true);
      expect(prefs.taskMention, false);
      expect(prefs.deadlineReminder, true);
      expect(prefs.teamInvite, false);
      expect(prefs.teamMemberAdded, true);
      expect(prefs.teamMemberRemoved, false);
      expect(prefs.systemNotifications, true);
      expect(prefs.taskPriorityChange, false);
      expect(prefs.taskOverdue, true);
    });

    test('should create from JSON with missing values defaulting to true', () {
      final json = <String, dynamic>{'taskAssigned': false};
      final prefs = NotificationPreferences.fromJson(json);

      expect(prefs.taskAssigned, false);
      expect(prefs.taskCompleted, true); // Default
      expect(prefs.taskStatusChange, true); // Default
    });

    test('should check if notification type is enabled', () {
      final prefs = NotificationPreferences(
        taskAssigned: true,
        taskCompleted: false,
        taskStatusChange: true,
        taskComment: false,
        taskMention: true,
        deadlineReminder: false,
        teamInvite: true,
        teamMemberAdded: false,
        teamMemberRemoved: true,
        systemNotifications: false,
        taskPriorityChange: true,
        taskOverdue: false,
      );

      expect(prefs.isNotificationTypeEnabled('task_assigned'), true);
      expect(prefs.isNotificationTypeEnabled('task_completed'), false);
      expect(prefs.isNotificationTypeEnabled('task_status_change'), true);
      expect(prefs.isNotificationTypeEnabled('task_comment'), false);
      expect(prefs.isNotificationTypeEnabled('mention'), true);
      expect(prefs.isNotificationTypeEnabled('deadline_reminder'), false);
      expect(prefs.isNotificationTypeEnabled('team_invite'), true);
      expect(prefs.isNotificationTypeEnabled('team_member_added'), false);
      expect(prefs.isNotificationTypeEnabled('team_member_removed'), true);
      expect(prefs.isNotificationTypeEnabled('system'), false);
      expect(prefs.isNotificationTypeEnabled('task_priority_change'), true);
      expect(prefs.isNotificationTypeEnabled('task_overdue'), false);
    });

    test('should return true for unknown notification types', () {
      final prefs = NotificationPreferences();
      expect(prefs.isNotificationTypeEnabled('unknown_type'), true);
    });

    test('should handle JSON round trip correctly', () {
      final original = NotificationPreferences(
        taskAssigned: false,
        taskCompleted: true,
        taskStatusChange: false,
        taskComment: true,
        taskMention: false,
        deadlineReminder: true,
        teamInvite: false,
        teamMemberAdded: true,
        teamMemberRemoved: false,
        systemNotifications: true,
        taskPriorityChange: false,
        taskOverdue: true,
      );

      final json = original.toJson();
      final restored = NotificationPreferences.fromJson(json);

      expect(restored.taskAssigned, original.taskAssigned);
      expect(restored.taskCompleted, original.taskCompleted);
      expect(restored.taskStatusChange, original.taskStatusChange);
      expect(restored.taskComment, original.taskComment);
      expect(restored.taskMention, original.taskMention);
      expect(restored.deadlineReminder, original.deadlineReminder);
      expect(restored.teamInvite, original.teamInvite);
      expect(restored.teamMemberAdded, original.teamMemberAdded);
      expect(restored.teamMemberRemoved, original.teamMemberRemoved);
      expect(restored.systemNotifications, original.systemNotifications);
      expect(restored.taskPriorityChange, original.taskPriorityChange);
      expect(restored.taskOverdue, original.taskOverdue);
    });
  });
}
