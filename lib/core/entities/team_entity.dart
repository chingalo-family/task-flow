import 'package:objectbox/objectbox.dart';

@Entity()
class TeamEntity {
  int id; // ObjectBox id

  @Index() // TODO: Add index on teamId for faster lookups by team ID
  String teamId; // API team id

  @Index() // TODO: Add index on name for faster search by team name
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

  @Index() // TODO: Add index on isSynced for filtering synced/unsynced teams
  bool isSynced;

  String? memberIdsJson;
  String? taskIdsJson;
  String? customTaskStatusesJson;
  String? teamIcon;
  String? teamColor;

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
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
