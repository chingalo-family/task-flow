import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/core/models/team.dart';
import 'package:task_flow/core/models/task_status.dart';
import 'package:task_flow/core/services/team_service.dart';

@GenerateMocks([TeamService])
import 'team_state_test.mocks.dart';

void main() {
  group('TeamState', () {
    late MockTeamService mockService;
    late TeamState teamState;

    setUp(() {
      mockService = MockTeamService();
      teamState = TeamState(service: mockService);
    });

    test('should start with empty teams list', () {
      expect(teamState.teams, []);
      expect(teamState.totalTeams, 0);
      expect(teamState.loading, false);
    });

    test('should initialize with teams', () async {
      final teams = [
        Team(id: 'team1', name: 'Team 1'),
        Team(id: 'team2', name: 'Team 2'),
      ];

      when(mockService.getAllTeams()).thenAnswer((_) async => teams);

      await teamState.initialize();

      expect(teamState.teams.length, 2);
      expect(teamState.totalTeams, 2);
      expect(teamState.loading, false);
      verify(mockService.getAllTeams()).called(1);
    });

    test('should handle initialization errors gracefully', () async {
      when(mockService.getAllTeams()).thenThrow(Exception('Network error'));

      await teamState.initialize();

      expect(teamState.teams, []);
      expect(teamState.totalTeams, 0);
      expect(teamState.loading, false);
    });

    test('should add team', () async {
      final team = Team(id: 'team1', name: 'New Team');

      when(mockService.createTeam(team)).thenAnswer((_) async => team);

      await teamState.addTeam(team);

      expect(teamState.teams.contains(team), true);
      expect(teamState.totalTeams, 1);
      verify(mockService.createTeam(team)).called(1);
    });

    test('should not add team if creation fails', () async {
      final team = Team(id: 'team1', name: 'New Team');

      when(mockService.createTeam(team)).thenAnswer((_) async => null);

      await teamState.addTeam(team);

      expect(teamState.teams.contains(team), false);
      expect(teamState.totalTeams, 0);
    });

    test('should update team', () async {
      final team = Team(id: 'team1', name: 'Original');
      final updatedTeam = team.copyWith(name: 'Updated');

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(updatedTeam)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.updateTeam(updatedTeam);

      expect(teamState.teams[0].name, 'Updated');
      verify(mockService.updateTeam(updatedTeam)).called(1);
    });

    test('should not update team if update fails', () async {
      final team = Team(id: 'team1', name: 'Original');
      final updatedTeam = team.copyWith(name: 'Updated');

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(updatedTeam)).thenAnswer((_) async => false);

      await teamState.initialize();
      await teamState.updateTeam(updatedTeam);

      expect(teamState.teams[0].name, 'Original');
    });

    test('should delete team', () async {
      final team = Team(id: 'team1', name: 'Team 1');

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.deleteTeam('team1')).thenAnswer((_) async => true);

      await teamState.initialize();
      expect(teamState.totalTeams, 1);

      await teamState.deleteTeam('team1');

      expect(teamState.totalTeams, 0);
      verify(mockService.deleteTeam('team1')).called(1);
    });

    test('should get team by id', () async {
      final teams = [
        Team(id: 'team1', name: 'Team 1'),
        Team(id: 'team2', name: 'Team 2'),
      ];

      when(mockService.getAllTeams()).thenAnswer((_) async => teams);
      await teamState.initialize();

      final team = teamState.getTeamById('team1');

      expect(team, isNotNull);
      expect(team!.id, 'team1');
      expect(team.name, 'Team 1');
    });

    test('should return null for non-existent team id', () async {
      when(mockService.getAllTeams()).thenAnswer((_) async => []);
      await teamState.initialize();

      final team = teamState.getTeamById('nonexistent');

      expect(team, null);
    });

    test('should add member to team', () async {
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        memberIds: ['user1'],
        memberCount: 1,
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.addMemberToTeam('team1', 'user2');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.memberIds, contains('user2'));
      expect(updatedTeam.memberCount, 2);
    });

    test('should not add duplicate member to team', () async {
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        memberIds: ['user1'],
        memberCount: 1,
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.addMemberToTeam('team1', 'user1');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.memberCount, 1);
    });

    test('should remove member from team', () async {
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        memberIds: ['user1', 'user2'],
        memberCount: 2,
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.removeMemberFromTeam('team1', 'user2');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.memberIds, isNot(contains('user2')));
      expect(updatedTeam.memberCount, 1);
    });

    test('should add task to team', () async {
      final team = Team(id: 'team1', name: 'Team 1', taskIds: ['task1']);

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.addTaskToTeam('team1', 'task2');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.taskIds, contains('task2'));
    });

    test('should remove task from team', () async {
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        taskIds: ['task1', 'task2'],
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.removeTaskFromTeam('team1', 'task2');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.taskIds, isNot(contains('task2')));
    });

    test('should add task status to team', () async {
      final team = Team(id: 'team1', name: 'Team 1');
      final newStatus = TaskStatus(
        id: 'custom1',
        name: 'Review',
        color: Colors.orange,
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.addTaskStatus('team1', newStatus);

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.taskStatuses.any((s) => s.id == 'custom1'), true);
    });

    test('should update task status', () async {
      final customStatus = TaskStatus(
        id: 'custom1',
        name: 'Review',
        color: Colors.orange,
      );
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        customTaskStatuses: [customStatus],
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();

      final updatedStatus = customStatus.copyWith(name: 'In Review');
      await teamState.updateTaskStatus('team1', 'custom1', updatedStatus);

      final updatedTeam = teamState.getTeamById('team1');
      final status = updatedTeam!.taskStatuses.firstWhere(
        (s) => s.id == 'custom1',
      );
      expect(status.name, 'In Review');
    });

    test('should delete non-default task status', () async {
      final customStatus = TaskStatus(
        id: 'custom1',
        name: 'Review',
        color: Colors.orange,
        isDefault: false,
      );
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        customTaskStatuses: [customStatus],
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.deleteTaskStatus('team1', 'custom1');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.taskStatuses.any((s) => s.id == 'custom1'), false);
    });

    test('should not delete default task status', () async {
      final defaultStatus = TaskStatus(
        id: 'todo',
        name: 'To Do',
        color: Colors.grey,
        isDefault: true,
      );
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        customTaskStatuses: [defaultStatus],
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.deleteTaskStatus('team1', 'todo');

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.taskStatuses.any((s) => s.id == 'todo'), true);
    });

    test('should reorder task statuses', () async {
      final status1 = TaskStatus(
        id: 's1',
        name: 'Status 1',
        color: Colors.blue,
      );
      final status2 = TaskStatus(
        id: 's2',
        name: 'Status 2',
        color: Colors.green,
      );
      final team = Team(
        id: 'team1',
        name: 'Team 1',
        customTaskStatuses: [status1, status2],
      );

      when(mockService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.reorderTaskStatuses('team1', [status2, status1]);

      final updatedTeam = teamState.getTeamById('team1');
      expect(updatedTeam!.taskStatuses[0].id, 's2');
      expect(updatedTeam.taskStatuses[1].id, 's1');
    });
  });
}
