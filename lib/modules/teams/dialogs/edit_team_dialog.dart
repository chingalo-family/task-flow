import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/components/components.dart';

class EditTeamDialog extends StatefulWidget {
  final Team team;

  const EditTeamDialog({super.key, required this.team});

  @override
  State<EditTeamDialog> createState() => _EditTeamDialogState();
}

class _EditTeamDialogState extends State<EditTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final _searchController = TextEditingController();

  late String _selectedIcon;
  late Color _selectedColor;
  late Set<String> _selectedMemberIds;
  String _searchQuery = '';

  // Notification preferences
  bool _mentionsEnabled = true;
  bool _taskUpdatesEnabled = true;
  bool _remindersEnabled = false;

  final List<Map<String, dynamic>> _teamIcons = [
    {'key': 'rocket', 'icon': Icons.rocket_launch},
    {'key': 'computer', 'icon': Icons.computer},
    {'key': 'palette', 'icon': Icons.palette},
    {'key': 'campaign', 'icon': Icons.campaign},
    {'key': 'bar_chart', 'icon': Icons.bar_chart},
    {'key': 'shopping_cart', 'icon': Icons.shopping_cart},
  ];

  final List<Color> _teamColors = [
    AppConstant.primaryBlue,
    Color(0xFF9B59B6), // Purple
    Color(0xFF10B981), // Green
    Color(0xFFEF4444), // Red/Pink
    Color(0xFFF59E0B), // Orange
    Color(0xFF06B6D4), // Cyan
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team.name);
    _descriptionController =
        TextEditingController(text: widget.team.description ?? '');
    _selectedIcon = 'rocket';
    _selectedColor = AppConstant.primaryBlue;
    _selectedMemberIds = Set.from(widget.team.memberIds ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Team Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppConstant.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: AppConstant.spacing24),

              // Team Name
              Text(
                'Team Name',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textPrimary,
                ),
              ),
              SizedBox(height: AppConstant.spacing8),
              InputField(
                controller: _nameController,
                hintText: 'e.g. Marketing Squad',
                icon: Icons.group,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppConstant.spacing20),

              // Description
              Text(
                'Description (Optional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textPrimary,
                ),
              ),
              SizedBox(height: AppConstant.spacing8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: TextStyle(color: AppConstant.textPrimary),
                decoration: InputDecoration(
                  hintText: 'What\'s this team about?',
                  hintStyle: TextStyle(color: AppConstant.textSecondary),
                  filled: true,
                  fillColor: AppConstant.cardBackground,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstant.borderRadius12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(AppConstant.spacing16),
                ),
              ),
              SizedBox(height: AppConstant.spacing24),

              // Appearance Section
              Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary,
                ),
              ),
              SizedBox(height: AppConstant.spacing16),

              // Team Icon
              Text(
                'TEAM ICON',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: AppConstant.spacing12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _teamIcons.map((iconData) {
                  final isSelected = _selectedIcon == iconData['key'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconData['key'];
                      });
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      margin: EdgeInsets.only(right: AppConstant.spacing12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _selectedColor
                            : AppConstant.cardBackground,
                        borderRadius:
                            BorderRadius.circular(AppConstant.borderRadius12),
                        border: Border.all(
                          color: isSelected
                              ? _selectedColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        iconData['icon'],
                        color: AppConstant.textPrimary,
                        size: 24,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: AppConstant.spacing20),

              // Team Color
              Text(
                'TEAM COLOR',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstant.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: AppConstant.spacing12),
              Row(
                children: _teamColors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: EdgeInsets.only(right: AppConstant.spacing12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppConstant.textPrimary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: AppConstant.spacing24),

              // Notification Preferences
              Text(
                'Notification Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary,
                ),
              ),
              SizedBox(height: AppConstant.spacing16),

              _buildNotificationToggle(
                icon: Icons.alternate_email,
                title: 'Mentions',
                subtitle: 'When someone mentions you',
                value: _mentionsEnabled,
                onChanged: (value) {
                  setState(() {
                    _mentionsEnabled = value;
                  });
                },
                iconColor: AppConstant.primaryBlue,
              ),
              SizedBox(height: AppConstant.spacing12),

              _buildNotificationToggle(
                icon: Icons.folder_special,
                title: 'Task Updates',
                subtitle: 'Status changes & assignments',
                value: _taskUpdatesEnabled,
                onChanged: (value) {
                  setState(() {
                    _taskUpdatesEnabled = value;
                  });
                },
                iconColor: Color(0xFF9B59B6),
              ),
              SizedBox(height: AppConstant.spacing12),

              _buildNotificationToggle(
                icon: Icons.access_time,
                title: 'Reminders',
                subtitle: 'Daily digest and due dates',
                value: _remindersEnabled,
                onChanged: (value) {
                  setState(() {
                    _remindersEnabled = value;
                  });
                },
                iconColor: AppConstant.successGreen,
              ),
              SizedBox(height: AppConstant.spacing24),

              // Members Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showMemberSelectionSheet(),
                    child: Text(
                      'Manage',
                      style: TextStyle(
                        color: AppConstant.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppConstant.spacing12),

              // Add member input
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstant.spacing16,
                  vertical: AppConstant.spacing12,
                ),
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius:
                      BorderRadius.circular(AppConstant.borderRadius12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: AppConstant.textSecondary,
                      size: 20,
                    ),
                    SizedBox(width: AppConstant.spacing12),
                    Expanded(
                      child: Text(
                        'Add by name or email...',
                        style: TextStyle(
                          color: AppConstant.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showMemberSelectionSheet(),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: AppConstant.primaryBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppConstant.spacing16),

              // Selected members list
              if (_selectedMemberIds.isNotEmpty)
                Consumer<UserListState>(
                  builder: (context, userListState, child) {
                    final selectedMembers = userListState.getUsersByIds(
                      _selectedMemberIds.toList(),
                    );
                    return Column(
                      children: selectedMembers.map((member) {
                        return Container(
                          margin:
                              EdgeInsets.only(bottom: AppConstant.spacing8),
                          padding: EdgeInsets.all(AppConstant.spacing12),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius12,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: AppConstant.primaryBlue,
                                child: Text(
                                  (member.fullName ?? member.username)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppConstant.spacing12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.fullName ?? member.username,
                                      style: TextStyle(
                                        color: AppConstant.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (member.email != null)
                                      Text(
                                        member.email!,
                                        style: TextStyle(
                                          color: AppConstant.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMemberIds.remove(member.id);
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: AppConstant.textSecondary,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              SizedBox(height: AppConstant.spacing24),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
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
                        'Save Changes',
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
              SizedBox(height: AppConstant.spacing16),

              // Offline mode indicator
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 16,
                      color: AppConstant.textSecondary,
                    ),
                    SizedBox(width: AppConstant.spacing8),
                    Text(
                      'OFFLINE MODE ENABLED',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstant.textSecondary,
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

  Widget _buildNotificationToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing16),
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: AppConstant.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstant.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConstant.primaryBlue,
          ),
        ],
      ),
    );
  }

  void _showMemberSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MemberSelectionSheet(
        selectedMemberIds: _selectedMemberIds,
        onMembersSelected: (members) {
          setState(() {
            _selectedMemberIds.clear();
            _selectedMemberIds.addAll(members);
          });
        },
      ),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedTeam = widget.team.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      memberIds: _selectedMemberIds.toList(),
      memberCount: _selectedMemberIds.length,
      updatedAt: DateTime.now(),
    );

    await context.read<TeamState>().updateTeam(updatedTeam);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }
}

class _MemberSelectionSheet extends StatefulWidget {
  final Set<String> selectedMemberIds;
  final Function(Set<String>) onMembersSelected;

  const _MemberSelectionSheet({
    required this.selectedMemberIds,
    required this.onMembersSelected,
  });

  @override
  State<_MemberSelectionSheet> createState() => _MemberSelectionSheetState();
}

class _MemberSelectionSheetState extends State<_MemberSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  late Set<String> _tempSelectedIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = Set.from(widget.selectedMemberIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppConstant.darkBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstant.borderRadius24),
          topRight: Radius.circular(AppConstant.borderRadius24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(AppConstant.spacing16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Members',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close,
                          color: AppConstant.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: AppConstant.spacing16),
                InputField(
                  controller: _searchController,
                  hintText: 'Search users...',
                  icon: Icons.search,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),

          // Members list
          Expanded(
            child: Consumer<UserListState>(
              builder: (context, userListState, child) {
                final users = userListState.users.where((user) {
                  if (_searchQuery.isEmpty) return true;
                  final name =
                      (user.fullName ?? user.username).toLowerCase();
                  final email = (user.email ?? '').toLowerCase();
                  return name.contains(_searchQuery) ||
                      email.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.spacing16,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final isSelected = _tempSelectedIds.contains(user.id);

                    return Container(
                      margin: EdgeInsets.only(bottom: AppConstant.spacing8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _tempSelectedIds.remove(user.id);
                              } else {
                                _tempSelectedIds.add(user.id);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(
                            AppConstant.borderRadius12,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(AppConstant.spacing12),
                            decoration: BoxDecoration(
                              color: AppConstant.cardBackground,
                              borderRadius: BorderRadius.circular(
                                AppConstant.borderRadius12,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppConstant.primaryBlue,
                                  child: Text(
                                    (user.fullName ?? user.username)
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppConstant.spacing12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName ?? user.username,
                                        style: TextStyle(
                                          color: AppConstant.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (user.email != null)
                                        Text(
                                          user.email!,
                                          style: TextStyle(
                                            color: AppConstant.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        _tempSelectedIds.add(user.id);
                                      } else {
                                        _tempSelectedIds.remove(user.id);
                                      }
                                    });
                                  },
                                  activeColor: AppConstant.primaryBlue,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Done button
          Padding(
            padding: EdgeInsets.all(AppConstant.spacing16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onMembersSelected(_tempSelectedIds);
                  Navigator.pop(context);
                },
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
                child: Text(
                  'Done (${_tempSelectedIds.length} selected)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
