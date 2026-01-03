import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/tasks/pages/task_detail_page.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskState = Provider.of<TaskState>(context, listen: false);
    final category = TaskCategory.getById(task.category);

    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
        border: Border.all(
          color: task.isOverdue
              ? AppConstant.errorRed.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(task: task),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(AppConstant.spacing16),
            child: Row(
              children: [
                // Category icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(category.icon, color: category.color, size: 28),
                ),
                SizedBox(width: AppConstant.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppConstant.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppConstant.spacing4),
                      // Category label and task ID
                      Row(
                        children: [
                          Text(
                            category.name.toUpperCase(),
                            style: TextStyle(
                              color: category.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: AppConstant.spacing8),
                          Text(
                            '#TSK-${task.id.length <= 3 ? task.id.padLeft(3, '0') : task.id.substring(0, 6)}',
                            style: TextStyle(
                              color: AppConstant.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                          if (task.priority == 'high') ...[
                            SizedBox(width: AppConstant.spacing8),
                            Text(
                              '• High Priority',
                              style: TextStyle(
                                color: AppConstant.errorRed,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppConstant.spacing12),
                // Checkbox/Status indicator
                GestureDetector(
                  onTap: () {
                    taskState.toggleTaskStatus(task.id);
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: task.isCompleted
                          ? AppConstant.primaryBlue
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isCompleted
                            ? AppConstant.primaryBlue
                            : AppConstant.textSecondary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: task.isCompleted
                        ? Icon(Icons.check, size: 18, color: Colors.white)
                        : null,
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
