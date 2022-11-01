import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/task.dart';

class DeleteTaskConfirmation extends StatelessWidget {
  const DeleteTaskConfirmation({
    Key? key,
    required this.currentTask,
  }) : super(key: key);

  final Task currentTask;

  onDeleteTodo(BuildContext context) async {
    await Provider.of<TaskState>(context, listen: false)
        .deleteTodo(currentTask);
    AppUtil.showToastMessage(
      message: '${currentTask.title} has been deleted successfully',
      position: ToastGravity.SNACKBAR,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(),
            child: Consumer<AppThemeState>(
              builder: (context, appThemeState, child) {
                String currentTheme = appThemeState.currentTheme;
                Color textColor = currentTheme == ThemeServices.darkTheme
                    ? AppContant.darkTextColor
                    : AppContant.ligthTextColor;
                return Container(
                  margin: const EdgeInsets.symmetric(),
                  child: Text(
                    "Are you sure you want to delete '${currentTask.title}' with ${currentTask.subTasks.length} tasks?",
                    style: const TextStyle().copyWith(
                      color: textColor,
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () => onDeleteTodo(context),
                        child: Text(
                          'Delete',
                          style: const TextStyle().copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'Cancel',
                          style: const TextStyle().copyWith(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
