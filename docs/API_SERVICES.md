# API & Services Documentation

This document describes the service layer architecture and available backend services in Task Flow.

## 🎯 Service Layer Overview

Task Flow uses a **service-oriented architecture** where business logic is separated from UI and state management. Services act as an intermediary between the state layer and data persistence layer.

### Architecture Pattern

```
┌─────────────────────────────────────────┐
│         UI Layer (Widgets)              │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│    State Management (Provider)          │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│         Service Layer ◄─────────────────┤ ← You are here
│  (Business Logic & Validation)          │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│    Data Layer (Offline Providers)       │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│    Persistence (ObjectBox Database)     │
└─────────────────────────────────────────┘
```

### Key Principles

1. **Singleton Pattern**: All services use singleton pattern for consistent access
2. **Separation of Concerns**: Business logic isolated from UI and data layers
3. **Error Handling**: Comprehensive try-catch blocks with logging
4. **Async/Await**: All operations are asynchronous
5. **Validation**: Input validation before data persistence
6. **Type Safety**: Null-safe Dart with proper return types

## 📦 Available Services

### Core Services

| Service | File | Purpose |
|---------|------|---------|
| **TaskService** | `task_service.dart` | Task management operations |
| **TeamService** | `team_service.dart` | Team collaboration features |
| **UserService** | `user_service.dart` | User authentication & management |
| **NotificationService** | `notification_service.dart` | Notification handling |
| **DBService** | `db_service.dart` | Database initialization |
| **EmailService** | `email_service.dart` | Email notifications |
| **PreferenceService** | `preference_service.dart` | User preferences storage |
| **HttpService** | `http_service.dart` | HTTP API communication |

---

## 🔹 TaskService

**Location**: `lib/core/services/task_service.dart`

Handles all task-related operations including CRUD, filtering, and status management.

### Constructor

```dart
final taskService = TaskService(); // Singleton instance
```

### Methods

#### Create & Read Operations

##### `createTask(Task task) → Future<Task?>`
Creates a new task in the database.

**Parameters**:
- `task`: Task object to create

**Returns**: Created task or `null` if failed

**Example**:
```dart
final task = Task(
  id: 'task_123',
  title: 'Implement new feature',
  priority: 'high',
  status: 'pending',
);
final created = await TaskService().createTask(task);
```

**Validation**:
- Title cannot be empty
- Auto-generates timestamps

---

##### `getTaskById(String id) → Future<Task?>`
Retrieves a task by its ID.

**Parameters**:
- `id`: Task identifier

**Returns**: Task object or `null` if not found

**Example**:
```dart
final task = await TaskService().getTaskById('task_123');
```

---

##### `getAllTasks() → Future<List<Task>>`
Retrieves all tasks from the database.

**Returns**: List of all tasks

**Example**:
```dart
final tasks = await TaskService().getAllTasks();
print('Total tasks: ${tasks.length}');
```

---

#### Update & Delete Operations

##### `updateTask(Task task) → Future<bool>`
Updates an existing task.

**Parameters**:
- `task`: Updated task object

**Returns**: `true` if successful

**Example**:
```dart
final updatedTask = task.copyWith(status: 'completed');
await TaskService().updateTask(updatedTask);
```

---

##### `deleteTask(String id) → Future<bool>`
Deletes a task by ID.

**Parameters**:
- `id`: Task identifier

**Returns**: `true` if successful

**Example**:
```dart
await TaskService().deleteTask('task_123');
```

---

##### `deleteTasksByIds(List<String> ids) → Future<bool>`
Deletes multiple tasks.

**Parameters**:
- `ids`: List of task identifiers

**Returns**: `true` if successful

**Example**:
```dart
await TaskService().deleteTasksByIds(['task_1', 'task_2', 'task_3']);
```

---

#### Filtering Operations

##### `getTasksByStatus(String status) → Future<List<Task>>`
Retrieves tasks by status.

**Parameters**:
- `status`: 'pending', 'in_progress', or 'completed'

**Returns**: Filtered list of tasks

**Example**:
```dart
final pendingTasks = await TaskService().getTasksByStatus('pending');
```

---

##### `getTasksByPriority(String priority) → Future<List<Task>>`
Retrieves tasks by priority level.

**Parameters**:
- `priority`: 'high', 'medium', or 'low'

**Returns**: Filtered list of tasks

**Example**:
```dart
final highPriorityTasks = await TaskService().getTasksByPriority('high');
```

---

##### `getMyTasks(String userId) → Future<List<Task>>`
Retrieves tasks assigned to a specific user.

**Parameters**:
- `userId`: User identifier

**Returns**: User's assigned tasks

**Example**:
```dart
final myTasks = await TaskService().getMyTasks(currentUser.id);
```

---

