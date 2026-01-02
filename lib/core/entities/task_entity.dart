import 'package:objectbox/objectbox.dart';

@Entity()
class TaskEntity {
  int id; // ObjectBox id

  String taskId; // API task id
  String title;
  String? description;
  String status; // 'pending', 'in_progress', 'completed'
  String priority; // 'low', 'medium', 'high'
  
  String? assignedToUserId;
  String? assignedToUsername;
  
  @Property(type: PropertyType.date)
  DateTime? dueDate;
  
  @Property(type: PropertyType.date)
  DateTime? completedAt;
  
  String? projectId;
  String? projectName;
  
  String? tagsJson; // JSON array of tags
  String? attachmentsJson; // JSON array of attachment URLs
  
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
    this.assignedToUserId,
    this.assignedToUsername,
    this.dueDate,
    this.completedAt,
    this.projectId,
    this.projectName,
    this.tagsJson,
    this.attachmentsJson,
    this.progress = 0,
    this.isSynced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
