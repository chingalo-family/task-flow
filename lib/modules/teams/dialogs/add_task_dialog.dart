import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/tasks/components/task_form_fields.dart';

class AddTaskDialog extends StatefulWidget {
  final Team team;

  const AddTaskDialog({super.key, required this.team});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPriority = TaskConstants.priorityMedium;
  String? _selectedCategory;
  DateTime? _selectedDueDate;
  bool _remindMe = false;
  List<String> _selectedAssignees = [];

  @override
  void initState() {
    super.initState();
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
        _selectedAssignees = [currentUserId];
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing24),
      decoration: BoxDecoration(
        color: AppConstant.darkBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstant.borderRadius24),
          topRight: Radius.circular(AppConstant.borderRadius24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Task to ${widget.team.name}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppConstant.textSecondary),
                ),
              ],
            ),
            SizedBox(height: AppConstant.spacing16),

            // Reuse TaskFormFields from task module
            TaskFormFields(
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              selectedPriority: _selectedPriority,
              selectedCategory: _selectedCategory,
              selectedDueDate: _selectedDueDate,
              remindMe: _remindMe,
              selectedTeam: widget.team,
              selectedAssignees: _selectedAssignees,
              onPriorityChanged: (priority) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              onDueDateChanged: (date) {
                setState(() {
                  _selectedDueDate = date;
                });
              },
              onRemindMeChanged: (remind) {
                setState(() {
                  _remindMe = remind;
                });
              },
              onTeamChanged: (team) {
                // Team is locked, so this won't be called
              },
              onAssigneesChanged: (assignees) {
                setState(() {
                  _selectedAssignees = assignees;
                });
              },
              hideTeamAndAssignee: false,
              isSubtask: false,
              lockTeam: true, // Lock team selection in team context
            ),

            SizedBox(height: AppConstant.spacing24),

            // Create Task Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstant.borderRadius12,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Task',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing8),
                    Icon(Icons.check, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final taskState = Provider.of<TaskState>(context, listen: false);

    // Generate a better ID for new tasks
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 1000).toString().padLeft(3, '0');
    final taskId = '$timestamp$random';

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
      teamId: widget.team.id,
      teamName: widget.team.name,
      assignedUserIds: _selectedAssignees.isEmpty ? null : _selectedAssignees,
      status: TaskConstants.statusPending,
      progress: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    taskState.addTask(task);

    // Also add the task to the team
    Provider.of<TeamState>(
      context,
      listen: false,
    ).addTaskToTeam(widget.team.id, taskId);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}
