import 'package:flutter/foundation.dart';
import 'package:task_flow/core/models/team/team.dart';
import 'package:task_flow/core/models/task_status/task_status.dart';
import 'package:task_flow/core/offline_db/team_offline_provider/team_offline_provider.dart';

/// Service layer for team management
///
/// Handles business logic, validation, and coordinates between state and data layers.
/// Follows singleton pattern for consistent access across the application.
class TeamService {
  TeamService._();
  static final TeamService _instance = TeamService._();
  factory TeamService() => _instance;

  final _offline = TeamOfflineProvider();

  /// Create a new team
  ///
  /// Validates and saves team to database.
  /// Returns the created team or null if creation fails.
  Future<Team?> createTeam(Team team) async {
    try {
      // Validate team has required fields
      if (team.name.trim().isEmpty) {
        throw Exception('Team name cannot be empty');
      }

      // Save to database
      await _offline.addOrUpdateTeam(team);
      return team;
    } catch (e) {
      debugPrint('Error creating team: $e');
      return null;
    }
  }

  /// Get team by ID
  Future<Team?> getTeamById(String id) async {
    try {
      return await _offline.getTeamById(id);
    } catch (e) {
      debugPrint('Error getting team by ID: $e');
      return null;
    }
  }

  /// Get all teams
  Future<List<Team>> getAllTeams() async {
    try {
      return await _offline.getAllTeams();
    } catch (e) {
      debugPrint('Error getting all teams: $e');
      return [];
    }
  }

  /// Update existing team
  Future<bool> updateTeam(Team team) async {
    try {
      await _offline.addOrUpdateTeam(team);
      return true;
    } catch (e) {
      debugPrint('Error updating team: $e');
      return false;
    }
  }

  /// Delete team
  Future<bool> deleteTeam(String id) async {
    try {
      await _offline.deleteTeam(id);
      return true;
    } catch (e) {
      debugPrint('Error deleting team: $e');
      return false;
    }
  }

  /// Get teams by member
  Future<List<Team>> getTeamsByMember(String userId) async {
    try {
      return await _offline.getTeamsByMemberId(userId);
    } catch (e) {
      debugPrint('Error getting teams by member: $e');
      return [];
    }
  }

  /// Add member to team
  Future<bool> addMemberToTeam(String teamId, String userId) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final memberIds = List<String>.from(team.memberIds ?? []);
      if (!memberIds.contains(userId)) {
        memberIds.add(userId);
        final updatedTeam = team.copyWith(
          memberIds: memberIds,
          memberCount: memberIds.length,
          updatedAt: DateTime.now(),
        );
        return await updateTeam(updatedTeam);
      }
      return true;
    } catch (e) {
      debugPrint('Error adding member to team: $e');
      return false;
    }
  }

  /// Remove member from team
  Future<bool> removeMemberFromTeam(String teamId, String userId) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final memberIds = List<String>.from(team.memberIds ?? []);
      memberIds.remove(userId);
      final updatedTeam = team.copyWith(
        memberIds: memberIds,
        memberCount: memberIds.length,
        updatedAt: DateTime.now(),
      );
      return await updateTeam(updatedTeam);
    } catch (e) {
      debugPrint('Error removing member from team: $e');
      return false;
    }
  }

  /// Add task to team
  Future<bool> addTaskToTeam(String teamId, String taskId) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final taskIds = List<String>.from(team.taskIds ?? []);
      if (!taskIds.contains(taskId)) {
        taskIds.add(taskId);
        final updatedTeam = team.copyWith(
          taskIds: taskIds,
          updatedAt: DateTime.now(),
        );
        return await updateTeam(updatedTeam);
      }
      return true;
    } catch (e) {
      debugPrint('Error adding task to team: $e');
      return false;
    }
  }

  /// Remove task from team
  Future<bool> removeTaskFromTeam(String teamId, String taskId) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final taskIds = List<String>.from(team.taskIds ?? []);
      taskIds.remove(taskId);
      final updatedTeam = team.copyWith(
        taskIds: taskIds,
        updatedAt: DateTime.now(),
      );
      return await updateTeam(updatedTeam);
    } catch (e) {
      debugPrint('Error removing task from team: $e');
      return false;
    }
  }

  /// Add task status to team
  Future<bool> addTaskStatus(String teamId, TaskStatus status) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final statuses = List<TaskStatus>.from(team.taskStatuses);
      statuses.add(status);
      final updatedTeam = team.copyWith(
        customTaskStatuses: statuses,
        updatedAt: DateTime.now(),
      );
      return await updateTeam(updatedTeam);
    } catch (e) {
      debugPrint('Error adding task status: $e');
      return false;
    }
  }

  /// Update task status
  Future<bool> updateTaskStatus(
      String teamId, String statusId, TaskStatus updatedStatus) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final statuses = List<TaskStatus>.from(team.taskStatuses);
      final index = statuses.indexWhere((s) => s.id == statusId);
      if (index != -1) {
        statuses[index] = updatedStatus;
        final updatedTeam = team.copyWith(
          customTaskStatuses: statuses,
          updatedAt: DateTime.now(),
        );
        return await updateTeam(updatedTeam);
      }
      return false;
    } catch (e) {
      debugPrint('Error updating task status: $e');
      return false;
    }
  }

  /// Delete task status
  Future<bool> deleteTaskStatus(String teamId, String statusId) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final statuses = List<TaskStatus>.from(team.taskStatuses);
      // Find status to delete
      final statusToDeleteIndex = statuses.indexWhere((s) => s.id == statusId);
      if (statusToDeleteIndex == -1) return false;
      
      final statusToDelete = statuses[statusToDeleteIndex];
      if (!statusToDelete.isDefault) {
        statuses.removeAt(statusToDeleteIndex);
        final updatedTeam = team.copyWith(
          customTaskStatuses: statuses,
          updatedAt: DateTime.now(),
        );
        return await updateTeam(updatedTeam);
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting task status: $e');
      return false;
    }
  }

  /// Reorder task statuses
  Future<bool> reorderTaskStatuses(
      String teamId, List<TaskStatus> reorderedStatuses) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) return false;

      final updatedTeam = team.copyWith(
        customTaskStatuses: reorderedStatuses,
        updatedAt: DateTime.now(),
      );
      return await updateTeam(updatedTeam);
    } catch (e) {
      debugPrint('Error reordering task statuses: $e');
      return false;
    }
  }

  /// Update sync status
  Future<bool> updateSyncStatus(String teamId, bool isSynced) async {
    try {
      await _offline.updateSyncStatus(teamId, isSynced);
      return true;
    } catch (e) {
      debugPrint('Error updating sync status: $e');
      return false;
    }
  }

  /// Delete all teams (for testing/reset purposes)
  Future<bool> deleteAllTeams() async {
    try {
      await _offline.deleteAllTeams();
      return true;
    } catch (e) {
      debugPrint('Error deleting all teams: $e');
      return false;
    }
  }
}
