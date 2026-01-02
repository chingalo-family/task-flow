class Notification {
  final String id;
  final String title;
  final String? body;
  final String type;
  final bool isRead;
  final String? relatedEntityId;
  final String? relatedEntityType;
  final String? actorUserId;
  final String? actorUsername;
  final String? actorAvatarUrl;
  final DateTime createdAt;

  Notification({
    required this.id,
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
  }) : createdAt = createdAt ?? DateTime.now();

  Notification copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorUserId,
    String? actorUsername,
    String? actorAvatarUrl,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      actorUserId: actorUserId ?? this.actorUserId,
      actorUsername: actorUsername ?? this.actorUsername,
      actorAvatarUrl: actorAvatarUrl ?? this.actorAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
