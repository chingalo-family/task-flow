import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/services/email_notification_service.dart';
import 'package:task_flow/modules/tasks/tasks_page.dart';
import 'package:task_flow/modules/teams/teams_page.dart';
import 'package:task_flow/modules/notifications/notifications_page.dart';
import 'package:task_flow/modules/settings/settings_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userState = Provider.of<UserState>(context, listen: false);
      final notificationState = Provider.of<NotificationState>(
        context,
        listen: false,
      );
      await notificationState.initialize();
      await EmailNotificationService().setUserEmail(
        userState.currentUser?.email ?? '',
      );
    });
  }

  final List<Widget> _pages = [
    const TasksPage(),
    const TeamsPage(),
    const NotificationsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppConstant.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing8,
              vertical: AppConstant.spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.check_circle_outline, 'My Tasks'),
                _buildNavItem(1, Icons.people_outline, 'Teams'),
                _buildNavItem(2, Icons.notifications_outlined, 'Alerts'),
                _buildNavItem(3, Icons.settings_outlined, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return Consumer<NotificationState>(
      builder: (context, notificationState, child) {
        final showBadge = index == 2 && notificationState.unreadCount > 0;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing16,
              vertical: AppConstant.spacing8,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppConstant.primaryBlue.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? AppConstant.primaryBlue
                          : AppConstant.textSecondary,
                      size: 24,
                    ),
                    if (showBadge)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppConstant.errorRed,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            notificationState.unreadCount > 9
                                ? '9+'
                                : '${notificationState.unreadCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppConstant.primaryBlue
                        : AppConstant.textSecondary,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
