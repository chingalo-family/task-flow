import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:task_flow/core/entities/task_entity.dart';
import 'package:task_flow/core/models/models.dart';

class TaskEntityMapper {
  static TaskEntity toEntity(Task task, {int objectBoxId = 0}) {
    String? assignedUserIdsJson;
    if (task.assignedUserIds != null && task.assignedUserIds!.isNotEmpty) {
      try {
        assignedUserIdsJson = jsonEncode(task.assignedUserIds);
      } catch (e) {
        debugPrint('Error encoding assignedUserIds: $e');
        assignedUserIdsJson = null;
      }
    }

    String? tagsJson;
    if (task.tags != null && task.tags!.isNotEmpty) {
      try {
        tagsJson = jsonEncode(task.tags);
      } catch (e) {
        debugPrint('Error encoding tags: $e');
        tagsJson = null;
      }
    }

    String? attachmentsJson;
    if (task.attachments != null && task.attachments!.isNotEmpty) {
      try {
        attachmentsJson = jsonEncode(task.attachments);
      } catch (e) {
        debugPrint('Error encoding attachments: $e');
        attachmentsJson = null;
      }
    }

    String? subtasksJson;
    if (task.subtasks != null && task.subtasks!.isNotEmpty) {
      try {
        subtasksJson = jsonEncode(
          task.subtasks!
              .map(
                (s) => {
                  'id': s.id,
                  'title': s.title,
                  'isCompleted': s.isCompleted,
                },
              )
              .toList(),
        );
      } catch (e) {
        debugPrint('Error encoding subtasks: $e');
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
      userId: task.userId,
      userName: task.userName,
      isSynced: false,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  static Task fromEntity(TaskEntity entity) {
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
        debugPrint('Error decoding assignedUserIds: $e');
        assignedUserIds = null;
      }
    }

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
        debugPrint('Error decoding tags: $e');
        tags = null;
      }
    }

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
        debugPrint('Error decoding attachments: $e');
        attachments = null;
      }
    }

    List<Subtask>? subtasks;
    if (entity.subtasksJson != null &&
        entity.subtasksJson!.isNotEmpty &&
        entity.subtasksJson != '[]') {
      try {
        final List<dynamic> subtasksData = jsonDecode(entity.subtasksJson!);
        subtasks = subtasksData
            .map(
              (subtask) => Subtask(
                id: subtask['id'] ?? '',
                title: subtask['title'] ?? '',
                isCompleted: subtask['isCompleted'] ?? false,
              ),
            )
            .toList();
      } catch (e) {
        debugPrint('Error decoding subtasks: $e');
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
      userId: entity.userId,
      userName: entity.userName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
