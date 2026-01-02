import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/login/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstant.cardBackground,
          title: Text('Logout', style: TextStyle(color: AppConstant.textPrimary)),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppConstant.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
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
              child: Text('Logout', style: TextStyle(color: AppConstant.errorRed)),
            ),
          ],
        );
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Profile Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppConstant.spacing24),
                child: Consumer<UserState>(
                  builder: (context, userState, _) {
                    final user = userState.currentUser;
                    return Container(
                      padding: EdgeInsets.all(AppConstant.spacing20),
                      decoration: BoxDecoration(
                        color: AppConstant.cardBackground,
                        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppConstant.primaryBlue,
                            child: Text(
                              (user?.fullName?.substring(0, 1) ?? 
                               user?.username?.substring(0, 1) ?? 
                               'U').toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: AppConstant.spacing16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.fullName ?? user?.username ?? 'User',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user?.email ?? 'No email',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: AppConstant.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Settings List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader(context, 'General'),
                  _buildSettingItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Account',
                    subtitle: 'Manage your account settings',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Configure notification preferences',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                    subtitle: 'Theme and display settings',
                    onTap: () {},
                  ),
                  
                  SizedBox(height: AppConstant.spacing16),
                  _buildSectionHeader(context, 'Support'),
                  _buildSettingItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () {},
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () {},
                  ),
                  
                  SizedBox(height: AppConstant.spacing16),
                  _buildSectionHeader(context, 'Account'),
                  _buildSettingItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    isDestructive: true,
                    onTap: () => _showLogoutDialog(context),
                  ),
                  
                  SizedBox(height: AppConstant.spacing32),
                  Consumer<AppInfoState>(
                    builder: (context, appInfo, _) {
                      return Center(
                        child: Text(
                          'Task Flow v${appInfo.version}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppConstant.textSecondary.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppConstant.spacing32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppConstant.spacing8,
        top: AppConstant.spacing8,
        bottom: AppConstant.spacing8,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: AppConstant.textSecondary.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppConstant.spacing8),
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? AppConstant.errorRed : AppConstant.primaryBlue,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive ? AppConstant.errorRed : AppConstant.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: AppConstant.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppConstant.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}
