import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/task_constants.dart';

/// Reusable widget for status picker
class StatusPicker extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;
  final bool enabled;

  const StatusPicker({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
    this.enabled = true,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case TaskConstants.statusCompleted:
        return AppConstant.successGreen;
      case TaskConstants.statusInProgress:
        return AppConstant.primaryBlue;
      case TaskConstants.statusPending:
        return AppConstant.textSecondary;
      default:
        return AppConstant.textSecondary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case TaskConstants.statusCompleted:
        return 'Completed';
      case TaskConstants.statusInProgress:
        return 'In Progress';
      case TaskConstants.statusPending:
        return 'Pending';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case TaskConstants.statusCompleted:
        return Icons.check_circle;
      case TaskConstants.statusInProgress:
        return Icons.play_circle;
      case TaskConstants.statusPending:
        return Icons.circle_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppConstant.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppConstant.borderRadius16),
                  ),
                ),
                builder: (context) => Container(
                  padding: EdgeInsets.all(AppConstant.spacing16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppConstant.textSecondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      SizedBox(height: AppConstant.spacing16),
                      Text(
                        'Change Status',
                        style: TextStyle(
                          color: AppConstant.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppConstant.spacing16),
                      _buildStatusOption(context, TaskConstants.statusPending),
                      _buildStatusOption(context, TaskConstants.statusInProgress),
                      _buildStatusOption(context, TaskConstants.statusCompleted),
                      SizedBox(height: AppConstant.spacing16),
                    ],
                  ),
                ),
              );
            }
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing16,
          vertical: AppConstant.spacing12,
        ),
        decoration: BoxDecoration(
          color: _getStatusColor(currentStatus).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
          border: Border.all(
            color: _getStatusColor(currentStatus).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStatusIcon(currentStatus),
              color: _getStatusColor(currentStatus),
              size: 20,
            ),
            SizedBox(width: AppConstant.spacing8),
            Text(
              _getStatusLabel(currentStatus),
              style: TextStyle(
                color: _getStatusColor(currentStatus),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (enabled) ...[
              SizedBox(width: AppConstant.spacing8),
              Icon(
                Icons.keyboard_arrow_down,
                color: _getStatusColor(currentStatus),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOption(BuildContext context, String status) {
    final isSelected = currentStatus == status;
    return InkWell(
      onTap: () {
        onStatusChanged(status);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing16,
          vertical: AppConstant.spacing12,
        ),
        margin: EdgeInsets.only(bottom: AppConstant.spacing8),
        decoration: BoxDecoration(
          color: isSelected
              ? _getStatusColor(status).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
        ),
        child: Row(
          children: [
            Icon(
              _getStatusIcon(status),
              color: _getStatusColor(status),
              size: 24,
            ),
            SizedBox(width: AppConstant.spacing12),
            Text(
              _getStatusLabel(status),
              style: TextStyle(
                color: AppConstant.textPrimary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: _getStatusColor(status),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
