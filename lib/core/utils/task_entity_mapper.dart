import 'dart:convert';
import 'package:task_flow/core/entities/task_entity.dart';
import 'package:task_flow/core/models/models.dart';

/// Utility class to convert between Task model and TaskEntity
class TaskEntityMapper {
  /// Convert Task model to TaskEntity for ObjectBox storage
  static TaskEntity toEntity(Task task, {int objectBoxId = 0}) {
    return TaskEntity(
      id: objectBoxId,
      taskId: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      category: task.category,
      assignedToUserId: task.assignedToUserId,
      assignedToUsername: task.assignedToUsername,
      assignedUserIdsJson: task.assignedUserIds != null
          ? jsonEncode(task.assignedUserIds)
          : null,
      teamId: task.teamId,
      teamName: task.teamName,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      projectId: task.projectId,
      projectName: task.projectName,
      tagsJson: task.tags != null ? jsonEncode(task.tags) : null,
      attachmentsJson:
          task.attachments != null ? jsonEncode(task.attachments) : null,
      subtasksJson: task.subtasks != null
          ? jsonEncode(task.subtasks!
              .map((s) => {
                    'id': s.id,
                    'title': s.title,
                    'isCompleted': s.isCompleted,
                  })
              .toList())
          : null,
      remindMe: task.remindMe,
      progress: task.progress,
      isSynced: false,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  /// Convert TaskEntity from ObjectBox to Task model
  static Task fromEntity(TaskEntity entity) {
    List<Subtask>? subtasks;
    if (entity.subtasksJson != null && entity.subtasksJson!.isNotEmpty) {
      try {
        final List<dynamic> subtasksData = jsonDecode(entity.subtasksJson!);
        subtasks = subtasksData
            .map((s) => Subtask(
                  id: s['id'],
                  title: s['title'],
                  isCompleted: s['isCompleted'] ?? false,
                ))
            .toList();
      } catch (e) {
        subtasks = [];
      }
    }

    return Task(
      id: entity.taskId,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      priority: entity.priority,
      category: entity.category,
      assignedToUserId: entity.assignedToUserId,
      assignedToUsername: entity.assignedToUsername,
      assignedUserIds: entity.assignedUserIdsJson != null
          ? List<String>.from(jsonDecode(entity.assignedUserIdsJson!))
          : null,
      teamId: entity.teamId,
      teamName: entity.teamName,
      dueDate: entity.dueDate,
      completedAt: entity.completedAt,
      projectId: entity.projectId,
      projectName: entity.projectName,
      tags: entity.tagsJson != null
          ? List<String>.from(jsonDecode(entity.tagsJson!))
          : null,
      attachments: entity.attachmentsJson != null
          ? List<String>.from(jsonDecode(entity.attachmentsJson!))
          : null,
      subtasks: subtasks,
      remindMe: entity.remindMe,
      progress: entity.progress,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
