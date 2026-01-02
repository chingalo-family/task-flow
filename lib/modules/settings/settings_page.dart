import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/login/login_page.dart';
import 'package:task_flow/modules/settings/components/profile_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
    );

    if (confirmed && context.mounted) {
      final userState = Provider.of<UserState>(context, listen: false);
      await userState.logout();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
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
                    return ProfileCard(user: userState.currentUser);
                  },
                ),
              ),
            ),

            // Settings List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SectionHeader(title: 'GENERAL'),
                  SettingsTile(
                    icon: Icons.person_outline,
                    title: 'Account',
                    subtitle: 'Manage your account settings',
                    onTap: () {},
                  ),
                  SizedBox(height: AppConstant.spacing8),
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Configure notification preferences',
                    onTap: () {},
                  ),
                  SizedBox(height: AppConstant.spacing8),
                  SettingsTile(
                    icon: Icons.palette_outlined,
                    title: 'Appearance',
                    subtitle: 'Theme and display settings',
                    onTap: () {},
                  ),
                  
                  SectionHeader(title: 'SUPPORT'),
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and contact support',
                    onTap: () {},
                  ),
                  SizedBox(height: AppConstant.spacing8),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () {},
                  ),
                  
                  SectionHeader(title: 'ACCOUNT'),
                  SettingsTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconColor: AppConstant.errorRed,
                    onTap: () => _handleLogout(context),
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
}
