import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart' as app_notif;
import 'package:task_flow/core/utils/notification_filter_utils.dart';
import 'package:task_flow/modules/notifications/components/filter_chip.dart' as custom_chip;
import 'package:task_flow/modules/notifications/components/grouped_notification_list.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationState>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      body: SafeArea(
        child: Consumer<NotificationState>(
          builder: (context, notificationState, child) {
            if (notificationState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppConstant.primaryBlue,
                ),
              );
            }

            final filteredNotifications = NotificationFilterUtils
                .filterNotifications(
              notificationState.notifications,
              selectedFilter,
            );
            final groupedNotifications = NotificationFilterUtils
                .groupNotificationsByTime(filteredNotifications);

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppConstant.darkBackground,
                  elevation: 0,
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.textPrimary,
                    ),
                  ),
                  actions: [
                    if (notificationState.unreadCount > 0)
                      TextButton(
                        onPressed: () {
                          notificationState.markAllAsRead();
                        },
                        child: Text(
                          'Mark all read',
                          style: TextStyle(
                            color: AppConstant.primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        notificationState.notificationsEnabled
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        color: notificationState.notificationsEnabled
                            ? AppConstant.primaryBlue
                            : AppConstant.textSecondary,
                      ),
                      onPressed: () {
                        notificationState.setNotificationsEnabled(
                          !notificationState.notificationsEnabled,
                        );
                      },
                    ),
                  ],
                ),

                // Filter Tabs
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing16,
                      vertical: AppConstant.spacing12,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          custom_chip.FilterChip(
                            label: 'All',
                            isSelected: selectedFilter == 'All',
                            onTap: () => setState(() => selectedFilter = 'All'),
                          ),
                          SizedBox(width: AppConstant.spacing8),
                          custom_chip.FilterChip(
                            label: 'Unread',
                            isSelected: selectedFilter == 'Unread',
                            onTap: () =>
                                setState(() => selectedFilter = 'Unread'),
                          ),
                          SizedBox(width: AppConstant.spacing8),
                          custom_chip.FilterChip(
                            label: 'Mentions',
                            isSelected: selectedFilter == 'Mentions',
                            onTap: () =>
                                setState(() => selectedFilter = 'Mentions'),
                          ),
                          SizedBox(width: AppConstant.spacing8),
                          custom_chip.FilterChip(
                            label: 'Assigned to Me',
                            isSelected: selectedFilter == 'Assigned to Me',
                            onTap: () =>
                                setState(() => selectedFilter = 'Assigned to Me'),
                          ),
                          SizedBox(width: AppConstant.spacing8),
                          custom_chip.FilterChip(
                            label: 'System',
                            isSelected: selectedFilter == 'System',
                            onTap: () =>
                                setState(() => selectedFilter = 'System'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Notification List
                filteredNotifications.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 80,
                                color: AppConstant.textSecondary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              SizedBox(height: AppConstant.spacing16),
                              Text(
                                'No notifications',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppConstant.textSecondary,
                                    ),
                              ),
                              SizedBox(height: AppConstant.spacing8),
                              Text(
                                'You\'ll see updates here',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstant.spacing16,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: GroupedNotificationList(
                            groupedNotifications: groupedNotifications,
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
