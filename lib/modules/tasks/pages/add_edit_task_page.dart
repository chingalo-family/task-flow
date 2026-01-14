import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/tasks/components/task_form_fields.dart';

class AddEditTaskPage extends StatefulWidget {
  final Task? task; // If null, we're adding a new task

  const AddEditTaskPage({super.key, this.task});

  @override
  State<AddEditTaskPage> createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPriority = TaskConstants.priorityMedium;
  String? _selectedCategory;
  DateTime? _selectedDueDate;
  bool _remindMe = false;
  Team? _selectedTeam;
  String? _selectedAssignee; // Changed to single assignee

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Editing existing task
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedPriority = widget.task!.priority;
      _selectedCategory = widget.task!.category;
      _selectedDueDate = widget.task!.dueDate;
      _remindMe = widget.task!.remindMe ?? false;
      _selectedAssignee = (widget.task!.assignedUserIds != null && widget.task!.assignedUserIds!.isNotEmpty)
          ? widget.task!.assignedUserIds!.first
          : null;
      _selectedTeam = widget.task!.teamId != null
          ? Team(id: widget.task!.teamId!, name: widget.task!.teamName!)
          : null;
    } else {
      // Default category for new task
      _selectedCategory = TaskCategory.general.id;
      // Default due date to today at 11:59 PM
      final now = DateTime.now();
      _selectedDueDate = DateTime(now.year, now.month, now.day, 23, 59);
      // Default assign to current user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userState = Provider.of<UserState>(context, listen: false);
        final currentUserId =
            userState.currentUser?.id.toString() ?? 'current_user';
        setState(() {
          _selectedAssignee = currentUserId;
        });
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final taskState = Provider.of<TaskState>(context, listen: false);

      // Generate a better ID for new tasks
      String taskId;
      if (widget.task != null) {
        taskId = widget.task!.id;
      } else {
        // Use milliseconds + random suffix for better uniqueness
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final random = (timestamp % 1000).toString().padLeft(3, '0');
        taskId = '$timestamp$random';
      }

      final task = Task(
        id: taskId,
        title: _titleController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _selectedDueDate,
        remindMe: _remindMe,
        teamId: _selectedTeam?.id,
        teamName: _selectedTeam?.name,
        assignedUserIds: _selectedAssignee != null ? [_selectedAssignee!] : null,
        status: widget.task?.status ?? TaskConstants.statusPending,
        progress: widget.task?.progress ?? 0,
        tags: widget.task?.tags,
        attachments: widget.task?.attachments,
        subtasks: widget.task?.subtasks,
        createdAt: widget.task?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.task == null) {
        taskState.addTask(task);
        Navigator.pop(context);
      } else {
        taskState.updateTask(task);
        // Navigate back to task module home after updating
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppConstant.textPrimary, fontSize: 16),
          ),
        ),
        leadingWidth: 80,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.task == null ? 'New Task' : 'Edit Task',
              style: TextStyle(
                color: AppConstant.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: AppConstant.spacing8),
            Icon(Icons.edit, color: AppConstant.successGreen, size: 20),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveTask,
            child: Text(
              'Save',
              style: TextStyle(
                color: AppConstant.primaryBlue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstant.spacing24),
        child: TaskFormFields(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          selectedPriority: _selectedPriority,
          selectedCategory: _selectedCategory,
          selectedDueDate: _selectedDueDate,
          remindMe: _remindMe,
          selectedTeam: _selectedTeam,
          selectedAssignees: _selectedAssignee != null ? [_selectedAssignee!] : [],
          onPriorityChanged: (value) {
            setState(() {
              _selectedPriority = value;
            });
          },
          onCategoryChanged: (value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          onDueDateChanged: (value) {
            setState(() {
              _selectedDueDate = value;
            });
          },
          onRemindMeChanged: (value) {
            setState(() {
              _remindMe = value;
            });
          },
          onTeamChanged: (value) {
            setState(() {
              _selectedTeam = value;
              // Clear assignee except current user when team is cleared
              if (value == null) {
                final userState = Provider.of<UserState>(
                  context,
                  listen: false,
                );
                final currentUserId =
                    userState.currentUser?.id.toString() ?? 'current_user';
                _selectedAssignee = currentUserId;
              }
            });
          },
          onAssigneeChanged: (value) {
            setState(() {
              _selectedAssignee = value;
            });
          },
          hideTeamAndAssignee: false, // Show all fields for main task form
          isSubtask: false, // This is not a subtask
        ),
      ),
    );
  }
}
