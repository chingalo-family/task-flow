import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:task_flow/core/entities/team_entity.dart';
import 'package:task_flow/core/models/models.dart';

/// Utility class to convert between Team model and TeamEntity
class TeamEntityMapper {
  /// Convert Team model to TeamEntity for ObjectBox storage
  static TeamEntity toEntity(Team team, {int objectBoxId = 0}) {
    // Encode memberIds as JSON
    String? memberIdsJson;
    if (team.memberIds != null && team.memberIds!.isNotEmpty) {
      try {
        memberIdsJson = jsonEncode(team.memberIds);
      } catch (e) {
        debugPrint('Error encoding memberIds: $e');
        memberIdsJson = null;
      }
    }

    // Encode taskIds as JSON
    String? taskIdsJson;
    if (team.taskIds != null && team.taskIds!.isNotEmpty) {
      try {
        taskIdsJson = jsonEncode(team.taskIds);
      } catch (e) {
        debugPrint('Error encoding taskIds: $e');
        taskIdsJson = null;
      }
    }

    // Encode customTaskStatuses as JSON
    String? customTaskStatusesJson;
    if (team.customTaskStatuses != null && team.customTaskStatuses!.isNotEmpty) {
      try {
        customTaskStatusesJson = jsonEncode(
          team.customTaskStatuses!
              .map((s) => {
                    'id': s.id,
                    'name': s.name,
                    'color': s.color,
                    'order': s.order,
                    'isDefault': s.isDefault,
                  })
              .toList(),
        );
      } catch (e) {
        debugPrint('Error encoding customTaskStatuses: $e');
        customTaskStatusesJson = null;
      }
    }

    return TeamEntity(
      id: objectBoxId,
      teamId: team.id,
      name: team.name,
      description: team.description,
      avatarUrl: team.avatarUrl,
      memberCount: team.memberCount,
      createdByUserId: team.createdByUserId,
      createdByUsername: team.createdByUsername,
      createdAt: team.createdAt,
      updatedAt: team.updatedAt,
      isSynced: false,
      memberIdsJson: memberIdsJson,
      taskIdsJson: taskIdsJson,
      customTaskStatusesJson: customTaskStatusesJson,
      teamIcon: team.teamIcon,
      teamColor: team.teamColor,
    );
  }

  /// Convert TeamEntity to Team model
  static Team fromEntity(TeamEntity entity) {
    // Decode memberIds from JSON
    List<String>? memberIds;
    if (entity.memberIdsJson != null && entity.memberIdsJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(entity.memberIdsJson!);
        memberIds = List<String>.from(decoded);
      } catch (e) {
        debugPrint('Error decoding memberIds: $e');
        memberIds = null;
      }
    }

    // Decode taskIds from JSON
    List<String>? taskIds;
    if (entity.taskIdsJson != null && entity.taskIdsJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(entity.taskIdsJson!);
        taskIds = List<String>.from(decoded);
      } catch (e) {
        debugPrint('Error decoding taskIds: $e');
        taskIds = null;
      }
    }

    // Decode customTaskStatuses from JSON
    List<TaskStatus>? customTaskStatuses;
    if (entity.customTaskStatusesJson != null &&
        entity.customTaskStatusesJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(entity.customTaskStatusesJson!) as List;
        customTaskStatuses = decoded
            .map((s) => TaskStatus(
                  id: s['id'] ?? '',
                  name: s['name'] ?? '',
                  color: s['color'] ?? '',
                  order: s['order'] ?? 0,
                  isDefault: s['isDefault'] ?? false,
                ))
            .toList();
      } catch (e) {
        debugPrint('Error decoding customTaskStatuses: $e');
        customTaskStatuses = null;
      }
    }

    return Team(
      id: entity.teamId,
      name: entity.name,
      description: entity.description,
      avatarUrl: entity.avatarUrl,
      memberCount: entity.memberCount,
      memberIds: memberIds,
      taskIds: taskIds,
      customTaskStatuses: customTaskStatuses,
      createdByUserId: entity.createdByUserId,
      createdByUsername: entity.createdByUsername,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      teamIcon: entity.teamIcon,
      teamColor: entity.teamColor,
    );
  }
}
