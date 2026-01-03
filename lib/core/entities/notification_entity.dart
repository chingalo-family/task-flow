import 'package:objectbox/objectbox.dart';

@Entity()
class NotificationEntity {
  @Id()
  int id; // ObjectBox id

  @Index()
  String notificationId; // API notification id
  String title;
  String? body;
  String type; // 'task_assigned', 'team_invite', 'task_completed', 'mention', etc.
  
  bool isRead;
  String? relatedEntityId; // ID of related task, team, etc.
  String? relatedEntityType; // 'task', 'team', 'user', etc.
  
  String? actorUserId; // User who triggered the notification
  String? actorUsername;
  String? actorAvatarUrl;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  String? metadataJson; // Additional metadata stored as JSON
  
  bool isSynced;

  NotificationEntity({
    this.id = 0,
    required this.notificationId,
    required this.title,
    this.body,
    required this.type,
    this.isRead = false,
    this.relatedEntityId,
    this.relatedEntityType,
    this.actorUserId,
    this.actorUsername,
    this.actorAvatarUrl,
    DateTime? createdAt,
    this.isSynced = false,
  }) : createdAt = createdAt ?? DateTime.now();
}
