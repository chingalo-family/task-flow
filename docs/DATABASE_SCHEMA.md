# Database Schema Documentation

This document describes the ObjectBox database schema used in Task Flow for local data persistence.

## 📋 Overview

Task Flow uses **ObjectBox**, a high-performance NoSQL database, for local data storage. ObjectBox provides:
- ⚡ Fast query performance
- 📴 Full offline support
- 💾 Efficient storage
- 🔄 Easy synchronization
- 🎯 Type-safe Dart integration

## 🗄️ Database Entities

### 1. UserEntity

Stores user account information and authentication data.

```dart
@Entity()
class UserEntity {
  int id;                    // ObjectBox auto-incremented ID
  String apiUserId;          // External API user ID
  String username;           // Unique username
  String? fullName;          // User's full name
  String? password;          // Encrypted password (for offline login)
  String? email;             // Email address
  String? phoneNumber;       // Phone number
  bool isLogin;              // Current login status
  DateTime createdAt;        // Account creation timestamp
  DateTime updatedAt;        // Last modification timestamp
}
```

**Indexes**: None currently (consider adding index on `apiUserId`)

**Relationships**: 
- One user → Many tasks (as assignee)
- One user → Many teams (as member)
- One user → Many notifications

**Usage**:
```dart
// Create user
final user = UserEntity(
  apiUserId: 'usr_123',
  username: 'johndoe',
  fullName: 'John Doe',
  email: 'john@example.com',
  isLogin: true,
);
await userBox.put(user);

// Query by username
final query = userBox
    .query(UserEntity_.username.equals('johndoe'))
    .build();
final user = query.findFirst();
```

### 2. TaskEntity

Stores task information including assignments, deadlines, and progress.

```dart
@Entity()
class TaskEntity {
  @Id()
  int id;                         // ObjectBox auto-incremented ID
  
  @Index()
  String taskId;                  // External API task ID
  
  String title;                   // Task title (required)
  String? description;            // Detailed description
  
  String status;                  // 'pending' | 'in_progress' | 'completed'
  String priority;                // 'low' | 'medium' | 'high'
  String? category;               // Task category
  
  // Assignment fields
  String? assignedToUserId;       // Primary assignee API ID
  String? assignedToUsername;     // Primary assignee username
  String? assignedUserIdsJson;    // JSON array of multiple assignees
  
  // Team fields
  String? teamId;                 // Associated team API ID
  String? teamName;               // Team name (denormalized)
  
  // Date fields
  @Property(type: PropertyType.date)
  DateTime? dueDate;              // Task deadline
  
  @Property(type: PropertyType.date)
  DateTime? completedAt;          // Completion timestamp
  
  // Project fields
  String? projectId;              // Project API ID
  String? projectName;            // Project name (denormalized)
  
  // Complex data (stored as JSON)
  String? tagsJson;               // JSON array of tags
  String? attachmentsJson;        // JSON array of attachment URLs
  String? subtasksJson;           // JSON array of subtasks
  
  // Additional fields
  bool? remindMe;                 // Reminder flag
  int progress;                   // Progress percentage (0-100)
  
  // Sync status
  bool isSynced;                  // Has been synced with server
  
  // Timestamps
  @Property(type: PropertyType.date)
  DateTime createdAt;             // Creation timestamp
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;             // Last modification timestamp
}
```

**Indexes**: 
- `taskId` - For fast lookup by API ID

**Recommended Additional Indexes**:
```dart
@Index()
String status;                    // Filter by status

@Index()
String priority;                  // Filter by priority

@Index()
bool isSynced;                    // Find unsynced tasks
```

**JSON Fields Structure**:

```dart
// tagsJson
["feature", "bug", "urgent"]

// attachmentsJson
["https://example.com/file1.pdf", "https://example.com/file2.png"]

// subtasksJson
[
  {"title": "Subtask 1", "completed": true},
  {"title": "Subtask 2", "completed": false}
]

// assignedUserIdsJson
["usr_123", "usr_456", "usr_789"]
```

**Usage**:
```dart
// Create task
final task = TaskEntity(
  taskId: 'task_abc123',
  title: 'Implement feature',
  status: TaskConstants.statusPending,
  priority: TaskConstants.priorityHigh,
  dueDate: DateTime.now().add(Duration(days: 7)),
  progress: 0,
  isSynced: false,
);
await taskBox.put(task);

// Query pending tasks
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .order(TaskEntity_.dueDate)
    .build();
final tasks = query.find();

// Query tasks by team
final teamQuery = taskBox
    .query(TaskEntity_.teamId.equals('team_789'))
    .build();
final teamTasks = teamQuery.find();
```

### 3. TeamEntity

Stores team information, members, and custom configurations.

