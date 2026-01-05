import 'package:objectbox/objectbox.dart';

@Entity()
class TeamEntity {
  int id; // ObjectBox id

  String teamId; // API team id
  String name;
  String? description;
  String? avatarUrl;
  
  int memberCount;
  String? createdByUserId;
  String? createdByUsername;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;
  
  bool isSynced;
  
  String? memberIdsJson; // JSON array of member user IDs
  String? taskIdsJson; // JSON array of task IDs
  String? customTaskStatusesJson; // JSON array of custom task statuses
  String? teamIcon; // Icon key (e.g., 'rocket', 'computer')
  String? teamColor; // Hex color string (e.g., '#2E90FA')

  TeamEntity({
    this.id = 0,
    required this.teamId,
    required this.name,
    this.description,
    this.avatarUrl,
    this.memberCount = 0,
    this.createdByUserId,
    this.createdByUsername,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isSynced = false,
    this.memberIdsJson,
    this.taskIdsJson,
    this.customTaskStatusesJson,
    this.teamIcon,
    this.teamColor,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
