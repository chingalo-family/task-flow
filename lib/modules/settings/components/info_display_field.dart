import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

/// Reusable read-only information display field
class InfoDisplayField extends StatelessWidget {
  final String label;
  final String value;
  final bool showLabel;

  const InfoDisplayField({
    super.key,
    required this.label,
    required this.value,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppConstant.spacing8),
        ],
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppConstant.spacing16,
            vertical: AppConstant.spacing16,
          ),
          decoration: BoxDecoration(
            color: AppConstant.cardBackground,
            borderRadius: BorderRadius.circular(
              AppConstant.borderRadius12,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
