import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:intl/intl.dart';

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

  String _selectedPriority = 'medium';
  String? _selectedCategory;
  DateTime? _selectedDueDate;
  bool _remindMe = false;
  Team? _selectedTeam;
  List<String> _selectedAssignees = [];

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
      _selectedAssignees = widget.task!.assignedUserIds ?? [];
    } else {
      // Default category for new task
      _selectedCategory = 'design';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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
        setState(() {
          _selectedDueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Today';
    return DateFormat('MMM d, h:mm a').format(date);
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
        assignedUserIds: _selectedAssignees.isEmpty ? null : _selectedAssignees,
        status: widget.task?.status ?? 'pending',
        progress: widget.task?.progress ?? 0,
        tags: widget.task?.tags,
        attachments: widget.task?.attachments,
        subtasks: widget.task?.subtasks,
        createdAt: widget.task?.createdAt,
        updatedAt: DateTime.now(),
      );

      if (widget.task == null) {
        taskState.addTask(task);
      } else {
        taskState.updateTask(task);
      }

      Navigator.pop(context);
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parent/Team selector (optional)
              if (_selectedTeam != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.spacing12,
                    vertical: AppConstant.spacing8,
                  ),
                  margin: EdgeInsets.only(bottom: AppConstant.spacing16),
                  decoration: BoxDecoration(
                    color: AppConstant.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        size: 16,
                        color: AppConstant.textSecondary,
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        'Parent: ${_selectedTeam!.name}',
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

              // Title field
              Text(
                'What needs to be done?',
                style: TextStyle(
                  color: AppConstant.textSecondary.withValues(alpha: 0.6),
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              SizedBox(height: AppConstant.spacing8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: AppConstant.textPrimary, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter task title...',
                  hintStyle: TextStyle(
                    color: AppConstant.textSecondary.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),

              SizedBox(height: AppConstant.spacing32),

              // Description field
              Container(
                padding: EdgeInsets.all(AppConstant.spacing16),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                  border: Border.all(
                    color: AppConstant.textSecondary.withValues(alpha: 0.1),
                  ),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(
                    color: AppConstant.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add more details...',
                    hintStyle: TextStyle(
                      color: AppConstant.textSecondary,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
              ),

              SizedBox(height: AppConstant.spacing24),

              // Due Date and Remind Me
              Container(
                padding: EdgeInsets.all(AppConstant.spacing20),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                ),
                child: Column(
                  children: [
                    // Due Date
                    InkWell(
                      onTap: _selectDueDate,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppConstant.spacing12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppConstant.errorRed.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: AppConstant.errorRed,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: AppConstant.spacing16),
                            Expanded(
                              child: Text(
                                'Due Date',
                                style: TextStyle(
                                  color: AppConstant.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _formatDate(_selectedDueDate),
                                  style: TextStyle(
                                    color: AppConstant.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: AppConstant.spacing8),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppConstant.textSecondary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: AppConstant.textSecondary.withValues(alpha: 0.1),
                    ),
                    // Remind Me
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppConstant.spacing12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppConstant.warningOrange.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: AppConstant.warningOrange,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: AppConstant.spacing16),
                          Expanded(
                            child: Text(
                              'Remind me',
                              style: TextStyle(
                                color: AppConstant.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Switch(
                            value: _remindMe,
                            onChanged: (value) {
                              setState(() {
                                _remindMe = value;
                              });
                            },
                            activeThumbColor: AppConstant.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppConstant.spacing24),

              // Priority
              Container(
                padding: EdgeInsets.all(AppConstant.spacing20),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppConstant.primaryBlue.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.flag,
                            color: AppConstant.primaryBlue,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: AppConstant.spacing16),
                        Text(
                          'Priority',
                          style: TextStyle(
                            color: AppConstant.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstant.spacing16),
                    Row(
                      children: [
                        Expanded(child: _buildPriorityButton('Low', 'low')),
                        SizedBox(width: AppConstant.spacing12),
                        Expanded(
                          child: _buildPriorityButton('Medium', 'medium'),
                        ),
                        SizedBox(width: AppConstant.spacing12),
                        Expanded(child: _buildPriorityButton('High', 'high')),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppConstant.spacing24),

              // Assign To
              Container(
                padding: EdgeInsets.all(AppConstant.spacing20),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFF8B5CF6).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.people,
                        color: Color(0xFF8B5CF6),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing16),
                    Expanded(
                      child: Text(
                        'Assign To',
                        style: TextStyle(
                          color: AppConstant.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (_selectedAssignees.isNotEmpty) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstant.primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ME',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          _buildAssigneeAvatar('A', 0),
                        ],
                        SizedBox(width: AppConstant.spacing8),
                        GestureDetector(
                          onTap: () {
                            // TODO: Show assignee picker
                            setState(() {
                              if (_selectedAssignees.isEmpty) {
                                _selectedAssignees = ['user1'];
                              }
                            });
                          },
                          child: Icon(
                            Icons.add_circle_outline,
                            color: AppConstant.textSecondary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppConstant.spacing24),

              // Category
              Container(
                padding: EdgeInsets.all(AppConstant.spacing20),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xFFEC4899).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.label,
                            color: Color(0xFFEC4899),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: AppConstant.spacing16),
                        Text(
                          'Category',
                          style: TextStyle(
                            color: AppConstant.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppConstant.spacing16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: TaskCategory.all.map((category) {
                          return _buildCategoryButton(category);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Team Selection (optional)
              SizedBox(height: AppConstant.spacing24),
              Consumer<TeamState>(
                builder: (context, teamState, _) {
                  return Container(
                    padding: EdgeInsets.all(AppConstant.spacing20),
                    decoration: BoxDecoration(
                      color: AppConstant.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppConstant.borderRadius12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppConstant.successGreen.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.group,
                            color: AppConstant.successGreen,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: AppConstant.spacing16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Team',
                                style: TextStyle(
                                  color: AppConstant.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (_selectedTeam != null)
                                Text(
                                  _selectedTeam!.name,
                                  style: TextStyle(
                                    color: AppConstant.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Show team picker
                          },
                          child: Text(
                            _selectedTeam == null ? 'Select' : 'Change',
                            style: TextStyle(
                              color: AppConstant.primaryBlue,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String label, String value) {
    final isSelected = _selectedPriority == value;
    Color color;

    switch (value) {
      case 'high':
        color = AppConstant.errorRed;
        break;
      case 'medium':
        color = AppConstant.primaryBlue;
        break;
      case 'low':
        color = AppConstant.successGreen;
        break;
      default:
        color = AppConstant.textSecondary;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppConstant.spacing12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? color
                : AppConstant.textSecondary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? color : AppConstant.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(TaskCategory category) {
    final isSelected = _selectedCategory == category.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category.id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: AppConstant.spacing12),
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing16,
          vertical: AppConstant.spacing12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? category.color
                : AppConstant.textSecondary.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              color: isSelected ? category.color : AppConstant.textSecondary,
              size: 20,
            ),
            SizedBox(width: AppConstant.spacing8),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? category.color : AppConstant.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssigneeAvatar(String initial, int index) {
    final colors = [Color(0xFF3B82F6), Color(0xFF10B981), Color(0xFFF59E0B)];

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: colors[index % colors.length].withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(color: colors[index % colors.length], width: 2),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colors[index % colors.length],
          ),
        ),
      ),
    );
  }
}
