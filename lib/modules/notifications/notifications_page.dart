import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/notifications/components/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
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

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: AppConstant.darkBackground,
                  elevation: 0,
                  title: Row(
                    children: [
                      Icon(
                        Icons.notifications_rounded,
                        color: AppConstant.primaryBlue,
                        size: 24,
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                          ),
                        ),
                      ),
                  ],
                ),

                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstant.spacing24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay Updated',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: AppConstant.spacing8),
                        Text(
                          notificationState.unreadCount > 0
                              ? '${notificationState.unreadCount} unread ${notificationState.unreadCount == 1 ? 'notification' : 'notifications'}'
                              : 'You\'re all caught up!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

                // Notification List
                notificationState.notifications.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 80,
                                color: AppConstant.textSecondary.withOpacity(0.3),
                              ),
                              SizedBox(height: AppConstant.spacing16),
                              Text(
                                'No notifications',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                        padding: EdgeInsets.all(AppConstant.spacing16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final notification = notificationState.notifications[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: AppConstant.spacing8),
                                child: NotificationCard(notification: notification),
                              );
                            },
                            childCount: notificationState.notifications.length,
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
