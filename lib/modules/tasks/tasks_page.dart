import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';
import 'package:task_flow/modules/tasks/components/task_stats.dart';
import 'package:task_flow/modules/login/login_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskState>(context, listen: false).initialize();
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppConstant.cardBackground,
          title: Text('Logout', style: TextStyle(color: AppConstant.textPrimary)),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: AppConstant.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final userState = Provider.of<UserState>(context, listen: false);
                await userState.logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: Text('Logout', style: TextStyle(color: AppConstant.errorRed)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      body: SafeArea(
        child: Consumer<TaskState>(
          builder: (context, taskState, child) {
            if (taskState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppConstant.primaryBlue,
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppConstant.darkBackground,
                  elevation: 0,
                  title: Row(
                    children: [
                      Icon(
                        Icons.layers_rounded,
                        color: AppConstant.primaryBlue,
                        size: 24,
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        'TaskFlow',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout, color: AppConstant.textSecondary),
                      onPressed: _showLogoutDialog,
                    ),
                  ],
                ),

                // Header with greeting
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstant.spacing24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<UserState>(
                          builder: (context, userState, _) {
                            final user = userState.currentUser;
                            return Text(
                              'Hello, ${user?.fullName ?? user?.username ?? "User"}! 👋',
                              style: Theme.of(context).textTheme.headlineMedium,
                            );
                          },
                        ),
                        SizedBox(height: AppConstant.spacing8),
                        Text(
                          'You have ${taskState.tasks.length} tasks',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Task Stats
                SliverToBoxAdapter(
                  child: TaskStats(),
                ),

                // Filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstant.spacing16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All', 'all', taskState),
                          _buildFilterChip('Pending', 'pending', taskState),
                          _buildFilterChip('In Progress', 'in_progress', taskState),
                          _buildFilterChip('Completed', 'completed', taskState),
                        ],
                      ),
                    ),
                  ),
                ),

                // Task List
                taskState.tasks.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 80,
                                color: AppConstant.textSecondary.withOpacity(0.3),
                              ),
                              SizedBox(height: AppConstant.spacing16),
                              Text(
                                'No tasks found',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppConstant.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.all(AppConstant.spacing16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final task = taskState.tasks[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppConstant.spacing12),
                                child: TaskCard(task: task),
                              );
                            },
                            childCount: taskState.tasks.length,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add task page
        },
        backgroundColor: AppConstant.primaryBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, TaskState taskState) {
    final isSelected = taskState.filterStatus == value;
    return Padding(
      padding: EdgeInsets.only(right: AppConstant.spacing8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          taskState.setFilterStatus(value);
        },
        backgroundColor: AppConstant.cardBackground,
        selectedColor: AppConstant.primaryBlue.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? AppConstant.primaryBlue : AppConstant.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? AppConstant.primaryBlue
              : AppConstant.textSecondary.withOpacity(0.2),
        ),
      ),
    );
  }
}
