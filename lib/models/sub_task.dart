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
    this.id = AppUtil.getUid();
    this.status = this.status != '' ? this.status : TaskStatusContant.notStarted;
    this.createdOn = DateTime.now().toString().split('.')[0];
    this.createdBy = '';
    this.dueDate = '';
    this.assignedTo = '';
    this.completedBy = '';
    this.completedOn = '';
  }

  Map<String, dynamic> toMap(SubTask todoTask) {
    var data = Map<String, dynamic>();
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
    this.id = mapData['id'];
    this.taskId = mapData['taskId'];
    this.title = mapData['title'];
    this.createdOn = mapData['createdOn'] ?? '';
    this.assignedTo = mapData['assignedTo'] ?? '';
    this.createdBy = mapData['createdBy'] ?? '';
    this.completedOn = mapData['completedOn'] ?? '';
    this.completedBy = mapData['completedBy'] ?? '';
    this.assignedTo = mapData['assignedTo'] ?? '';
    this.dueDate = mapData['dueDate'] ?? '';
    this.status = mapData['status'] ?? '';
    this.isCompleted = '${mapData['isCompleted']}' == '1' || '${mapData['isCompleted']}' == 'true';
  }

  @override
  String toString() {
    return 'Sub task <$id : $title>';
  }
}
