import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/tasks/pages/task_detail_page.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskState = Provider.of<TaskState>(context, listen: false);
    final category = TaskCategory.getById(task.category);
    final isCompleted = task.isCompleted;

    // Get the first assignee if available
    final userListState = Provider.of<UserListState>(context, listen: false);
    final assignedUserId =
        (task.assignedUserIds != null && task.assignedUserIds!.isNotEmpty)
        ? task.assignedUserIds!.first
        : null;
    final assignedUser = assignedUserId != null
        ? userListState.getUserById(assignedUserId)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppConstant.borderRadius16),
          bottomRight: Radius.circular(AppConstant.borderRadius16),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppConstant.borderRadius16),
            bottomRight: Radius.circular(AppConstant.borderRadius16),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(task: task),
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colored left border
              Container(
                width: AppConstant.borderRadius8,
                height: 120,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppConstant.textSecondary.withValues(alpha: 0.4)
                      : category.color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppConstant.borderRadius16),
                    bottomLeft: Radius.circular(AppConstant.borderRadius16),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppConstant.spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with category badge and DONE badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isCompleted
                                        ? AppConstant.textSecondary.withValues(
                                            alpha: 0.6,
                                          )
                                        : AppConstant.textPrimary,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: AppConstant.spacing8),
                          if (isCompleted)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstant.successGreen.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'DONE',
                                style: TextStyle(
                                  color: AppConstant.successGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: AppConstant.spacing8),
                      // Description
                      if (task.description != null &&
                          task.description!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: AppConstant.spacing8,
                          ),
                          child: Text(
                            task.description!,
                            style: TextStyle(
                              color: isCompleted
                                  ? AppConstant.textSecondary.withValues(
                                      alpha: 0.5,
                                    )
                                  : AppConstant.textSecondary,
                              fontSize: 13,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      // Tags display
                      if (task.tags != null && task.tags!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: AppConstant.spacing8),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: task.tags!.take(3).map((tag) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? AppConstant.textSecondary.withValues(alpha: 0.2)
                                      : AppConstant.primaryBlue.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color: isCompleted
                                        ? AppConstant.textSecondary.withValues(alpha: 0.6)
                                        : AppConstant.primaryBlue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    decoration: isCompleted 
                                        ? TextDecoration.lineThrough 
                                        : null,
                                  ),
                                ),
                              );
                            }).toList()
                              ..addAll(task.tags!.length > 3
                                  ? [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? AppConstant.textSecondary.withValues(alpha: 0.2)
                                              : AppConstant.primaryBlue.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '+${task.tags!.length - 3}',
                                          style: TextStyle(
                                            color: isCompleted
                                                ? AppConstant.textSecondary.withValues(alpha: 0.6)
                                                : AppConstant.primaryBlue,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ]
                                  : []),
                          ),
                        ),
                      SizedBox(height: AppConstant.spacing4),
                      // Assignee and Due Date row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Assignee
                          if (assignedUser != null)
                            Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: isCompleted
                                        ? AppConstant.textSecondary.withValues(
                                            alpha: 0.4,
                                          )
                                        : AppConstant.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      assignedUser.fullName != null &&
                                              assignedUser.fullName!.isNotEmpty
                                          ? assignedUser.fullName!
                                                .substring(0, 1)
                                                .toUpperCase()
                                          : 'U',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppConstant.spacing8),
                                Text(
                                  assignedUser.fullName ??
                                      assignedUser.username,
                                  style: TextStyle(
                                    color: isCompleted
                                        ? AppConstant.textSecondary.withValues(
                                            alpha: 0.5,
                                          )
                                        : AppConstant.textSecondary,
                                    fontSize: 12,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          // Due Date
                          if (task.dueDate != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: isCompleted
                                      ? AppConstant.textSecondary.withValues(
                                          alpha: 0.5,
                                        )
                                      : (task.isOverdue
                                            ? AppConstant.errorRed
                                            : AppConstant.textSecondary),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  _formatDueDate(task.dueDate!),
                                  style: TextStyle(
                                    color: isCompleted
                                        ? AppConstant.textSecondary.withValues(
                                            alpha: 0.5,
                                          )
                                        : (task.isOverdue
                                              ? AppConstant.errorRed
                                              : AppConstant.textSecondary),
                                    fontSize: 12,
                                    fontWeight: task.isOverdue && !isCompleted
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow';
    } else if (taskDate.isBefore(today)) {
      return 'Yesterday';
    } else if (taskDate.difference(today).inDays < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return DateFormat('MMM d').format(date); // e.g., "Jan 15"
    }
  }
}
