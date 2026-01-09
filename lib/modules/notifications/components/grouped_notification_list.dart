import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart' as app_notif;
import 'package:task_flow/modules/notifications/components/notification_card.dart';

class GroupedNotificationList extends StatelessWidget {
  final Map<String, List<app_notif.Notification>> groupedNotifications;
  final String recentLabel;
  final String earlierLabel;

  const GroupedNotificationList({
    super.key,
    required this.groupedNotifications,
    this.recentLabel = 'Recent',
    this.earlierLabel = 'Earlier',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recent Notifications
        if (groupedNotifications[recentLabel] != null &&
            groupedNotifications[recentLabel]!.isNotEmpty) ...[
          for (var notification in groupedNotifications[recentLabel]!)
            Padding(
              padding: EdgeInsets.only(bottom: AppConstant.spacing12),
              child: NotificationCard(notification: notification),
            ),
        ],
        // Earlier Section
        if (groupedNotifications[earlierLabel] != null &&
            groupedNotifications[earlierLabel]!.isNotEmpty) ...[
          SizedBox(height: AppConstant.spacing16),
          Padding(
            padding: EdgeInsets.only(bottom: AppConstant.spacing16),
            child: Text(
              earlierLabel,
              style: TextStyle(
                color: AppConstant.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (var notification in groupedNotifications[earlierLabel]!)
            Padding(
              padding: EdgeInsets.only(bottom: AppConstant.spacing12),
              child: NotificationCard(notification: notification),
            ),
        ],
        SizedBox(height: AppConstant.spacing24),
      ],
    );
  }
}
