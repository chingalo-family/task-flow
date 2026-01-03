import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

/// Reusable profile avatar widget with edit button overlay
class ProfileAvatarWithEdit extends StatelessWidget {
  // Size ratio constants for consistent scaling
  static const double _fontSizeRatio = 0.72;
  static const double _editButtonSizeRatio = 0.64;
  static const double _editIconSizeRatio = 0.32;

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
              fontSize: radius * _fontSizeRatio,
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
                width: radius * _editButtonSizeRatio,
                height: radius * _editButtonSizeRatio,
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
                  size: radius * _editIconSizeRatio,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
