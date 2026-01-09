import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/app_state/team_state/team_state.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';
import 'package:task_flow/modules/tasks/components/task_search_delegate.dart';
import 'package:task_flow/modules/tasks/pages/add_edit_task_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskState>(context, listen: false).initialize();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TeamState>(context, listen: false).initialize();
        Provider.of<UserListState>(context, listen: false).initialize();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
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

            // Get current user ID
            final currentUserId =
                context.watch<UserState>().currentUser?.id ?? '';

            // Get user-specific task lists
            final tasksDueToday = taskState.getMyTasksDueToday(currentUserId);
            final overdueTasks = taskState.getMyOverdueTasks(currentUserId);
            final upcomingTasks = taskState.getMyUpcomingTasks(currentUserId);

            return CustomScrollView(
              slivers: [
                // App Bar with user avatar and search
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppConstant.darkBackground,
                  elevation: 0,
                  leading: Padding(
                    padding: EdgeInsets.all(AppConstant.spacing8),
                    child: Consumer<UserState>(
                      builder: (context, userState, _) {
                        final user = userState.currentUser;
                        final initials = user?.fullName != null
                            ? user!.fullName!
                                  .split(' ')
                                  .map((n) => n[0])
                                  .take(2)
                                  .join()
                            : user?.username.substring(0, 1).toUpperCase() ??
                                  'U';

                        return CircleAvatar(
                          backgroundColor: AppConstant.primaryBlue,
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  title: Text(
                    'My Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search, color: AppConstant.textPrimary),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: TaskSearchDelegate(taskState.allTasks),
                        );
                      },
                    ),
                  ],
                ),

                // Greeting and task count
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppConstant.spacing24,
                      AppConstant.spacing16,
                      AppConstant.spacing24,
                      AppConstant.spacing8,
                    ),
                    child: Consumer<UserState>(
                      builder: (context, userState, _) {
                        final user = userState.currentUser;
                        final firstName =
                            user?.fullName?.split(' ').first ??
                            user?.username ??
                            'User';
                        final userId = user?.id ?? '';
                        final myTasksDueTodayCount = taskState
                            .getMyTasksDueToday(userId)
                            .length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_getGreeting()}, $firstName',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppConstant.textPrimary,
                              ),
                            ),
                            SizedBox(height: AppConstant.spacing8),
                            Text(
                              'You have $myTasksDueTodayCount tasks pending today.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppConstant.textSecondary,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // My Progress Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing24,
                      vertical: AppConstant.spacing16,
                    ),
                    child: Consumer<UserState>(
                      builder: (context, userState, _) {
                        final userId = userState.currentUser?.id ?? '';
                        final myCompletedCount = taskState
                            .getMyCompletedTasksCount(userId);
                        final myTotalCount = taskState.getMyTotalTasksCount(
                          userId,
                        );
                        final myProgress = taskState.getMyCompletionProgress(
                          userId,
                        );

                        return Container(
                          padding: EdgeInsets.all(AppConstant.spacing20),
                          decoration: BoxDecoration(
                            color: AppConstant.cardBackground,
                            borderRadius: BorderRadius.circular(
                              AppConstant.borderRadius16,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'My Progress',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstant.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: AppConstant.spacing4),
                                      Text(
                                        '$myCompletedCount/$myTotalCount tasks completed',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppConstant.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: CircularProgressIndicator(
                                            value: myProgress,
                                            strokeWidth: 6,
                                            backgroundColor: AppConstant
                                                .textSecondary
                                                .withValues(alpha: 0.2),
                                            valueColor: AlwaysStoppedAnimation(
                                              AppConstant.primaryBlue,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '${(myProgress * 100).toInt()}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: AppConstant.primaryBlue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppConstant.spacing16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: myProgress,
                                  backgroundColor: AppConstant.textSecondary
                                      .withValues(alpha: 0.2),
                                  valueColor: AlwaysStoppedAnimation(
                                    AppConstant.primaryBlue,
                                  ),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Focus Today Section (tasks due today)
                if (tasksDueToday.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppConstant.spacing24,
                        AppConstant.spacing16,
                        AppConstant.spacing24,
                        AppConstant.spacing12,
                      ),
                      child: Text(
                        'Focus Today',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final task = tasksDueToday[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: AppConstant.spacing12,
                          ),
                          child: TaskCard(task: task),
                        );
                      }, childCount: tasksDueToday.length),
                    ),
                  ),
                ],

                // Overdue Section
                if (overdueTasks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppConstant.spacing24,
                        AppConstant.spacing16,
                        AppConstant.spacing24,
                        AppConstant.spacing12,
                      ),
                      child: Text(
                        'Overdue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.errorRed,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final task = overdueTasks[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: AppConstant.spacing12,
                          ),
                          child: TaskCard(task: task),
                        );
                      }, childCount: overdueTasks.length),
                    ),
                  ),
                ],

                // Upcoming Section
                if (upcomingTasks.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppConstant.spacing24,
                        AppConstant.spacing16,
                        AppConstant.spacing24,
                        AppConstant.spacing12,
                      ),
                      child: Text(
                        'Upcoming',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstant.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppConstant.spacing24,
                      0,
                      AppConstant.spacing24,
                      AppConstant.spacing24,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final task = upcomingTasks[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: AppConstant.spacing12,
                          ),
                          child: TaskCard(task: task),
                        );
                      }, childCount: upcomingTasks.length),
                    ),
                  ),
                ],

                // Empty state
                if (tasksDueToday.isEmpty &&
                    overdueTasks.isEmpty &&
                    upcomingTasks.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: AppConstant.textSecondary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          SizedBox(height: AppConstant.spacing16),
                          Text(
                            'No tasks found',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppConstant.textSecondary),
                          ),
                        ],
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskPage()),
          );
        },
        backgroundColor: AppConstant.primaryBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
