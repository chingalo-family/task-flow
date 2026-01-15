import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/notification_constants.dart';
import 'package:task_flow/core/models/models.dart' as app_notif;

class NotificationCard extends StatelessWidget {
  final app_notif.Notification notification;

  const NotificationCard({super.key, required this.notification});

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationConstants.typeTaskAssigned:
        return Icons.task_alt;
      case NotificationConstants.typeTeamInvite:
        return Icons.people;
      case NotificationConstants.typeTaskCompleted:
        return Icons.check_circle;
      case NotificationConstants.typeMention:
        return Icons.alternate_email;
      case NotificationConstants.typeDeadlineReminder:
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationConstants.typeTaskAssigned:
        return AppConstant.primaryBlue;
      case NotificationConstants.typeTeamInvite:
        return AppConstant.successGreen;
      case NotificationConstants.typeTaskCompleted:
        return AppConstant.successGreen;
      case NotificationConstants.typeMention:
        return AppConstant.warningOrange;
      case NotificationConstants.typeDeadlineReminder:
        return AppConstant.errorRed;
      default:
        return AppConstant.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = Provider.of<NotificationState>(
      context,
      listen: false,
    );

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: AppConstant.errorRed,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppConstant.spacing16),
        child: Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      onDismissed: (direction) {
        notificationState.deleteNotification(notification.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppConstant.cardBackground
              : AppConstant.cardBackground.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
          border: Border.all(
            color: notification.isRead
                ? Colors.transparent
                : AppConstant.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
            onTap: () {
              if (!notification.isRead) {
                notificationState.markAsRead(notification.id);
              }
              // TODO: Navigate to related entity
            },
            child: Padding(
              padding: EdgeInsets.all(AppConstant.spacing12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getNotificationColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getNotificationIcon(),
                      color: _getNotificationColor(),
                      size: 20,
                    ),
                  ),

                  SizedBox(width: AppConstant.spacing12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: notification.isRead
                                          ? FontWeight.normal
                                          : FontWeight.w600,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead) ...[
                              SizedBox(width: 8),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppConstant.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),

                        if (notification.body != null &&
                            notification.body!.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(
                            notification.body!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        SizedBox(height: 8),

                        Text(
                          notification.getTimeAgo(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: 12,
                                color: AppConstant.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
