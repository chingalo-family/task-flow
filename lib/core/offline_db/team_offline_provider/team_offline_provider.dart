import 'package:flutter/foundation.dart';
import 'package:task_flow/core/entities/team_entity.dart';
import 'package:task_flow/core/models/team.dart';
import 'package:task_flow/core/services/db_service.dart';
import 'package:task_flow/core/utils/team_entity_mapper.dart';

/// Offline provider for team persistence
///
/// Handles all ObjectBox database operations for teams.
/// Follows singleton pattern for efficient database access.
class TeamOfflineProvider {
  TeamOfflineProvider._();
  static final TeamOfflineProvider _instance = TeamOfflineProvider._();
  factory TeamOfflineProvider() => _instance;

  /// Add or update team in database
  Future<void> addOrUpdateTeam(Team team) async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return;

      // Convert Team model to TeamEntity
      final entity = TeamEntityMapper.toEntity(team);

      // Check if team already exists by iterating through all teams
      // NOTE: This is a temporary solution until ObjectBox indexing is optimized
      // TODO: Add index on teamId field for better performance
      final allEntities = box.getAll();
      TeamEntity? existing;
      for (var e in allEntities) {
        if (e.teamId == team.id) {
          existing = e;
          break;
        }
      }

      if (existing != null) {
        // Update existing team
        entity.id = existing.id;
      }

      // Save to database
      box.put(entity);
    } catch (e) {
      debugPrint('Error adding/updating team: $e');
      rethrow;
    }
  }

  /// Get team by API team ID
  Future<Team?> getTeamById(String apiTeamId) async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return null;

      // Find team by iterating through all teams
      // NOTE: This is a temporary solution until ObjectBox indexing is optimized
      // TODO: Add index on teamId field for better performance
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.teamId == apiTeamId) {
          return TeamEntityMapper.fromEntity(entity);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting team by ID: $e');
      return null;
    }
  }

  /// Get all teams
  Future<List<Team>> getAllTeams() async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return [];

      final entities = box.getAll();

      return entities
          .map((entity) => TeamEntityMapper.fromEntity(entity))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      debugPrint('Error getting all teams: $e');
      return [];
    }
  }

  /// Delete team by API team ID
  Future<void> deleteTeam(String apiTeamId) async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return;

      // Find and delete team by iterating through all teams
      // NOTE: This is a temporary solution until ObjectBox indexing is optimized
      // TODO: Add index on teamId field for better performance
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.teamId == apiTeamId) {
          box.remove(entity.id);
          break;
        }
      }
    } catch (e) {
      debugPrint('Error deleting team: $e');
      rethrow;
    }
  }

  /// Delete all teams
  Future<void> deleteAllTeams() async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return;

      box.removeAll();
    } catch (e) {
      debugPrint('Error deleting all teams: $e');
      rethrow;
    }
  }

  /// Get teams by member ID
  Future<List<Team>> getTeamsByMemberId(String userId) async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return [];

      final allTeams = await getAllTeams();
      return allTeams
          .where((team) => team.memberIds?.contains(userId) ?? false)
          .toList();
    } catch (e) {
      debugPrint('Error getting teams by member ID: $e');
      return [];
    }
  }

  /// Update team sync status
  Future<void> updateSyncStatus(String apiTeamId, bool isSynced) async {
    try {
      await DBService().init();
      final box = DBService().teamBox;
      if (box == null) return;

      // Find and update team sync status
      // NOTE: This follows the same pattern as task module
      // TODO: Consider optimizing with ObjectBox indexing
      final allEntities = box.getAll();
      for (var entity in allEntities) {
        if (entity.teamId == apiTeamId) {
          entity.isSynced = isSynced;
          box.put(entity);
          break;
        }
      }
    } catch (e) {
      debugPrint('Error updating sync status: $e');
      rethrow;
    }
  }
}
