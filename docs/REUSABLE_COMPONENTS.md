# Reusable Components and Utilities - Settings & Notifications Modules

This document outlines the reusable components and utilities created for the Settings and Notifications modules to improve code maintainability and reusability.

## Settings Module Components

### 1. ProfileAvatarWithEdit
**Location:** `lib/modules/settings/components/profile_avatar_with_edit.dart`

A reusable profile avatar widget with an optional edit button overlay.

**Features:**
- Customizable radius, background color, and edit button color
- Shows user initials in the avatar
- Optional edit button with tap callback
- Automatically scales icon sizes based on avatar radius

**Usage:**
```dart
ProfileAvatarWithEdit(
  initials: 'JD',
  onEditTap: () {
    // Handle profile picture edit
  },
  radius: 50, // Optional, defaults to 50
)
```

### 2. InfoDisplayField
**Location:** `lib/modules/settings/components/info_display_field.dart`

A reusable read-only information display field with consistent styling.

**Features:**
- Optional label display
- Consistent card background and border radius
- Matches app theme colors

**Usage:**
```dart
InfoDisplayField(
  label: 'Display Name',
  value: 'Jane Doe',
  showLabel: true, // Optional, defaults to true
)
```

### 3. PreferenceToggleItem
**Location:** `lib/modules/settings/components/preference_toggle_item.dart`

A reusable preference toggle item for settings with icon, title, subtitle, and switch.

**Features:**
- Icon with colored background
- Optional subtitle
- Customizable switch color
- Consistent styling across preferences

**Usage:**
```dart
PreferenceToggleItem(
  icon: Icons.notifications,
  iconColor: AppConstant.pinkAccent,
  title: 'Notifications',
  subtitle: 'Get notified about updates', // Optional
  value: notificationsEnabled,
  onChanged: (value) {
    // Handle toggle change
  },
  activeColor: AppConstant.primaryBlue, // Optional
)
```

## Notifications Module Components

### 4. FilterChip
**Location:** `lib/modules/notifications/components/filter_chip.dart`

A reusable filter chip for notification filters.

**Features:**
- Selected and unselected states
- Consistent styling with app theme
- Tap callback for selection

**Usage:**
```dart
FilterChip(
  label: 'All',
  isSelected: selectedFilter == 'All',
  onTap: () {
    setState(() => selectedFilter = 'All');
  },
)
```

### 5. GroupedNotificationList
**Location:** `lib/modules/notifications/components/grouped_notification_list.dart`

A reusable widget for displaying notifications grouped by time (Recent/Earlier).

**Features:**
- Displays Recent and Earlier sections
- Customizable section labels
- Uses NotificationCard for each notification
- Automatically handles empty groups

**Usage:**
```dart
GroupedNotificationList(
  groupedNotifications: {
    'Recent': recentNotifications,
    'Earlier': earlierNotifications,
  },
  recentLabel: 'Recent', // Optional, defaults to 'Recent'
  earlierLabel: 'Earlier', // Optional, defaults to 'Earlier'
)
```

## Utilities

### 6. NotificationFilterUtils
**Location:** `lib/core/utils/notification_filter_utils.dart`

A utility class for filtering and grouping notifications.

**Methods:**

#### filterNotifications
Filters notifications based on selected filter type.
```dart
List<Notification> filtered = NotificationFilterUtils.filterNotifications(
  notifications,
  'Unread', // Options: 'All', 'Unread', 'Mentions', 'Assigned to Me', 'System'
);
```

#### groupNotificationsByTime
Groups notifications by time (Recent < 24hrs, Earlier >= 24hrs).
```dart
Map<String, List<Notification>> grouped = 
  NotificationFilterUtils.groupNotificationsByTime(
    notifications,
    recentHoursThreshold: 24, // Optional, defaults to 24
  );
```

#### getUnreadCount
Gets count of unread notifications.
```dart
int unreadCount = NotificationFilterUtils.getUnreadCount(notifications);
```

#### getNotificationsByType
Gets notifications of a specific type.
```dart
List<Notification> taskNotifications = 
  NotificationFilterUtils.getNotificationsByType(
    notifications,
    'task_assigned',
  );
```

#### getUnreadNotificationsByType
Gets unread notifications of a specific type.
```dart
List<Notification> unreadMentions = 
  NotificationFilterUtils.getUnreadNotificationsByType(
    notifications,
    'mention',
  );
```

## Benefits of These Reusable Components

1. **Code Reduction:** Eliminates ~150+ lines of duplicate code across the modules
2. **Consistency:** Ensures all similar UI elements look and behave the same way
3. **Maintainability:** Changes to design can be made in one place
4. **Testability:** Components can be tested in isolation
5. **Reusability:** Can be used in other parts of the app beyond Settings and Notifications
6. **Type Safety:** Proper typing and error handling built in
7. **Documentation:** Well-documented with examples for easy adoption

## Migration Guide

### Before (Settings Page):
```dart
// Repeated code for display fields
Container(
  width: double.infinity,
  padding: EdgeInsets.symmetric(...),
  decoration: BoxDecoration(...),
  child: Text(...),
);
```

### After (Settings Page):
```dart
// Using reusable component
InfoDisplayField(
  label: 'Display Name',
  value: userName,
)
```

### Before (Notifications Page):
```dart
// Custom filtering logic in page
List<Notification> _filterNotifications(...) {
  switch (selectedFilter) {
    case 'Unread': ...
    // 20+ lines of filtering logic
  }
}
```

### After (Notifications Page):
```dart
// Using utility class
final filtered = NotificationFilterUtils.filterNotifications(
  notifications,
  selectedFilter,
);
```

## Future Enhancements

These components are designed to be extensible. Consider adding:

1. **ProfileAvatarWithEdit:** Support for actual profile images (not just initials)
2. **InfoDisplayField:** Editable mode with validation
3. **PreferenceToggleItem:** Loading state during async operations
4. **FilterChip:** Badge count display
5. **NotificationFilterUtils:** Custom filter functions, date range filtering

## Testing

All components should be tested for:
- Correct rendering with various props
- Proper callback execution
- Edge cases (empty strings, null values)
- Accessibility features
- Theme consistency

Example test:
```dart
testWidgets('ProfileAvatarWithEdit displays initials correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProfileAvatarWithEdit(
        initials: 'JD',
      ),
    ),
  );
  
  expect(find.text('JD'), findsOneWidget);
});
```
