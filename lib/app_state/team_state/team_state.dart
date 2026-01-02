import 'package:flutter/material.dart';
import 'package:task_flow/core/models/models.dart';

class TeamState extends ChangeNotifier {
  List<Team> _teams = [];
  bool _loading = false;

  List<Team> get teams => _teams;
  bool get loading => _loading;

  int get totalTeams => _teams.length;

  Future<void> initialize() async {
    _loading = true;
    notifyListeners();
    
    // TODO: Load teams from ObjectBox
    await _loadTeams();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadTeams() async {
    // TODO: Implement ObjectBox loading
    // For now, create some sample data
    _teams = _generateSampleTeams();
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
    _teams.add(team);
    // TODO: Save to ObjectBox
    notifyListeners();
  }

  Future<void> updateTeam(Team team) async {
    final index = _teams.indexWhere((t) => t.id == team.id);
    if (index != -1) {
      _teams[index] = team;
      // TODO: Update in ObjectBox
      notifyListeners();
    }
  }

  Future<void> deleteTeam(String teamId) async {
    _teams.removeWhere((t) => t.id == teamId);
    // TODO: Delete from ObjectBox
    notifyListeners();
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
}
