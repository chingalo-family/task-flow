import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/teams/components/add_status_container.dart';
import 'package:task_flow/modules/teams/components/edit_status_container.dart';

class TeamSettingsPage extends StatefulWidget {
  final String teamId;

  const TeamSettingsPage({super.key, required this.teamId});

  @override
  State<TeamSettingsPage> createState() => _TeamSettingsPageState();
}

class _TeamSettingsPageState extends State<TeamSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      appBar: AppBar(
        title: const Text('Team Settings'),
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
      ),
      body: Consumer<TeamState>(
        builder: (context, teamState, _) {
          final team = teamState.getTeamById(widget.teamId);
          if (team == null) {
            return const Center(child: Text('Team not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [_buildTaskStatusesSection(context, teamState, team)],
          );
        },
      ),
    );
  }

  Widget _buildTaskStatusesSection(
    BuildContext context,
    TeamState teamState,
    Team team,
  ) {
    final statuses = team.taskStatuses;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Task Statuses',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showAddStatusDialog(context, teamState, team),
              icon: const Icon(Icons.add, color: AppConstant.primaryBlue),
              label: const Text(
                'Add Status',
                style: TextStyle(color: AppConstant.primaryBlue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Customize task statuses for this team',
          style: TextStyle(color: AppConstant.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 16),
        ...statuses.map((status) {
          return _buildStatusCard(context, teamState, team, status);
        }),
      ],
    );
  }

  Widget _buildStatusCard(
    BuildContext context,
    TeamState teamState,
    Team team,
    TaskStatus status,
  ) {
    return Card(
      color: AppConstant.cardBackground,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: status.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.circle, color: status.color, size: 20),
        ),
        title: Text(
          status.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: status.isDefault
            ? const Text(
                'Default status',
                style: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 12,
                ),
              )
            : null,
        trailing: status.isDefault
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: AppConstant.primaryBlue,
                      size: 20,
                    ),
                    onPressed: () =>
                        _showEditStatusDialog(context, teamState, team, status),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: AppConstant.errorRed,
                      size: 20,
                    ),
                    onPressed: () =>
                        _deleteStatus(context, teamState, team, status),
                  ),
                ],
              ),
      ),
    );
  }

  void _showAddStatusDialog(
    BuildContext context,
    TeamState teamState,
    Team team,
  ) async {
    final result = await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: const AddStatusContainer(),
      maxHeightRatio: 0.7,
      initialHeightRatio: 0.7,
    );

    if (result != null && result is Map<String, dynamic>) {
      final newStatus = TaskStatus(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result['name'],
        color: result['color'],
        order: team.taskStatuses.length,
      );

      await teamState.addTaskStatus(team.id, newStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status added successfully')),
        );
      }
    }
  }

  void _showEditStatusDialog(
    BuildContext context,
    TeamState teamState,
    Team team,
    TaskStatus status,
  ) async {
    final result = await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: EditStatusContainer(status: status),
      maxHeightRatio: 0.7,
      initialHeightRatio: 0.7,
    );

    if (result != null && result is Map<String, dynamic>) {
      final updatedStatus = status.copyWith(
        name: result['name'],
        color: result['color'],
      );

      await teamState.updateTaskStatus(team.id, status.id, updatedStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully')),
        );
      }
    }
  }

  void _deleteStatus(
    BuildContext context,
    TeamState teamState,
    Team team,
    TaskStatus status,
  ) {
    DialogUtils.showConfirmationDialog(
      context: context,
      title: 'Delete Status',
      message: 'Are you sure you want to delete "${status.name}" status?',
      confirmText: 'Delete',
      onConfirm: () async {
        await teamState.deleteTaskStatus(team.id, status.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status deleted successfully')),
        );
      },
    );
  }
}
