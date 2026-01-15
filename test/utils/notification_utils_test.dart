import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/utils/notification_utils.dart';

void main() {
  group('NotificationUtils', () {
    group('createTaskAssignedNotification', () {
      test('should create task assigned notification', () {
        final notification = NotificationUtils.createTaskAssignedNotification(
          taskTitle: 'Implement login',
          assignedBy: 'John Doe',
          taskId: 'task123',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'New task assigned');
        expect(notification.body, 'John Doe assigned you to "Implement login"');
        expect(notification.type, 'task_assigned');
        expect(notification.isRead, false);
        expect(notification.actorUsername, 'John Doe');
        expect(notification.relatedEntityId, 'task123');
        expect(notification.relatedEntityType, 'task');
      });

      test('should create notification without task id', () {
        final notification = NotificationUtils.createTaskAssignedNotification(
          taskTitle: 'Fix bug',
          assignedBy: 'Jane Smith',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'New task assigned');
        expect(notification.relatedEntityId, null);
      });
    });

    group('createTaskCompletedNotification', () {
      test('should create task completed notification', () {
        final notification = NotificationUtils.createTaskCompletedNotification(
          taskTitle: 'Implement feature',
          completedBy: 'Alice',
          taskId: 'task456',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'Task completed');
        expect(
          notification.body,
          'Alice marked "Implement feature" as complete',
        );
        expect(notification.type, 'task_completed');
        expect(notification.isRead, false);
        expect(notification.actorUsername, 'Alice');
        expect(notification.relatedEntityId, 'task456');
        expect(notification.relatedEntityType, 'task');
      });
    });

    group('createTeamInviteNotification', () {
      test('should create team invite notification', () {
        final notification = NotificationUtils.createTeamInviteNotification(
          teamName: 'Engineering Team',
          invitedBy: 'Bob',
          teamId: 'team789',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'Team invitation');
        expect(
          notification.body,
          'You\'ve been invited to join Engineering Team',
        );
        expect(notification.type, 'team_invite');
        expect(notification.isRead, false);
        expect(notification.actorUsername, 'Bob');
        expect(notification.relatedEntityId, 'team789');
        expect(notification.relatedEntityType, 'team');
      });
    });

    group('createMentionNotification', () {
      test('should create mention notification with preview', () {
        final notification = NotificationUtils.createMentionNotification(
          mentionedBy: 'Charlie',
          context: 'comment',
          entityId: 'entity123',
          preview: 'Great work on this!',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'Mentioned in comment');
        expect(notification.body, 'Great work on this!');
        expect(notification.type, 'mention');
        expect(notification.actorUsername, 'Charlie');
        expect(notification.relatedEntityId, 'entity123');
        expect(notification.relatedEntityType, 'comment');
      });

      test('should create mention notification without preview', () {
        final notification = NotificationUtils.createMentionNotification(
          mentionedBy: 'Charlie',
          context: 'comment',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.body, 'Charlie mentioned you in a comment');
      });
    });

    group('createDeadlineReminderNotification', () {
      test('should create deadline reminder for today', () {
        final dueDate = DateTime.now().add(const Duration(hours: 5));
        final notification =
            NotificationUtils.createDeadlineReminderNotification(
              taskTitle: 'Submit report',
              dueDate: dueDate,
              taskId: 'task111',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'Deadline reminder');
        expect(notification.body, '"Submit report" is due today');
        expect(notification.type, 'deadline_reminder');
        expect(notification.relatedEntityId, 'task111');
        expect(notification.relatedEntityType, 'task');
      });

      test('should create deadline reminder for tomorrow', () {
        final dueDate = DateTime.now().add(const Duration(hours: 30));
        final notification =
            NotificationUtils.createDeadlineReminderNotification(
              taskTitle: 'Review code',
              dueDate: dueDate,
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.body, '"Review code" is due tomorrow');
      });

      test('should create deadline reminder for multiple days', () {
        final dueDate = DateTime.now().add(const Duration(days: 5));
        final notification =
            NotificationUtils.createDeadlineReminderNotification(
              taskTitle: 'Project deadline',
              dueDate: dueDate,
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.body, contains('in'));
        expect(notification.body, contains('days'));
      });
    });

    group('createTaskCommentNotification', () {
      test('should create task comment notification with preview', () {
        final notification = NotificationUtils.createTaskCommentNotification(
          taskTitle: 'Fix bug',
          commentedBy: 'David',
          commentPreview: 'I found the issue!',
          taskId: 'task222',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'David commented');
        expect(notification.body, 'I found the issue!');
        expect(notification.type, 'task_comment');
        expect(notification.actorUsername, 'David');
        expect(notification.relatedEntityId, 'task222');
      });

      test('should create task comment notification without preview', () {
        final notification = NotificationUtils.createTaskCommentNotification(
          taskTitle: 'Fix bug',
          commentedBy: 'David',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.body, 'David commented on "Fix bug"');
      });
    });

    group('createTaskStatusChangeNotification', () {
      test('should create task status change notification', () {
        final notification =
            NotificationUtils.createTaskStatusChangeNotification(
              taskTitle: 'Update docs',
              newStatus: 'In Progress',
              changedBy: 'Eve',
              taskId: 'task333',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'Task status updated');
        expect(notification.body, 'Eve changed "Update docs" to In Progress');
        expect(notification.type, 'task_status_change');
        expect(notification.actorUsername, 'Eve');
        expect(notification.relatedEntityId, 'task333');
        expect(notification.relatedEntityType, 'task');
      });
    });

    group('createSystemNotification', () {
      test('should create system notification', () {
        final notification = NotificationUtils.createSystemNotification(
          title: 'Maintenance',
          message: 'System will be down for maintenance',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'Maintenance');
        expect(notification.body, 'System will be down for maintenance');
        expect(notification.type, 'system');
        expect(notification.isRead, false);
      });
    });

    group('createCustomNotification', () {
      test('should create custom notification', () {
        final notification = NotificationUtils.createCustomNotification(
          title: 'Custom Title',
          body: 'Custom Body',
          type: 'custom_type',
          actorUsername: 'Frank',
          relatedEntityId: 'entity999',
          relatedEntityType: 'custom',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'Custom Title');
        expect(notification.body, 'Custom Body');
        expect(notification.type, 'custom_type');
        expect(notification.actorUsername, 'Frank');
        expect(notification.relatedEntityId, 'entity999');
        expect(notification.relatedEntityType, 'custom');
      });
    });

    group('batchCreateNotifications', () {
      test('should create multiple notifications', () {
        final notifications = NotificationUtils.batchCreateNotifications([
          () => NotificationUtils.createSystemNotification(
            title: 'Test 1',
            message: 'Message 1',
            recipientUserId: '',
            recipientUserName: '',
          ),
          () => NotificationUtils.createSystemNotification(
            title: 'Test 2',
            message: 'Message 2',
            recipientUserId: '',
            recipientUserName: '',
          ),
        ]);

        expect(notifications.length, 2);
        expect(notifications[0].title, 'Test 1');
        expect(notifications[1].title, 'Test 2');
      });
    });

    group('getNotificationIcon', () {
      test('should return correct icons for notification types', () {
        expect(
          NotificationUtils.getNotificationIcon('task_assigned'),
          'task_alt',
        );
        expect(NotificationUtils.getNotificationIcon('team_invite'), 'people');
        expect(
          NotificationUtils.getNotificationIcon('task_completed'),
          'check_circle',
        );
        expect(
          NotificationUtils.getNotificationIcon('mention'),
          'alternate_email',
        );
        expect(
          NotificationUtils.getNotificationIcon('deadline_reminder'),
          'alarm',
        );
        expect(
          NotificationUtils.getNotificationIcon('task_comment'),
          'comment',
        );
        expect(
          NotificationUtils.getNotificationIcon('task_status_change'),
          'update',
        );
        expect(NotificationUtils.getNotificationIcon('system'), 'info');
      });

      test('should return default icon for unknown type', () {
        expect(
          NotificationUtils.getNotificationIcon('unknown'),
          'notifications',
        );
      });
    });

    group('getNotificationColor', () {
      test('should return correct colors for notification types', () {
        expect(
          NotificationUtils.getNotificationColor('task_assigned'),
          'primaryBlue',
        );
        expect(
          NotificationUtils.getNotificationColor('team_invite'),
          'successGreen',
        );
        expect(
          NotificationUtils.getNotificationColor('task_completed'),
          'successGreen',
        );
        expect(
          NotificationUtils.getNotificationColor('mention'),
          'warningOrange',
        );
        expect(
          NotificationUtils.getNotificationColor('task_comment'),
          'warningOrange',
        );
        expect(
          NotificationUtils.getNotificationColor('deadline_reminder'),
          'errorRed',
        );
        expect(
          NotificationUtils.getNotificationColor('task_status_change'),
          'primaryBlue',
        );
        expect(
          NotificationUtils.getNotificationColor('system'),
          'textSecondary',
        );
      });

      test('should return default color for unknown type', () {
        expect(
          NotificationUtils.getNotificationColor('unknown'),
          'primaryBlue',
        );
      });
    });

    group('createTeamMemberAddedNotification', () {
      test('should create team member added notification', () {
        final notification =
            NotificationUtils.createTeamMemberAddedNotification(
              teamName: 'Dev Team',
              memberUsername: 'john_doe',
              addedBy: 'Admin',
              teamId: 'team123',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'New team member');
        expect(notification.body, 'Admin added john_doe to Dev Team');
        expect(notification.type, 'team_member_added');
        expect(notification.isRead, false);
        expect(notification.actorUsername, 'Admin');
        expect(notification.relatedEntityId, 'team123');
        expect(notification.relatedEntityType, 'team');
      });
    });

    group('createTeamMemberRemovedNotification', () {
      test('should create team member removed notification', () {
        final notification =
            NotificationUtils.createTeamMemberRemovedNotification(
              teamName: 'Dev Team',
              memberUsername: 'john_doe',
              removedBy: 'Admin',
              teamId: 'team123',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'Team member removed');
        expect(notification.body, 'Admin removed john_doe from Dev Team');
        expect(notification.type, 'team_member_removed');
        expect(notification.isRead, false);
        expect(notification.actorUsername, 'Admin');
        expect(notification.relatedEntityId, 'team123');
        expect(notification.relatedEntityType, 'team');
      });
    });

    group('createTaskPriorityChangeNotification', () {
      test('should create task priority change notification', () {
        final notification =
            NotificationUtils.createTaskPriorityChangeNotification(
              taskTitle: 'Fix bug',
              newPriority: 'High',
              changedBy: 'Manager',
              taskId: 'task456',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'Task priority changed');
        expect(notification.body, 'Manager changed "Fix bug" priority to High');
        expect(notification.type, 'task_priority_change');
        expect(notification.isRead, false);
        expect(notification.actorUsername, 'Manager');
        expect(notification.relatedEntityId, 'task456');
        expect(notification.relatedEntityType, 'task');
      });
    });

    group('createTaskOverdueNotification', () {
      test('should create overdue notification for tasks due days ago', () {
        final dueDate = DateTime.now().subtract(const Duration(days: 3));
        final notification = NotificationUtils.createTaskOverdueNotification(
          taskTitle: 'Submit report',
          dueDate: dueDate,
          taskId: 'task789',
          recipientUserId: '',
          recipientUserName: '',
        );

        expect(notification.title, 'Task overdue');
        expect(notification.body, '"Submit report" was due 3 days ago');
        expect(notification.type, 'task_overdue');
        expect(notification.relatedEntityId, 'task789');
        expect(notification.relatedEntityType, 'task');
      });
    });

    group('createTaskAssignmentChangeNotification', () {
      test('should create task reassignment notification', () {
        final notification =
            NotificationUtils.createTaskAssignmentChangeNotification(
              taskTitle: 'Review code',
              newAssignee: 'Jane',
              changedBy: 'Manager',
              taskId: 'task999',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'Task reassigned');
        expect(notification.body, 'Manager reassigned "Review code" to Jane');
        expect(notification.type, 'task_assignment_change');
        expect(notification.actorUsername, 'Manager');
        expect(notification.relatedEntityId, 'task999');
        expect(notification.relatedEntityType, 'task');
      });
    });

    group('createTaskDueDateChangeNotification', () {
      test('should create due date change notification', () {
        final newDueDate = DateTime.now().add(const Duration(days: 3));
        final notification =
            NotificationUtils.createTaskDueDateChangeNotification(
              taskTitle: 'Project deadline',
              newDueDate: newDueDate,
              changedBy: 'Manager',
              taskId: 'task111',
              recipientUserId: '',
              recipientUserName: '',
            );

        expect(notification.title, 'Due date changed');
        expect(
          notification.body,
          contains('Manager changed "Project deadline" due date'),
        );
        expect(notification.type, 'task_due_date_change');
        expect(notification.actorUsername, 'Manager');
        expect(notification.relatedEntityId, 'task111');
      });
    });

    test('all created notifications should have unique IDs', () {
      final n1 = NotificationUtils.createSystemNotification(
        title: 'Test',
        message: 'Message',
        recipientUserId: '',
        recipientUserName: '',
      );

      final n2 = NotificationUtils.createSystemNotification(
        title: 'Test',
        message: 'Message',
        recipientUserId: '',
        recipientUserName: '',
      );

      expect(n1.id, isNot(equals(n2.id)));
    });

    test('all notifications should have createdAt timestamp', () {
      final before = DateTime.now();
      final notification = NotificationUtils.createSystemNotification(
        title: 'Test',
        message: 'Message',
        recipientUserId: '',
        recipientUserName: '',
      );
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
  });
}
