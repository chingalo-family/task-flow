# Notification System Enhancement

This document describes the enhanced notification system implemented in the Task Flow application.

## Overview

The notification system has been enhanced to support comprehensive notification management across tasks, teams, and system events. The system includes:

1. **Preference Management**: Global and team-specific notification preferences
2. **Service Integration**: Automatic notification creation for various application events
3. **UI Components**: Settings pages for managing notification preferences
4. **Flexible Notification Types**: Support for 14+ different notification types

## Architecture

### Models

#### NotificationPreferences
Location: `lib/core/models/notification_preferences.dart`

Manages user preferences for different notification types:
- Task-related: assigned, completed, status changes, comments, mentions, priority changes
- Deadline-related: reminders, overdue tasks
- Team-related: invites, member additions/removals
- System notifications

**Key Methods:**
- `toJson()` / `fromJson()`: Serialization for storage
- `isNotificationTypeEnabled(String type)`: Check if a specific notification type is enabled
- `copyWith()`: Create modified copies of preferences

### Constants

#### NotificationConstants
Location: `lib/core/constants/notification_constants.dart`

Defines constants for:
- Notification types (e.g., `typeTaskAssigned`, `typeDeadlineReminder`)
- Preference keys for storage
- Entity types (task, team, user, comment)

### Services

#### NotificationPreferenceService
Location: `lib/core/services/notification_preference_service.dart`

Manages loading and saving notification preferences:
- `getGlobalPreferences()`: Get user's global notification preferences
- `saveGlobalPreferences(prefs)`: Save global preferences
- `getTeamPreferences(teamId)`: Get team-specific preferences
- `saveTeamPreferences(teamId, prefs)`: Save team-specific preferences
- `isNotificationTypeEnabled(type)`: Check if a notification type is globally enabled
- `isTeamNotificationTypeEnabled(teamId, type)`: Check if enabled for a specific team

#### Enhanced NotificationService
Location: `lib/core/services/notification_service.dart`

Enhanced with preference-aware notification creation:
- `createNotification(notification)`: Creates notification if preferences allow
- `createNotificationForTeam(notification, teamId)`: Creates with team-specific preference check

#### Enhanced TaskService
Location: `lib/core/services/task_service.dart`

Automatically creates notifications for:
- Task creation (when assigned to users)
- Task status changes
- Task completion
- Deadline reminders
- Overdue tasks

**New Methods:**
- `getTasksNeedingDeadlineReminders()`: Find tasks due within 24 hours
- `createDeadlineReminders()`: Generate deadline reminder notifications
- `createOverdueTaskNotifications()`: Generate overdue task notifications

#### Enhanced TeamService
Location: `lib/core/services/team_service.dart`

Automatically creates notifications for:
- Team member additions
- Team member removals

### Notification Types

The system supports the following notification types:

1. **task_assigned**: When a task is assigned to a user
2. **task_completed**: When a task is marked as complete
3. **task_status_change**: When task status is updated
4. **task_priority_change**: When task priority is changed
5. **task_comment**: When someone comments on a task
6. **task_assignment_change**: When a task is reassigned
7. **task_due_date_change**: When task due date is modified
8. **mention**: When a user is mentioned
9. **deadline_reminder**: Reminder before task due date
10. **task_overdue**: When a task becomes overdue
11. **team_invite**: Team invitation
12. **team_member_added**: When a member joins a team
13. **team_member_removed**: When a member leaves a team
14. **system**: System-level notifications

### Utility Functions

#### NotificationUtils
Location: `lib/core/utils/notification_utils.dart`

Enhanced with new helper methods:
- `createTeamMemberAddedNotification()`: Create team member added notification
- `createTeamMemberRemovedNotification()`: Create team member removed notification
- `createTaskPriorityChangeNotification()`: Create priority change notification
- `createTaskOverdueNotification()`: Create overdue task notification
- `createTaskAssignmentChangeNotification()`: Create reassignment notification
- `createTaskDueDateChangeNotification()`: Create due date change notification

Updated icon and color mappings for all new notification types.

## UI Components

### Notification Preferences Page
Location: `lib/modules/settings/pages/notification_preferences_page.dart`

Full-featured preferences management UI with sections for:
- Task Notifications (6 toggle options)
- Deadlines & Reminders (2 toggle options)
- Team Notifications (3 toggle options)
- System Notifications (1 toggle option)

Each preference is displayed with an icon, title, subtitle, and toggle switch.

### Settings Page Integration
Location: `lib/modules/settings/settings_page.dart`

Added:
- Link to Notification Preferences page
- Quick toggle for overall notifications enable/disable

## Usage Examples

### Creating a Notification with Preferences

