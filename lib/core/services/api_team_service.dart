import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:task_flow/core/constants/api_config.dart';
import 'package:task_flow/core/models/team.dart';
import 'package:task_flow/core/models/task_status.dart';
import 'package:task_flow/core/services/task_flow_api_service.dart';
import 'package:task_flow/core/services/team_service.dart';

/// API Team Service
/// 
/// Handles team operations with the backend API
/// Falls back to local TeamService for offline support
class ApiTeamService {
  final TaskFlowApiService _api = TaskFlowApiService();
  final TeamService _localService = TeamService();

  ApiTeamService._();
  static final ApiTeamService _instance = ApiTeamService._();
  factory ApiTeamService() => _instance;

  /// Create a new team on the server
  Future<Team?> createTeam(Team team) async {
    try {
      final teamJson = _teamToJson(team);
      
      final response = await _api.post(
        ApiConfig.teamsEndpoint,
        body: teamJson,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final createdTeam = _teamFromJson(data);
        
        // Save to local storage
        await _localService.createTeam(createdTeam);
        
        return createdTeam;
      }
      
      return null;
    } catch (e) {
      debugPrint('API create team error: $e');
      return await _localService.createTeam(team);
    }
  }

  /// Get all teams from the server
  Future<List<Team>> getAllTeams() async {
    try {
      final response = await _api.get(ApiConfig.teamsEndpoint);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> teamsJson = data['teams'] ?? data;
        
        final teams = teamsJson.map((json) => _teamFromJson(json)).toList();
        
        // Update local storage
        for (var team in teams) {
          await _localService.updateTeam(team);
        }
        
        return teams;
      }
      
      return await _localService.getAllTeams();
    } catch (e) {
      debugPrint('API get all teams error: $e');
      return await _localService.getAllTeams();
    }
  }

  /// Get a specific team by ID
  Future<Team?> getTeamById(String id) async {
    try {
      final response = await _api.get('${ApiConfig.teamsEndpoint}/$id');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final team = _teamFromJson(data);
        
        // Update local storage
        await _localService.updateTeam(team);
        
        return team;
      }
      
      return null;
    } catch (e) {
      debugPrint('API get team by ID error: $e');
      return await _localService.getTeamById(id);
    }
  }

  /// Update a team on the server
  Future<bool> updateTeam(Team team) async {
    try {
      final teamJson = _teamToJson(team);
      
      final response = await _api.put(
        '${ApiConfig.teamsEndpoint}/${team.id}',
        body: teamJson,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final updatedTeam = _teamFromJson(data);
        
        // Update local storage
        await _localService.updateTeam(updatedTeam);
        
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API update team error: $e');
      return await _localService.updateTeam(team);
    }
  }

  /// Delete a team from the server
  Future<bool> deleteTeam(String id) async {
    try {
      final response = await _api.delete('${ApiConfig.teamsEndpoint}/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Delete from local storage
        await _localService.deleteTeam(id);
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('API delete team error: $e');
      return await _localService.deleteTeam(id);
    }
  }

  /// Add a member to a team
  Future<bool> addTeamMember(String teamId, String userId) async {
    try {
      final response = await _api.post(
        '${ApiConfig.teamsEndpoint}/$teamId/members',
        body: {'userId': userId},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('API add team member error: $e');
      return false;
    }
  }

  /// Remove a member from a team
  Future<bool> removeTeamMember(String teamId, String userId) async {
    try {
      final response = await _api.delete(
        '${ApiConfig.teamsEndpoint}/$teamId/members/$userId',
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('API remove team member error: $e');
      return false;
    }
  }

  /// Convert Team model to JSON for API
  Map<String, dynamic> _teamToJson(Team team) {
    return {
      'id': team.id,
      'name': team.name,
      'description': team.description,
      'avatarUrl': team.avatarUrl,
      'memberCount': team.memberCount,
      'memberIds': team.memberIds,
      'taskIds': team.taskIds,
      'customTaskStatuses': team.customTaskStatuses?.map((status) => {
        'value': status.value,
        'label': status.label,
        'color': status.color,
        'icon': status.icon,
      }).toList(),
      'createdByUserId': team.createdByUserId,
      'createdByUsername': team.createdByUsername,
      'teamIcon': team.teamIcon,
      'teamColor': team.teamColor,
      'createdAt': team.createdAt.toIso8601String(),
      'updatedAt': team.updatedAt.toIso8601String(),
    };
  }

  /// Convert JSON from API to Team model
  Team _teamFromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      avatarUrl: json['avatarUrl'],
      memberCount: json['memberCount'] ?? 0,
      memberIds: json['memberIds'] != null
          ? List<String>.from(json['memberIds'])
          : null,
      taskIds: json['taskIds'] != null
          ? List<String>.from(json['taskIds'])
          : null,
      customTaskStatuses: json['customTaskStatuses'] != null
          ? (json['customTaskStatuses'] as List).map((status) => TaskStatus(
                value: status['value'] ?? '',
                label: status['label'] ?? '',
                color: status['color'] ?? '',
                icon: status['icon'] ?? '',
              )).toList()
          : null,
      createdByUserId: json['createdByUserId'],
      createdByUsername: json['createdByUsername'],
      teamIcon: json['teamIcon'],
      teamColor: json['teamColor'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
