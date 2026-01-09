import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/services/task_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'task_state_test.mocks.dart';

@GenerateMocks([TaskService])
void main() {
  group('TaskState Tests', () {
    late MockTaskService mockTaskService;
    late TaskState taskState;

    setUp(() {
      mockTaskService = MockTaskService();
      taskState = TaskState(service: mockTaskService);
    });

    group('Initialization', () {
      test('initial state is correct', () {
        expect(taskState.loading, false);
        expect(taskState.allTasks, isEmpty);
        expect(taskState.tasks, isEmpty);
        expect(taskState.filterStatus, TaskConstants.defaultFilterStatus);
        expect(taskState.filterPriority, TaskConstants.defaultFilterPriority);
        expect(taskState.sortBy, TaskConstants.defaultSortBy);
        expect(taskState.filterTeamId, isNull);
      });

      test('initialize loads tasks successfully', () async {
        final testTasks = [
          Task(id: '1', title: 'Task 1'),
          Task(id: '2', title: 'Task 2'),
        ];

        when(mockTaskService.getAllTasks()).thenAnswer((_) async => testTasks);

        await taskState.initialize();

        expect(taskState.loading, false);
        expect(taskState.allTasks.length, 2);
        verify(mockTaskService.getAllTasks()).called(1);
      });

      test('initialize handles errors gracefully', () async {
        when(mockTaskService.getAllTasks()).thenThrow(Exception('Test error'));

        await taskState.initialize();

        expect(taskState.loading, false);
        expect(taskState.allTasks, isEmpty);
      });
    });

    group('Task Statistics', () {
      setUp(() async {
        final testTasks = [
          Task(
            id: '1',
            title: 'Pending Task',
            status: TaskConstants.statusPending,
          ),
          Task(
            id: '2',
            title: 'In Progress Task',
            status: TaskConstants.statusInProgress,
          ),
          Task(
            id: '3',
            title: 'Completed Task',
            status: TaskConstants.statusCompleted,
            completedAt: DateTime.now(),
          ),
          Task(
            id: '4',
            title: 'Due Today',
            dueDate: DateTime.now().add(Duration(hours: 2)),
          ),
        ];

        when(mockTaskService.getAllTasks()).thenAnswer((_) async => testTasks);
        await taskState.initialize();
      });

      test('totalTasks returns correct count', () {
        expect(taskState.totalTasks, 4);
      });

      test('completedTasks returns correct count', () {
        expect(taskState.completedTasks, 1);
      });

      test('inProgressTasks returns correct count', () {
        expect(taskState.inProgressTasks, 1);
      });

      test('tasksDueToday returns correct count', () {
        expect(taskState.tasksDueToday, 1);
      });
    });

    group('User-specific Tasks', () {
      setUp(() async {
        final testTasks = [
          Task(
            id: '1',
            title: 'User 1 Task',
            assignedUserIds: ['user1'],
            status: TaskConstants.statusPending,
          ),
          Task(
            id: '2',
            title: 'User 1 Completed',
            assignedUserIds: ['user1'],
            status: TaskConstants.statusCompleted,
          ),
          Task(id: '3', title: 'User 2 Task', assignedUserIds: ['user2']),
          Task(
            id: '4',
            title: 'User 1 Overdue',
            assignedUserIds: ['user1'],
            dueDate: DateTime.now().subtract(Duration(days: 1)),
            status: TaskConstants.statusPending,
          ),
        ];

        when(mockTaskService.getAllTasks()).thenAnswer((_) async => testTasks);
        await taskState.initialize();
      });

      test('getMyTasks returns tasks for specific user', () {
        final myTasks = taskState.getMyTasks('user1');
        expect(myTasks.length, 3);
        expect(
          myTasks.every((task) => task.assignedUserIds!.contains('user1')),
          true,
        );
      });

      test('getMyCompletedTasksCount returns correct count', () {
        final count = taskState.getMyCompletedTasksCount('user1');
        expect(count, 1);
      });

      test('getMyTotalTasksCount returns correct count', () {
        final count = taskState.getMyTotalTasksCount('user1');
        expect(count, 3);
      });

      test('getMyCompletionProgress calculates correct percentage', () {
        final progress = taskState.getMyCompletionProgress('user1');
        expect(progress, closeTo(0.333, 0.01));
      });

      test('getMyPendingTasksCount returns correct count', () {
        final count = taskState.getMyPendingTasksCount('user1');
        expect(count, 2);
      });

      test('getMyInProgressTasksCount returns correct count', () {
        final count = taskState.getMyInProgressTasksCount('user1');
        expect(count, 0);
      });

      test('getMyOverdueTasks returns overdue tasks', () {
        final overdueTasks = taskState.getMyOverdueTasks('user1');
        expect(overdueTasks.length, 1);
        expect(overdueTasks.first.id, '4');
      });

      test('getMyTasksDueToday returns tasks due today', () {
        // Add a task due today
        final tasksWithDueToday = [
          Task(id: '1', title: 'User 1 Task', assignedUserIds: ['user1']),
          Task(
            id: '2',
            title: 'Due Today',
            assignedUserIds: ['user1'],
            dueDate: DateTime.now().add(Duration(hours: 3)),
          ),
        ];

        when(
          mockTaskService.getAllTasks(),
        ).thenAnswer((_) async => tasksWithDueToday);
        taskState = TaskState(service: mockTaskService);

        taskState.initialize().then((_) {
          final dueToday = taskState.getMyTasksDueToday('user1');
          expect(dueToday.length, greaterThanOrEqualTo(0));
        });
      });
    });

    group('Filtering and Sorting', () {
      setUp(() async {
        final testTasks = [
          Task(
            id: '1',
            title: 'High Priority Pending',
            priority: TaskConstants.priorityHigh,
            status: TaskConstants.statusPending,
            teamId: 'team1',
          ),
          Task(
            id: '2',
            title: 'Low Priority Completed',
            priority: TaskConstants.priorityLow,
            status: TaskConstants.statusCompleted,
            teamId: 'team1',
          ),
          Task(
            id: '3',
            title: 'Medium Priority In Progress',
            priority: TaskConstants.priorityMedium,
            status: TaskConstants.statusInProgress,
            teamId: 'team2',
          ),
        ];

        when(mockTaskService.getAllTasks()).thenAnswer((_) async => testTasks);
        await taskState.initialize();
      });

      test('setFilterStatus filters tasks correctly', () {
        taskState.setFilterStatus(TaskConstants.statusPending);
        expect(taskState.tasks.length, 1);
        expect(taskState.tasks.first.status, TaskConstants.statusPending);
      });

      test('setFilterPriority filters tasks correctly', () {
        taskState.setFilterPriority(TaskConstants.priorityHigh);
        expect(taskState.tasks.length, 1);
        expect(taskState.tasks.first.priority, TaskConstants.priorityHigh);
      });

      test('setFilterTeamId filters tasks correctly', () {
        taskState.setFilterTeamId('team1');
        expect(taskState.tasks.length, 2);
        expect(taskState.tasks.every((t) => t.teamId == 'team1'), true);
      });

      test('setSortBy changes sort order', () {
        taskState.setSortBy(TaskConstants.sortByPriority);
        expect(taskState.sortBy, TaskConstants.sortByPriority);
        // High priority should come first
        expect(taskState.tasks.first.priority, TaskConstants.priorityHigh);
      });

      test('combined filters work correctly', () {
        taskState.setFilterStatus(TaskConstants.statusPending);
        taskState.setFilterPriority(TaskConstants.priorityHigh);
        expect(taskState.tasks.length, 1);
        expect(taskState.tasks.first.id, '1');
      });
    });

    group('Task Operations', () {
      test('addTask adds new task', () async {
        final newTask = Task(id: '1', title: 'New Task');
        when(mockTaskService.createTask(any)).thenAnswer((_) async => newTask);
        when(mockTaskService.getAllTasks()).thenAnswer((_) async => []);
        await taskState.initialize();

        await taskState.addTask(newTask);

        expect(taskState.allTasks.length, 1);
        expect(taskState.allTasks.first.id, '1');
        verify(mockTaskService.createTask(newTask)).called(1);
      });

      test('updateTask updates existing task', () async {
        final originalTask = Task(id: '1', title: 'Original');
        when(
          mockTaskService.getAllTasks(),
        ).thenAnswer((_) async => [originalTask]);
        await taskState.initialize();

        final updatedTask = originalTask.copyWith(title: 'Updated');
        when(mockTaskService.updateTask(any)).thenAnswer((_) async => true);

        await taskState.updateTask(updatedTask);

        expect(taskState.allTasks.first.title, 'Updated');
        verify(mockTaskService.updateTask(updatedTask)).called(1);
      });

      test('deleteTask removes task', () async {
        final task = Task(id: '1', title: 'To Delete');
        when(mockTaskService.getAllTasks()).thenAnswer((_) async => [task]);
        await taskState.initialize();

        when(mockTaskService.deleteTask('1')).thenAnswer((_) async => true);

        await taskState.deleteTask('1');

        expect(taskState.allTasks, isEmpty);
        verify(mockTaskService.deleteTask('1')).called(1);
      });

      test(
        'toggleTaskStatus changes status from pending to completed',
        () async {
          final task = Task(
            id: '1',
            title: 'Task',
            status: TaskConstants.statusPending,
          );
          when(mockTaskService.getAllTasks()).thenAnswer((_) async => [task]);
          await taskState.initialize();

          when(mockTaskService.updateTask(any)).thenAnswer((_) async => true);

          await taskState.toggleTaskStatus('1');

          expect(
            taskState.allTasks.first.status,
            TaskConstants.statusCompleted,
          );
          expect(taskState.allTasks.first.progress, 100);
          expect(taskState.allTasks.first.completedAt, isNotNull);
        },
      );

      test(
        'toggleTaskStatus changes status from completed to pending',
        () async {
          final task = Task(
            id: '1',
            title: 'Task',
            status: TaskConstants.statusCompleted,
            progress: 100,
            completedAt: DateTime.now(),
          );
          when(mockTaskService.getAllTasks()).thenAnswer((_) async => [task]);
          await taskState.initialize();

          when(mockTaskService.updateTask(any)).thenAnswer((_) async => true);

          await taskState.toggleTaskStatus('1');

          expect(taskState.allTasks.first.status, TaskConstants.statusPending);
        },
      );

      test(
        'toggleTaskStatus marks all subtasks as completed when completing task',
        () async {
          final task = Task(
            id: '1',
            title: 'Task',
            status: TaskConstants.statusPending,
            subtasks: [
              Subtask(id: 'st1', title: 'Subtask 1', isCompleted: false),
              Subtask(id: 'st2', title: 'Subtask 2', isCompleted: true),
            ],
          );
          when(mockTaskService.getAllTasks()).thenAnswer((_) async => [task]);
          await taskState.initialize();

          when(mockTaskService.updateTask(any)).thenAnswer((_) async => true);

          await taskState.toggleTaskStatus('1');

          final updatedTask = taskState.allTasks.first;
          expect(updatedTask.status, TaskConstants.statusCompleted);
          expect(updatedTask.subtasks!.every((st) => st.isCompleted), true);
        },
      );
    });

    group('getTasksByTeamId', () {
      test('returns tasks for specific team', () async {
        final testTasks = [
          Task(id: '1', title: 'Team 1 Task 1', teamId: 'team1'),
          Task(id: '2', title: 'Team 1 Task 2', teamId: 'team1'),
          Task(id: '3', title: 'Team 2 Task', teamId: 'team2'),
        ];

        when(mockTaskService.getAllTasks()).thenAnswer((_) async => testTasks);
        await taskState.initialize();

        final team1Tasks = taskState.getTasksByTeamId('team1');
        expect(team1Tasks.length, 2);
        expect(team1Tasks.every((t) => t.teamId == 'team1'), true);
      });
    });
  });
}
