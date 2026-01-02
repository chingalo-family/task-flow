import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class TaskStats extends StatelessWidget {
  const TaskStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskState>(
      builder: (context, taskState, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing16),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total',
                  taskState.totalTasks.toString(),
                  AppConstant.primaryBlue,
                  Icons.task_alt,
                ),
              ),
              SizedBox(width: AppConstant.spacing12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'In Progress',
                  taskState.inProgressTasks.toString(),
                  AppConstant.warningOrange,
                  Icons.trending_up,
                ),
              ),
              SizedBox(width: AppConstant.spacing12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Completed',
                  taskState.completedTasks.toString(),
                  AppConstant.successGreen,
                  Icons.check_circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing16),
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
