import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/core/models/models.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late TeamState teamState;
  late MockTeamService mockTeamService;

  setUp(() {
    mockTeamService = MockTeamService();
    teamState = TeamState(service: mockTeamService);
  });

  final testTeam = Team(
    id: '1',
    name: 'Test Team',
    description: 'Description',
    memberIds: ['user1'],
    taskIds: ['task1'],
  );

  group('TeamState Tests', () {
    test('initial state is correct', () {
      expect(teamState.teams, isEmpty);
      expect(teamState.loading, false);
    });

    test('initialize loads teams', () async {
      when(mockTeamService.getAllTeams()).thenAnswer((_) async => [testTeam]);

      await teamState.initialize();

      verify(mockTeamService.getAllTeams()).called(1);
      expect(teamState.teams, contains(testTeam));
    });

    test('addTeam adds team on success', () async {
      when(mockTeamService.getAllTeams()).thenAnswer((_) async => []);
      await teamState.initialize();

      when(mockTeamService.createTeam(any)).thenAnswer((_) async => testTeam);

      await teamState.addTeam(testTeam);

      verify(mockTeamService.createTeam(testTeam)).called(1);
      expect(teamState.teams, contains(testTeam));
    });

    test('addMemberToTeam updates team', () async {
      final team = testTeam.copyWith(memberIds: []);
      when(mockTeamService.getAllTeams()).thenAnswer((_) async => [team]);
      when(mockTeamService.updateTeam(any)).thenAnswer((_) async => true);

      await teamState.initialize();
      await teamState.addMemberToTeam('1', 'newMember');

      verify(mockTeamService.updateTeam(any)).called(1);
      expect(teamState.teams.first.memberIds, contains('newMember'));
    });
  });
}
