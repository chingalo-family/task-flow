import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Content
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 80,
                      color: AppConstant.textSecondary.withOpacity(0.3),
                    ),
                    SizedBox(height: AppConstant.spacing16),
                    Text(
                      'Notifications',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppConstant.spacing8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing32),
                      child: Text(
                        'Stay updated with real-time notifications about task updates, deadlines, and team activities.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing32),
                    Text(
                      'Coming Soon',
                      style: TextStyle(
                        color: AppConstant.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
