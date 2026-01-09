import 'package:objectbox/objectbox.dart';

@Entity()
class NotificationEntity {
  @Id()
  int id;

  @Index()
  String notificationId;
  String title;
  String? body;
  String
  type; // 'task_assigned', 'team_invite', 'task_completed', 'mention', etc.

  bool isRead;
  String? relatedEntityId;
  String? relatedEntityType; // 'task', 'team', 'user', etc.

  String? actorUserId;
  String? actorUsername;
  String? actorAvatarUrl;

  @Property(type: PropertyType.date)
  DateTime createdAt;

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
    String? metadataJson,
  }) : createdAt = createdAt ?? DateTime.now();
}