```dart
@Entity()
class TeamEntity {
  int id;                         // ObjectBox auto-incremented ID
  
  @Index()
  String teamId;                  // External API team ID
  
  @Index()
  String name;                    // Team name
  
  String? description;            // Team description
  String? avatarUrl;              // Team avatar URL
  
  int memberCount;                // Number of members
  String? createdByUserId;        // Creator API ID
  String? createdByUsername;      // Creator username
  
  // Timestamps
  @Property(type: PropertyType.date)
  DateTime createdAt;             // Creation timestamp
  
  @Property(type: PropertyType.date)
  DateTime updatedAt;             // Last modification timestamp
  
  // Sync status
  @Index()
  bool isSynced;                  // Has been synced with server
  
  // Complex data (stored as JSON)
  String? memberIdsJson;          // JSON array of member user IDs
  String? taskIdsJson;            // JSON array of task IDs
  String? customTaskStatusesJson; // JSON array of custom statuses
  
  // Customization
  String? teamIcon;               // Icon key (e.g., 'rocket', 'computer')
  String? teamColor;              // Hex color (e.g., '#2E90FA')
}
```

**Indexes**:
- `teamId` - For fast lookup by API ID
- `name` - For search by team name
- `isSynced` - Filter synced/unsynced teams

**JSON Fields Structure**:

```dart
// memberIdsJson
["usr_123", "usr_456", "usr_789"]

// taskIdsJson
["task_abc", "task_def", "task_ghi"]

// customTaskStatusesJson
[
  {"key": "code_review", "label": "Code Review", "color": "#F59E0B"},
  {"key": "testing", "label": "Testing", "color": "#10B981"}
]
```

**Usage**:
```dart
// Create team
final team = TeamEntity(
  teamId: 'team_789',
  name: 'Development Team',
  description: 'Core dev team',
  memberCount: 5,
  teamIcon: 'rocket',
  teamColor: '#2E90FA',
  isSynced: false,
);
await teamBox.put(team);

// Query teams by name
final query = teamBox
    .query(TeamEntity_.name.contains('Dev'))
    .build();
final teams = query.find();

// Get all unsynced teams
final unsyncedQuery = teamBox
    .query(TeamEntity_.isSynced.equals(false))
    .build();
final unsyncedTeams = unsyncedQuery.find();
```

### 4. NotificationEntity

Stores notifications and alerts for users.

```dart
@Entity()
class NotificationEntity {
  @Id()
  int id;                         // ObjectBox auto-incremented ID
  
  @Index()
  String notificationId;          // External API notification ID
  
  String title;                   // Notification title
  String? body;                   // Notification message
  
  String type;                    // Notification type
                                  // 'task_assigned' | 'team_invite' | 
                                  // 'task_completed' | 'mention' | 'system'
  
  bool isRead;                    // Read status
  
  // Related entity information
  String? relatedEntityId;        // ID of related task/team/user
  String? relatedEntityType;      // 'task' | 'team' | 'user'
  
  // Actor information
  String? actorUserId;            // User who triggered notification
  String? actorUsername;          // Actor username
  String? actorAvatarUrl;         // Actor avatar URL
  
  // Timestamp
  @Property(type: PropertyType.date)
  DateTime createdAt;             // Notification timestamp
  
  // Additional data
  String? metadataJson;           // Additional metadata (JSON)
  
  // Sync status
  bool isSynced;                  // Has been synced with server
}
```

**Indexes**:
- `notificationId` - For fast lookup by API ID

**Recommended Additional Indexes**:
```dart
@Index()
bool isRead;                      // Filter by read status

@Index()
String type;                      // Filter by notification type
```

**Metadata JSON Structure**:

```dart
// Task notification metadata
{
  "taskTitle": "Implement feature",
  "taskPriority": "high",
  "teamName": "Development Team"
}

// Team invite metadata
{
  "teamName": "Marketing Team",
  "inviterName": "John Doe"
}
```

**Usage**:
```dart
// Create notification
final notification = NotificationEntity(
  notificationId: 'notif_abc',
  title: 'New task assigned',
  body: 'You have been assigned to "Implement feature"',
  type: 'task_assigned',
  isRead: false,
  relatedEntityId: 'task_123',
  relatedEntityType: 'task',
  actorUserId: 'usr_456',
  actorUsername: 'janedoe',
  isSynced: false,
);
await notificationBox.put(notification);

// Query unread notifications
final query = notificationBox
    .query(NotificationEntity_.isRead.equals(false))
    .order(NotificationEntity_.createdAt, flags: Order.descending)
    .build();
final unread = query.find();

// Query notifications by type
final typeQuery = notificationBox
    .query(NotificationEntity_.type.equals('task_assigned'))
    .build();
final taskNotifications = typeQuery.find();
```

## 🔗 Relationships

### Implicit Relationships

ObjectBox entities use foreign keys stored as strings (API IDs) rather than ObjectBox relations:

```dart
// Task → User (assignee)
TaskEntity.assignedToUserId → UserEntity.apiUserId

// Task → Team
TaskEntity.teamId → TeamEntity.teamId

// Notification → User (actor)
NotificationEntity.actorUserId → UserEntity.apiUserId

// Notification → Task (related entity)
NotificationEntity.relatedEntityId → TaskEntity.taskId
```

