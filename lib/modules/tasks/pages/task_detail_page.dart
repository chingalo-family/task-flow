import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/tasks/pages/add_edit_task_page.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMM d, h:mm a').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppConstant.successGreen;
      case 'in_progress':
        return AppConstant.primaryBlue;
      case 'pending':
        return AppConstant.textSecondary;
      default:
        return AppConstant.textSecondary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskState = Provider.of<TaskState>(context, listen: false);
    final category = TaskCategory.getById(_task.category);

    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstant.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Detail',
          style: TextStyle(
            color: AppConstant.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppConstant.textPrimary),
            color: AppConstant.cardBackground,
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditTaskPage(task: _task),
                  ),
                );
              } else if (value == 'delete') {
                taskState.deleteTask(_task.id);
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20, color: AppConstant.textPrimary),
                    SizedBox(width: AppConstant.spacing8),
                    Text('Edit', style: TextStyle(color: AppConstant.textPrimary)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: AppConstant.errorRed),
                    SizedBox(width: AppConstant.spacing8),
                    Text('Delete', style: TextStyle(color: AppConstant.errorRed)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstant.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and task ID badge
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.spacing12,
                    vertical: AppConstant.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category.icon, size: 16, color: category.color),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        category.name.toUpperCase(),
                        style: TextStyle(
                          color: category.color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppConstant.spacing12),
                Text(
                  '#TSK-${_task.id.padLeft(3, '0')}',
                  style: TextStyle(
                    color: AppConstant.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppConstant.spacing24),

            // Task title
            Text(
              _task.title,
              style: TextStyle(
                color: AppConstant.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            SizedBox(height: AppConstant.spacing24),

            // Status and Due Date
            Row(
              children: [
                // Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUS',
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: AppConstant.spacing8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstant.spacing16,
                          vertical: AppConstant.spacing12,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_task.status).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(_task.status).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _task.isCompleted
                                      ? Icons.check_circle
                                      : _task.isInProgress
                                          ? Icons.play_circle
                                          : Icons.radio_button_unchecked,
                                  size: 20,
                                  color: _getStatusColor(_task.status),
                                ),
                                SizedBox(width: AppConstant.spacing8),
                                Text(
                                  _getStatusLabel(_task.status),
                                  style: TextStyle(
                                    color: _getStatusColor(_task.status),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: _getStatusColor(_task.status),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppConstant.spacing16),

                // Due Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DUE DATE',
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: AppConstant.spacing8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstant.spacing12,
                          vertical: AppConstant.spacing12,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstant.cardBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppConstant.textSecondary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppConstant.textPrimary,
                            ),
                            SizedBox(width: AppConstant.spacing8),
                            Expanded(
                              child: Text(
                                _formatDate(_task.dueDate),
                                style: TextStyle(
                                  color: AppConstant.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: AppConstant.spacing32),

            // Description
            Text(
              'Description',
              style: TextStyle(
                color: AppConstant.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConstant.spacing12),
            Text(
              _task.description ?? 'No description provided.',
              style: TextStyle(
                color: AppConstant.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            SizedBox(height: AppConstant.spacing32),

            // Assigned to
            Text(
              'Assigned to',
              style: TextStyle(
                color: AppConstant.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppConstant.spacing12),
            Row(
              children: [
                // Display avatars - using placeholder circles with initials
                ..._buildAssigneeAvatars(),
                SizedBox(width: AppConstant.spacing12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppConstant.textSecondary.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: AppConstant.textSecondary,
                  ),
                ),
              ],
            ),

            // Subtasks section
            if (_task.subtasks != null && _task.subtasks!.isNotEmpty) ...[
              SizedBox(height: AppConstant.spacing32),
              Container(
                padding: EdgeInsets.all(AppConstant.spacing20),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtasks',
                          style: TextStyle(
                            color: AppConstant.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_task.subtasksCompleted}/${_task.subtasksTotal}',
                          style: TextStyle(
                            color: AppConstant.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstant.spacing16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _task.subtasksProgress,
                        backgroundColor:
                            AppConstant.textSecondary.withOpacity(0.2),
                        valueColor:
                            AlwaysStoppedAnimation(AppConstant.primaryBlue),
                        minHeight: 8,
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing20),
                    ..._task.subtasks!.map((subtask) => Padding(
                          padding: EdgeInsets.only(bottom: AppConstant.spacing12),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    final index = _task.subtasks!.indexOf(subtask);
                                    final updatedSubtasks = List<Subtask>.from(_task.subtasks!);
                                    updatedSubtasks[index] = subtask.copyWith(
                                      isCompleted: !subtask.isCompleted,
                                    );
                                    _task = _task.copyWith(subtasks: updatedSubtasks);
                                    taskState.updateTask(_task);
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: subtask.isCompleted
                                        ? AppConstant.primaryBlue
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: subtask.isCompleted
                                          ? AppConstant.primaryBlue
                                          : AppConstant.textSecondary
                                              .withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: subtask.isCompleted
                                      ? Icon(Icons.check,
                                          size: 16, color: Colors.white)
                                      : null,
                                ),
                              ),
                              SizedBox(width: AppConstant.spacing12),
                              Expanded(
                                child: Text(
                                  subtask.title,
                                  style: TextStyle(
                                    color: subtask.isCompleted
                                        ? AppConstant.textSecondary
                                        : AppConstant.textPrimary,
                                    fontSize: 14,
                                    decoration: subtask.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: AppConstant.spacing8),
                    GestureDetector(
                      onTap: () {
                        // TODO: Add new subtask
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add,
                              size: 20, color: AppConstant.primaryBlue),
                          SizedBox(width: AppConstant.spacing8),
                          Text(
                            'Add Subtask',
                            style: TextStyle(
                              color: AppConstant.primaryBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAssigneeAvatars() {
    final assigneeIds = _task.assignedUserIds ?? [];
    if (assigneeIds.isEmpty && _task.assignedToUserId != null) {
      // Fallback to single assignee
      return [
        _buildAvatar(_task.assignedToUsername ?? 'U', 0),
      ];
    }

    // Create avatars for multiple assignees (max 3 visible)
    final colors = [
      Color(0xFFEF4444),
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
    ];

    return assigneeIds.take(3).toList().asMap().entries.map((entry) {
      final index = entry.key;
      return _buildAvatar('U${index + 1}', index % colors.length);
    }).toList();
  }

  Widget _buildAvatar(String initials, int colorIndex) {
    final colors = [
      Color(0xFFEF4444),
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
    ];

    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: colors[colorIndex].withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: colors[colorIndex],
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initials.substring(0, 1),
          style: TextStyle(
            color: colors[colorIndex],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
