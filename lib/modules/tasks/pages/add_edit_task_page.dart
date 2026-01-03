import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/utils/app_modal_util.dart';
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
      _selectedTeam = widget.task!.teamId != null
          ? Team(
              id: widget.task!.teamId!,
              name: widget.task!.teamName!,
            )
          : null;
    } else {
      // Default category for new task
      _selectedCategory = 'design';
      // Default due date to today at 11:59 PM
      final now = DateTime.now();
      _selectedDueDate = DateTime(now.year, now.month, now.day, 23, 59);
      // Default assign to current user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userState = Provider.of<UserState>(context, listen: false);
        final currentUserId = userState.currentUser?.id.toString() ?? 'current_user';
        setState(() {
          _selectedAssignees = [currentUserId];
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.subject,
                        color: AppConstant.textSecondary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
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
                  ],
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

              // Team Selection (optional)
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
                            _showTeamPicker(context);
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
                          Consumer<UserState>(
                            builder: (context, userState, _) {
                              return Container(
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
                              );
                            },
                          ),
                          SizedBox(width: 8),
                          if (_selectedAssignees.length > 1)
                            _buildAssigneeAvatar('A', 0),
                        ],
                        SizedBox(width: AppConstant.spacing8),
                        if (_selectedTeam != null)
                          GestureDetector(
                            onTap: () {
                              _showUserPicker(context);
                            },
                            child: Icon(
                              Icons.add_circle_outline,
                              color: AppConstant.primaryBlue,
                              size: 24,
                            ),
                          )
                        else
                          Icon(
                            Icons.add_circle_outline,
                            color: AppConstant.textSecondary.withValues(
                              alpha: 0.3,
                            ),
                            size: 24,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showTeamPicker(BuildContext context) async {
    final teamState = Provider.of<TeamState>(context, listen: false);
    
    await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: _TeamPickerContainer(
        teams: teamState.teams,
        selectedTeam: _selectedTeam,
        onTeamSelected: (team) {
          setState(() {
            _selectedTeam = team;
          });
          Navigator.pop(context);
        },
        onClearSelection: () {
          setState(() {
            _selectedTeam = null;
            // Clear assignees except current user
            final userState =
                Provider.of<UserState>(context, listen: false);
            final currentUserId =
                userState.currentUser?.id.toString() ?? 'current_user';
            _selectedAssignees = [currentUserId];
          });
          Navigator.pop(context);
        },
      ),
      maxHeightRatio: 0.7,
      initialHeightRatio: 0.5,
    );
  }

  void _showUserPicker(BuildContext context) async {
    if (_selectedTeam == null) return;

    final teamState = Provider.of<TeamState>(context, listen: false);
    final team = teamState.getTeamById(_selectedTeam!.id);
    
    if (team == null || team.memberIds == null || team.memberIds!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No team members available'),
          backgroundColor: AppConstant.errorRed,
        ),
      );
      return;
    }

    await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: _UserPickerContainer(
        team: team,
        selectedAssignees: _selectedAssignees,
        onAssigneesChanged: (updatedAssignees) {
          setState(() {
            _selectedAssignees = updatedAssignees;
          });
        },
      ),
      maxHeightRatio: 0.7,
      initialHeightRatio: 0.5,
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

// Team Picker Container Widget
class _TeamPickerContainer extends StatelessWidget {
  final List<Team> teams;
  final Team? selectedTeam;
  final Function(Team) onTeamSelected;
  final VoidCallback onClearSelection;

  const _TeamPickerContainer({
    required this.teams,
    required this.selectedTeam,
    required this.onTeamSelected,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Team',
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          if (teams.isEmpty)
            Padding(
              padding: EdgeInsets.all(AppConstant.spacing24),
              child: Text(
                'No teams available',
                style: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 14,
                ),
              ),
            )
          else
            ...teams.map((team) {
              final isSelected = selectedTeam?.id == team.id;
              return ListTile(
                leading: Icon(
                  Icons.group,
                  color: isSelected
                      ? AppConstant.primaryBlue
                      : AppConstant.textSecondary,
                ),
                title: Text(
                  team.name,
                  style: TextStyle(
                    color: isSelected
                        ? AppConstant.primaryBlue
                        : AppConstant.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: team.description != null
                    ? Text(
                        team.description!,
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 12,
                        ),
                      )
                    : null,
                trailing: isSelected
                    ? Icon(Icons.check, color: AppConstant.primaryBlue)
                    : null,
                onTap: () => onTeamSelected(team),
              );
            }),
          if (selectedTeam != null) ...[
            Divider(color: AppConstant.textSecondary.withValues(alpha: 0.2)),
            ListTile(
              leading: Icon(Icons.clear, color: AppConstant.errorRed),
              title: Text(
                'Clear Selection',
                style: TextStyle(color: AppConstant.errorRed),
              ),
              onTap: onClearSelection,
            ),
          ],
        ],
      ),
    );
  }
}

// User Picker Container Widget
class _UserPickerContainer extends StatefulWidget {
  final Team team;
  final List<String> selectedAssignees;
  final Function(List<String>) onAssigneesChanged;

  const _UserPickerContainer({
    required this.team,
    required this.selectedAssignees,
    required this.onAssigneesChanged,
  });

  @override
  State<_UserPickerContainer> createState() => _UserPickerContainerState();
}

class _UserPickerContainerState extends State<_UserPickerContainer> {
  late List<String> _localSelectedAssignees;

  @override
  void initState() {
    super.initState();
    _localSelectedAssignees = List.from(widget.selectedAssignees);
  }

  void _toggleAssignee(String userId) {
    setState(() {
      if (_localSelectedAssignees.contains(userId)) {
        _localSelectedAssignees.remove(userId);
      } else {
        _localSelectedAssignees.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Team Members',
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          ...widget.team.memberIds!.map((userId) {
            final isSelected = _localSelectedAssignees.contains(userId);
            final userState = Provider.of<UserState>(context, listen: false);
            final isCurrentUser =
                userId == userState.currentUser?.id.toString();

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isSelected
                    ? AppConstant.primaryBlue
                    : AppConstant.textSecondary.withValues(alpha: 0.3),
                child: Text(
                  userId.length > 0 ? userId.substring(0, 1).toUpperCase() : 'U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                isCurrentUser
                    ? '${userState.currentUser?.fullName ?? userState.currentUser?.username ?? "User"} (Me)'
                    : 'User $userId',
                style: TextStyle(
                  color: AppConstant.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (value) => _toggleAssignee(userId),
                activeColor: AppConstant.primaryBlue,
              ),
              onTap: () => _toggleAssignee(userId),
            );
          }),
          SizedBox(height: AppConstant.spacing16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onAssigneesChanged(_localSelectedAssignees);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstant.primaryBlue,
                padding: EdgeInsets.symmetric(
                  vertical: AppConstant.spacing16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
