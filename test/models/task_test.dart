import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/task.dart';
import 'package:task_flow/core/constants/task_constants.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation with required fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.status, TaskConstants.statusPending);
      expect(task.priority, TaskConstants.priorityMedium);
      expect(task.progress, 0);
      expect(task.subtasks, isEmpty);
    });

    test('Task creation with all fields', () {
      final now = DateTime.now();
      final dueDate = now.add(Duration(days: 7));
      final subtasks = [
        Subtask(id: 'st1', title: 'Subtask 1', isCompleted: false),
        Subtask(id: 'st2', title: 'Subtask 2', isCompleted: true),
      ];

      final task = Task(
        id: '2',
        title: 'Complete Task',
        description: 'Task description',
        status: TaskConstants.statusInProgress,
        priority: TaskConstants.priorityHigh,
        category: 'dev',
        assignedToUserId: 'user1',
        assignedToUsername: 'testuser',
        assignedUserIds: ['user1', 'user2'],
        teamId: 'team1',
        teamName: 'Test Team',
        dueDate: dueDate,
        projectId: 'proj1',
        projectName: 'Test Project',
        tags: ['urgent', 'bug'],
        attachments: ['file1.pdf'],
        subtasks: subtasks,
        remindMe: true,
        progress: 50,
        createdAt: now,
        updatedAt: now,
      );

      expect(task.id, '2');
      expect(task.title, 'Complete Task');
      expect(task.description, 'Task description');
      expect(task.status, TaskConstants.statusInProgress);
      expect(task.priority, TaskConstants.priorityHigh);
      expect(task.category, 'dev');
      expect(task.assignedToUserId, 'user1');
      expect(task.assignedToUsername, 'testuser');
      expect(task.assignedUserIds, ['user1', 'user2']);
      expect(task.teamId, 'team1');
      expect(task.teamName, 'Test Team');
      expect(task.dueDate, dueDate);
      expect(task.projectId, 'proj1');
      expect(task.projectName, 'Test Project');
      expect(task.tags, ['urgent', 'bug']);
      expect(task.attachments, ['file1.pdf']);
      expect(task.subtasks, subtasks);
      expect(task.remindMe, true);
      expect(task.progress, 50);
    });

    test('Task copyWith creates new instance with updated fields', () {
      final task = Task(id: '1', title: 'Original');
      final updatedTask = task.copyWith(
        title: 'Updated',
        status: TaskConstants.statusCompleted,
      );

      expect(task.title, 'Original');
      expect(task.status, TaskConstants.statusPending);
      expect(updatedTask.title, 'Updated');
      expect(updatedTask.status, TaskConstants.statusCompleted);
      expect(updatedTask.id, task.id);
    });

    test('Task status getters work correctly', () {
      final pendingTask = Task(id: '1', title: 'Pending', status: TaskConstants.statusPending);
      final inProgressTask = Task(id: '2', title: 'In Progress', status: TaskConstants.statusInProgress);
      final completedTask = Task(id: '3', title: 'Completed', status: TaskConstants.statusCompleted);

      expect(pendingTask.isPending, true);
      expect(pendingTask.isInProgress, false);
      expect(pendingTask.isCompleted, false);

      expect(inProgressTask.isPending, false);
      expect(inProgressTask.isInProgress, true);
      expect(inProgressTask.isCompleted, false);

      expect(completedTask.isPending, false);
      expect(completedTask.isInProgress, false);
      expect(completedTask.isCompleted, true);
    });

    test('Task priority getters work correctly', () {
      final lowTask = Task(id: '1', title: 'Low', priority: TaskConstants.priorityLow);
      final mediumTask = Task(id: '2', title: 'Medium', priority: TaskConstants.priorityMedium);
      final highTask = Task(id: '3', title: 'High', priority: TaskConstants.priorityHigh);

      expect(lowTask.isLowPriority, true);
      expect(lowTask.isMediumPriority, false);
      expect(lowTask.isHighPriority, false);

      expect(mediumTask.isLowPriority, false);
      expect(mediumTask.isMediumPriority, true);
      expect(mediumTask.isHighPriority, false);

      expect(highTask.isLowPriority, false);
      expect(highTask.isMediumPriority, false);
      expect(highTask.isHighPriority, true);
    });

    test('Task isOverdue returns correct value', () {
      final now = DateTime.now();
      final pastDate = now.subtract(Duration(days: 1));
      final futureDate = now.add(Duration(days: 1));

      final overdueTask = Task(id: '1', title: 'Overdue', dueDate: pastDate);
      final notOverdueTask = Task(id: '2', title: 'Not Overdue', dueDate: futureDate);
      final noDueDateTask = Task(id: '3', title: 'No Due Date');
      final completedOverdueTask = Task(
        id: '4',
        title: 'Completed Overdue',
        dueDate: pastDate,
        status: TaskConstants.statusCompleted,
      );

      expect(overdueTask.isOverdue, true);
      expect(notOverdueTask.isOverdue, false);
      expect(noDueDateTask.isOverdue, false);
      expect(completedOverdueTask.isOverdue, false);
    });

    test('Subtasks count and progress calculation', () {
      final subtasks = [
        Subtask(id: 'st1', title: 'Subtask 1', isCompleted: true),
        Subtask(id: 'st2', title: 'Subtask 2', isCompleted: true),
        Subtask(id: 'st3', title: 'Subtask 3', isCompleted: false),
        Subtask(id: 'st4', title: 'Subtask 4', isCompleted: false),
      ];

      final task = Task(id: '1', title: 'Task with Subtasks', subtasks: subtasks);

      expect(task.subtasksTotal, 4);
      expect(task.subtasksCompleted, 2);
      expect(task.subtasksProgress, 0.5);
    });

    test('Subtasks progress with no subtasks', () {
      final task = Task(id: '1', title: 'No Subtasks');

      expect(task.subtasksTotal, 0);
      expect(task.subtasksCompleted, 0);
      expect(task.subtasksProgress, 0.0);
    });

    test('Subtasks progress with all completed', () {
      final subtasks = [
        Subtask(id: 'st1', title: 'Subtask 1', isCompleted: true),
        Subtask(id: 'st2', title: 'Subtask 2', isCompleted: true),
      ];

      final task = Task(id: '1', title: 'All Completed', subtasks: subtasks);

      expect(task.subtasksProgress, 1.0);
    });
  });

  group('Subtask Model Tests', () {
    test('Subtask creation', () {
      final subtask = Subtask(id: 'st1', title: 'Test Subtask');

      expect(subtask.id, 'st1');
      expect(subtask.title, 'Test Subtask');
      expect(subtask.isCompleted, false);
    });

    test('Subtask copyWith', () {
      final subtask = Subtask(id: 'st1', title: 'Original', isCompleted: false);
      final updated = subtask.copyWith(isCompleted: true);

      expect(subtask.isCompleted, false);
      expect(updated.isCompleted, true);
      expect(updated.id, 'st1');
      expect(updated.title, 'Original');
    });
  });
}
