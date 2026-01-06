import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import '../helpers/test_helper.mocks.dart';

void main() {
  late TaskState taskState;
  late MockTaskService mockTaskService;

  setUp(() {
    mockTaskService = MockTaskService();
    taskState = TaskState(service: mockTaskService);
  });

  final testTask = Task(
    id: '1',
    title: 'Test Task',
    status: TaskConstants.statusPending,
    priority: TaskConstants.priorityMedium,
    dueDate: DateTime.now().add(const Duration(days: 1)),
  );

  group('TaskState Tests', () {
    test('initial state is correct', () {
      expect(taskState.tasks, isEmpty);
      expect(taskState.loading, false);
      expect(taskState.filterStatus, TaskConstants.defaultFilterStatus);
    });

    test('initialize loads tasks', () async {
      when(mockTaskService.getAllTasks()).thenAnswer((_) async => [testTask]);

      expect(taskState.loading, false); // initially
      final future = taskState.initialize();
      // Should ideally check loading is true during future, but sync here somewhat
      // In tests, notifyListeners logic might be fast.
      await future;

      verify(mockTaskService.getAllTasks()).called(1);
      expect(taskState.tasks.length, 1);
      expect(taskState.tasks.first, testTask);
      expect(taskState.loading, false);
    });

    test('initialize handles error', () async {
      when(mockTaskService.getAllTasks()).thenThrow('Error');

      await taskState.initialize();

      expect(taskState.tasks, isEmpty);
      expect(taskState.loading, false);
    });

    test('addTask adds to list on success', () async {
      when(mockTaskService.getAllTasks()).thenAnswer((_) async => []);
      await taskState.initialize(); // clear list

      when(mockTaskService.createTask(any)).thenAnswer((_) async => testTask);

      await taskState.addTask(testTask);

      verify(mockTaskService.createTask(testTask)).called(1);
      expect(taskState.tasks, contains(testTask));
    });

    test('updateTask updates list on success', () async {
      when(mockTaskService.getAllTasks()).thenAnswer((_) async => [testTask]);
      await taskState.initialize();

      final updatedTask = testTask.copyWith(title: 'Updated Title');
      when(mockTaskService.updateTask(any)).thenAnswer((_) async => true);

      await taskState.updateTask(updatedTask);

      verify(mockTaskService.updateTask(updatedTask)).called(1);
      expect(taskState.tasks.first.title, 'Updated Title');
    });

    test('deleteTask removes from list on success', () async {
      when(mockTaskService.getAllTasks()).thenAnswer((_) async => [testTask]);
      await taskState.initialize();

      when(mockTaskService.deleteTask('1')).thenAnswer((_) async => true);

      await taskState.deleteTask('1');

      verify(mockTaskService.deleteTask('1')).called(1);
      expect(taskState.tasks, isEmpty);
    });

    test('filtering works', () async {
      final task1 = Task(
        id: '1',
        title: 'T1',
        status: TaskConstants.statusPending,
      );
      final task2 = Task(
        id: '2',
        title: 'T2',
        status: TaskConstants.statusCompleted,
      );

      when(
        mockTaskService.getAllTasks(),
      ).thenAnswer((_) async => [task1, task2]);
      await taskState.initialize();

      expect(taskState.tasks.length, 2);

      taskState.setFilterStatus(TaskConstants.statusCompleted);
      expect(taskState.tasks.length, 1);
      expect(taskState.tasks.first.id, '2');

      taskState.setFilterStatus(TaskConstants.statusAll);
      expect(taskState.tasks.length, 2);
    });

    group('User-specific task methods', () {
      final userId = 'user123';
      final otherUserId = 'user456';

      final userTask1 = Task(
        id: '1',
        title: 'User Task 1',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityHigh,
        assignedUserIds: [userId],
        dueDate: DateTime.now().add(const Duration(hours: 2)), // Due today
      );

      final userTask2 = Task(
        id: '2',
        title: 'User Task 2',
        status: TaskConstants.statusInProgress,
        priority: TaskConstants.priorityMedium,
        assignedUserIds: [userId],
        dueDate: DateTime.now().add(const Duration(days: 2)), // Upcoming
      );

      final userTask3 = Task(
        id: '3',
        title: 'User Task 3',
        status: TaskConstants.statusCompleted,
        priority: TaskConstants.priorityLow,
        assignedUserIds: [userId],
        dueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue (but completed)
      );

      final overdueTask = Task(
        id: '4',
        title: 'Overdue Task',
        status: TaskConstants.statusPending,
        priority: TaskConstants.priorityHigh,
        assignedUserIds: [userId],
        dueDate: DateTime.now().subtract(const Duration(days: 2)), // Overdue
      );

      final otherUserTask = Task(
        id: '5',
        title: 'Other User Task',
        status: TaskConstants.statusPending,
        assignedUserIds: [otherUserId],
      );

      setUp(() async {
        when(mockTaskService.getAllTasks()).thenAnswer(
          (_) async => [userTask1, userTask2, userTask3, overdueTask, otherUserTask],
        );
        await taskState.initialize();
      });

      test('getMyTasks returns only user assigned tasks', () {
        final myTasks = taskState.getMyTasks(userId);
        expect(myTasks.length, 4);
        expect(myTasks.every((t) => t.assignedUserIds?.contains(userId) ?? false), true);
      });

      test('getMyTotalTasksCount returns correct count', () {
        final count = taskState.getMyTotalTasksCount(userId);
        expect(count, 4);
      });

      test('getMyCompletedTasksCount returns correct count', () {
        final count = taskState.getMyCompletedTasksCount(userId);
        expect(count, 1); // Only userTask3 is completed
      });

      test('getMyPendingTasksCount returns correct count', () {
        final count = taskState.getMyPendingTasksCount(userId);
        expect(count, 2); // userTask1 and overdueTask are pending
      });

      test('getMyInProgressTasksCount returns correct count', () {
        final count = taskState.getMyInProgressTasksCount(userId);
        expect(count, 1); // Only userTask2 is in progress
      });

      test('getMyCompletionProgress calculates correctly', () {
        final progress = taskState.getMyCompletionProgress(userId);
        expect(progress, 0.25); // 1 completed out of 4 total
      });

      test('getMyOverdueTasks returns only overdue uncompleted tasks', () {
        final overdue = taskState.getMyOverdueTasks(userId);
        expect(overdue.length, 1);
        expect(overdue.first.id, '4'); // Only overdueTask (userTask3 is completed)
      });

      test('getMyTasksDueToday returns tasks due today', () {
        final dueToday = taskState.getMyTasksDueToday(userId);
        expect(dueToday.length, 1);
        expect(dueToday.first.id, '1'); // Only userTask1 is due today
      });

      test('getMyUpcomingTasks returns tasks due after today', () {
        final upcoming = taskState.getMyUpcomingTasks(userId);
        expect(upcoming.length, 1);
        expect(upcoming.first.id, '2'); // Only userTask2 is upcoming
      });

      test('getMyFocusTasks returns uncompleted tasks sorted by priority', () {
        final focus = taskState.getMyFocusTasks(userId);
        expect(focus.length, 3); // All except completed task
        expect(focus.first.priority, TaskConstants.priorityHigh);
        expect(focus.last.priority, TaskConstants.priorityMedium);
      });

      test('getMyFocusTasks excludes completed tasks', () {
        final focus = taskState.getMyFocusTasks(userId);
        expect(focus.every((t) => !t.isCompleted), true);
      });
    });
  });
}
