import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';
import 'package:task_flow/modules/teams/dialogs/add_member_dialog.dart';
import 'package:task_flow/modules/teams/dialogs/add_task_dialog.dart';
import 'package:task_flow/modules/teams/pages/team_settings_page.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;

  const TeamDetailPage({super.key, required this.team});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamState = context.watch<TeamState>();
    final team = teamState.getTeamById(widget.team.id) ?? widget.team;

    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstant.primaryBlue,
          labelColor: AppConstant.primaryBlue,
          unselectedLabelColor: AppConstant.textSecondary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Members'),
            Tab(text: 'Tasks'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(team),
          _buildMembersTab(team),
          _buildTasksTab(team),
          _buildSettingsTab(team),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Team team) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstant.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard('Total Members', team.memberCount.toString(), Icons.people),
          SizedBox(height: AppConstant.defaultPadding),
          _buildStatCard('Active Tasks', (team.taskIds?.length ?? 0).toString(), Icons.task_alt),
          SizedBox(height: AppConstant.defaultPadding * 2),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary,
            ),
          ),
          SizedBox(height: AppConstant.defaultPadding),
          Text(
            team.description ?? 'No description available',
            style: TextStyle(
              fontSize: 14,
              color: AppConstant.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppConstant.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstant.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
            ),
            child: Icon(icon, color: AppConstant.primaryBlue, size: 24),
          ),
          SizedBox(width: AppConstant.defaultPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstant.textSecondary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstant.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(Team team) {
    return Consumer<UserListState>(
      builder: (context, userListState, child) {
        final members = userListState.getUsersByIds(team.memberIds ?? []);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstant.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${members.length} Member${members.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddMemberDialog(context, team),
                    icon: Icon(Icons.person_add, size: 18),
                    label: Text('Add Member'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: members.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppConstant.textSecondary.withOpacity(0.5),
                          ),
                          SizedBox(height: AppConstant.defaultPadding),
                          Text(
                            'No members yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppConstant.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: AppConstant.defaultPadding),
                      itemCount: members.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return _buildMemberCard(context, team, member);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMemberCard(BuildContext context, Team team, User member) {
    return Container(
      padding: EdgeInsets.all(AppConstant.defaultPadding),
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppConstant.primaryBlue,
            child: Text(
              (member.fullName ?? member.username).substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: AppConstant.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName ?? member.username,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstant.textPrimary,
                  ),
                ),
                if (member.email != null)
                  Text(
                    member.email!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstant.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeMember(context, team, member),
            icon: Icon(Icons.remove_circle_outline, color: AppConstant.errorRed),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(Team team) {
    return Consumer<TaskState>(
      builder: (context, taskState, child) {
        final tasks = taskState.getTasksByTeamId(team.id);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppConstant.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${tasks.length} Task${tasks.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddTaskDialog(context, team),
                    icon: Icon(Icons.add_task, size: 18),
                    label: Text('Add Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_outlined,
                            size: 64,
                            color: AppConstant.textSecondary.withOpacity(0.5),
                          ),
                          SizedBox(height: AppConstant.defaultPadding),
                          Text(
                            'No tasks yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppConstant.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: AppConstant.defaultPadding),
                      itemCount: tasks.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(task: task);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context, Team team) {
    showDialog(
      context: context,
      builder: (context) => AddMemberDialog(team: team),
    );
  }

  void _showAddTaskDialog(BuildContext context, Team team) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(team: team),
    );
  }

  void _removeMember(BuildContext context, Team team, User member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstant.cardBackground,
        title: Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove ${member.fullName ?? member.username} from ${team.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TeamState>().removeMemberFromTeam(team.id, member.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Member removed successfully')),
              );
            },
            child: Text('Remove', style: TextStyle(color: AppConstant.errorRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(Team team) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstant.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary,
            ),
          ),
          SizedBox(height: AppConstant.defaultPadding),
          
          // Task Statuses Card
          _buildSettingsCard(
            title: 'Task Statuses',
            subtitle: 'Customize task statuses for this team',
            icon: Icons.check_circle_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamSettingsPage(teamId: team.id),
                ),
              );
            },
          ),
          
          SizedBox(height: AppConstant.defaultPadding),
          
          // Preview current statuses
          Text(
            'Current Statuses (${team.taskStatuses.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstant.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: team.taskStatuses.map((status) {
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: status.color,
                  radius: 8,
                ),
                label: Text(status.name),
                backgroundColor: AppConstant.cardDark,
                labelStyle: TextStyle(color: AppConstant.textPrimary, fontSize: 12),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppConstant.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstant.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppConstant.primaryBlue),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppConstant.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppConstant.textSecondary, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: AppConstant.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
