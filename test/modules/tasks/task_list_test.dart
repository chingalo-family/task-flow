import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/modules/tasks/tasks_page.dart';

import '../../helpers/test_helper.mocks.dart';

// Mock UserListState since we haven't mocked it elsewhere yet
class MockUserListState extends Mock implements UserListState {
  @override
  Future<void> initialize() async {}
}

void main() {
  late MockTaskService mockTaskService;
  late MockTeamService mockTeamService;
  late MockUserService mockUserService;

  // Real states with Mock services pattern
  late TaskState taskState;
  late TeamState teamState;
  late UserState userState;
  late MockUserListState mockUserListState;

  setUp(() {
    mockTaskService = MockTaskService();
    mockTeamService = MockTeamService();
    mockUserService = MockUserService();
    mockUserListState = MockUserListState();

    when(mockTaskService.getAllTasks()).thenAnswer((_) async => []);
    when(mockTeamService.getAllTeams()).thenAnswer((_) async => []);

    // User setup
    final user = User(id: '1', username: 'test_user', fullName: 'Test User');
    when(mockUserService.getCurrentUser()).thenAnswer((_) async => user);

    taskState = TaskState(service: mockTaskService);
    teamState = TeamState(service: mockTeamService);
    userState = UserState(service: mockUserService);
    // UserState needs to load user to have currentUser
    // Actually we can just manually set it if setter exposed, looking at UserState it's usually via login
    // Or we can stub currentUser property if we used MockUserState.
    // Since we use Real UserState, let's just make it return user via init check or similar.
    // UserState loadCurrentUser calls service.
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskState>.value(value: taskState),
        ChangeNotifierProvider<TeamState>.value(value: teamState),
        ChangeNotifierProvider<UserState>.value(value: userState),
        ChangeNotifierProvider<UserListState>.value(value: mockUserListState),
      ],
      child: const MaterialApp(home: TasksPage()),
    );
  }

  testWidgets('TasksPage shows empty state when no tasks', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('No tasks found'), findsOneWidget);
    expect(find.byIcon(Icons.task_alt), findsOneWidget); // Empty state icon
  });

  testWidgets('TasksPage shows tasks appropriately', (
    WidgetTester tester,
  ) async {
    final task1 = Task(
      id: '1',
      title: 'Task 1',
      description: 'Desc 1',
      status: 'pending',
      // creatorId removed as it doesn't exist on Task model
      createdAt: DateTime.now(),
      dueDate: DateTime.now(), // Due today
    );

    when(mockTaskService.getAllTasks()).thenAnswer((_) async => [task1]);

    // Create new TaskState to trigger load or refresh
    // But easier: call initialize inside pump
    // But createWidgetUnderTest uses 'taskState' variable.
    // We can just rely on auto-init in TasksPage which calls initialize.

    // Re-run setup logic essentially but we need valid Tasks return before initState happens.
    // So we need to re-instantiate taskState or ensure when was called before.
  });
}
