import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
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
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing8,
          vertical: AppConstant.spacing8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppConstant.primaryBlue
                  : AppConstant.textSecondary,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppConstant.primaryBlue
                    : AppConstant.textSecondary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
