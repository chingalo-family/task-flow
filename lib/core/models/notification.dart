import 'package:task_flow/core/utils/utils.dart';

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
  final String recipientUserId; // User who should receive this notification (required)
  final String recipientUserName; // Name of recipient user (required)
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
    required this.recipientUserId,
    required this.recipientUserName,
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
    String? recipientUserId,
    String? recipientUserName,
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
      recipientUserId: recipientUserId ?? this.recipientUserId,
      recipientUserName: recipientUserName ?? this.recipientUserName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String getTimeAgo() {
    return TimeUtils.getTimeAgo(createdAt);
  }
}
