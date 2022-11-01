import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/task.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.task,
    this.onSelectTask,
  }) : super(key: key);

  final Task task;
  final VoidCallback? onSelectTask;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeState>(
      builder: (context, appThemeState, child) {
        String currentTheme = appThemeState.currentTheme;
        Color textColor = currentTheme == ThemeServices.darkTheme
            ? AppContant.darkTextColor
            : AppContant.ligthTextColor;
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5.0,
          ),
          child: GestureDetector(
            onTap: onSelectTask,
            child: MaterialCard(
              body: Container(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 5.0,
                  top: 10.0,
                  bottom: 10.0,
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(),
                              child: Text(
                                task.title!,
                                style: const TextStyle().copyWith(
                                  fontSize: 18.0,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: task.description != '',
                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: 3.0,
                                ),
                                child: Text(
                                  task.description!,
                                  style: const TextStyle().copyWith(
                                    color: textColor,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 3.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Status : ${task.isCompleted! ? 'Completed' : 'Not completed'}',
                                      style: const TextStyle().copyWith(
                                        color: task.isCompleted!
                                            ? const Color(0xFF34C759)
                                            : Colors.redAccent,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(),
                                    child: Text(
                                      '${task.completedTasks}/${task.subTasks.length} tasks',
                                      style: const TextStyle().copyWith(
                                        color: task.isCompleted!
                                            ? const Color(0xFF34C759)
                                            : Colors.redAccent,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(),
                      child: Icon(
                        Icons.chevron_right,
                        color: textColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
