import 'package:flutter/foundation.dart';
import 'package:task_manager/core/offline_db/task_offline_provider/task_offline_provider.dart';
import 'package:task_manager/core/offline_db/task_offline_provider/sub_task_offline_provider.dart';
import 'package:task_manager/models/sub_task.dart';
import 'package:task_manager/models/task.dart';

class TaskState with ChangeNotifier {
  final TaskOfflineProvider taskOfflineProvider = new TaskOfflineProvider();
  final SubTaskOfflineProvider subtaskOfflineProvider = new SubTaskOfflineProvider();

  List<Task> _taskList = [];
  Task? _currentTask;

  List<Task> get todoList => _taskList.toList();
  int get todoCount => _taskList.toList().length;
  Task? get currentTask => _currentTask;

  void initiateTaskList() async {
    //@TODO refecture app status methods
    List<Task> tasks = await taskOfflineProvider.getAllTasks();
    List<SubTask> subTasks = await subtaskOfflineProvider.getAllSubTasks();
    _taskList = tasks.map((Task task) {
      String taskId = task.id!;
      task.subTasks = subTasks.where((SubTask todoTask) => todoTask.taskId == taskId).toList();
      List<bool> completenesStatus =
          task.subTasks.map((SubTask subTask) => subTask.isCompleted!).toList();
      task.isCompleted = !completenesStatus.contains(false);
      List<SubTask> completedSubTasks =
          task.subTasks.where((SubTask subTask) => subTask.isCompleted!).toList();
      task.completedTasks = '${completedSubTasks.length}';
      return task;
    }).toList();
    if (_currentTask != null && _currentTask!.id!.isNotEmpty) {
      int index = _taskList.indexWhere((Task task) => task.id == _currentTask!.id);
      _currentTask = _taskList[index];
    }
    notifyListeners();
  }

  void setCurrentTodo(Task task) {
    _currentTask = task;
    notifyListeners();
  }

  void resetCurrentTodo() {
    _currentTask = null;
    notifyListeners();
  }

  void addTodo(Task todo) async {
    //@TODO refecture app status methods
    await taskOfflineProvider.addOrUpdateTask(todo);
    initiateTaskList();
  }

  Future deleteTodo(Task todo) async {
    await taskOfflineProvider.deleteTask(todo.id!);
    for (SubTask subTask in todo.subTasks) {
      await subtaskOfflineProvider.deleteSubTask(subTask.id!);
    }
    _currentTask = null;
    initiateTaskList();
  }

  void addSubTask(SubTask subTask) async {
    //@TODO refecture app status methods
    await subtaskOfflineProvider.addOrUpdateSubTask(subTask);
    initiateTaskList();
  }

  Future deleteSubTask(SubTask subTask) async {
    await subtaskOfflineProvider.deleteSubTask(subTask.id!);
    initiateTaskList();
  }
}
