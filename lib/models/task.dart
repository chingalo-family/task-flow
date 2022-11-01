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
    id = AppUtil.getUid();
    status = status != '' ? status : TaskStatusContant.notStarted;
    assignedTo = assignedTo != '' ? assignedTo : AppContant.defaultUserId;
    createdBy = createdBy != '' ? createdBy : AppContant.defaultUserId;
    groupId = groupId != '' ? groupId : AppContant.defaultUserGroupId;
    subTasks = [];
    createdOn = DateTime.now().toString().split('.')[0];
  }

  Map<String, dynamic> toMap() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['createdOn'] = createdOn;
    data['assignedTo'] = assignedTo;
    data['completedBy'] = completedBy;
    data['completedOn'] = completedOn;
    data['createdBy'] = createdBy != '' ? createdBy : '';
    data['dueDate'] = dueDate != '' ? dueDate : '';
    data['groupId'] = groupId;
    data['status'] = status;
    return data;
  }

  Task.fromMap(Map mapData) {
    id = mapData['id'];
    title = mapData['title'];
    description = mapData['description'];
    createdOn = mapData['createdOn'] ?? '';
    assignedTo = mapData['assignedTo'] ?? AppContant.defaultUserId;
    completedBy = mapData['completedBy'] ?? '';
    completedOn = mapData['completedOn'] ?? '';
    createdBy = mapData['createdBy'] ?? AppContant.defaultUserId;
    dueDate = mapData['dueDate'] ?? '';
    status = mapData['status'];
    assignedTo = mapData['assignedTo'] ?? AppContant.defaultUserId;
    groupId = mapData['groupId'] ?? AppContant.defaultUserGroupId;
  }

  @override
  String toString() {
    return 'Task <$id $title>';
  }
}
