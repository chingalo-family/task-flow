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
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
