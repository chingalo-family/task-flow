import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

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
                'Teams',
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
                      Icons.people_outline,
                      size: 80,
                      color: AppConstant.textSecondary.withOpacity(0.3),
                    ),
                    SizedBox(height: AppConstant.spacing16),
                    Text(
                      'Team Management',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: AppConstant.spacing8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing32),
                      child: Text(
                        'Collaborate with your team members, assign tasks, and track progress together.',
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
