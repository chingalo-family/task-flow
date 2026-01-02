import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/components/components.dart';

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

  String _priority = 'medium';
  String? _assignedToUserId;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstant.defaultPadding),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(height: AppConstant.defaultPadding),

                // Title
                InputField(
                  controller: _titleController,
                  hintText: 'Enter task title',
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Description
                InputField(
                  controller: _descriptionController,
                  hintText: 'Enter task description',
                  icon: Icons.description,
                  labelText: 'Description (Optional)',
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                SizedBox(height: 16),

                // Priority
                Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildPriorityChip('high', 'High', AppConstant.errorRed),
                    SizedBox(width: 8),
                    _buildPriorityChip(
                      'medium',
                      'Medium',
                      AppConstant.warningOrange,
                    ),
                    SizedBox(width: 8),
                    _buildPriorityChip('low', 'Low', AppConstant.successGreen),
                  ],
                ),
                SizedBox(height: 16),

                // Assign to team member
                Consumer<UserListState>(
                  builder: (context, userListState, child) {
                    final teamMembers = userListState.getUsersByIds(
                      widget.team.memberIds ?? [],
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assign To (Optional)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConstant.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String?>(
                          initialValue: _assignedToUserId,
                          dropdownColor: AppConstant.cardBackground,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppConstant.darkBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstant.borderRadius12,
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          hint: Text(
                            'Select team member',
                            style: TextStyle(color: AppConstant.textSecondary),
                          ),
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text(
                                'Unassigned',
                                style: TextStyle(
                                  color: AppConstant.textSecondary,
                                ),
                              ),
                            ),
                            ...teamMembers.map((member) {
                              return DropdownMenuItem<String>(
                                value: member.id,
                                child: Text(
                                  member.fullName ?? member.username,
                                  style: TextStyle(
                                    color: AppConstant.textPrimary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _assignedToUserId = value;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),

                // Due Date
                InkWell(
                  onTap: _selectDueDate,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppConstant.darkBackground,
                      borderRadius: BorderRadius.circular(
                        AppConstant.borderRadius12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppConstant.textSecondary,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _dueDate == null
                                ? 'Set Due Date (Optional)'
                                : 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                            style: TextStyle(
                              color: _dueDate == null
                                  ? AppConstant.textSecondary
                                  : AppConstant.textPrimary,
                            ),
                          ),
                        ),
                        if (_dueDate != null)
                          IconButton(
                            onPressed: () => setState(() => _dueDate = null),
                            icon: Icon(Icons.clear, size: 20),
                            color: AppConstant.textSecondary,
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppConstant.defaultPadding * 1.5),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppConstant.textSecondary),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _createTask,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppConstant.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Create Task'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String value, String label, Color color) {
    final isSelected = _priority == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _priority = value),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.2)
                : AppConstant.darkBackground,
            borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? color : AppConstant.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppConstant.primaryBlue,
              surface: AppConstant.cardBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  void _createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final taskState = context.read<TaskState>();
    final teamState = context.read<TeamState>();
    final userListState = context.read<UserListState>();

    final assignedUser = _assignedToUserId != null
        ? userListState.getUserById(_assignedToUserId!)
        : null;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      status: 'pending',
      priority: _priority,
      teamId: widget.team.id,
      teamName: widget.team.name,
      assignedToUserId: _assignedToUserId,
      assignedToUsername: assignedUser?.fullName ?? assignedUser?.username,
      dueDate: _dueDate,
      progress: 0,
    );

    await taskState.addTask(newTask);
    await teamState.addTaskToTeam(widget.team.id, newTask.id);

    if (mounted) {
      Navigator.pop(context, true); // Return true to indicate success
    }
  }
}