##### `getTasksByTeam(String teamId) → Future<List<Task>>`
Retrieves tasks belonging to a team.

**Parameters**:
- `teamId`: Team identifier

**Returns**: Team's tasks

**Example**:
```dart
final teamTasks = await TaskService().getTasksByTeam('team_456');
```

---

#### Status Management

##### `updateTaskStatus(String id, String status) → Future<bool>`
Updates task status with automatic timestamp handling.

**Parameters**:
- `id`: Task identifier
- `status`: New status value

**Returns**: `true` if successful

**Features**:
- Auto-sets `completedAt` when status is 'completed'
- Auto-sets progress to 100% when completed

**Example**:
```dart
await TaskService().updateTaskStatus('task_123', 'completed');
```

---

##### `markAsCompleted(String id) → Future<bool>`
Convenience method to mark task as completed.

**Example**:
```dart
await TaskService().markAsCompleted('task_123');
```

---

##### `markAsPending(String id) → Future<bool>`
Convenience method to mark task as pending.

**Example**:
```dart
await TaskService().markAsPending('task_123');
```

---

#### Date-based Filtering

##### `getOverdueTasks() → Future<List<Task>>`
Retrieves tasks past their due date.

**Returns**: List of overdue tasks

**Logic**:
- Excludes completed tasks
- Compares due date with current date

**Example**:
```dart
final overdue = await TaskService().getOverdueTasks();
```

---

##### `getTasksDueToday() → Future<List<Task>>`
Retrieves tasks due today.

**Returns**: Tasks with due date today

**Example**:
```dart
final todayTasks = await TaskService().getTasksDueToday();
```

---

##### `getUpcomingTasks() → Future<List<Task>>`
Retrieves tasks due in the future.

**Returns**: Tasks with future due dates

**Example**:
```dart
final upcoming = await TaskService().getUpcomingTasks();
```

---

## 🔹 TeamService

**Location**: `lib/core/services/team_service.dart`

Manages team operations, member management, and custom team workflows.

### Methods

#### Core Operations

##### `createTeam(Team team) → Future<Team?>`
Creates a new team.

**Validation**: Team name cannot be empty

**Example**:
```dart
final team = Team(
  id: 'team_123',
  name: 'Development Team',
  description: 'Core development team',
  teamIcon: 'code',
  teamColor: '#2E90FA',
);
await TeamService().createTeam(team);
```

---

##### `getAllTeams() → Future<List<Team>>`
Retrieves all teams.

**Example**:
```dart
final teams = await TeamService().getAllTeams();
```

---

##### `getTeamById(String id) → Future<Team?>`
Retrieves a team by ID.

---

##### `updateTeam(Team team) → Future<bool>`
Updates team information.

---

##### `deleteTeam(String id) → Future<bool>`
Deletes a team.

---

#### Member Management

##### `getTeamsByMember(String userId) → Future<List<Team>>`
Retrieves teams a user belongs to.

**Example**:
```dart
final myTeams = await TeamService().getTeamsByMember(currentUser.id);
```

---

##### `addMemberToTeam(String teamId, String userId) → Future<bool>`
Adds a member to a team.

**Features**:
- Checks for duplicates
- Updates member count
- Sets updated timestamp

**Example**:
```dart
await TeamService().addMemberToTeam('team_123', 'user_456');
```

---

##### `removeMemberFromTeam(String teamId, String userId) → Future<bool>`
Removes a member from a team.

**Example**:
```dart
await TeamService().removeMemberFromTeam('team_123', 'user_456');
```

---

#### Task Management

##### `addTaskToTeam(String teamId, String taskId) → Future<bool>`
Associates a task with a team.

**Example**:
```dart
await TeamService().addTaskToTeam('team_123', 'task_789');
```

---

##### `removeTaskFromTeam(String teamId, String taskId) → Future<bool>`
Removes task from team.

---

#### Custom Workflow Management

##### `addTaskStatus(String teamId, TaskStatus status) → Future<bool>`
Adds a custom task status to a team.

**Example**:
```dart
final customStatus = TaskStatus(
  id: 'status_123',
  name: 'Under Review',
  color: '#FFA500',
  isDefault: false,
);
await TeamService().addTaskStatus('team_123', customStatus);
```

---

##### `updateTaskStatus(String teamId, String statusId, TaskStatus updatedStatus) → Future<bool>`
Updates a custom task status.

---

##### `deleteTaskStatus(String teamId, String statusId) → Future<bool>`
Deletes a custom task status.

**Note**: Cannot delete default statuses

---

##### `reorderTaskStatuses(String teamId, List<TaskStatus> reorderedStatuses) → Future<bool>`
Reorders team task statuses.

---

## 🔹 UserService

**Location**: `lib/core/services/user_service.dart`

