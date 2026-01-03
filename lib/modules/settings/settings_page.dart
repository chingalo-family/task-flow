import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/login/login_page.dart';
import 'package:task_flow/modules/settings/pages/privacy_policy_page.dart';
import 'package:task_flow/modules/settings/pages/contact_us_page.dart';
import 'package:task_flow/modules/settings/components/change_password_form.dart';

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
    // TODO: Load from preferences
  }

  Future<void> _handleLogout(BuildContext context) async {
    await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      onConfirm: () async {
        final userState = Provider.of<UserState>(context, listen: false);
        await userState.logout();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      },
    );
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
                    Center(
                      child: Stack(
                        children: [
                          Consumer<UserState>(
                            builder: (context, userState, _) {
                              return CircleAvatar(
                                radius: 50,
                                backgroundColor: AppConstant.primaryBlue,
                                child: Text(
                                  (userState.currentUser?.fullName?.substring(
                                            0,
                                            1,
                                          ) ??
                                          userState.currentUser?.username
                                              .substring(0, 1) ??
                                          '')
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppConstant.primaryBlue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppConstant.darkBackground,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing24),

                    // Display Name Field
                    Text(
                      'Display Name',
                      style: TextStyle(
                        color: AppConstant.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing8),
                    Consumer<UserState>(
                      builder: (context, userState, _) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.spacing16,
                            vertical: AppConstant.spacing16,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius12,
                            ),
                          ),
                          child: Text(
                            userState.currentUser?.fullName ??
                                userState.currentUser?.username ??
                                'User',
                            style: TextStyle(
                              color: AppConstant.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppConstant.spacing16),

                    // Email Address Field
                    Text(
                      'Email Address',
                      style: TextStyle(
                        color: AppConstant.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing8),
                    Consumer<UserState>(
                      builder: (context, userState, _) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.spacing16,
                            vertical: AppConstant.spacing16,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius12,
                            ),
                          ),
                          child: Text(
                            userState.currentUser?.email ?? 'No email',
                            style: TextStyle(
                              color: AppConstant.textPrimary,
                              fontSize: 16,
                            ),
                          ),
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
                        return Container(
                          margin: EdgeInsets.only(bottom: AppConstant.spacing12),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius12,
                            ),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppConstant.pinkAccent.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppConstant.borderRadius8,
                                ),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: AppConstant.pinkAccent,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              'Notifications',
                              style: TextStyle(
                                color: AppConstant.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Switch(
                              value: notificationState.notificationsEnabled,
                              onChanged: (value) {
                                notificationState.setNotificationsEnabled(value);
                              },
                              activeColor: AppConstant.primaryBlue,
                            ),
                          ),
                        );
                      },
                    ),

                    // Offline Access Toggle
                    Container(
                      margin: EdgeInsets.only(bottom: AppConstant.spacing12),
                      decoration: BoxDecoration(
                        color: AppConstant.cardBackground,
                        borderRadius: BorderRadius.circular(
                          AppConstant.borderRadius12,
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppConstant.successGreen.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius8,
                            ),
                          ),
                          child: Icon(
                            Icons.wifi_off,
                            color: AppConstant.successGreen,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Offline Access',
                          style: TextStyle(
                            color: AppConstant.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Sync data automatically',
                          style: TextStyle(
                            color: AppConstant.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Switch(
                          value: offlineAccessEnabled,
                          onChanged: (value) {
                            setState(() {
                              offlineAccessEnabled = value;
                            });
                          },
                          activeThumbColor: AppConstant.primaryBlue,
                        ),
                      ),
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
