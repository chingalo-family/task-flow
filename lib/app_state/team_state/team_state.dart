import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/services/team_service.dart';

class TeamState extends ChangeNotifier {
  final TeamService _service;

  TeamState({TeamService? service}) : _service = service ?? TeamService();

  List<Team> _teams = [];
  bool _loading = false;

  List<Team> get teams => _teams;
  bool get loading => _loading;

  int get totalTeams => _teams.length;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    await _loadTeams();
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadTeams() async {
    try {
      _teams = await _service.getAllTeams();
    } catch (e) {
      debugPrint('Error loading teams: $e');
      _teams = [];
    }
  }

  Future<void> addTeam(Team team) async {
    final createdTeam = await _service.createTeam(team);
    if (createdTeam != null) {
      _teams.add(createdTeam);
      notifyListeners();
    }
  }

  Future<void> updateTeam(Team updateTeam) async {
    final success = await _service.updateTeam(updateTeam);
    if (success) {
      final index = _teams.indexWhere((team) => team.id == updateTeam.id);
      if (index != -1) {
        _teams[index] = updateTeam;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTeam(String teamId) async {
    final success = await _service.deleteTeam(teamId);
    if (success) {
      _teams.removeWhere((team) => team.id == teamId);
      notifyListeners();
    }
  }

  Team? getTeamById(String teamId) {
    try {
      return _teams.firstWhere((team) => team.id == teamId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addMemberToTeam(String teamId, String userId) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final memberIds = List<String>.from(team.memberIds ?? []);
      if (!memberIds.contains(userId)) {
        memberIds.add(userId);
        final updatedTeam = team.copyWith(
          memberIds: memberIds,
          memberCount: memberIds.length,
          updatedAt: DateTime.now(),
        );
        await updateTeam(updatedTeam);
      }
    }
  }

  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final memberIds = List<String>.from(team.memberIds ?? []);
      memberIds.remove(userId);
      final updatedTeam = team.copyWith(
        memberIds: memberIds,
        memberCount: memberIds.length,
        updatedAt: DateTime.now(),
      );
      await updateTeam(updatedTeam);
    }
  }

  Future<void> addTaskToTeam(String teamId, String taskId) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final taskIds = List<String>.from(team.taskIds ?? []);
      if (!taskIds.contains(taskId)) {
        taskIds.add(taskId);
        final updatedTeam = team.copyWith(
          taskIds: taskIds,
          updatedAt: DateTime.now(),
        );
        await updateTeam(updatedTeam);
      }
    }
  }

  Future<void> removeTaskFromTeam(String teamId, String taskId) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final taskIds = List<String>.from(team.taskIds ?? []);
      taskIds.remove(taskId);
      final updatedTeam = team.copyWith(
        taskIds: taskIds,
        updatedAt: DateTime.now(),
      );
      await updateTeam(updatedTeam);
    }
  }

  Future<void> addTaskStatus(String teamId, TaskStatus status) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final statuses = List<TaskStatus>.from(team.taskStatuses);
      statuses.add(status);
      final updatedTeam = team.copyWith(
        customTaskStatuses: statuses,
        updatedAt: DateTime.now(),
      );
      await updateTeam(updatedTeam);
    }
  }

  Future<void> updateTaskStatus(
    String teamId,
    String statusId,
    TaskStatus updatedStatus,
  ) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final statuses = List<TaskStatus>.from(team.taskStatuses);
      final index = statuses.indexWhere((s) => s.id == statusId);
      if (index != -1) {
        statuses[index] = updatedStatus;
        final updatedTeam = team.copyWith(
          customTaskStatuses: statuses,
          updatedAt: DateTime.now(),
        );
        await updateTeam(updatedTeam);
      }
    }
  }

  Future<void> deleteTaskStatus(String teamId, String statusId) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final statuses = List<TaskStatus>.from(team.taskStatuses);
      final statusToDelete = statuses.firstWhere(
        (status) => status.id == statusId,
      );
      if (!statusToDelete.isDefault) {
        statuses.removeWhere((status) => status.id == statusId);
        final updatedTeam = team.copyWith(
          customTaskStatuses: statuses,
          updatedAt: DateTime.now(),
        );
        await updateTeam(updatedTeam);
      }
    }
  }

  Future<void> reorderTaskStatuses(
    String teamId,
    List<TaskStatus> reorderedStatuses,
  ) async {
    final team = getTeamById(teamId);
    if (team != null) {
      final updatedTeam = team.copyWith(
        customTaskStatuses: reorderedStatuses,
        updatedAt: DateTime.now(),
      );
      await updateTeam(updatedTeam);
    }
  }
}
