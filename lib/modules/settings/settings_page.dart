import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/login/login_page.dart';
import 'package:task_flow/modules/settings/pages/privacy_policy_page.dart';
import 'package:task_flow/modules/settings/pages/contact_us_page.dart';
import 'package:task_flow/modules/settings/pages/notification_preferences_page.dart';
import 'package:task_flow/modules/settings/pages/advanced_notification_settings_page.dart';
import 'package:task_flow/modules/settings/components/change_password_form.dart';
import 'package:task_flow/modules/settings/components/profile_avatar_with_edit.dart';
import 'package:task_flow/modules/settings/components/info_display_field.dart';
import 'package:task_flow/modules/settings/components/preference_toggle_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool offlineAccessEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load offline access preference
    _loadOfflineAccessPreference();
  }

  Future<void> _loadOfflineAccessPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        offlineAccessEnabled = prefs.getBool('offlineAccessEnabled') ?? false;
      });
    }
  }

  Future<void> _saveOfflineAccessPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offlineAccessEnabled', value);
  }

  Future<void> _handleLogout(BuildContext context) async {
    bool isConfirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );

    if (isConfirmed) {
      _logOutUser();
    }
  }

  void _logOutUser() async {
    Provider.of<UserState>(context, listen: false).logout();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppConstant.darkBackground,
              elevation: 0,
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstant.spacing24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Info Section
                    SectionHeader(
                      title: 'Account Info',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing16,
                      ),
                    ),

                    // Profile Avatar with Edit
                    Consumer<UserState>(
                      builder: (context, userState, _) {
                        final initials =
                            (userState.currentUser?.fullName?.substring(0, 1) ??
                                    userState.currentUser?.username.substring(
                                      0,
                                      1,
                                    ) ??
                                    '')
                                .toUpperCase();
                        return Center(
                          child: ProfileAvatarWithEdit(
                            initials: initials,
                            onEditTap: () {
                              // TODO: Implement profile picture edit
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing24),

                    // Display Name Field
                    Consumer<UserState>(
                      builder: (context, userState, _) {
                        return InfoDisplayField(
                          label: 'Display Name',
                          value:
                              userState.currentUser?.fullName ??
                              userState.currentUser?.username ??
                              'User',
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing16),

                    // Email Address Field
                    Consumer<UserState>(
                      builder: (context, userState, _) {
                        return InfoDisplayField(
                          label: 'Email Address',
                          value: userState.currentUser?.email ?? 'No email',
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing16),

                    // Change Password
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Last changed 30 days ago',
                      onTap: () {
                        AppModalUtil.showActionSheetModal(
                          context: context,
                          actionSheetContainer: const ChangePasswordForm(),
                          initialHeightRatio: 0.7,
                          maxHeightRatio: 0.85,
                        );
                      },
                    ),

                    SizedBox(height: AppConstant.spacing32),

                    // Preferences Section
                    SectionHeader(
                      title: 'Preferences',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    // Notifications Toggle
                    Consumer<NotificationState>(
                      builder: (context, notificationState, _) {
                        return PreferenceToggleItem(
                          icon: Icons.notifications,
                          iconColor: AppConstant.pinkAccent,
                          title: 'Notifications',
                          value: notificationState.notificationsEnabled,
                          onChanged: (value) {
                            notificationState.setNotificationsEnabled(value);
                          },
                        );
                      },
                    ),

                    // Notification Preferences
                    SettingsTile(
                      icon: Icons.tune,
                      title: 'Notification Preferences',
                      subtitle: 'Customize notification types',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationPreferencesPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing12),

                    // Advanced Notification Settings
                    SettingsTile(
                      icon: Icons.settings_applications,
                      title: 'Advanced Notifications',
                      subtitle: 'Email & scheduled checks',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const AdvancedNotificationSettingsPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing12),

                    // Offline Access Toggle
                    PreferenceToggleItem(
                      icon: Icons.wifi_off,
                      iconColor: AppConstant.successGreen,
                      title: 'Offline Access',
                      subtitle: 'Sync data automatically',
                      value: offlineAccessEnabled,
                      onChanged: (value) {
                        setState(() {
                          offlineAccessEnabled = value;
                        });
                        _saveOfflineAccessPreference(value);
                      },
                    ),

                    SizedBox(height: AppConstant.spacing32),

                    // Support Section
                    SectionHeader(
                      title: 'Support',
                      padding: EdgeInsets.only(
                        left: 0,
                        bottom: AppConstant.spacing12,
                      ),
                    ),

                    // Contact Us
                    SettingsTile(
                      icon: Icons.headset_mic_outlined,
                      title: 'Contact Us',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ContactUsPage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing12),

                    // Privacy Policy
                    SettingsTile(
                      icon: Icons.shield_outlined,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppConstant.spacing32),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleLogout(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstant.cardBackground,
                          padding: EdgeInsets.symmetric(
                            vertical: AppConstant.spacing16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius12,
                            ),
                          ),
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: AppConstant.errorRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppConstant.spacing24),

                    // Version Info
                    Consumer<AppInfoState>(
                      builder: (context, appInfo, _) {
                        return Center(
                          child: Text(
                            'Version ${appInfo.version} (Build ${appInfo.buildNumber})',
                            style: TextStyle(
                              color: AppConstant.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
