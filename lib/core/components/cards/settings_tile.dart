import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (iconColor ?? AppConstant.primaryBlue).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppConstant.primaryBlue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppConstant.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 14,
                ),
              )
            : null,
        trailing:
            trailing ??
            Icon(Icons.chevron_right, color: AppConstant.textSecondary),
      ),
    );
  }
}
