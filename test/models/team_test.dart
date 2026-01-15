import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/team.dart';
import 'package:task_flow/core/models/task_status.dart';

void main() {
  group('Team', () {
    test('should create team with required fields', () {
      final team = Team(id: 'team1', name: 'Engineering Team');

      expect(team.id, 'team1');
      expect(team.name, 'Engineering Team');
      expect(team.memberCount, 0);
      expect(team.description, null);
      expect(team.avatarUrl, null);
    });

    test('should create team with all fields', () {
      final createdAt = DateTime(2024, 1, 1);
      final updatedAt = DateTime(2024, 1, 2);
      final customStatuses = [
        TaskStatus(id: 'custom1', name: 'Review', color: Colors.orange),
      ];

      final team = Team(
        id: 'team1',
        name: 'Engineering Team',
        description: 'Software development team',
        avatarUrl: 'https://example.com/avatar.png',
        memberCount: 5,
        memberIds: ['user1', 'user2'],
        taskIds: ['task1', 'task2'],
        customTaskStatuses: customStatuses,
        createdByUserId: 'user123',
        createdByUsername: 'admin',
        createdAt: createdAt,
        updatedAt: updatedAt,
        teamIcon: '👨‍💻',
        teamColor: '#FF5733',
      );

      expect(team.id, 'team1');
      expect(team.name, 'Engineering Team');
      expect(team.description, 'Software development team');
      expect(team.avatarUrl, 'https://example.com/avatar.png');
      expect(team.memberCount, 5);
      expect(team.memberIds, ['user1', 'user2']);
      expect(team.taskIds, ['task1', 'task2']);
      expect(team.customTaskStatuses, customStatuses);
      expect(team.createdByUserId, 'user123');
      expect(team.createdByUsername, 'admin');
      expect(team.createdAt, createdAt);
      expect(team.updatedAt, updatedAt);
      expect(team.teamIcon, '👨‍💻');
      expect(team.teamColor, '#FF5733');
    });

    test('should default memberCount to 0', () {
      final team = Team(id: 'team1', name: 'Test Team');

      expect(team.memberCount, 0);
    });

    test('should default timestamps to current time', () {
      final before = DateTime.now();
      final team = Team(id: 'team1', name: 'Test Team');
      final after = DateTime.now();

      expect(
        team.createdAt.isAfter(before) ||
            team.createdAt.isAtSameMomentAs(before),
        true,
      );
      expect(
        team.createdAt.isBefore(after) ||
            team.createdAt.isAtSameMomentAs(after),
        true,
      );
      expect(
        team.updatedAt.isAfter(before) ||
            team.updatedAt.isAtSameMomentAs(before),
        true,
      );
      expect(
        team.updatedAt.isBefore(after) ||
            team.updatedAt.isAtSameMomentAs(after),
        true,
      );
    });

    test('should return default statuses when customTaskStatuses is null', () {
      final team = Team(id: 'team1', name: 'Test Team');

      final statuses = team.taskStatuses;
      final defaultStatuses = TaskStatus.getDefaultStatuses();

      expect(statuses.length, defaultStatuses.length);
      expect(statuses[0].id, 'todo');
      expect(statuses[1].id, 'in_progress');
      expect(statuses[2].id, 'completed');
    });

    test('should return custom statuses when provided', () {
      final customStatuses = [
        TaskStatus(id: 'custom1', name: 'Review', color: Colors.orange),
      ];

      final team = Team(
        id: 'team1',
        name: 'Test Team',
        customTaskStatuses: customStatuses,
      );

      expect(team.taskStatuses, customStatuses);
      expect(team.taskStatuses.length, 1);
      expect(team.taskStatuses[0].id, 'custom1');
    });

    test('should copy team with updated fields', () {
      final original = Team(id: 'team1', name: 'Original Team', memberCount: 3);

      final copied = original.copyWith(name: 'Updated Team', memberCount: 5);

      expect(copied.id, 'team1');
      expect(copied.name, 'Updated Team');
      expect(copied.memberCount, 5);
    });

    test('should copy team without changes', () {
      final original = Team(
        id: 'team1',
        name: 'Test Team',
        description: 'A test team',
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.description, original.description);
    });

    test('should copy team with new member list', () {
      final original = Team(
        id: 'team1',
        name: 'Test Team',
        memberIds: ['user1', 'user2'],
      );

      final copied = original.copyWith(
        memberIds: ['user1', 'user2', 'user3'],
        memberCount: 3,
      );

      expect(copied.memberIds, ['user1', 'user2', 'user3']);
      expect(copied.memberCount, 3);
      expect(original.memberIds, ['user1', 'user2']);
    });

    test('should copy team with new task list', () {
      final original = Team(id: 'team1', name: 'Test Team', taskIds: ['task1']);

      final copied = original.copyWith(taskIds: ['task1', 'task2']);

      expect(copied.taskIds, ['task1', 'task2']);
      expect(original.taskIds, ['task1']);
    });

    test('should copy team with custom statuses', () {
      final original = Team(id: 'team1', name: 'Test Team');

      final newStatuses = [
        TaskStatus(id: 'custom1', name: 'Review', color: Colors.orange),
      ];

      final copied = original.copyWith(customTaskStatuses: newStatuses);

      expect(copied.customTaskStatuses, newStatuses);
      expect(copied.taskStatuses, newStatuses);
    });
  });
}
