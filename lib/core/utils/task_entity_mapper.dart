import 'dart:convert';
import 'package:task_flow/core/entities/task_entity.dart';
import 'package:task_flow/core/models/models.dart';

/// Utility class to convert between Task model and TaskEntity
class TaskEntityMapper {
  /// Convert Task model to TaskEntity for ObjectBox storage
  static TaskEntity toEntity(Task task, {int objectBoxId = 0}) {
    // Properly encode assignedUserIds - handle both null and empty list
    String? assignedUserIdsJson;
    if (task.assignedUserIds != null && task.assignedUserIds!.isNotEmpty) {
      try {
        assignedUserIdsJson = jsonEncode(task.assignedUserIds);
      } catch (e) {
        print('Error encoding assignedUserIds: $e');
        assignedUserIdsJson = null;
      }
    }

    // Properly encode tags
    String? tagsJson;
    if (task.tags != null && task.tags!.isNotEmpty) {
      try {
        tagsJson = jsonEncode(task.tags);
      } catch (e) {
        print('Error encoding tags: $e');
        tagsJson = null;
      }
    }

    // Properly encode attachments
    String? attachmentsJson;
    if (task.attachments != null && task.attachments!.isNotEmpty) {
      try {
        attachmentsJson = jsonEncode(task.attachments);
      } catch (e) {
        print('Error encoding attachments: $e');
        attachmentsJson = null;
      }
    }

    // Properly encode subtasks
    String? subtasksJson;
    if (task.subtasks != null && task.subtasks!.isNotEmpty) {
      try {
        subtasksJson = jsonEncode(task.subtasks!
            .map((s) => {
                  'id': s.id,
                  'title': s.title,
                  'isCompleted': s.isCompleted,
                })
            .toList());
      } catch (e) {
        print('Error encoding subtasks: $e');
        subtasksJson = null;
      }
    }

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
      assignedUserIdsJson: assignedUserIdsJson,
      teamId: task.teamId,
      teamName: task.teamName,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      projectId: task.projectId,
      projectName: task.projectName,
      tagsJson: tagsJson,
      attachmentsJson: attachmentsJson,
      subtasksJson: subtasksJson,
      remindMe: task.remindMe,
      progress: task.progress,
      isSynced: false,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  /// Convert TaskEntity from ObjectBox to Task model
  static Task fromEntity(TaskEntity entity) {
    // Decode assignedUserIds with proper error handling
    List<String>? assignedUserIds;
    if (entity.assignedUserIdsJson != null &&
        entity.assignedUserIdsJson!.isNotEmpty &&
        entity.assignedUserIdsJson != '[]') {
      try {
        final decoded = jsonDecode(entity.assignedUserIdsJson!);
        if (decoded is List) {
          assignedUserIds = List<String>.from(decoded);
        }
      } catch (e) {
        print('Error decoding assignedUserIds: $e');
        assignedUserIds = null;
      }
    }

    // Decode tags with proper error handling
    List<String>? tags;
    if (entity.tagsJson != null &&
        entity.tagsJson!.isNotEmpty &&
        entity.tagsJson != '[]') {
      try {
        final decoded = jsonDecode(entity.tagsJson!);
        if (decoded is List) {
          tags = List<String>.from(decoded);
        }
      } catch (e) {
        print('Error decoding tags: $e');
        tags = null;
      }
    }

    // Decode attachments with proper error handling
    List<String>? attachments;
    if (entity.attachmentsJson != null &&
        entity.attachmentsJson!.isNotEmpty &&
        entity.attachmentsJson != '[]') {
      try {
        final decoded = jsonDecode(entity.attachmentsJson!);
        if (decoded is List) {
          attachments = List<String>.from(decoded);
        }
      } catch (e) {
        print('Error decoding attachments: $e');
        attachments = null;
      }
    }

    // Decode subtasks with proper error handling
    List<Subtask>? subtasks;
    if (entity.subtasksJson != null &&
        entity.subtasksJson!.isNotEmpty &&
        entity.subtasksJson != '[]') {
      try {
        final List<dynamic> subtasksData = jsonDecode(entity.subtasksJson!);
        subtasks = subtasksData
            .map((s) => Subtask(
                  id: s['id'] ?? '',
                  title: s['title'] ?? '',
                  isCompleted: s['isCompleted'] ?? false,
                ))
            .toList();
      } catch (e) {
        print('Error decoding subtasks: $e');
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
      assignedUserIds: assignedUserIds,
      teamId: entity.teamId,
      teamName: entity.teamName,
      dueDate: entity.dueDate,
      completedAt: entity.completedAt,
      projectId: entity.projectId,
      projectName: entity.projectName,
      tags: tags,
      attachments: attachments,
      subtasks: subtasks,
      remindMe: entity.remindMe,
      progress: entity.progress,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
