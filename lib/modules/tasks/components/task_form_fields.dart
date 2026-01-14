import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/utils/app_modal_util.dart';
import 'package:intl/intl.dart';

class TaskFormFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String selectedPriority;
  final String? selectedCategory;
  final DateTime? selectedDueDate;
  final bool remindMe;
  final Team? selectedTeam;
  final List<String> selectedAssignees;
  final List<String> selectedTags; // Added tags support
  final Function(String) onPriorityChanged;
  final Function(String) onCategoryChanged;
  final Function(DateTime) onDueDateChanged;
  final Function(bool) onRemindMeChanged;
  final Function(Team?) onTeamChanged;
  final Function(String?) onAssigneeChanged; // Changed to single assignee
  final Function(List<String>) onTagsChanged; // Added tags callback
  final bool hideTeamAndAssignee; // Hide team and assignee fields
  final bool isSubtask; // Indicates if this is a subtask form
  final bool lockTeam; // Lock team selection (disable interaction)

  const TaskFormFields({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.selectedPriority,
    required this.selectedCategory,
    required this.selectedDueDate,
    required this.remindMe,
    required this.selectedTeam,
    required this.selectedAssignees,
    required this.selectedTags, // Added
    required this.onPriorityChanged,
    required this.onCategoryChanged,
    required this.onDueDateChanged,
    required this.onRemindMeChanged,
    required this.onTeamChanged,
    required this.onAssigneeChanged, // Changed to single assignee
    required this.onTagsChanged, // Added
    this.hideTeamAndAssignee = false,
    this.isSubtask = false,
    this.lockTeam = false,
  });

  @override
  State<TaskFormFields> createState() => _TaskFormFieldsState();
}

