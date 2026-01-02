import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            left: AppConstant.spacing8,
            top: AppConstant.spacing16,
            bottom: AppConstant.spacing8,
          ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppConstant.textSecondary.withOpacity(0.7),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
