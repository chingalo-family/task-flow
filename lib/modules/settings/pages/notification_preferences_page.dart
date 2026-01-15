import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/notification_preferences.dart';
import 'package:task_flow/core/services/notification_preference_service.dart';
import 'package:task_flow/modules/settings/components/preference_toggle_item.dart';
import 'package:task_flow/core/components/cards/section_header.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  final _prefService = NotificationPreferenceService();
  NotificationPreferences _preferences = NotificationPreferences();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _prefService.getGlobalPreferences();
    setState(() {
      _preferences = prefs;
      _loading = false;
    });
  }

  Future<void> _updatePreferences(NotificationPreferences newPrefs) async {
    setState(() {
      _preferences = newPrefs;
    });
    await _prefService.saveGlobalPreferences(newPrefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstant.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notification Preferences',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstant.textPrimary,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: AppConstant.primaryBlue),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstant.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Notifications Section
                    SectionHeader(
                      title: 'Task Notifications',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    PreferenceToggleItem(
                      icon: Icons.task_alt,
                      iconColor: AppConstant.primaryBlue,
                      title: 'Task Assigned',
                      subtitle: 'When a task is assigned to you',
                      value: _preferences.taskAssigned,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskAssigned: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.check_circle,
                      iconColor: AppConstant.successGreen,
                      title: 'Task Completed',
                      subtitle: 'When a task is marked as complete',
                      value: _preferences.taskCompleted,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskCompleted: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.update,
                      iconColor: AppConstant.primaryBlue,
                      title: 'Status Changes',
                      subtitle: 'When a task status is updated',
                      value: _preferences.taskStatusChange,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskStatusChange: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.priority_high,
                      iconColor: AppConstant.warningOrange,
                      title: 'Priority Changes',
                      subtitle: 'When task priority is changed',
                      value: _preferences.taskPriorityChange,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskPriorityChange: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.comment,
                      iconColor: AppConstant.warningOrange,
                      title: 'Comments',
                      subtitle: 'When someone comments on a task',
                      value: _preferences.taskComment,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskComment: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.alternate_email,
                      iconColor: AppConstant.primaryBlue,
                      title: 'Mentions',
                      subtitle: 'When you are mentioned',
                      value: _preferences.taskMention,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskMention: value),
                        );
                      },
                    ),

                    SizedBox(height: AppConstant.spacing32),

                    // Deadline & Reminders Section
                    SectionHeader(
                      title: 'Deadlines & Reminders',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    PreferenceToggleItem(
                      icon: Icons.alarm,
                      iconColor: AppConstant.errorRed,
                      title: 'Deadline Reminders',
                      subtitle: 'Remind before task due dates',
                      value: _preferences.deadlineReminder,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(deadlineReminder: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.warning,
                      iconColor: AppConstant.errorRed,
                      title: 'Overdue Tasks',
                      subtitle: 'When tasks are overdue',
                      value: _preferences.taskOverdue,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(taskOverdue: value),
                        );
                      },
                    ),

                    SizedBox(height: AppConstant.spacing32),

                    // Team Notifications Section
                    SectionHeader(
                      title: 'Team Notifications',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    PreferenceToggleItem(
                      icon: Icons.people,
                      iconColor: AppConstant.successGreen,
                      title: 'Team Invites',
                      subtitle: 'When you are invited to a team',
                      value: _preferences.teamInvite,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(teamInvite: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.person_add,
                      iconColor: AppConstant.successGreen,
                      title: 'Member Added',
                      subtitle: 'When a member is added to your team',
                      value: _preferences.teamMemberAdded,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(teamMemberAdded: value),
                        );
                      },
                    ),

                    PreferenceToggleItem(
                      icon: Icons.person_remove,
                      iconColor: AppConstant.textSecondary,
                      title: 'Member Removed',
                      subtitle: 'When a member is removed from your team',
                      value: _preferences.teamMemberRemoved,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(teamMemberRemoved: value),
                        );
                      },
                    ),

                    SizedBox(height: AppConstant.spacing32),

                    // System Notifications Section
                    SectionHeader(
                      title: 'System',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    PreferenceToggleItem(
                      icon: Icons.info,
                      iconColor: AppConstant.textSecondary,
                      title: 'System Notifications',
                      subtitle: 'Important system updates and announcements',
                      value: _preferences.systemNotifications,
                      onChanged: (value) {
                        _updatePreferences(
                          _preferences.copyWith(systemNotifications: value),
                        );
                      },
                    ),

                    SizedBox(height: AppConstant.spacing24),
                  ],
                ),
              ),
            ),
    );
  }
}
