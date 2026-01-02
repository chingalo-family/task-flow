import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';

class AddMemberDialog extends StatefulWidget {
  final Team team;

  const AddMemberDialog({super.key, required this.team});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedUserIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppConstant.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(AppConstant.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Add Members',
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
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(color: AppConstant.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: AppConstant.textSecondary),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppConstant.textSecondary,
                ),
                filled: true,
                fillColor: AppConstant.darkBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius12,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: AppConstant.defaultPadding),
            if (_selectedUserIds.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: AppConstant.defaultPadding),
                decoration: BoxDecoration(
                  color: AppConstant.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppConstant.borderRadius8,
                  ),
                  border: Border.all(
                    color: AppConstant.primaryBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${_selectedUserIds.length} user${_selectedUserIds.length > 1 ? 's' : ''} selected',
                  style: TextStyle(
                    color: AppConstant.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Expanded(
              child: Consumer<UserListState>(
                builder: (context, userListState, child) {
                  final allUsers = userListState.searchUsers(_searchQuery);
                  final existingMemberIds = widget.team.memberIds ?? [];
                  final availableUsers = allUsers
                      .where((user) => !existingMemberIds.contains(user.id))
                      .toList();

                  if (availableUsers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search,
                            size: 64,
                            color: AppConstant.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          SizedBox(height: AppConstant.defaultPadding),
                          Text(
                            _searchQuery.isEmpty
                                ? 'All users are already members'
                                : 'No users found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppConstant.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: availableUsers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = availableUsers[index];
                      final isSelected = _selectedUserIds.contains(user.id);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedUserIds.remove(user.id);
                            } else {
                              _selectedUserIds.add(user.id);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(
                          AppConstant.borderRadius8,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppConstant.primaryBlue.withValues(alpha: 0.1)
                                : AppConstant.darkBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius8,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppConstant.primaryBlue
                                  : Colors.transparent,
                              width: 2,
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
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName ?? user.username,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppConstant.textPrimary,
                                      ),
                                    ),
                                    if (user.email != null)
                                      Text(
                                        user.email!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppConstant.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppConstant.primaryBlue,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppConstant.defaultPadding),
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
                    onPressed: _selectedUserIds.isEmpty ? null : _addMembers,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppConstant.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Add (${_selectedUserIds.length})'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addMembers() async {
    final teamState = context.read<TeamState>();

    for (final userId in _selectedUserIds) {
      await teamState.addMemberToTeam(widget.team.id, userId);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_selectedUserIds.length} member${_selectedUserIds.length > 1 ? 's' : ''} added successfully',
          ),
        ),
      );
    }
  }
}
