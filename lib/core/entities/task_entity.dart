import 'package:objectbox/objectbox.dart';

@Entity()
class TaskEntity {
  int id; // ObjectBox id

  String taskId; // API task id
  String title;
  String? description;
  String status; // 'pending', 'in_progress', 'completed'
  String priority; // 'low', 'medium', 'high'
  String? category; // Task category
  
  String? assignedToUserId;
  String? assignedToUsername;
  String? assignedUserIdsJson; // JSON array of assigned user IDs
  
  String? teamId; // Team this task belongs to
  String? teamName;
  
  @Property(type: PropertyType.date)
  DateTime? dueDate;
  
  @Property(type: PropertyType.date)
  DateTime? completedAt;
  
  String? projectId;
  String? projectName;
  
  String? tagsJson; // JSON array of tags
  String? attachmentsJson; // JSON array of attachment URLs
  String? subtasksJson; // JSON array of subtasks
  
  bool? remindMe;
  int progress; // 0-100
  
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
    this.status = 'pending',
    this.priority = 'medium',
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
    this.isSynced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