Handles user authentication, profile management, and user data operations.

### Methods

#### Authentication

##### `signUpUser({...}) → Future<User?>`
Creates a new user account.

**Parameters**:
- `username`: Unique username
- `password`: User password
- `email`: Email address
- `firstName`: User's first name
- `surname`: User's surname
- `phoneNumber`: Contact number

**Example**:
```dart
final user = await UserService().signUpUser(
  username: 'john_doe',
  password: 'securePass123',
  email: 'john@example.com',
  firstName: 'John',
  surname: 'Doe',
  phoneNumber: '+1234567890',
);
```

---

##### `login(String username, String password) → Future<User?>`
Authenticates a user.

**Returns**: User object if successful, `null` if failed

**Features**:
- Validates credentials with backend
- Stores user in local database
- Sets as current user
- Marks as logged in

**Example**:
```dart
final user = await UserService().login('john_doe', 'password123');
if (user != null) {
  print('Login successful!');
}
```

---

##### `logout() → Future<void>`
Logs out the current user.

**Features**:
- Marks user as logged out
- Clears current user preference
- Maintains user data in database

**Example**:
```dart
await UserService().logout();
```

---

#### User Management

##### `getCurrentUser() → Future<User?>`
Retrieves the currently logged-in user.

**Example**:
```dart
final currentUser = await UserService().getCurrentUser();
```

---

##### `setCurrentUser(User user) → Future<void>`
Sets a user as the current user.

**Example**:
```dart
await UserService().setCurrentUser(user);
```

---

##### `getAllUsers() → Future<List<User>>`
Retrieves all users (for team member selection).

**Example**:
```dart
final users = await UserService().getAllUsers();
```

---

#### Password Management

##### `changeCurrentUserPassword(String oldPassword, String newPassword) → Future<bool>`
Changes the current user's password.

**Parameters**:
- `oldPassword`: Current password for verification
- `newPassword`: New password to set

**Returns**: `true` if successful

**Example**:
```dart
final success = await UserService().changeCurrentUserPassword(
  'oldPass123',
  'newSecurePass456',
);
```

---

#### Data Synchronization

##### `syncAvailableUsersInformations({...}) → Future<void>`
Syncs user data from backend to local database.

**Parameters**:
- `username`: Admin username
- `password`: Admin password

**Note**: Used for populating user directory for team member assignment

---

## 🔹 NotificationService

**Location**: `lib/core/services/notification_service.dart`

Manages in-app notifications and notification lifecycle.

### Methods

#### Core Operations

##### `createNotification(Notification notification) → Future<Notification?>`
Creates a new notification.

**Features**:
- Auto-generates ID if not provided
- Returns created notification

**Example**:
```dart
final notification = Notification(
  id: '',
  title: 'New Task',
  body: 'You have been assigned a new task',
  type: 'task_assigned',
  isRead: false,
);
await NotificationService().createNotification(notification);
```

---

##### `getAllNotifications() → Future<List<Notification>>`
Retrieves all notifications, sorted by creation date (newest first).

**Example**:
```dart
final notifications = await NotificationService().getAllNotifications();
```

---

##### `getNotificationById(String id) → Future<Notification?>`
Retrieves a specific notification.

---

##### `updateNotification(Notification notification) → Future<bool>`
Updates a notification.

---

##### `deleteNotification(String id) → Future<bool>`
Deletes a notification.

---

#### Filtering

##### `getUnreadNotifications() → Future<List<Notification>>`
Retrieves unread notifications.

**Example**:
```dart
final unread = await NotificationService().getUnreadNotifications();
```

---

##### `getNotificationsByType(String type) → Future<List<Notification>>`
Retrieves notifications of a specific type.

**Types**:
- `task_assigned`
- `task_completed`
- `team_invite`
- `mention`
- `system`

**Example**:
```dart
final taskNotifs = await NotificationService().getNotificationsByType('task_assigned');
```

---

##### `getUnreadNotificationsByType(String type) → Future<List<Notification>>`
Retrieves unread notifications of a specific type.

---

#### Read Status Management

##### `markAsRead(String id) → Future<bool>`
Marks a notification as read.

**Example**:
```dart
await NotificationService().markAsRead('notif_123');
```

---

##### `markAllAsRead() → Future<bool>`
Marks all notifications as read.

**Example**:
```dart
await NotificationService().markAllAsRead();
```

---

#### Utility Methods

##### `getUnreadCount() → Future<int>`
Gets count of unread notifications.

**Example**:
```dart
final count = await NotificationService().getUnreadCount();
print('You have $count unread notifications');
```

---

##### `deleteAll() → Future<bool>`
Deletes all notifications.

---

#### Notification Creators

##### `createTaskAssignedNotification({...}) → Future<Notification?>`
Creates a task assignment notification.

