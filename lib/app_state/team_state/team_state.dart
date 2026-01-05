import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/services/team_service.dart';

class TeamState extends ChangeNotifier {
  final _service = TeamService();
  
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
      
      // If no teams in database, generate sample data for demonstration
      if (_teams.isEmpty) {
        _teams = _generateSampleTeams();
        // Save sample teams to database
        for (var team in _teams) {
          await _service.createTeam(team);
        }
      }
    } catch (e) {
      debugPrint('Error loading teams: $e');
      _teams = [];
    }
  }

  List<Team> _generateSampleTeams() {
    final now = DateTime.now();
    return [
      Team(
        id: '1',
        name: 'Product Team',
        description: 'Building amazing features for our users',
        memberCount: 8,
        memberIds: ['user1', 'user2', 'user3', 'user4', 'user5', 'user6', 'user7', 'user8'],
        taskIds: ['1', '2'],
        createdAt: now.subtract(Duration(days: 30)),
      ),
      Team(
        id: '2',
        name: 'Design Squad',
        description: 'Crafting beautiful experiences',
        memberCount: 5,
        memberIds: ['user1', 'user9', 'user10', 'user11', 'user12'],
        taskIds: ['3'],
        createdAt: now.subtract(Duration(days: 20)),
      ),
      Team(
        id: '3',
        name: 'Engineering',
        description: 'Code, deploy, repeat',
        memberCount: 12,
        memberIds: ['user1', 'user2', 'user13', 'user14', 'user15'],
        taskIds: ['4'],
        createdAt: now.subtract(Duration(days: 15)),
      ),
      Team(
        id: '4',
        name: 'Marketing',
        description: 'Spreading the word',
        memberCount: 6,
        memberIds: ['user16', 'user17', 'user18'],
        taskIds: ['5'],
        createdAt: now.subtract(Duration(days: 10)),
      ),
    ];
  }

  Future<void> addTeam(Team team) async {
    final createdTeam = await _service.createTeam(team);
    if (createdTeam != null) {
      _teams.add(createdTeam);
      notifyListeners();
    }
  }

  Future<void> updateTeam(Team team) async {
    final success = await _service.updateTeam(team);
    if (success) {
      final index = _teams.indexWhere((t) => t.id == team.id);
      if (index != -1) {
        _teams[index] = team;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTeam(String teamId) async {
    final success = await _service.deleteTeam(teamId);
    if (success) {
      _teams.removeWhere((t) => t.id == teamId);
      notifyListeners();
    }
  }

  Team? getTeamById(String teamId) {
    try {
      return _teams.firstWhere((t) => t.id == teamId);
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
      String teamId, String statusId, TaskStatus updatedStatus) async {
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
      // Don't allow deleting default statuses
      final statusToDelete = statuses.firstWhere((s) => s.id == statusId);
      if (!statusToDelete.isDefault) {
        statuses.removeWhere((s) => s.id == statusId);
        final updatedTeam = team.copyWith(
          customTaskStatuses: statuses,
          updatedAt: DateTime.now(),
        );
        await updateTeam(updatedTeam);
      }
    }
  }

  Future<void> reorderTaskStatuses(
      String teamId, List<TaskStatus> reorderedStatuses) async {
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
