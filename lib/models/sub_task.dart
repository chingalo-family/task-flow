import 'package:task_manager/core/constants/task_status_constant.dart';
import 'package:task_manager/core/utils/app_util.dart';

class SubTask {
  String? id;
  String? taskId;
  String? title;
  String? status;
  bool? isCompleted;
  String? createdOn;
  String? createdBy;
  String? completedOn;
  String? completedBy;
  String? assignedTo;
  String? dueDate;

  SubTask({
    required this.taskId,
    required this.title,
    required this.isCompleted,
    this.status,
  }) {
    id = AppUtil.getUid();
    status = status != '' ? status : TaskStatusContant.notStarted;
    createdOn = DateTime.now().toString().split('.')[0];
    createdBy = '';
    dueDate = '';
    assignedTo = '';
    completedBy = '';
    completedOn = '';
  }

  Map<String, dynamic> toMap(SubTask todoTask) {
    var data = <String, dynamic>{};
    data['id'] = todoTask.id;
    data['taskId'] = todoTask.taskId;
    data['title'] = todoTask.title;
    data['isCompleted'] = todoTask.isCompleted! ? 1 : 0;
    data['createdBy'] = todoTask.createdBy;
    data['createdOn'] = todoTask.createdOn;
    data['assignedTo'] = todoTask.assignedTo;
    data['completedBy'] = todoTask.completedBy;
    data['assignedTo'] = todoTask.assignedTo;
    data['dueDate'] = todoTask.dueDate;
    data['completedOn'] = todoTask.completedOn;
    data['status'] = todoTask.status;
    return data;
  }

  SubTask.fromMap(Map mapData) {
    id = mapData['id'];
    taskId = mapData['taskId'];
    title = mapData['title'];
    createdOn = mapData['createdOn'] ?? '';
    assignedTo = mapData['assignedTo'] ?? '';
    createdBy = mapData['createdBy'] ?? '';
    completedOn = mapData['completedOn'] ?? '';
    completedBy = mapData['completedBy'] ?? '';
    assignedTo = mapData['assignedTo'] ?? '';
    dueDate = mapData['dueDate'] ?? '';
    status = mapData['status'] ?? '';
    isCompleted = '${mapData['isCompleted']}' == '1' ||
        '${mapData['isCompleted']}' == 'true';
  }

  @override
  String toString() {
    return 'Sub task <$id : $title>';
  }
}
