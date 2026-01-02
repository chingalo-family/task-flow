import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart';
import 'package:task_flow/core/utils/utils.dart';

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
        }).toList(),
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
  ) {
    final nameController = TextEditingController();
    Color selectedColor = const Color(0xFF2E90FA);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppConstant.cardBackground,
            title: const Text(
              'Add Task Status',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Status Name',
                      labelStyle: const TextStyle(
                        color: AppConstant.textSecondary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.cardBackground,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.primaryBlue,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Color',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _colorOption(
                        const Color(0xFF2E90FA),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF10B981),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFFF59E0B),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFFEF4444),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF8B5CF6),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFFEC4899),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF6B7280),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF14B8A6),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppConstant.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a status name'),
                      ),
                    );
                    return;
                  }

                  final newStatus = TaskStatus(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    color: selectedColor,
                    order: team.taskStatuses.length,
                  );

                  await teamState.addTaskStatus(team.id, newStatus);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Status added successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primaryBlue,
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditStatusDialog(
    BuildContext context,
    TeamState teamState,
    Team team,
    TaskStatus status,
  ) {
    final nameController = TextEditingController(text: status.name);
    Color selectedColor = status.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppConstant.cardBackground,
            title: const Text(
              'Edit Task Status',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Status Name',
                      labelStyle: const TextStyle(
                        color: AppConstant.textSecondary,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.cardBackground,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: AppConstant.primaryBlue,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Color',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _colorOption(
                        const Color(0xFF2E90FA),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF10B981),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFFF59E0B),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFFEF4444),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF8B5CF6),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFFEC4899),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF6B7280),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                      _colorOption(
                        const Color(0xFF14B8A6),
                        selectedColor,
                        setState,
                        (color) => selectedColor = color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppConstant.textSecondary),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a status name'),
                      ),
                    );
                    return;
                  }

                  final updatedStatus = status.copyWith(
                    name: nameController.text.trim(),
                    color: selectedColor,
                  );

                  await teamState.updateTaskStatus(
                    team.id,
                    status.id,
                    updatedStatus,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Status updated successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primaryBlue,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _colorOption(
    Color color,
    Color selectedColor,
    void Function(void Function()) setState,
    void Function(Color) onSelect,
  ) {
    final isSelected = color.value == selectedColor.value;
    return GestureDetector(
      onTap: () {
        setState(() => onSelect(color));
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 24)
            : null,
      ),
    );
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
