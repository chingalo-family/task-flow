import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

/// Reusable profile avatar widget with edit button overlay
class ProfileAvatarWithEdit extends StatelessWidget {
  final String initials;
  final VoidCallback? onEditTap;
  final double radius;
  final Color backgroundColor;
  final Color editButtonColor;

  const ProfileAvatarWithEdit({
    super.key,
    required this.initials,
    this.onEditTap,
    this.radius = 50,
    this.backgroundColor = AppConstant.primaryBlue,
    this.editButtonColor = AppConstant.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          child: Text(
            initials.toUpperCase(),
            style: TextStyle(
              fontSize: radius * 0.72, // 36 for radius of 50
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        if (onEditTap != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: radius * 0.64, // 32 for radius of 50
                height: radius * 0.64,
                decoration: BoxDecoration(
                  color: editButtonColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstant.darkBackground,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: radius * 0.32, // 16 for radius of 50
                ),
              ),
            ),
          ),
      ],
    );
  }
}
