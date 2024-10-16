import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/sub_task_container.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/task_summary_container.dart';

class TaskViewContainer extends StatelessWidget {
  const TaskViewContainer({
    super.key,
    required this.currentTask,
    this.onTapCurrentTask,
  });

  final Task currentTask;
  final VoidCallback? onTapCurrentTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Consumer<UserState>(
        builder: (context, userState, child) {
          return Container(
            margin: const EdgeInsets.symmetric(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskSummaryContainer(
                  currentTask: currentTask,
                  onTapCurrentTask: onTapCurrentTask,
                ),
                SubTaskContainer(
                  currentTask: currentTask,
                  currentUser: userState.currrentUser,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
