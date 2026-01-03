import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/models.dart' as app_notif;
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/modules/notifications/components/notification_card.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedFilter = 'All';
  bool notificationsMuted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationState>(context, listen: false).initialize();
    });
  }

  List<app_notif.Notification> _filterNotifications(
    List<app_notif.Notification> notifications,
  ) {
    switch (selectedFilter) {
      case 'Mentions':
        return notifications
            .where((n) => n.type == 'mention')
            .toList();
      case 'Assigned to Me':
        return notifications
            .where((n) => n.type == 'task_assigned')
            .toList();
      case 'System':
        return notifications
            .where((n) => n.type == 'system' || n.type == 'deadline_reminder')
            .toList();
      default:
        return notifications;
    }
  }

  Map<String, List<app_notif.Notification>> _groupNotifications(
    List<app_notif.Notification> notifications,
  ) {
    final Map<String, List<app_notif.Notification>> grouped = {
      'Recent': [],
      'Earlier': [],
    };

    final now = DateTime.now();
    for (var notification in notifications) {
      final difference = now.difference(notification.createdAt);
      if (difference.inHours < 24) {
        grouped['Recent']!.add(notification);
      } else {
        grouped['Earlier']!.add(notification);
      }
    }

    return grouped;
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

            final filteredNotifications = _filterNotifications(
              notificationState.notifications,
            );
            final groupedNotifications = _groupNotifications(
              filteredNotifications,
            );

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
                        notificationsMuted
                            ? Icons.notifications_off
                            : Icons.notifications_none,
                        color: AppConstant.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          notificationsMuted = !notificationsMuted;
                        });
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
                          _buildFilterChip('All'),
                          SizedBox(width: AppConstant.spacing8),
                          _buildFilterChip('Mentions'),
                          SizedBox(width: AppConstant.spacing8),
                          _buildFilterChip('Assigned to Me'),
                          SizedBox(width: AppConstant.spacing8),
                          _buildFilterChip('System'),
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
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Recent Notifications
                            if (groupedNotifications['Recent']!.isNotEmpty) ...[
                              for (var notification in groupedNotifications['Recent']!)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppConstant.spacing12,
                                  ),
                                  child: NotificationCard(
                                    notification: notification,
                                  ),
                                ),
                            ],
                            
                            // Earlier Section
                            if (groupedNotifications['Earlier']!.isNotEmpty) ...[
                              SizedBox(height: AppConstant.spacing16),
                              SectionHeader(
                                title: 'Earlier',
                                padding: EdgeInsets.only(
                                  left: 0,
                                  bottom: AppConstant.spacing16,
                                ),
                              ),
                              for (var notification in groupedNotifications['Earlier']!)
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: AppConstant.spacing12,
                                  ),
                                  child: NotificationCard(
                                    notification: notification,
                                  ),
                                ),
                            ],
                            SizedBox(height: AppConstant.spacing24),
                          ]),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing16,
          vertical: AppConstant.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstant.primaryBlue
              : AppConstant.cardBackground,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppConstant.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
