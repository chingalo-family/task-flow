import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/services/email_notification_service.dart';
import 'package:task_flow/core/services/notification_scheduler_service.dart';
import 'package:task_flow/modules/settings/components/preference_toggle_item.dart';
import 'package:task_flow/core/components/forms/input_field.dart';
import 'package:task_flow/core/components/cards/section_header.dart';
import 'package:task_flow/core/components/buttons/primary_button.dart';

class AdvancedNotificationSettingsPage extends StatefulWidget {
  const AdvancedNotificationSettingsPage({super.key});

  @override
  State<AdvancedNotificationSettingsPage> createState() =>
      _AdvancedNotificationSettingsPageState();
}

class _AdvancedNotificationSettingsPageState
    extends State<AdvancedNotificationSettingsPage> {
  final _emailService = EmailNotificationService();
  final _schedulerService = NotificationSchedulerService();
  
  bool _emailNotificationsEnabled = false;
  bool _scheduledNotificationsEnabled = true;
  String _userEmail = '';
  int _preferredCheckTime = 6;
  DateTime? _lastCheckTime;
  bool _loading = true;

  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final emailEnabled = await _emailService.areEmailNotificationsEnabled();
    final savedEmail = await _emailService.getUserEmail();
    final scheduledEnabled =
        await _schedulerService.areScheduledNotificationsEnabled();
    final checkTime = await _schedulerService.getPreferredCheckTime();
    final lastCheck = await _schedulerService.getLastCheckTime();

    // Get current user's email from UserState
    final userState = context.read<UserState>();
    final currentUserEmail = userState.currentUser?.email ?? '';

    // Use saved email if exists and not blank, otherwise use current user's email
    final emailToUse = (savedEmail != null && savedEmail.isNotEmpty)
        ? savedEmail
        : currentUserEmail;

    setState(() {
      _emailNotificationsEnabled = emailEnabled;
      _userEmail = emailToUse;
      _emailController.text = emailToUse;
      _scheduledNotificationsEnabled = scheduledEnabled;
      _preferredCheckTime = checkTime;
      _lastCheckTime = lastCheck;
      _loading = false;
    });
  }

  Future<void> _updateEmailNotificationsEnabled(bool enabled) async {
    setState(() {
      _emailNotificationsEnabled = enabled;
    });
    await _emailService.setEmailNotificationsEnabled(enabled);
  }

  Future<void> _updateScheduledNotificationsEnabled(bool enabled) async {
    setState(() {
      _scheduledNotificationsEnabled = enabled;
    });
    await _schedulerService.setScheduledNotificationsEnabled(enabled);
  }

  Future<void> _saveEmailAddress() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && _isValidEmail(email)) {
      setState(() {
        _userEmail = email;
      });
      await _emailService.setUserEmail(email);
      _showSnackBar('Email address saved');
    } else {
      _showSnackBar('Please enter a valid email address');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _updatePreferredCheckTime(int hour) async {
    setState(() {
      _preferredCheckTime = hour;
    });
    await _schedulerService.setPreferredCheckTime(hour);
  }

  Future<void> _triggerManualCheck() async {
    _showSnackBar('Running notification check...');
    await _schedulerService.manualTrigger();
    final lastCheck = await _schedulerService.getLastCheckTime();
    setState(() {
      _lastCheckTime = lastCheck;
    });
    _showSnackBar('Notification check completed');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          'Advanced Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstant.textPrimary,
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppConstant.primaryBlue,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstant.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Notifications Section
                    SectionHeader(
                      title: 'Email Notifications',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    PreferenceToggleItem(
                      icon: Icons.email,
                      iconColor: AppConstant.primaryBlue,
                      title: 'Email Notifications',
                      subtitle: 'Receive emails for critical notifications',
                      value: _emailNotificationsEnabled,
                      onChanged: _updateEmailNotificationsEnabled,
                    ),

                    if (_emailNotificationsEnabled) ...[
                      SizedBox(height: AppConstant.spacing16),
                      InputField(
                        controller: _emailController,
                        hintText: 'Enter your email',
                        icon: Icons.email,
                        labelText: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: AppConstant.spacing12),
                      PrimaryButton(
                        onPressed: _saveEmailAddress,
                        child: Text(
                          'Save Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: AppConstant.spacing8),
                      Text(
                        'Critical notifications (task assignments, deadlines, team invites) will be sent to this email',
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],

                    SizedBox(height: AppConstant.spacing32),

                    // Scheduled Checks Section
                    SectionHeader(
                      title: 'Scheduled Checks',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    PreferenceToggleItem(
                      icon: Icons.schedule,
                      iconColor: AppConstant.warningOrange,
                      title: 'Scheduled Checks',
                      subtitle: 'Daily checks for deadlines and overdue tasks',
                      value: _scheduledNotificationsEnabled,
                      onChanged: _updateScheduledNotificationsEnabled,
                    ),

                    if (_scheduledNotificationsEnabled) ...[
                      SizedBox(height: AppConstant.spacing16),
                      Container(
                        padding: EdgeInsets.all(AppConstant.spacing16),
                        decoration: BoxDecoration(
                          color: AppConstant.cardBackground,
                          borderRadius:
                              BorderRadius.circular(AppConstant.borderRadius12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preferred Check Time',
                              style: TextStyle(
                                color: AppConstant.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: AppConstant.spacing12),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '$_preferredCheckTime:00',
                                    style: TextStyle(
                                      color: AppConstant.primaryBlue,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: AppConstant.primaryBlue,
                                ),
                              ],
                            ),
                            SizedBox(height: AppConstant.spacing12),
                            Slider(
                              value: _preferredCheckTime.toDouble(),
                              min: 0,
                              max: 23,
                              divisions: 23,
                              label: '$_preferredCheckTime:00',
                              onChanged: (value) {
                                _updatePreferredCheckTime(value.toInt());
                              },
                            ),
                            SizedBox(height: AppConstant.spacing8),
                            Text(
                              'Notifications will be checked daily at this time',
                              style: TextStyle(
                                color: AppConstant.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppConstant.spacing16),
                      if (_lastCheckTime != null)
                        Container(
                          padding: EdgeInsets.all(AppConstant.spacing12),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius8,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppConstant.textSecondary,
                                size: 16,
                              ),
                              SizedBox(width: AppConstant.spacing8),
                              Expanded(
                                child: Text(
                                  'Last check: ${_formatDateTime(_lastCheckTime!)}',
                                  style: TextStyle(
                                    color: AppConstant.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: AppConstant.spacing16),
                      PrimaryButton(
                        onPressed: _triggerManualCheck,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow, color: Colors.white),
                            SizedBox(width: AppConstant.spacing8),
                            Text(
                              'Run Check Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: AppConstant.spacing32),

                    // Info Section
                    Container(
                      padding: EdgeInsets.all(AppConstant.spacing16),
                      decoration: BoxDecoration(
                        color: AppConstant.primaryBlue.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppConstant.borderRadius12),
                        border: Border.all(
                          color: AppConstant.primaryBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: AppConstant.primaryBlue,
                                size: 20,
                              ),
                              SizedBox(width: AppConstant.spacing8),
                              Text(
                                'About Scheduled Checks',
                                style: TextStyle(
                                  color: AppConstant.primaryBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppConstant.spacing8),
                          Text(
                            'Scheduled checks automatically look for:\n'
                            '• Tasks due within 24 hours (deadline reminders)\n'
                            '• Tasks that have passed their due date (overdue alerts)\n\n'
                            'For best results, enable background task execution in your device settings.',
                            style: TextStyle(
                              color: AppConstant.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
