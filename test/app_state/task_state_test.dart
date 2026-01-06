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
  });
}
