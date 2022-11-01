import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/sub_task.dart';

class DeleteSubTaskConfirmation extends StatelessWidget {
  const DeleteSubTaskConfirmation({
    Key? key,
    required this.subTask,
  }) : super(key: key);

  final SubTask subTask;

  onDeleteTodo(context) async {
    await Provider.of<TaskState>(context, listen: false).deleteSubTask(subTask);
    AppUtil.showToastMessage(
      message: '${subTask.title} has been deleted successfully',
      position: ToastGravity.SNACKBAR,
    );
    Navigator.of(context).pop();
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
                    "Are you sure you want to delete '${subTask.title}' task?",
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
