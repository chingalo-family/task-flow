import 'dart:convert';
import 'package:task_flow/core/constants/notification_constants.dart';
import 'package:task_flow/core/models/notification_preferences.dart';
import 'package:task_flow/core/services/preference_service.dart';

class NotificationPreferenceService {
  NotificationPreferenceService._();
  static final NotificationPreferenceService _instance =
      NotificationPreferenceService._();
  factory NotificationPreferenceService() => _instance;

  final _prefs = PreferenceService();

  /// Get global notification preferences
  Future<NotificationPreferences> getGlobalPreferences() async {
    try {
      final taskAssigned =
          await _prefs.getBool(NotificationConstants.prefTaskAssigned) ?? true;
      final taskCompleted =
          await _prefs.getBool(NotificationConstants.prefTaskCompleted) ?? true;
      final taskStatusChange =
          await _prefs.getBool(NotificationConstants.prefTaskStatusChange) ??
              true;
      final taskComment =
          await _prefs.getBool(NotificationConstants.prefTaskComment) ?? true;
      final taskMention =
          await _prefs.getBool(NotificationConstants.prefTaskMention) ?? true;
      final deadlineReminder =
          await _prefs.getBool(NotificationConstants.prefDeadlineReminder) ??
              true;
      final teamInvite =
          await _prefs.getBool(NotificationConstants.prefTeamInvite) ?? true;
      final teamMemberAdded =
          await _prefs.getBool(NotificationConstants.prefTeamMemberAdded) ??
              true;
      final teamMemberRemoved =
          await _prefs.getBool(NotificationConstants.prefTeamMemberRemoved) ??
              true;
      final systemNotifications =
          await _prefs.getBool(NotificationConstants.prefSystemNotifications) ??
              true;
      final taskPriorityChange =
          await _prefs.getBool(NotificationConstants.prefTaskPriorityChange) ??
              true;
      final taskOverdue =
          await _prefs.getBool(NotificationConstants.prefTaskOverdue) ?? true;

      return NotificationPreferences(
        taskAssigned: taskAssigned,
        taskCompleted: taskCompleted,
        taskStatusChange: taskStatusChange,
        taskComment: taskComment,
        taskMention: taskMention,
        deadlineReminder: deadlineReminder,
        teamInvite: teamInvite,
        teamMemberAdded: teamMemberAdded,
        teamMemberRemoved: teamMemberRemoved,
        systemNotifications: systemNotifications,
        taskPriorityChange: taskPriorityChange,
        taskOverdue: taskOverdue,
      );
    } catch (e) {
      return NotificationPreferences();
    }
  }

  /// Save global notification preferences
  Future<void> saveGlobalPreferences(NotificationPreferences prefs) async {
    await _prefs.setBool(
      NotificationConstants.prefTaskAssigned,
      prefs.taskAssigned,
    );
    await _prefs.setBool(
      NotificationConstants.prefTaskCompleted,
      prefs.taskCompleted,
    );
    await _prefs.setBool(
      NotificationConstants.prefTaskStatusChange,
      prefs.taskStatusChange,
    );
    await _prefs.setBool(
      NotificationConstants.prefTaskComment,
      prefs.taskComment,
    );
    await _prefs.setBool(
      NotificationConstants.prefTaskMention,
      prefs.taskMention,
    );
    await _prefs.setBool(
      NotificationConstants.prefDeadlineReminder,
      prefs.deadlineReminder,
    );
    await _prefs.setBool(
      NotificationConstants.prefTeamInvite,
      prefs.teamInvite,
    );
    await _prefs.setBool(
      NotificationConstants.prefTeamMemberAdded,
      prefs.teamMemberAdded,
    );
    await _prefs.setBool(
      NotificationConstants.prefTeamMemberRemoved,
      prefs.teamMemberRemoved,
    );
    await _prefs.setBool(
      NotificationConstants.prefSystemNotifications,
      prefs.systemNotifications,
    );
    await _prefs.setBool(
      NotificationConstants.prefTaskPriorityChange,
      prefs.taskPriorityChange,
    );
    await _prefs.setBool(
      NotificationConstants.prefTaskOverdue,
      prefs.taskOverdue,
    );
  }

  /// Get team-specific notification preferences
  Future<NotificationPreferences> getTeamPreferences(String teamId) async {
    try {
      final prefsJson = await _prefs.getString('team_${teamId}_notif_prefs');
      if (prefsJson != null) {
        final Map<String, dynamic> json = jsonDecode(prefsJson);
        return NotificationPreferences.fromJson(json);
      }
      // Return default preferences if none are saved
      return NotificationPreferences();
    } catch (e) {
      return NotificationPreferences();
    }
  }

  /// Save team-specific notification preferences
  Future<void> saveTeamPreferences(
    String teamId,
    NotificationPreferences prefs,
  ) async {
    final prefsJson = jsonEncode(prefs.toJson());
    await _prefs.setString('team_${teamId}_notif_prefs', prefsJson);
  }

  /// Check if a specific notification type is enabled globally
  Future<bool> isNotificationTypeEnabled(String type) async {
    final prefs = await getGlobalPreferences();
    return prefs.isNotificationTypeEnabled(type);
  }

  /// Check if a specific notification type is enabled for a team
  Future<bool> isTeamNotificationTypeEnabled(
    String teamId,
    String type,
  ) async {
    final prefs = await getTeamPreferences(teamId);
    return prefs.isNotificationTypeEnabled(type);
  }

  /// Update a single notification preference globally
  Future<void> updateGlobalPreference(String prefKey, bool value) async {
    await _prefs.setBool(prefKey, value);
  }

  /// Check if notifications are globally enabled
  Future<bool> areNotificationsEnabled() async {
    return await _prefs.getBool(
          NotificationConstants.prefNotificationsEnabled,
        ) ??
        true;
  }

  /// Set notifications globally enabled/disabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(
      NotificationConstants.prefNotificationsEnabled,
      enabled,
    );
  }
}
