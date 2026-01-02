import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'high':
        return AppConstant.errorRed;
      case 'medium':
        return AppConstant.warningOrange;
      case 'low':
        return AppConstant.successGreen;
      default:
        return AppConstant.textSecondary;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays} days';
    } else {
      return '${-difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskState = Provider.of<TaskState>(context, listen: false);
    
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
        border: Border.all(
          color: task.isOverdue
              ? AppConstant.errorRed.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
          onTap: () {
            // TODO: Navigate to task detail
          },
          child: Padding(
            padding: EdgeInsets.all(AppConstant.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with checkbox and priority
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        taskState.toggleTaskStatus(task.id);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? AppConstant.primaryBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: task.isCompleted
                                ? AppConstant.primaryBlue
                                : AppConstant.textSecondary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted
                            ? Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? AppConstant.textSecondary
                              : AppConstant.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstant.spacing8,
                        vertical: AppConstant.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task.priority.toUpperCase(),
                        style: TextStyle(
                          color: _getPriorityColor(),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Description
                if (task.description != null && task.description!.isNotEmpty) ...[
                  SizedBox(height: AppConstant.spacing8),
                  Padding(
                    padding: EdgeInsets.only(left: 36),
                    child: Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],

                // Progress bar
                if (!task.isCompleted && task.progress > 0) ...[
                  SizedBox(height: AppConstant.spacing12),
                  Padding(
                    padding: EdgeInsets.only(left: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${task.progress}%',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppConstant.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppConstant.spacing4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: task.progress / 100,
                            backgroundColor: AppConstant.textSecondary.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(AppConstant.primaryBlue),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Footer with due date and tags
                SizedBox(height: AppConstant.spacing12),
                Padding(
                  padding: EdgeInsets.only(left: 36),
                  child: Row(
                    children: [
                      if (task.dueDate != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: task.isOverdue
                              ? AppConstant.errorRed
                              : AppConstant.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          _formatDate(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isOverdue
                                ? AppConstant.errorRed
                                : AppConstant.textSecondary,
                          ),
                        ),
                      ],
                      if (task.tags != null && task.tags!.isNotEmpty) ...[
                        SizedBox(width: AppConstant.spacing12),
                        Expanded(
                          child: Wrap(
                            spacing: 4,
                            children: task.tags!.take(2).map((tag) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstant.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppConstant.primaryBlue,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
