import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/notification_preferences.dart';
import 'package:task_flow/core/services/notification_preference_service.dart';
import 'package:task_flow/modules/settings/components/preference_toggle_item.dart';

class TeamNotificationPreferences extends StatefulWidget {
  final String teamId;

  const TeamNotificationPreferences({super.key, required this.teamId});

  @override
  State<TeamNotificationPreferences> createState() =>
      _TeamNotificationPreferencesState();
}

class _TeamNotificationPreferencesState
    extends State<TeamNotificationPreferences> {
  final _prefService = NotificationPreferenceService();
  NotificationPreferences _preferences = NotificationPreferences();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _prefService.getTeamPreferences(widget.teamId);
    setState(() {
      _preferences = prefs;
      _loading = false;
    });
  }

  Future<void> _updatePreferences(NotificationPreferences newPrefs) async {
    setState(() {
      _preferences = newPrefs;
    });
    await _prefService.saveTeamPreferences(widget.teamId, newPrefs);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: AppConstant.primaryBlue),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Notification Preferences',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Override global notification settings for this team',
          style: TextStyle(color: AppConstant.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Task Notifications
        const Text(
          'Task Notifications',
          style: TextStyle(
            color: AppConstant.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        PreferenceToggleItem(
          icon: Icons.task_alt,
          iconColor: AppConstant.primaryBlue,
          title: 'Task Assigned',
          value: _preferences.taskAssigned,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(taskAssigned: value));
          },
        ),

        PreferenceToggleItem(
          icon: Icons.check_circle,
          iconColor: AppConstant.successGreen,
          title: 'Task Completed',
          value: _preferences.taskCompleted,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(taskCompleted: value));
          },
        ),

        PreferenceToggleItem(
          icon: Icons.update,
          iconColor: AppConstant.primaryBlue,
          title: 'Status Changes',
          value: _preferences.taskStatusChange,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(taskStatusChange: value));
          },
        ),

        PreferenceToggleItem(
          icon: Icons.priority_high,
          iconColor: AppConstant.warningOrange,
          title: 'Priority Changes',
          value: _preferences.taskPriorityChange,
          onChanged: (value) {
            _updatePreferences(
              _preferences.copyWith(taskPriorityChange: value),
            );
          },
        ),

        const SizedBox(height: 16),

        // Team Notifications
        const Text(
          'Team Notifications',
          style: TextStyle(
            color: AppConstant.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        PreferenceToggleItem(
          icon: Icons.person_add,
          iconColor: AppConstant.successGreen,
          title: 'Member Added',
          value: _preferences.teamMemberAdded,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(teamMemberAdded: value));
          },
        ),

        PreferenceToggleItem(
          icon: Icons.person_remove,
          iconColor: AppConstant.textSecondary,
          title: 'Member Removed',
          value: _preferences.teamMemberRemoved,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(teamMemberRemoved: value));
          },
        ),

        const SizedBox(height: 16),

        // Deadline Notifications
        const Text(
          'Deadlines',
          style: TextStyle(
            color: AppConstant.textSecondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        PreferenceToggleItem(
          icon: Icons.alarm,
          iconColor: AppConstant.errorRed,
          title: 'Deadline Reminders',
          value: _preferences.deadlineReminder,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(deadlineReminder: value));
          },
        ),

        PreferenceToggleItem(
          icon: Icons.warning,
          iconColor: AppConstant.errorRed,
          title: 'Overdue Tasks',
          value: _preferences.taskOverdue,
          onChanged: (value) {
            _updatePreferences(_preferences.copyWith(taskOverdue: value));
          },
        ),
      ],
    );
  }
}
