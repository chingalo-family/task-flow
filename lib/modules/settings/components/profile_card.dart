import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';

class ProfileCard extends StatelessWidget {
  final User? user;
  final VoidCallback? onEditTap;

  const ProfileCard({
    super.key,
    required this.user,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(
              Icons.edit,
              color: AppConstant.textSecondary,
              size: 20,
            ),
            onPressed: onEditTap,
          ),
        ],
      ),
    );
  }
}
