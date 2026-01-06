import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/models/team.dart';
import 'package:task_flow/modules/teams/teams_page.dart';

import '../../helpers/test_helper.mocks.dart';

class MockUserListState extends Mock implements UserListState {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> reSyncUserList() async {}
}

void main() {
  late MockTeamService mockTeamService;
  late TeamState teamState;
  late MockUserListState mockUserListState;

  setUp(() {
    mockTeamService = MockTeamService();
    mockUserListState = MockUserListState();

    when(mockTeamService.getAllTeams()).thenAnswer((_) async => []);

    teamState = TeamState(service: mockTeamService);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TeamState>.value(value: teamState),
        ChangeNotifierProvider<UserListState>.value(value: mockUserListState),
      ],
      child: const MaterialApp(home: TeamsPage()),
    );
  }

  group('TeamsPage Tests', () {
    testWidgets('shows empty state when no teams', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No teams yet'), findsOneWidget);
    });

    testWidgets('shows teams when available', (WidgetTester tester) async {
      final team1 = Team(
        id: 't1',
        name: 'Alpha Team',
        description: 'The A Team',
        createdAt: DateTime.now(),
        createdByUserId: 'u1',
        memberIds: [],
      );

      when(mockTeamService.getAllTeams()).thenAnswer((_) async => [team1]);

      // Need fresh state or ensure init calls service
      // TasksPage calls init in postFrameCallback.
      // So if we mock service return BEFORE pump, it should load.
      // Wait: we instantiated `teamState` in setUp. It hasn't loaded yet.
      // `TeamsPage.initState` calls `teamState.initialize()`.

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Alpha Team'), findsOneWidget);
    });
  });
}