class _TaskFormFieldsState extends State<TaskFormFields> {
  final _customTagController = TextEditingController();

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.selectedDueDate ?? DateTime.now(),
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
        final selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        widget.onDueDateChanged(selectedDateTime);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Today';
    return DateFormat('MMM d, h:mm a').format(date);
  }

  void _showTeamPicker() {
    final teamState = Provider.of<TeamState>(context, listen: false);
    final teams = teamState.teams;

    AppModalUtil.showActionSheetModal(
      context: context,
      maxHeightRatio: 0.85,
      initialHeightRatio: 0.85,
      actionSheetContainer: _TeamPickerContainer(
        teams: teams,
        selectedTeam: widget.selectedTeam,
        onTeamSelected: (team) {
          widget.onTeamChanged(team);
          widget.onAssigneeChanged(null); // Clear assignee when team changes
          Navigator.pop(context);
        },
        onClearTeam: () {
          widget.onTeamChanged(null);
          widget.onAssigneeChanged(null); // Clear assignee when team is cleared
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showUserPicker() {
    final userState = Provider.of<UserState>(context, listen: false);
    final teamState = Provider.of<TeamState>(context, listen: false);

    // Get team members if a team is selected
    final memberIds = widget.selectedTeam != null
        ? teamState.getTeamById(widget.selectedTeam!.id)?.memberIds ?? []
        : <String>[];

    if (memberIds.isEmpty) {
      // Show a message if no team is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a team first'),
          backgroundColor: AppConstant.textSecondary,
        ),
      );
      return;
    }

    AppModalUtil.showActionSheetModal(
      context: context,
      maxHeightRatio: 0.85,
      initialHeightRatio: 0.85,
      actionSheetContainer: _UserPickerContainer(
        memberIds: memberIds,
        selectedUserId: widget.selectedAssignees.isNotEmpty
            ? widget.selectedAssignees.first
            : null,
        currentUserId: userState.currentUser?.id.toString() ?? 'current_user',
        onUserSelected: (userId) {
          widget.onAssigneeChanged(userId);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final currentUserId =
        userState.currentUser?.id.toString() ?? 'current_user';

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parent/Team selector (optional) - only show if team is selected
          if (widget.selectedTeam != null && !widget.hideTeamAndAssignee)
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
                    'Parent: ${widget.selectedTeam!.name}',
                    style: TextStyle(
                      color: AppConstant.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          // Title field
          Text(
            widget.isSubtask
                ? 'What is the subtask?'
                : 'What needs to be done?',
            style: TextStyle(
              color: AppConstant.textPrimary.withValues(alpha: 0.6),
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          SizedBox(height: AppConstant.spacing8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing16,
              vertical: AppConstant.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppConstant.cardBackground,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              border: Border.all(
                color: AppConstant.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: TextFormField(
              controller: widget.titleController,
              style: TextStyle(color: AppConstant.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.isSubtask
                    ? 'Enter subtask title...'
                    : 'Enter task title...',
                hintStyle: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              maxLines: null,
            ),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Description field with icon
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing16,
              vertical: AppConstant.spacing12,
            ),
            decoration: BoxDecoration(
              color: AppConstant.cardBackground,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              border: Border.all(
                color: AppConstant.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.subject, color: AppConstant.textSecondary, size: 20),
                SizedBox(width: AppConstant.spacing12),
                Expanded(
                  child: TextFormField(
                    controller: widget.descriptionController,
                    style: TextStyle(
                      color: AppConstant.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add a description...',
                      hintStyle: TextStyle(
                        color: AppConstant.textSecondary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Due date and reminder
          Container(
            padding: EdgeInsets.all(AppConstant.spacing16),
            decoration: BoxDecoration(
              color: AppConstant.cardBackground,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              border: Border.all(
                color: AppConstant.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                // Due date
                GestureDetector(
                  onTap: _selectDueDate,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: AppConstant.spacing12),
                      Expanded(
                        child: Text(
                          'Due Date',
                          style: TextStyle(
                            color: AppConstant.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(widget.selectedDueDate),
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppConstant.textSecondary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppConstant.spacing16),
                Divider(
                  color: AppConstant.textSecondary.withValues(alpha: 0.1),
                  height: 1,
                ),
                SizedBox(height: AppConstant.spacing16),
                // Remind me
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Text(
                        'Remind me',
                        style: TextStyle(
                          color: AppConstant.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: widget.remindMe,
                      onChanged: widget.onRemindMeChanged,
                      activeThumbColor: AppConstant.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstant.spacing24),
          // Category
          Text(
            'Category',
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppConstant.spacing12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TaskCategory.all.map((category) {
                final isSelected = widget.selectedCategory == category.id;
                return Padding(
                  padding: EdgeInsets.only(right: AppConstant.spacing12),
                  child: GestureDetector(
                    onTap: () => widget.onCategoryChanged(category.id),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? category.color.withValues(alpha: 0.2)
                            : AppConstant.cardBackground,
                        borderRadius: BorderRadius.circular(
                          AppConstant.borderRadius12,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? category.color
                              : AppConstant.textSecondary.withValues(
                                  alpha: 0.1,
                                ),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category.icon,
                            color: isSelected
                                ? category.color
                                : AppConstant.textSecondary,
                            size: 28,
                          ),
                          SizedBox(height: AppConstant.spacing8),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected
                                  ? category.color
                                  : AppConstant.textSecondary,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Priority
          Container(
            padding: EdgeInsets.all(AppConstant.spacing16),
            decoration: BoxDecoration(
              color: AppConstant.cardBackground,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              border: Border.all(
                color: AppConstant.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: AppConstant.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Text(
                      'Priority',
                      style: TextStyle(
                        color: AppConstant.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstant.spacing16),
                Row(
                  children: [
                    Expanded(
                      child: _PriorityButton(
                        label: 'Low',
                        isSelected:
                            widget.selectedPriority ==
                            TaskConstants.priorityLow,
                        color: AppConstant.successGreen,
                        onTap: () =>
                            widget.onPriorityChanged(TaskConstants.priorityLow),
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: _PriorityButton(
                        label: 'Medium',
                        isSelected:
                            widget.selectedPriority ==
                            TaskConstants.priorityMedium,
                        color: Colors.orange,
                        onTap: () => widget.onPriorityChanged(
                          TaskConstants.priorityMedium,
                        ),
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: _PriorityButton(
                        label: 'High',
                        isSelected:
                            widget.selectedPriority ==
                            TaskConstants.priorityHigh,
                        color: Colors.red,
                        onTap: () => widget.onPriorityChanged(
                          TaskConstants.priorityHigh,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Team and Assign To - only show if not hidden
          if (!widget.hideTeamAndAssignee) ...[
            // Team selection
            Opacity(
              opacity: widget.lockTeam ? 0.6 : 1.0,
              child: GestureDetector(
                onTap: widget.lockTeam ? null : _showTeamPicker,
                child: Container(
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
                    children: [
                      Icon(
                        widget.lockTeam ? Icons.lock : Icons.group,
                        color: AppConstant.textSecondary,
                        size: 20,
                      ),
                      SizedBox(width: AppConstant.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Team',
                                  style: TextStyle(
                                    color: AppConstant.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (widget.lockTeam) ...[
                                  SizedBox(width: 8),
                                  Text(
                                    '(Fixed)',
                                    style: TextStyle(
                                      color: AppConstant.textSecondary,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (widget.selectedTeam != null)
                              Text(
                                widget.selectedTeam!.name,
                                style: TextStyle(
                                  color: AppConstant.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!widget.lockTeam)
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppConstant.textSecondary,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: AppConstant.spacing16),

            // Assign To
            GestureDetector(
              onTap: widget.selectedTeam != null ? _showUserPicker : null,
              child: Container(
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
                  children: [
                    Icon(
                      Icons.person,
                      color: AppConstant.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Text(
                        'Assign To',
                        style: TextStyle(
                          color: AppConstant.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Show avatar for single assignee
                    if (widget.selectedAssignees.isNotEmpty)
                      _buildAssigneeAvatar(
                        widget.selectedAssignees.first,
                        currentUserId,
                      ),
                    SizedBox(width: AppConstant.spacing8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppConstant.textSecondary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppConstant.spacing24),
          ],

          // Tags Section
          Text(
            'Tags',
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppConstant.spacing12),

          // Selected tags display
          if (widget.selectedTags.isNotEmpty)
            Wrap(
              spacing: AppConstant.spacing8,
              runSpacing: AppConstant.spacing8,
              children: widget.selectedTags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstant.primaryBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstant.primaryBlue,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tag,
                        style: TextStyle(
                          color: AppConstant.primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          final updatedTags = List<String>.from(
                            widget.selectedTags,
                          );
                          updatedTags.remove(tag);
                          widget.onTagsChanged(updatedTags);
                        },
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: AppConstant.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

          if (widget.selectedTags.isNotEmpty)
            SizedBox(height: AppConstant.spacing12),

          // Common tags suggestions
          Text(
            'Common Tags',
            style: TextStyle(color: AppConstant.textSecondary, fontSize: 14),
          ),
          SizedBox(height: AppConstant.spacing8),
          Wrap(
            spacing: AppConstant.spacing8,
            runSpacing: AppConstant.spacing8,
            children: TaskConstants.commonTags.map((tag) {
              final isSelected = widget.selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  final updatedTags = List<String>.from(widget.selectedTags);
                  if (isSelected) {
                    updatedTags.remove(tag);
                  } else {
                    updatedTags.add(tag);
                  }
                  widget.onTagsChanged(updatedTags);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppConstant.primaryBlue.withValues(alpha: 0.1)
                        : AppConstant.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppConstant.primaryBlue
                          : AppConstant.textSecondary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected
                          ? AppConstant.primaryBlue
                          : AppConstant.textSecondary,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: AppConstant.spacing16),

          // Custom tag input
          Text(
            'Add Custom Tag',
            style: TextStyle(color: AppConstant.textSecondary, fontSize: 14),
          ),
          SizedBox(height: AppConstant.spacing8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.spacing12,
                    vertical: AppConstant.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstant.cardBackground,
                    borderRadius: BorderRadius.circular(
                      AppConstant.borderRadius12,
                    ),
                    border: Border.all(
                      color: AppConstant.textSecondary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    controller: _customTagController,
                    style: TextStyle(
                      color: AppConstant.textPrimary,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type custom tag and press Enter',
                      hintStyle: TextStyle(
                        color: AppConstant.textSecondary,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        final customTag = value.trim().toLowerCase();
                        if (!widget.selectedTags.contains(customTag)) {
                          final updatedTags = List<String>.from(
                            widget.selectedTags,
                          );
                          updatedTags.add(customTag);
                          widget.onTagsChanged(updatedTags);
                        }
                        // Clear the input field after submission
                        _customTagController.clear();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppConstant.spacing24),
        ],
      ),
    );
  }

  Widget _buildAssigneeAvatar(String userId, String currentUserId) {
    final userListState = Provider.of<UserListState>(context);
    final user = userListState.getUserById(userId);
    final isCurrentUser = userId == currentUserId;

    String initials;
    if (isCurrentUser) {
      initials = 'ME';
    } else if (user != null && user.fullName!.isNotEmpty) {
      initials = user.fullName!.length >= 2
          ? user.fullName!.substring(0, 2).toUpperCase()
          : user.fullName!.substring(0, 1).toUpperCase();
    } else if (userId.isNotEmpty) {
      initials = userId.length >= 2
          ? userId.substring(0, 2).toUpperCase()
          : userId.substring(0, 1).toUpperCase();
    } else {
      initials = '?';
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppConstant.primaryBlue
            : AppConstant.successGreen,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PriorityButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _PriorityButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppConstant.spacing12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : AppConstant.darkBackground,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
          border: Border.all(
            color: isSelected
                ? color
                : AppConstant.textSecondary.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? color : AppConstant.textSecondary,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// Team Picker Container
class _TeamPickerContainer extends StatefulWidget {
  final List<Team> teams;
  final Team? selectedTeam;
  final Function(Team) onTeamSelected;
  final VoidCallback onClearTeam;

  const _TeamPickerContainer({
    required this.teams,
    required this.selectedTeam,
    required this.onTeamSelected,
    required this.onClearTeam,
  });

  @override
  State<_TeamPickerContainer> createState() => _TeamPickerContainerState();
}

class _TeamPickerContainerState extends State<_TeamPickerContainer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort teams alphabetically by name
    final sortedTeams = List<Team>.from(widget.teams)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    // Filter teams based on search query
    final filteredTeams = sortedTeams.where((team) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return team.name.toLowerCase().contains(query) ||
          (team.description?.toLowerCase().contains(query) ?? false);
    }).toList();

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
          // Search field
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing16,
              vertical: AppConstant.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppConstant.cardBackground,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              border: Border.all(
                color: AppConstant.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppConstant.textSecondary, size: 20),
                SizedBox(width: AppConstant.spacing12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: AppConstant.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search teams...',
                      hintStyle: TextStyle(color: AppConstant.textSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: AppConstant.textSecondary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          if (widget.selectedTeam != null) ...[
            ListTile(
              leading: Icon(Icons.clear, color: Colors.red),
              title: Text(
                'No Team (Personal Task)',
                style: TextStyle(color: AppConstant.textPrimary),
              ),
              onTap: widget.onClearTeam,
            ),
            Divider(color: AppConstant.textSecondary.withValues(alpha: 0.2)),
          ],
          ...filteredTeams.map((team) {
            final isSelected = widget.selectedTeam?.id == team.id;
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
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: team.description != null
                  ? Text(
                      team.description!,
                      style: TextStyle(color: AppConstant.textSecondary),
                    )
                  : null,
              trailing: isSelected
                  ? Icon(Icons.check, color: AppConstant.primaryBlue)
                  : null,
              onTap: () => widget.onTeamSelected(team),
            );
          }),
        ],
      ),
    );
  }
}

// User Picker Container - Single Selection
class _UserPickerContainer extends StatefulWidget {
  final List<String> memberIds;
  final String? selectedUserId; // Changed to single selection
  final String currentUserId;
  final Function(String?) onUserSelected; // Changed to single selection

  const _UserPickerContainer({
    required this.memberIds,
    required this.selectedUserId,
    required this.currentUserId,
    required this.onUserSelected,
  });

  @override
  State<_UserPickerContainer> createState() => _UserPickerContainerState();
}

class _UserPickerContainerState extends State<_UserPickerContainer> {
  String? _tempSelectedUser; // Changed to single selection
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedUser = widget.selectedUserId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userListState = Provider.of<UserListState>(context);

    // Make member list unique
    final uniqueMemberIds = widget.memberIds.toSet().toList();

    // Sort members alphabetically by name
    final sortedMemberIds = List<String>.from(uniqueMemberIds)
      ..sort((a, b) {
        final userA = userListState.getUserById(a);
        final userB = userListState.getUserById(b);
        final nameA = userA?.fullName ?? 'User $a';
        final nameB = userB?.fullName ?? 'User $b';
        return nameA.toLowerCase().compareTo(nameB.toLowerCase());
      });

    // Filter members based on search query
    final filteredMemberIds = sortedMemberIds.where((memberId) {
      if (_searchQuery.isEmpty) return true;
      final user = userListState.getUserById(memberId);
      final name = user?.fullName ?? 'User $memberId';
      final email = user?.email ?? '';
      final query = _searchQuery.toLowerCase();
      return name.toLowerCase().contains(query) ||
          email.toLowerCase().contains(query);
    }).toList();

    return Container(
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Team Member',
            style: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          // Search field
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing16,
              vertical: AppConstant.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppConstant.cardBackground,
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              border: Border.all(
                color: AppConstant.textSecondary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: AppConstant.textSecondary, size: 20),
                SizedBox(width: AppConstant.spacing12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: AppConstant.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      hintStyle: TextStyle(color: AppConstant.textSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: AppConstant.textSecondary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          // Option to clear selection
          if (_tempSelectedUser != null) ...[
            ListTile(
              leading: Icon(Icons.clear, color: Colors.red),
              title: Text(
                'Unassign',
                style: TextStyle(color: AppConstant.textPrimary),
              ),
              onTap: () {
                setState(() {
                  _tempSelectedUser = null;
                });
                widget.onUserSelected(null);
              },
            ),
            Divider(color: AppConstant.textSecondary.withValues(alpha: 0.2)),
          ],
          if (filteredMemberIds.isEmpty)
            Text(
              _searchQuery.isEmpty
                  ? 'No team members available'
                  : 'No members found',
              style: TextStyle(color: AppConstant.textSecondary),
            )
          else
            ...filteredMemberIds.map((memberId) {
              final user = userListState.getUserById(memberId);
              final isCurrentUser = memberId == widget.currentUserId;
              return RadioListTile<String>(
                value: memberId,
                groupValue: _tempSelectedUser,
                onChanged: (String? value) {
                  setState(() {
                    _tempSelectedUser = value;
                  });
                  widget.onUserSelected(value);
                },
                title: Row(
                  children: [
                    Text(
                      user?.fullName ?? 'User $memberId',
                      style: TextStyle(color: AppConstant.textPrimary),
                    ),
                    if (isCurrentUser) ...[
                      SizedBox(width: AppConstant.spacing8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstant.primaryBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ME',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                activeColor: AppConstant.primaryBlue,
              );
            }),
        ],
      ),
    );
  }
}
