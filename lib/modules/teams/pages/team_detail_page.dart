import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';
import 'package:task_flow/modules/teams/dialogs/add_task_dialog.dart';
import 'package:task_flow/modules/teams/dialogs/edit_team_dialog.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;

  const TeamDetailPage({super.key, required this.team});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All Tasks';
  String? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamState = context.watch<TeamState>();
    final team = teamState.getTeamById(widget.team.id) ?? widget.team;

    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstant.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              '${team.name} Team',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstant.textPrimary,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_done,
                  size: 12,
                  color: AppConstant.successGreen,
                ),
                SizedBox(width: 4),
                Text(
                  'SYNCED',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppConstant.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppConstant.textPrimary),
            onPressed: () async {
              final result = await AppModalUtil.showActionSheetModal(
                context: context,
                actionSheetContainer: EditTeamDialog(team: team),
                maxHeightRatio: 0.95,
                initialHeightRatio: 0.95,
              );

              if (result == true && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Team updated successfully'),
                    backgroundColor: AppConstant.successGreen,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Member filter tabs
          Container(
            height: 105, // Increased from 100 to prevent overflow
            padding: EdgeInsets.symmetric(vertical: AppConstant.spacing12),
            child: Consumer<UserListState>(
              builder: (context, userListState, child) {
                final members = userListState.getUsersByIds(
                  team.memberIds ?? [],
                );

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.spacing16,
                  ),
                  itemCount: members.length + 1, // +1 for "All" option
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // All members option
                      return Padding(
                        padding: EdgeInsets.only(right: AppConstant.spacing8),
                        child: _buildMemberFilterChip(
                          label: 'All',
                          isSelected: _selectedMemberId == null,
                          onTap: () {
                            setState(() {
                              _selectedMemberId = null;
                            });
                          },
                          icon: Icons.people,
                        ),
                      );
                    }
                    
                    // Individual members
                    final member = members[index - 1];
                    return Padding(
                      padding: EdgeInsets.only(right: AppConstant.spacing8),
                      child: _buildMemberFilterChip(
                        label: member.fullName ?? member.username,
                        isSelected: _selectedMemberId == member.id,
                        onTap: () {
                          setState(() {
                            _selectedMemberId = member.id;
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Search and filter bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstant.spacing16,
              vertical: AppConstant.spacing8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing16,
                      vertical: AppConstant.spacing12,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstant.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppConstant.borderRadius12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppConstant.textSecondary,
                          size: 20,
                        ),
                        SizedBox(width: AppConstant.spacing12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: AppConstant.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search tasks, tags...',
                              hintStyle: TextStyle(
                                color: AppConstant.textSecondary,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppConstant.spacing12),
                GestureDetector(
                  onTap: _showFilterOptions,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstant.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppConstant.borderRadius12,
                      ),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: AppConstant.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Task filter tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterTab('All Tasks'),
                  SizedBox(width: AppConstant.spacing8),
                  _buildFilterTab('My Tasks'),
                  SizedBox(width: AppConstant.spacing8),
                  _buildFilterTab('Due Soon'),
                  SizedBox(width: AppConstant.spacing8),
                  _buildFilterTab('Overdue'),
                ],
              ),
            ),
          ),
          SizedBox(height: AppConstant.spacing16),

          // Active Tasks Section
          Expanded(child: _buildTasksList(team)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, team),
        backgroundColor: AppConstant.primaryBlue,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildMemberFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70, // Fixed width to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppConstant.primaryBlue
                    : AppConstant.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppConstant.primaryBlue
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: icon != null
                  ? Icon(icon, color: AppConstant.textPrimary, size: 24)
                  : Center(
                      child: Text(
                        label.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: AppConstant.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? AppConstant.textPrimary
                      : AppConstant.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTab(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing16,
          vertical: AppConstant.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstant.primaryBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? AppConstant.primaryBlue
                : AppConstant.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList(Team team) {
    return Consumer<TaskState>(
      builder: (context, taskState, child) {
        var tasks = taskState.getTasksByTeamId(team.id);

        // Apply member filter
        if (_selectedMemberId != null) {
          tasks = tasks.where((task) {
            return task.assignedToUserId == _selectedMemberId;
          }).toList();
        }

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          tasks = tasks.where((task) {
            final query = _searchQuery.toLowerCase();
            return task.title.toLowerCase().contains(query) ||
                (task.description?.toLowerCase().contains(query) ?? false);
          }).toList();
        }

        // Apply task filter
        if (_selectedFilter == 'My Tasks') {
          final currentUser = context.read<UserState>().currentUser;
          final currentUserId = currentUser?.id;
          tasks = tasks.where((task) {
            // Check if current user is in the assignedUserIds list
            return task.assignedUserIds?.contains(currentUserId) ?? false;
          }).toList();
        } else if (_selectedFilter == 'Due Soon') {
          final now = DateTime.now();
          final threeDaysFromNow = now.add(Duration(days: 3));
          tasks = tasks.where((task) {
            if (task.dueDate == null) return false;
            return task.dueDate!.isAfter(now) &&
                task.dueDate!.isBefore(threeDaysFromNow);
          }).toList();
        } else if (_selectedFilter == 'Overdue') {
          final now = DateTime.now();
          tasks = tasks.where((task) {
            if (task.dueDate == null) return false;
            return task.dueDate!.isBefore(now) &&
                task.status.toLowerCase() != 'done' &&
                task.status.toLowerCase() != 'completed';
          }).toList();
        }

        // Separate active and completed tasks
        final activeTasks = tasks
            .where(
              (task) =>
                  task.status.toLowerCase() != 'done' &&
                  task.status.toLowerCase() != 'completed',
            )
            .toList();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppConstant.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Tasks (${activeTasks.length})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary,
                ),
              ),
              SizedBox(height: AppConstant.spacing12),
              if (activeTasks.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstant.spacing32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 64,
                          color: AppConstant.textSecondary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        SizedBox(height: AppConstant.spacing16),
                        Text(
                          'No tasks found',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppConstant.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...activeTasks.map((task) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppConstant.spacing12),
                    child: TaskCard(task: task),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppConstant.spacing24),
        decoration: BoxDecoration(
          color: AppConstant.darkBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstant.borderRadius24),
            topRight: Radius.circular(AppConstant.borderRadius24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Tasks',
                  style: TextStyle(
                    fontSize: 20,
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
            SizedBox(height: AppConstant.spacing16),
            
            // Filter options
            _buildFilterOption('All Tasks', _selectedFilter == 'All Tasks', () {
              setState(() {
                _selectedFilter = 'All Tasks';
              });
              Navigator.pop(context);
            }),
            SizedBox(height: AppConstant.spacing8),
            _buildFilterOption('My Tasks', _selectedFilter == 'My Tasks', () {
              setState(() {
                _selectedFilter = 'My Tasks';
              });
              Navigator.pop(context);
            }),
            SizedBox(height: AppConstant.spacing8),
            _buildFilterOption('Due Soon', _selectedFilter == 'Due Soon', () {
              setState(() {
                _selectedFilter = 'Due Soon';
              });
              Navigator.pop(context);
            }),
            SizedBox(height: AppConstant.spacing8),
            _buildFilterOption('Overdue', _selectedFilter == 'Overdue', () {
              setState(() {
                _selectedFilter = 'Overdue';
              });
              Navigator.pop(context);
            }),
            
            SizedBox(height: AppConstant.spacing24),
            
            // Reset filter
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = 'All Tasks';
                    _selectedMemberId = null;
                    _searchQuery = '';
                    _searchController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Reset All Filters',
                  style: TextStyle(
                    color: AppConstant.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConstant.spacing16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstant.primaryBlue.withValues(alpha: 0.2)
              : AppConstant.cardBackground,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
          border: Border.all(
            color: isSelected
                ? AppConstant.primaryBlue
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? AppConstant.primaryBlue
                  : AppConstant.textSecondary,
              size: 20,
            ),
            SizedBox(width: AppConstant.spacing12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppConstant.textPrimary
                    : AppConstant.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, Team team) async {
    final result = await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: AddTaskDialog(team: team),
      maxHeightRatio: 0.85,
      initialHeightRatio: 0.85,
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created successfully')),
      );
    }
  }
}