**Rationale**: 
- Simplifies synchronization with remote API
- Avoids ObjectBox relation complexity
- Matches REST API structure

### Querying Related Data

```dart
// Get user's tasks
final user = getUserById('usr_123');
final tasksQuery = taskBox
    .query(TaskEntity_.assignedToUserId.equals(user.apiUserId))
    .build();
final userTasks = tasksQuery.find();

// Get team members (requires additional query)
final team = getTeamById('team_789');
final memberIds = jsonDecode(team.memberIdsJson ?? '[]');
final members = memberIds.map((id) => getUserByApiId(id)).toList();
```

## 📊 Query Examples

### Common Queries

**Get all pending tasks**:
```dart
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .build();
final tasks = query.find();
```

**Get high priority tasks due this week**:
```dart
final now = DateTime.now();
final weekEnd = now.add(Duration(days: 7));

final query = taskBox
    .query(
      TaskEntity_.priority.equals('high') &
      TaskEntity_.dueDate.between(now.millisecondsSinceEpoch, weekEnd.millisecondsSinceEpoch)
    )
    .order(TaskEntity_.dueDate)
    .build();
final tasks = query.find();
```

**Get unsynced entities**:
```dart
final unsyncedTasks = taskBox
    .query(TaskEntity_.isSynced.equals(false))
    .build()
    .find();

final unsyncedTeams = teamBox
    .query(TeamEntity_.isSynced.equals(false))
    .build()
    .find();
```

**Search tasks by title**:
```dart
final query = taskBox
    .query(TaskEntity_.title.contains('feature', caseSensitive: false))
    .build();
final tasks = query.find();
```

**Get recently created notifications**:
```dart
final yesterday = DateTime.now().subtract(Duration(days: 1));

final query = notificationBox
    .query(NotificationEntity_.createdAt.greaterThan(yesterday.millisecondsSinceEpoch))
    .order(NotificationEntity_.createdAt, flags: Order.descending)
    .build();
final recent = query.find();
```

## 🔄 Data Synchronization

### Sync Status Tracking

All entities have an `isSynced` boolean field:
- `true` - Data matches server
- `false` - Local changes not yet synced

### Sync Workflow

```dart
// 1. Mark as unsynced on local change
task.isSynced = false;
await taskBox.put(task);

// 2. Get unsynced items for upload
final unsynced = taskBox
    .query(TaskEntity_.isSynced.equals(false))
    .build()
    .find();

// 3. Upload to server
for (final task in unsynced) {
  await apiClient.uploadTask(task);
  task.isSynced = true;
  await taskBox.put(task);
}

// 4. Download server changes
final serverTasks = await apiClient.fetchTasks();
for (final task in serverTasks) {
  task.isSynced = true;
  await taskBox.put(task);
}
```

## 🗑️ Data Management

### Clearing Data

```dart
// Clear all tasks
taskBox.removeAll();

// Clear all data
store.close();
await Directory(dbPath).delete(recursive: true);
```

### Database Backup

```dart
// Backup database directory
final dbDir = await getApplicationDocumentsDirectory();
final backupDir = Directory('${dbDir.path}/backup');
await dbDir.copy(backupDir.path);
```

## 📈 Performance Optimization

### Index Usage

Add indexes to frequently queried fields:

```dart
@Index()
String status;    // Frequently filtered

@Index()
bool isSynced;    // Sync queries
```

### Query Limits

Limit results for large datasets:

```dart
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .build();
query.limit = 50;  // Limit to 50 results
final tasks = query.find();
```

### Lazy Queries

Use lazy queries for large result sets:

```dart
final query = taskBox.query().build();
final stream = query.findStream();
await for (final tasks in stream) {
  // Process tasks
}
```

## 🔧 Migrations

### Adding New Fields

1. Add field to entity:
```dart
@Entity()
class TaskEntity {
  // Existing fields...
  
  String? newField;  // New field
}
```

2. Regenerate ObjectBox code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. ObjectBox automatically handles schema migration

### Removing Fields

Similar process - ObjectBox handles automatically.

## 📝 Best Practices

1. **Always regenerate** after entity changes
2. **Use indexes** for frequently queried fields
3. **Limit query results** for better performance
4. **Clean up old data** periodically
5. **Handle null values** appropriately
6. **Use JSON** for complex/nested data
7. **Track sync status** with isSynced flag
8. **Close store** properly on app exit

## 🐛 Troubleshooting

**Issue**: Build errors after entity changes  
**Solution**: Run build_runner with `--delete-conflicting-outputs`

**Issue**: Query returns no results  
**Solution**: Check if data exists, verify query conditions

**Issue**: Slow queries  
**Solution**: Add indexes to queried fields

**Issue**: Database corruption  
**Solution**: Clear and rebuild database

---

For more information, see:
- [ObjectBox Flutter Documentation](https://docs.objectbox.io/flutter)
- [Architecture Overview](ARCHITECTURE.md)
- [API Specification](API_SPECIFICATION.md)
