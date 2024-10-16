import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/core/components/material_card.dart';

class TaskSummaryContainer extends StatelessWidget {
  const TaskSummaryContainer({
    super.key,
    required this.currentTask,
    this.onTapCurrentTask,
  });

  final Task currentTask;
  final VoidCallback? onTapCurrentTask;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCurrentTask,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: MaterialCard(
          body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 3.0,
                          ),
                          child: Text(
                            currentTask.title!,
                            style: const TextStyle().copyWith(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: currentTask.description != '',
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 3.0,
                            ),
                            child: Text(
                              currentTask.description!,
                              style: const TextStyle().copyWith(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 3.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Status : ${currentTask.isCompleted! ? 'Completed' : 'Not completed'}',
                                  style: const TextStyle().copyWith(
                                    color: currentTask.isCompleted!
                                        ? const Color(0xFF34C759)
                                        : Colors.redAccent,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(),
                                child: Text(
                                  '${currentTask.completedTasks}/${currentTask.subTasks.length} tasks',
                                  style: const TextStyle().copyWith(
                                    color: currentTask.isCompleted!
                                        ? const Color(0xFF34C759)
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
