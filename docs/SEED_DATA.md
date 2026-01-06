# Seed Data Feature

## Overview

The Task Flow application now includes a seed data feature that automatically prepopulates the app with sample data on first launch. This helps new users explore the app's features immediately without having to manually create tasks, teams, and notifications.

## What's Included

The seed data service (`lib/core/services/seed_data_service.dart`) creates the following sample data:

### Sample Users (4)
- Sarah Chen (sarah_chen)
- James Wilson (james_wilson)
- Maria Garcia (maria_garcia)
- David Kim (david_kim)

### Sample Teams (3)
1. **Product Development** - Building the future of task management
   - Members: Sarah, James, Maria
   - Icon: Rocket 🚀
   - Color: Blue (#2E90FA)

2. **Marketing Team** - Spreading the word about our amazing product
   - Members: Maria, David
   - Icon: Megaphone 📣
   - Color: Orange (#F79009)

3. **Design Studio** - Crafting beautiful user experiences
   - Members: Sarah, David
   - Icon: Palette 🎨
   - Color: Purple (#7F56D9)

### Sample Tasks (9)

**Focus Tasks (Due Today/Soon):**
- Review product roadmap Q1 (High priority, In Progress)
- Fix critical bug in login flow (High priority, In Progress, with subtasks)
- Design new onboarding screens (High priority, Pending)

**Upcoming Tasks:**
- Prepare Q1 marketing campaign (Medium priority)
- Conduct user research interviews (Medium priority, with subtasks)
- Update project documentation (Low priority)

**Overdue Tasks:**
- Submit monthly report (High priority, 2 days overdue)
- Review team performance (Medium priority, 1 day overdue)

**Completed Tasks:**
- Launch new feature: Dark mode (Completed)

### Sample Notifications (7)
- New task assigned
- Team invitation
- Task completed
- Task overdue alert
- New comment
- Task due soon reminder
- New team member joined

## How It Works

1. **First Launch Detection**: The service uses SharedPreferences to track whether seed data has been loaded using the key `seed_data_loaded`.

2. **Initialization Flow**: During app startup (in `splash.dart`), the `SeedDataService` is called before other state initialization:
   ```dart
   final seedDataService = SeedDataService();
   await seedDataService.initializeSeedData();
   ```

3. **One-Time Loading**: The seed data is only created once. On subsequent app launches, the service checks the preference flag and skips initialization.

4. **Data Creation Order**:
   - Users are created first (needed for teams and tasks)
   - Teams are created next (needed for task assignments)
   - Tasks are created (with proper user and team references)
   - Notifications are created last

## Usage

The seed data is automatically loaded when:
- The app is launched for the first time
- The app is launched after clearing all data
- The app is launched after calling `resetSeedData()`

### Resetting Seed Data (For Development/Testing)

If you want to reload the seed data, you can call:

```dart
final seedDataService = SeedDataService();
await seedDataService.resetSeedData();
```

This will clear the flag, causing the seed data to be recreated on the next app launch.

## Benefits

1. **Better User Onboarding**: New users can immediately see how the app works with real-looking data
2. **Feature Discovery**: Users can explore all features (tasks, teams, notifications) without setup
3. **Demo Ready**: The app always has meaningful data for demonstrations
4. **Consistent Experience**: All new users see the same initial data

## Technical Details

### Files Modified
- `lib/core/services/seed_data_service.dart` - New service for managing seed data
- `lib/modules/splash/splash.dart` - Integration point for seed data initialization

### Dependencies
- Uses existing services: TaskService, TeamService, NotificationService
- Uses UserOfflineProvider directly for user creation
- Uses PreferenceService for tracking initialization state

### Data Persistence
All seed data is stored in ObjectBox (offline database) and persists across app sessions.

## Future Enhancements

Potential improvements for the seed data feature:
- Allow users to clear and reload seed data from settings
- Make seed data configurable (different sets for different use cases)
- Add more diverse task examples (different categories, priorities)
- Include sample projects and milestones
- Add sample task comments and activity history