**Parameters**:
- `taskTitle`: Title of the task
- `taskId`: Task identifier
- `actorUsername`: Who assigned the task

**Example**:
```dart
await NotificationService().createTaskAssignedNotification(
  taskTitle: 'Implement login feature',
  taskId: 'task_123',
  actorUsername: 'john_doe',
);
```

---

##### `createTeamInviteNotification({...}) → Future<Notification?>`
Creates a team invitation notification.

**Example**:
```dart
await NotificationService().createTeamInviteNotification(
  teamName: 'Dev Team',
  teamId: 'team_123',
  actorUsername: 'jane_smith',
);
```

---

##### `createTaskCompletedNotification({...}) → Future<Notification?>`
Creates a task completion notification.

---

## 🔹 DBService

**Location**: `lib/core/services/db_service.dart`

Manages ObjectBox database initialization and lifecycle.

### Methods

##### `init() → Future<void>`
Initializes the ObjectBox database.

**Usage**: Called once at app startup in `main.dart`

**Example**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().init();
  runApp(MyApp());
}
```

---

## 🔹 EmailService

**Location**: `lib/core/services/email_service.dart`

Handles email notifications via SMTP.

### Features
- HTML email templates
- Task assignment notifications
- Team invitation emails
- Configurable SMTP settings

---

## 🔹 PreferenceService

**Location**: `lib/core/services/preference_service.dart`

Manages user preferences using SharedPreferences.

### Methods

##### `setString(String key, String value) → Future<bool>`
Stores a string preference.

##### `getString(String key) → Future<String?>`
Retrieves a string preference.

##### `remove(String key) → Future<bool>`
Removes a preference.

---

## 🔹 HttpService

**Location**: `lib/core/services/http_service.dart`

Handles HTTP API communication.

### Methods
- `httpGet()`: GET requests
- `httpPost()`: POST requests
- `httpPut()`: PUT requests
- `httpDelete()`: DELETE requests

---

## 🛠️ Best Practices

### Error Handling

All services use comprehensive error handling:

```dart
Future<Task?> getTaskById(String id) async {
  try {
    return await _offline.getTaskById(id);
  } catch (e) {
    debugPrint('Error getting task by ID: $e');
    return null;
  }
}
```

### Null Safety

Services return:
- `null` for single object failures
- Empty lists for collection failures
- `false` for boolean operation failures

### Singleton Pattern

All services use singleton pattern:

```dart
class TaskService {
  TaskService._();
  static final TaskService _instance = TaskService._();
  factory TaskService() => _instance;
}
```

### Async Operations

All operations are asynchronous:

```dart
// ✅ Good
final tasks = await TaskService().getAllTasks();

// ❌ Bad
final tasks = TaskService().getAllTasks(); // Missing await
```

---

## 📊 Service Usage Examples

### Complete Task Workflow

```dart
// 1. Create a task
final task = Task(
  id: 'task_123',
  title: 'Build new feature',
  priority: 'high',
  status: 'pending',
);
await TaskService().createTask(task);

// 2. Assign to team
await TeamService().addTaskToTeam('team_456', 'task_123');

// 3. Send notification
await NotificationService().createTaskAssignedNotification(
  taskTitle: task.title,
  taskId: task.id,
  actorUsername: 'manager',
);

// 4. Mark as completed
await TaskService().markAsCompleted('task_123');
```

### User Authentication Flow

```dart
// 1. Login
final user = await UserService().login('username', 'password');

if (user != null) {
  // 2. Get user's tasks
  final myTasks = await TaskService().getMyTasks(user.id);
  
  // 3. Get user's teams
  final myTeams = await TeamService().getTeamsByMember(user.id);
  
  // 4. Check notifications
  final unreadCount = await NotificationService().getUnreadCount();
}
```

---

## 🔍 Testing Services

### Unit Testing Example

```dart
test('TaskService creates task successfully', () async {
  final task = Task(
    id: 'test_123',
    title: 'Test Task',
  );
  
  final result = await TaskService().createTask(task);
  
  expect(result, isNotNull);
  expect(result?.title, 'Test Task');
});
```

---

## 🚀 Future Enhancements

Planned service improvements:
- [ ] Batch operations for bulk updates
- [ ] Transaction support for complex operations
- [ ] Caching layer for frequently accessed data
- [ ] Real-time sync with backend
- [ ] Retry logic for failed operations
- [ ] Service health monitoring
- [ ] Performance metrics

---

## 📚 Related Documentation

- [Architecture](./ARCHITECTURE.md) - Overall architecture
- [State Management](./STATE_MANAGEMENT.md) - State layer
- [Tech Stack](./TECH_STACK.md) - Technologies used

---

**Last Updated**: January 2026
