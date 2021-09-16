import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/core/components/material_card.dart';

class TaskSummaryContainer extends StatelessWidget {
  const TaskSummaryContainer({
    Key? key,
    required this.textColor,
    required this.currentTask,
    this.onTapCurrentTask,
  }) : super(key: key);

  final Color textColor;
  final Task currentTask;
  final VoidCallback? onTapCurrentTask;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCurrentTask,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: MaterialCard(
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 3.0,
                          ),
                          child: Text(
                            currentTask.title!,
                            style: TextStyle().copyWith(
                              fontSize: 20.0,
                              color: textColor,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentTask.description != "",
                          child: Container(
                            margin: EdgeInsets.only(
                              bottom: 3.0,
                            ),
                            child: Text(
                              currentTask.description!,
                              style: TextStyle().copyWith(
                                color: textColor,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 3.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Status : ${currentTask.isCompleted! ? 'Completed' : 'Not completed'}',
                                  style: TextStyle().copyWith(
                                    color: currentTask.isCompleted!
                                        ? Color(0xFF34C759)
                                        : Colors.redAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '${currentTask.completedTasks}/${currentTask.subTasks.length} tasks',
                                  style: TextStyle().copyWith(
                                    color: currentTask.isCompleted!
                                        ? Color(0xFF34C759)
                                        : Colors.redAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
