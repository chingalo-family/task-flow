import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

/// Reusable widget for displaying user avatars
class UserAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? backgroundColor;
  final bool showMeBadge;

  const UserAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.backgroundColor,
    this.showMeBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: backgroundColor ?? AppConstant.primaryBlue,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size / 2.5,
            ),
          ),
        ),
        if (showMeBadge)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppConstant.successGreen,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppConstant.darkBackground,
                  width: 2,
                ),
              ),
              child: Text(
                'ME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Reusable widget for displaying a list of user avatars
class UserAvatarList extends StatelessWidget {
  final List<String> userInitials;
  final double size;
  final int maxDisplay;
  final VoidCallback? onAddPressed;

  const UserAvatarList({
    super.key,
    required this.userInitials,
    this.size = 40,
    this.maxDisplay = 3,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = userInitials.length > maxDisplay
        ? maxDisplay
        : userInitials.length;
    final remaining = userInitials.length - maxDisplay;

    return Row(
      children: [
        ...List.generate(displayCount, (index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < displayCount - 1 ? 8 : 0,
            ),
            child: UserAvatar(
              initials: userInitials[index],
              size: size,
            ),
          );
        }),
        if (remaining > 0)
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: AppConstant.cardBackground,
              child: Text(
                '+$remaining',
                style: TextStyle(
                  color: AppConstant.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: size / 2.5,
                ),
              ),
            ),
          ),
        if (onAddPressed != null)
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstant.textSecondary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  color: AppConstant.textSecondary,
                  size: size / 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
