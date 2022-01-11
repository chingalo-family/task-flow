import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/modules/task_manager/components/task_list.dart';
import 'package:task_manager/modules/task_manager/sub_module/task_manager_view.dart';

class TaskListContainer extends StatelessWidget {
  const TaskListContainer({Key? key}) : super(key: key);

  onSelectTodo(BuildContext context, Task task) {
    Provider.of<TaskState>(context, listen: false).setCurrentTodo(task);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskMangerView(),
      ),
    );
  }

  //@TODO loading and listing tasks by pagination
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskState>(
      builder: (context, todoState, child) {
        List<Task> tasks = todoState.todoList;
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            children: tasks
                .map(
                  (Task task) => TaskList(
                    task: task,
                    onSelectTodo: () => onSelectTodo(
                      context,
                      task,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
