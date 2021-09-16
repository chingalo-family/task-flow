import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/sub_task_container.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/task_summary_container.dart';

class TaskViewContainer extends StatelessWidget {
  const TaskViewContainer({
    Key? key,
    required this.currentTask,
    this.onTapCurrentTask,
  }) : super(key: key);

  final Task currentTask;
  final VoidCallback? onTapCurrentTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<AppThemeState>(
        builder: (context, appThemeState, child) {
          String currentTheme = appThemeState.currentTheme;
          Color textColor = currentTheme == ThemeServices.darkTheme
              ? AppContant.darkTextColor
              : AppContant.ligthTextColor;
          return Consumer<UserState>(
            builder: (context, userState, child) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskSummaryContainer(
                      currentTask: currentTask,
                      textColor: textColor,
                      onTapCurrentTask: onTapCurrentTask,
                    ),
                    SubTaskContainer(
                      currentTask: currentTask,
                      textColor: textColor,
                      currentUser: userState.currrentUser,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
