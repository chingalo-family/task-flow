import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/constants/task_status_constant.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/sub_task.dart';

class Task {
  String? id;
  String? title;
  String? description;
  String? createdOn;
  String? createdBy;
  String? dueDate;
  String? status;
  String? completedOn;
  String? completedBy;
  bool? isCompleted;
  String? assignedTo;
  String? groupId;
  String? completedTasks;

  late List<SubTask> subTasks;

  Task({
    required this.title,
    required this.description,
    this.createdOn = '',
    this.assignedTo = '',
    this.completedBy = '',
    this.completedOn = '',
    this.createdBy = '',
    this.isCompleted = false,
    this.status = '',
    this.dueDate = '',
    this.groupId = '',
  }) {
    this.id = AppUtil.getUid();
    this.status = this.status != '' ? this.status : TaskStatusContant.notStarted;
    this.assignedTo = this.assignedTo != '' ? this.assignedTo : AppContant.defaultUserId;
    this.createdBy = this.createdBy != '' ? this.createdBy : AppContant.defaultUserId;
    this.groupId = this.groupId != '' ? this.groupId : AppContant.defaultUserGroupId;
    this.subTasks = [];
    this.createdOn = DateTime.now().toString().split('.')[0];
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['createdOn'] = this.createdOn;
    data['assignedTo'] = this.assignedTo;
    data['completedBy'] = this.completedBy;
    data['completedOn'] = this.completedOn;
    data['createdBy'] = this.createdBy != '' ? this.createdBy : '';
    data['dueDate'] = this.dueDate != '' ? this.dueDate : '';
    data['groupId'] = this.groupId;
    data['status'] = this.status;
    return data;
  }

  Task.fromMap(Map mapData) {
    this.id = mapData['id'];
    this.title = mapData['title'];
    this.description = mapData['description'];
    this.createdOn = mapData['createdOn'] ?? '';
    this.assignedTo = mapData['assignedTo'] ?? AppContant.defaultUserId;
    this.completedBy = mapData['completedBy'] ?? '';
    this.completedOn = mapData['completedOn'] ?? '';
    this.createdBy = mapData['createdBy'] ?? AppContant.defaultUserId;
    this.dueDate = mapData['dueDate'] ?? '';
    this.status = mapData['status'];
    this.assignedTo = mapData['assignedTo'] ?? AppContant.defaultUserId;
    this.groupId = mapData['groupId'] ?? AppContant.defaultUserGroupId;
  }

  @override
  String toString() {
    return 'Task <$id $title>';
  }
}
