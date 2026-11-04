import 'package:objectbox/objectbox.dart';
import 'package:task_flow/core/constants/task_constants.dart';

@Entity()
class TaskEntity {
  @Id()
  int id; // ObjectBox id

  @Index()
  String taskId;
  String title;
  String? description;
  String status; // 'pending', 'in_progress', 'completed'
  String priority; // 'low', 'medium', 'high'
  String? category; // Task category

  String? assignedToUserId;
  String? assignedToUsername;
  String? assignedUserIdsJson;

  String? teamId;
  String? teamName;

  @Property(type: PropertyType.date)
  DateTime? dueDate;

  @Property(type: PropertyType.date)
  DateTime? completedAt;

  String? projectId;
  String? projectName;

  String? tagsJson;
  String? attachmentsJson;
  String? subtasksJson;

  bool? remindMe;
  int progress; // 0-100

  String? userId; // User who created this task
  String? userName; // Name of user who created this task

  bool isSynced;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  TaskEntity({
    this.id = 0,
    required this.taskId,
    required this.title,
    this.description,
    this.status = TaskConstants.statusPending,
    this.priority = TaskConstants.priorityMedium,
    this.category,
    this.assignedToUserId,
    this.assignedToUsername,
    this.assignedUserIdsJson,
    this.teamId,
    this.teamName,
    this.dueDate,
    this.completedAt,
    this.projectId,
    this.projectName,
    this.tagsJson,
    this.attachmentsJson,
    this.subtasksJson,
    this.remindMe,
    this.progress = 0,
    this.userId,
    this.userName,
    this.isSynced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
