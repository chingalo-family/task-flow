class Team {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final int memberCount;
  final List<String>? memberIds;
  final List<String>? taskIds; // List of task IDs belonging to this team
  final String? createdByUserId;
  final String? createdByUsername;
  final DateTime createdAt;
  final DateTime updatedAt;

  Team({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    this.memberCount = 0,
    this.memberIds,
    this.taskIds,
    this.createdByUserId,
    this.createdByUsername,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Team copyWith({
    String? id,
    String? name,
    String? description,
    String? avatarUrl,
    int? memberCount,
    List<String>? memberIds,
    List<String>? taskIds,
    String? createdByUserId,
    String? createdByUsername,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      memberCount: memberCount ?? this.memberCount,
      memberIds: memberIds ?? this.memberIds,
      taskIds: taskIds ?? this.taskIds,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByUsername: createdByUsername ?? this.createdByUsername,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