```dart
// In TaskService when creating a task
final notification = NotificationUtils.createTaskAssignedNotification(
  taskTitle: task.title,
  assignedBy: currentUser.username,
  taskId: task.id,
);

// If task belongs to a team, use team-specific preferences
if (task.teamId != null) {
  await _notificationService.createNotificationForTeam(
    notification,
    task.teamId!,
  );
} else {
  await _notificationService.createNotification(notification);
}
```

### Managing Preferences

```dart
// Load global preferences
final prefService = NotificationPreferenceService();
final prefs = await prefService.getGlobalPreferences();

// Update specific preference
final updated = prefs.copyWith(taskAssigned: false);
await prefService.saveGlobalPreferences(updated);

// Check if notification type is enabled
final isEnabled = await prefService.isNotificationTypeEnabled('task_assigned');
```

### Checking Team-Specific Preferences

```dart
final prefService = NotificationPreferenceService();
final teamPrefs = await prefService.getTeamPreferences(teamId);
final isEnabled = teamPrefs.isNotificationTypeEnabled('task_completed');
```

## Integration Points

### Task Management
- `TaskService.createTask()`: Sends assignment notifications
- `TaskService.updateTaskStatus()`: Sends status change and completion notifications
- `TaskService.createDeadlineReminders()`: Should be called periodically (e.g., daily)
- `TaskService.createOverdueTaskNotifications()`: Should be called periodically

### Team Management
- `TeamService.addMemberToTeam()`: Sends member added notifications
- `TeamService.removeMemberFromTeam()`: Sends member removed notifications

## Recommended Scheduler Setup

For deadline reminders and overdue notifications, implement a periodic check:

```dart
// Suggested: Run daily at 9 AM
void scheduleNotificationChecks() async {
  final taskService = TaskService();
  
  // Check for deadline reminders
  await taskService.createDeadlineReminders();
  
  // Check for overdue tasks
  await taskService.createOverdueTaskNotifications();
}
```

Consider using packages like `workmanager` or `flutter_local_notifications` for background scheduling.

## Testing

### Unit Tests

Test files created:
- `test/models/notification_preferences_test.dart`: Tests for NotificationPreferences model
- `test/utils/notification_utils_test.dart`: Enhanced with tests for all new notification types

To run tests:
```bash
./run_tests.sh
```

Or directly:
```bash
flutter test
```

## Future Enhancements

1. **Team-Specific Preference UI**: Add notification preferences within team settings
2. **Email Notifications**: Integrate with existing email service
3. **Push Notifications**: Add native push notification support
4. **Notification Scheduling**: Implement background task scheduler
5. **Notification Grouping**: Group similar notifications together
6. **Smart Notifications**: AI-based notification prioritization
7. **Notification Delivery Channels**: Support for in-app, email, and push
8. **Quiet Hours**: Schedule when notifications should be muted
9. **Notification History**: Archive and search past notifications
10. **Batch Notifications**: Digest mode for multiple notifications

## Migration Notes

### For Existing Users
- Default preferences are set to `true` (all enabled)
- Existing notification behavior remains unchanged
- Users can customize preferences via Settings → Notification Preferences

### Team Data Model
- `Team` model extended with `notificationPreferences` field
- Backward compatible (nullable field)
- Team preferences are stored separately in SharedPreferences

## Performance Considerations

1. **Preference Caching**: Consider caching preferences in memory to reduce disk reads
2. **Batch Operations**: When creating multiple notifications, consider batching database operations
3. **Background Processing**: Deadline and overdue checks should run in background
4. **Notification Limits**: Consider implementing notification limits to prevent spam

## Security & Privacy

1. **Preference Isolation**: User preferences are stored locally per device
2. **Team Permissions**: Only team members receive team-related notifications
3. **Data Privacy**: Notification content respects entity access permissions
4. **Opt-out Support**: All notification types can be disabled individually

## Troubleshooting

### Notifications Not Appearing
1. Check global notifications are enabled in Settings
2. Verify specific notification type is enabled in Notification Preferences
3. For team notifications, check team-specific preferences
4. Ensure `NotificationState` is initialized properly

### Preferences Not Saving
1. Verify `SharedPreferences` initialization
2. Check for async/await errors in preference service
3. Ensure proper JSON serialization/deserialization

### Missing Notification Types
1. Verify notification type constant is defined in `NotificationConstants`
2. Add icon/color mapping in `NotificationUtils`
3. Add preference field in `NotificationPreferences` model
4. Update preference service getter/setter methods

## Contributing

When adding new notification types:

1. Add type constant to `NotificationConstants`
2. Add preference field to `NotificationPreferences` model
3. Add creation method to `NotificationUtils`
4. Add icon/color mapping in `NotificationUtils`
5. Update preference service methods
6. Add UI toggle in `NotificationPreferencesPage`
7. Write unit tests
8. Update this documentation
