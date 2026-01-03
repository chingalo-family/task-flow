import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/utils/app_modal_util.dart';
import 'package:task_flow/modules/tasks/pages/add_edit_task_page.dart';
import 'package:task_flow/modules/tasks/components/task_form_fields.dart';
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
              if (!_task.isCompleted)
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: AppConstant.textPrimary,
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        'Edit',
                        style: TextStyle(color: AppConstant.textPrimary),
                      ),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: AppConstant.errorRed),
                    SizedBox(width: AppConstant.spacing8),
                    Text(
                      'Delete',
                      style: TextStyle(color: AppConstant.errorRed),
                    ),
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
                    color: category.color.withValues(alpha: 0.15),
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
                  '#TSK-${_task.id.length <= 3 ? _task.id.padLeft(3, '0') : _task.id.substring(0, 6)}',
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
                      InkWell(
                        onTap: _task.isCompleted
                            ? null
                            : () => _showStatusPicker(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.spacing16,
                            vertical: AppConstant.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              _task.status,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getStatusColor(
                                _task.status,
                              ).withValues(alpha: 0.3),
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
                              if (!_task.isCompleted)
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: _getStatusColor(_task.status),
                                ),
                            ],
                          ),
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
                      InkWell(
                        onTap: _task.isCompleted
                            ? null
                            : () => _selectDueDate(),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppConstant.spacing12,
                            vertical: AppConstant.spacing12,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppConstant.textSecondary.withValues(
                                alpha: 0.2,
                              ),
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
                              if (!_task.isCompleted)
                                Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: AppConstant.textSecondary,
                                ),
                            ],
                          ),
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

            // Team (if applicable)
            if (_task.teamId != null) ...[
              Text(
                'Team',
                style: TextStyle(
                  color: AppConstant.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppConstant.spacing12),
              Container(
                padding: EdgeInsets.all(AppConstant.spacing16),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                  border: Border.all(
                    color: AppConstant.textSecondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppConstant.successGreen.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.group,
                        color: AppConstant.successGreen,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Text(
                        _task.teamName ?? 'Unknown Team',
                        style: TextStyle(
                          color: AppConstant.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstant.spacing32),
            ],

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
                // Display avatars - using proper user information
                ..._buildAssigneeAvatars(context),
                SizedBox(width: AppConstant.spacing12),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppConstant.textSecondary.withValues(alpha: 0.3),
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
            ...[
              SizedBox(height: AppConstant.spacing32),
              Container(
                padding: EdgeInsets.all(AppConstant.spacing20),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius16,
                  ),
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
                        backgroundColor: AppConstant.textSecondary.withValues(
                          alpha: 0.2,
                        ),
                        valueColor: AlwaysStoppedAnimation(
                          AppConstant.primaryBlue,
                        ),
                        minHeight: 8,
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing20),
                    ...(_task.subtasks ?? []).asMap().entries.map((entry) {
                      final index = entry.key;
                      final subtask = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppConstant.spacing12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  final updatedSubtasks = List<Subtask>.from(
                                    _task.subtasks!,
                                  );
                                  updatedSubtasks[index] = subtask.copyWith(
                                    isCompleted: !subtask.isCompleted,
                                  );
                                  _task = _task.copyWith(
                                    subtasks: updatedSubtasks,
                                  );
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
                                        : AppConstant.textSecondary.withValues(
                                            alpha: 0.3,
                                          ),
                                    width: 2,
                                  ),
                                ),
                                child: subtask.isCompleted
                                    ? Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
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
                            if (!_task.isCompleted)
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 18,
                                  color: AppConstant.textSecondary,
                                ),
                                color: AppConstant.cardBackground,
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditSubtaskDialog(subtask, index);
                                  } else if (value == 'delete') {
                                    _deleteSubtask(index);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 18,
                                          color: AppConstant.primaryBlue,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: AppConstant.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: AppConstant.errorRed,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: AppConstant.errorRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: AppConstant.spacing8),
                    if (!_task.isCompleted)
                      GestureDetector(
                        onTap: () {
                          _showAddSubtaskDialog();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: AppConstant.primaryBlue,
                            ),
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

  void _showStatusPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstant.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(AppConstant.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Status',
                style: TextStyle(
                  color: AppConstant.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppConstant.spacing16),
              _buildStatusOption(
                'pending',
                'Pending',
                Icons.radio_button_unchecked,
              ),
              _buildStatusOption(
                'in_progress',
                'In Progress',
                Icons.play_circle,
              ),
              _buildStatusOption('completed', 'Completed', Icons.check_circle),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(String status, String label, IconData icon) {
    final isSelected = _task.status == status;
    final color = _getStatusColor(status);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? color : AppConstant.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: color) : null,
      onTap: () {
        final taskState = Provider.of<TaskState>(context, listen: false);
        setState(() {
          _task = _task.copyWith(
            status: status,
            completedAt: status == 'completed' ? DateTime.now() : null,
            progress: status == 'completed' ? 100 : _task.progress,
          );
          taskState.updateTask(_task);
        });
        Navigator.pop(context);
      },
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _task.dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppConstant.primaryBlue,
              onPrimary: Colors.white,
              surface: AppConstant.cardBackground,
              onSurface: AppConstant.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppConstant.primaryBlue,
                onPrimary: Colors.white,
                surface: AppConstant.cardBackground,
                onSurface: AppConstant.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        final taskState = Provider.of<TaskState>(context, listen: false);
        setState(() {
          _task = _task.copyWith(
            dueDate: DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ),
          );
          taskState.updateTask(_task);
        });
      }
    }
  }

  void _showAddSubtaskDialog() {
    final userState = Provider.of<UserState>(context, listen: false);
    final currentUserId =
        userState.currentUser?.id.toString() ?? 'current_user';

    // Form controllers and state
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedPriority = 'medium';
    String selectedCategory = 'general';
    final now = DateTime.now();
    DateTime selectedDueDate = DateTime(now.year, now.month, now.day, 23, 59);
    bool remindMe = false;
    List<String> selectedAssignees = [
      currentUserId,
    ]; // Auto-assign to current user

    AppModalUtil.showActionSheetModal(
      context: context,
      maxHeightRatio: 0.85,
      initialHeightRatio: 0.85,
      actionSheetContainer: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(AppConstant.spacing24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Subtask',
                      style: TextStyle(
                        color: AppConstant.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppConstant.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: AppConstant.spacing16),

                // Task Form Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: TaskFormFields(
                      formKey: formKey,
                      titleController: titleController,
                      descriptionController: descriptionController,
                      selectedPriority: selectedPriority,
                      selectedCategory: selectedCategory,
                      selectedDueDate: selectedDueDate,
                      remindMe: remindMe,
                      selectedTeam: null, // No team for subtasks
                      selectedAssignees: selectedAssignees,
                      onPriorityChanged: (value) =>
                          setState(() => selectedPriority = value),
                      onCategoryChanged: (value) =>
                          setState(() => selectedCategory = value),
                      onDueDateChanged: (value) =>
                          setState(() => selectedDueDate = value),
                      onRemindMeChanged: (value) =>
                          setState(() => remindMe = value),
                      onTeamChanged: (value) {}, // Not used for subtasks
                      onAssigneesChanged: (value) =>
                          setState(() => selectedAssignees = value),
                      hideTeamAndAssignee:
                          _task.teamId ==
                          null, // Hide if parent task has no team
                      isSubtask: true,
                    ),
                  ),
                ),

                SizedBox(height: AppConstant.spacing24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final taskState = Provider.of<TaskState>(
                          context,
                          listen: false,
                        );
                        final subtasks = List<Subtask>.from(
                          _task.subtasks ?? [],
                        );
                        subtasks.add(
                          Subtask(
                            id: '${DateTime.now().millisecondsSinceEpoch}_${subtasks.length}',
                            title: titleController.text.trim(),
                            isCompleted: false,
                          ),
                        );
                        setState(() {
                          _task = _task.copyWith(subtasks: subtasks);
                          taskState.updateTask(_task);
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstant.borderRadius12,
                        ),
                      ),
                    ),
                    child: Text(
                      'Add Subtask',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditSubtaskDialog(Subtask subtask, int index) {
    final userState = Provider.of<UserState>(context, listen: false);
    final currentUserId =
        userState.currentUser?.id.toString() ?? 'current_user';

    // Form controllers and state - pre-fill with subtask data
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: subtask.title);
    final descriptionController = TextEditingController();
    String selectedPriority = 'medium';
    String selectedCategory = 'general';
    final now = DateTime.now();
    DateTime selectedDueDate = DateTime(now.year, now.month, now.day, 23, 59);
    bool remindMe = false;
    List<String> selectedAssignees = [currentUserId];

    AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(AppConstant.spacing24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Subtask',
                      style: TextStyle(
                        color: AppConstant.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: AppConstant.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: AppConstant.spacing16),

                // Task Form Fields
                Expanded(
                  child: SingleChildScrollView(
                    child: TaskFormFields(
                      formKey: formKey,
                      titleController: titleController,
                      descriptionController: descriptionController,
                      selectedPriority: selectedPriority,
                      selectedCategory: selectedCategory,
                      selectedDueDate: selectedDueDate,
                      remindMe: remindMe,
                      selectedTeam: null,
                      selectedAssignees: selectedAssignees,
                      onPriorityChanged: (value) =>
                          setState(() => selectedPriority = value),
                      onCategoryChanged: (value) =>
                          setState(() => selectedCategory = value),
                      onDueDateChanged: (value) =>
                          setState(() => selectedDueDate = value),
                      onRemindMeChanged: (value) =>
                          setState(() => remindMe = value),
                      onTeamChanged: (value) {},
                      onAssigneesChanged: (value) =>
                          setState(() => selectedAssignees = value),
                      hideTeamAndAssignee: _task.teamId == null,
                      isSubtask: true,
                    ),
                  ),
                ),

                SizedBox(height: AppConstant.spacing24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final taskState = Provider.of<TaskState>(
                          context,
                          listen: false,
                        );
                        final subtasks = List<Subtask>.from(
                          _task.subtasks ?? [],
                        );
                        subtasks[index] = subtask.copyWith(
                          title: titleController.text.trim(),
                        );
                        setState(() {
                          _task = _task.copyWith(subtasks: subtasks);
                          taskState.updateTask(_task);
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstant.borderRadius12,
                        ),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _deleteSubtask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstant.cardBackground,
        title: Text(
          'Delete Subtask',
          style: TextStyle(color: AppConstant.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this subtask?',
          style: TextStyle(color: AppConstant.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppConstant.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final taskState = Provider.of<TaskState>(context, listen: false);
              setState(() {
                final subtasks = List<Subtask>.from(_task.subtasks!);
                subtasks.removeAt(index);
                _task = _task.copyWith(subtasks: subtasks);
                taskState.updateTask(_task);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.errorRed,
            ),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAssigneeAvatars(BuildContext context) {
    final assigneeIds = _task.assignedUserIds ?? [];
    final userState = Provider.of<UserState>(context, listen: false);
    final currentUserId = userState.currentUser?.id.toString() ?? '';

    if (assigneeIds.isEmpty && _task.assignedToUserId != null) {
      // Fallback to single assignee
      return [_buildAvatar(_task.assignedToUsername ?? 'U', 0, false)];
    }

    if (assigneeIds.isEmpty) {
      return [];
    }

    // Create avatars for multiple assignees (max 3 visible)
    return assigneeIds.take(3).toList().asMap().entries.map((entry) {
      final index = entry.key;
      final userId = entry.value;
      final isCurrentUser = userId == currentUserId;

      // Get user initials - try to get from user state, otherwise use generic
      String initials;
      if (isCurrentUser) {
        final user = userState.currentUser;
        if (user?.fullName != null && user!.fullName!.isNotEmpty) {
          final nameParts = user.fullName!
              .split(' ')
              .where((p) => p.isNotEmpty)
              .toList();
          if (nameParts.length >= 2 &&
              nameParts[0].isNotEmpty &&
              nameParts[1].isNotEmpty) {
            initials =
                nameParts[0].substring(0, 1).toUpperCase() +
                nameParts[1].substring(0, 1).toUpperCase();
          } else if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
            initials = nameParts[0].substring(0, 1).toUpperCase();
          } else {
            initials = 'ME';
          }
        } else if (user?.username != null && user!.username.isNotEmpty) {
          initials = user.username.substring(0, 1).toUpperCase();
        } else {
          initials = 'ME';
        }
      } else {
        // For other users, show first letter of user ID
        initials = userId.isNotEmpty
            ? userId.substring(0, 1).toUpperCase()
            : 'U';
      }

      return _buildAvatar(initials, index, isCurrentUser);
    }).toList();
  }

  Widget _buildAvatar(String initials, int colorIndex, bool isCurrentUser) {
    final colors = [
      Color(0xFFEF4444),
      Color(0xFF3B82F6),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
    ];

    final color = colors[colorIndex % colors.length];

    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          initials.length > 2 ? initials.substring(0, 2) : initials,
          style: TextStyle(
            color: color,
            fontSize: initials.length > 1 ? 12 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
