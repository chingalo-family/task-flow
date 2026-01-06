# State Management Documentation

This document describes the state management architecture and implementation in Task Flow.

## 🎯 Overview

Task Flow uses **Provider** for state management, following a reactive programming paradigm where UI automatically updates when state changes.

### Why Provider?

- ✅ **Simple & Intuitive**: Easy to understand and use
- ✅ **Performant**: Efficient widget rebuilding
- ✅ **Flutter-recommended**: Official Flutter team recommendation
- ✅ **Dependency Injection**: Built-in DI capabilities
- ✅ **Scoped State**: State can be scoped to widget subtrees
- ✅ **Testable**: Easy to mock and test

## 🏗️ Architecture

### State Management Flow

```
┌──────────────────────────────────────────┐
│         Widget Tree                      │
│  (Consumes State via Consumer/Watch)     │
└──────────────┬───────────────────────────┘
               │ reads
               ▼
┌──────────────────────────────────────────┐
│    ChangeNotifier State Classes          │ ← You are here
│  (TaskState, TeamState, UserState, etc)  │
└──────────────┬───────────────────────────┘
               │ calls
               ▼
┌──────────────────────────────────────────┐
│         Service Layer                    │
│  (TaskService, TeamService, etc)         │
└──────────────┬───────────────────────────┘
               │ persists
               ▼
┌──────────────────────────────────────────┐
│         ObjectBox Database               │
└──────────────────────────────────────────┘
```

### App-Level Provider Setup

**Location**: `lib/my_app.dart`

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => TaskState()),
        ChangeNotifierProvider(create: (_) => TeamState()),
        ChangeNotifierProvider(create: (_) => NotificationState()),
        ChangeNotifierProvider(create: (_) => UserListState()),
      ],
      child: MaterialApp(
        title: 'Task Flow',
        home: Splash(),
      ),
    );
  }
}
```

---

## 📦 State Classes

### Available State Providers

| State Class | File | Purpose |
|------------|------|---------|
| **TaskState** | `task_state.dart` | Task management state |
| **TeamState** | `team_state.dart` | Team collaboration state |
| **UserState** | `user_state.dart` | Authentication & user state |
| **NotificationState** | `notification_state.dart` | Notification management |
| **UserListState** | `user_list_state.dart` | User directory state |
| **AppInfoState** | `app_info_state.dart` | App metadata state |

---

## 🔹 TaskState

**Location**: `lib/app_state/task_state/task_state.dart`

Manages all task-related state and operations.

### Properties

#### Public Getters

```dart
List<Task> get tasks           // Filtered task list
List<Task> get allTasks        // All tasks (unfiltered)
bool get loading               // Loading indicator
String get filterStatus        // Current status filter
String get filterPriority      // Current priority filter
String get sortBy              // Current sort method
String? get filterTeamId       // Team filter
```

#### Computed Properties

```dart
int get totalTasks             // Total task count
int get completedTasks         // Completed task count
int get inProgressTasks        // In-progress task count
int get tasksDueToday          // Tasks due today count
int get tasksCompletedToday    // Tasks completed today count
List<Task> get tasksDueTodayList  // Tasks due today
```

### Methods

#### Initialization

##### `initialize() → Future<void>`
Initializes state by loading tasks from database.

**Usage**: Called once when app starts

**Example**:
```dart
final taskState = TaskState();
await taskState.initialize();
```

---

#### Task CRUD Operations

##### `addTask(Task task) → Future<void>`
Adds a new task.

**Features**:
- Calls TaskService to persist
- Updates local state
- Notifies listeners

**Example**:
```dart
final task = Task(
  id: 'task_123',
  title: 'New Feature',
  priority: 'high',
);
await context.read<TaskState>().addTask(task);
```

---

##### `updateTask(Task task) → Future<void>`
Updates an existing task.

**Example**:
```dart
final updatedTask = task.copyWith(status: 'completed');
await context.read<TaskState>().updateTask(updatedTask);
```

---

##### `deleteTask(String taskId) → Future<void>`
Deletes a task.

**Example**:
```dart
await context.read<TaskState>().deleteTask('task_123');
```

---

#### Filtering & Sorting

##### `setFilterStatus(String status) → void`
Sets status filter.

**Values**: 'all', 'pending', 'in_progress', 'completed'

**Example**:
```dart
context.read<TaskState>().setFilterStatus('completed');
```

---

##### `setFilterPriority(String priority) → void`
Sets priority filter.

**Values**: 'all', 'high', 'medium', 'low'

---

##### `setFilterTeamId(String? teamId) → void`
Filters tasks by team.

**Example**:
```dart
context.read<TaskState>().setFilterTeamId('team_123');
```

---

##### `setSortBy(String sortBy) → void`
Sets sort method.

**Values**: 'created', 'updated', 'due_date', 'priority', 'title'

---

##### `clearFilters() → void`
Resets all filters to default.

---

#### User-Specific Methods

##### `getMyTasks(String userId) → List<Task>`
Gets tasks assigned to a user.

**Returns**: Filtered task list

**Example**:
```dart
final myTasks = context.read<TaskState>().getMyTasks(currentUser.id);
```

---

##### `getMyCompletedTasksCount(String userId) → int`
Gets count of user's completed tasks.

---

##### `getMyTotalTasksCount(String userId) → int`
Gets count of user's total tasks.

---

##### `getMyCompletionProgress(String userId) → double`
Gets completion percentage (0.0 to 1.0).

**Example**:
```dart
final progress = context.read<TaskState>().getMyCompletionProgress(userId);
print('${(progress * 100).toStringAsFixed(1)}% complete');
```

---

##### `getMyPendingTasksCount(String userId) → int`
Gets count of user's pending (not completed) tasks.

**Example**:
```dart
final pending = context.read<TaskState>().getMyPendingTasksCount(userId);
print('You have $pending pending tasks');
```



#### Computed Statistics

##### `totalTasks → int`
Total count of all tasks.

##### `completedTasks → int`
Count of completed tasks.

##### `inProgressTasks → int`
Count of in-progress tasks.

##### `tasksDueToday → int`
Count of tasks due today.

##### `tasksCompletedToday → int`
Count of tasks completed today.

**Example**:
```dart
final stats = context.watch<TaskState>();
return StatsCard(
  total: stats.totalTasks,
  completed: stats.completedTasks,
  inProgress: stats.inProgressTasks,
  dueToday: stats.tasksDueToday,
);
```

---

### Usage in Widgets

#### Consuming State

**Using Consumer**:
```dart
Consumer<TaskState>(
  builder: (context, taskState, child) {
    if (taskState.loading) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        final task = taskState.tasks[index];
        return TaskCard(task: task);
      },
    );
  },
)
```

**Using context.watch**:
```dart
Widget build(BuildContext context) {
  final tasks = context.watch<TaskState>().tasks;
  final loading = context.watch<TaskState>().loading;
  
  if (loading) return CircularProgressIndicator();
  return TaskList(tasks: tasks);
}
```

**Using context.read** (for actions):
```dart
onPressed: () {
  context.read<TaskState>().addTask(newTask);
}
```

---

### Building a Personal Dashboard

Here's a complete example of building a user's personal task dashboard using TaskState:

```dart
class PersonalDashboard extends StatelessWidget {
  final String userId;
  
  const PersonalDashboard({required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskState>(
      builder: (context, taskState, child) {
        // Get user-specific data
        final myTasks = taskState.getMyTasks(userId);
        final myProgress = taskState.getMyCompletionProgress(userId);
        final pendingCount = myTasks.where((t) => !t.isCompleted).length;
        final completedCount = taskState.getMyCompletedTasksCount(userId);
        
        // Get task views
        final overdue = taskState.overdueTasks.where(
          (t) => t.assignedUserIds?.contains(userId) ?? false
        ).toList();
        final todayTasks = taskState.tasksDueTodayList.where(
          (t) => t.assignedUserIds?.contains(userId) ?? false
        ).toList();
        final focusList = taskState.focusTasks.where(
          (t) => t.assignedUserIds?.contains(userId) ?? false
        ).take(5).toList();
        
        return SingleChildScrollView(
          child: Column(
            children: [
              // Progress Card
              ProgressCard(
                totalTasks: myTasks.length,
                completedTasks: completedCount,
                pendingTasks: pendingCount,
                progress: myProgress,
              ),
              
              // Overdue Tasks Alert
              if (overdue.isNotEmpty)
                OverdueAlert(
                  count: overdue.length,
                  tasks: overdue,
                ),
              
              // Tasks Due Today
              TaskSection(
                title: 'Due Today',
                count: todayTasks.length,
                tasks: todayTasks,
                icon: Icons.today,
              ),
              
              // Focus of the Day
              TaskSection(
                title: 'Focus of the Day',
                subtitle: 'Top priority tasks',
                tasks: focusList,
                icon: Icons.wb_sunny,
              ),
              
              // All My Tasks
              TaskSection(
                title: 'All My Tasks',
                count: myTasks.length,
                tasks: myTasks,
                icon: Icons.list,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Example ProgressCard widget
class ProgressCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final double progress;
  
  const ProgressCard({
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.progress,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Progress', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(0)}% Complete'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem('Total', totalTasks, Colors.blue),
                _StatItem('Pending', pendingTasks, Colors.orange),
                _StatItem('Completed', completedTasks, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _StatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label),
      ],
    );
  }
}
```

This example demonstrates:
- Getting user-specific tasks and metrics
- Filtering global task views for current user
- Building a comprehensive personal dashboard
- Using multiple TaskState getters together
- Creating reusable UI components

---

## 🔹 TeamState

**Location**: `lib/app_state/team_state/team_state.dart`

Manages team-related state and operations.

### Properties

```dart
List<Team> get teams           // All teams
bool get loading               // Loading indicator
int get totalTeams             // Total team count
```

### Methods

#### Initialization

##### `initialize() → Future<void>`
Loads teams from database.

---

#### Team CRUD

##### `addTeam(Team team) → Future<void>`
Adds a new team.

**Example**:
```dart
final team = Team(
  id: 'team_123',
  name: 'Dev Team',
  description: 'Development team',
);
await context.read<TeamState>().addTeam(team);
```

---

##### `updateTeam(Team team) → Future<void>`
Updates a team.

---

##### `deleteTeam(String teamId) → Future<void>`
Deletes a team.

---

##### `getTeamById(String teamId) → Team?`
Retrieves a team by ID.

**Example**:
```dart
final team = context.read<TeamState>().getTeamById('team_123');
```

---

#### Member Management

##### `addMemberToTeam(String teamId, String userId) → Future<void>`
Adds a member to a team.

**Example**:
```dart
await context.read<TeamState>().addMemberToTeam('team_123', 'user_456');
```

---

##### `removeMemberFromTeam(String teamId, String userId) → Future<void>`
Removes a member from a team.

---

#### Task Management

##### `addTaskToTeam(String teamId, String taskId) → Future<void>`
Associates a task with a team.

---

##### `removeTaskFromTeam(String teamId, String taskId) → Future<void>`
Removes task from team.

---

### Usage Example

```dart
class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamState>(
      builder: (context, teamState, child) {
        final teams = teamState.teams;
        
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return TeamCard(team: teams[index]);
          },
        );
      },
    );
  }
}
```

---

## 🔹 UserState

**Location**: `lib/app_state/user_state/user_state.dart`

Manages authentication and current user state.

### Properties

```dart
User? get currentUser          // Currently logged-in user
bool get isAuthenticated       // Authentication status
```

### Methods

#### Initialization

##### `initialize() → Future<void>`
Loads current user from storage.

**Usage**: Called at app startup

**Example**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().init();
  
  final userState = UserState();
  await userState.initialize();
  
  runApp(
    ChangeNotifierProvider.value(
      value: userState,
      child: MyApp(),
    ),
  );
}
```

---

#### Authentication

##### `signIn(String username, String password) → Future<bool>`
Authenticates a user.

**Returns**: `true` if successful

**Example**:
```dart
final success = await context.read<UserState>().signIn(
  'john_doe',
  'password123',
);

if (success) {
  Navigator.pushReplacementNamed(context, '/home');
} else {
  showError('Invalid credentials');
}
```

---

##### `logout() → Future<void>`
Logs out the current user.

**Example**:
```dart
await context.read<UserState>().logout();
Navigator.pushReplacementNamed(context, '/login');
```

---

##### `setCurrent(User user) → Future<void>`
Sets a user as the current user.

---

##### `changeCurrentUserPassword(String oldPassword, String newPassword) → Future<bool>`
Changes the current user's password.

**Example**:
```dart
final success = await context.read<UserState>().changeCurrentUserPassword(
  oldPassword,
  newPassword,
);
```

---

### Usage Example

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        final user = userState.currentUser;
        
        if (user == null) {
          return LoginPage();
        }
        
        return Column(
          children: [
            Text('Welcome, ${user.fullName}'),
            Text(user.email ?? ''),
            ElevatedButton(
              onPressed: () => userState.logout(),
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## 🔹 NotificationState

**Location**: `lib/app_state/notification_state/notification_state.dart`

Manages notification state and filtering.

### Properties

```dart
List<Notification> get notifications     // All notifications
List<Notification> get filteredNotifications  // Filtered list
bool get loading                         // Loading indicator
String get selectedFilter                // Current filter
int get unreadCount                      // Unread count
```

### Methods

#### Initialization

##### `initialize() → Future<void>`
Loads notifications from database.

---

#### Notification Operations

##### `addNotification(Notification notification) → Future<void>`
Adds a notification.

---

##### `markAsRead(String id) → Future<void>`
Marks a notification as read.

**Example**:
```dart
await context.read<NotificationState>().markAsRead('notif_123');
```

---

##### `markAllAsRead() → Future<void>`
Marks all notifications as read.

---

##### `deleteNotification(String id) → Future<void>`
Deletes a notification.

---

#### Filtering

##### `setFilter(String filter) → void`
Sets notification filter.

**Values**:
- 'All'
- 'Unread'
- 'Mentions'
- 'Assigned to Me'
- 'System'

**Example**:
```dart
context.read<NotificationState>().setFilter('Unread');
```

---

### Usage Example

```dart
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationState>(
      builder: (context, notifState, child) {
        final notifications = notifState.filteredNotifications;
        final unreadCount = notifState.unreadCount;
        
        return Column(
          children: [
            FilterChips(
              selectedFilter: notifState.selectedFilter,
              onFilterChanged: notifState.setFilter,
            ),
            Badge(
              label: Text('$unreadCount'),
              child: Icon(Icons.notifications),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return NotificationCard(
                    notification: notifications[index],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
```

---

## 🛠️ Best Practices

### 1. Use context.read for Actions

For operations that don't need to rebuild the widget:

```dart
// ✅ Good
onPressed: () {
  context.read<TaskState>().addTask(task);
}

// ❌ Bad (unnecessary rebuilds)
onPressed: () {
  context.watch<TaskState>().addTask(task);
}
```

### 2. Use context.watch for Reactive UI

For values that should trigger rebuilds:

```dart
// ✅ Good
Widget build(BuildContext context) {
  final tasks = context.watch<TaskState>().tasks;
  return TaskList(tasks: tasks);
}
```

### 3. Use Consumer for Scoped Rebuilds

When only part of the widget should rebuild:

```dart
// ✅ Good - Only TaskList rebuilds
Column(
  children: [
    StaticHeader(), // Doesn't rebuild
    Consumer<TaskState>(
      builder: (context, state, child) {
        return TaskList(tasks: state.tasks); // Rebuilds
      },
    ),
  ],
)
```

### 4. Use Selector for Granular Updates

When you need only specific property changes:

```dart
Selector<TaskState, int>(
  selector: (context, state) => state.totalTasks,
  builder: (context, totalTasks, child) {
    return Text('Total: $totalTasks');
  },
)
```

### 5. Always Call notifyListeners

After modifying state:

```dart
void addTask(Task task) {
  _tasks.add(task);
  notifyListeners(); // ✅ Required
}
```

### 6. Handle Loading States

Show loading indicators during async operations:

```dart
Future<void> loadTasks() async {
  _loading = true;
  notifyListeners();
  
  _tasks = await _service.getAllTasks();
  
  _loading = false;
  notifyListeners();
}
```

### 7. Error Handling

Handle errors gracefully:

```dart
Future<void> addTask(Task task) async {
  try {
    final created = await _service.createTask(task);
    if (created != null) {
      _tasks.add(created);
      notifyListeners();
    }
  } catch (e) {
    debugPrint('Error adding task: $e');
    // Optionally notify user via error state
  }
}
```

---

## 🔄 State Lifecycle

### Initialization Flow

```dart
1. App starts
2. MultiProvider creates state instances
3. Splash screen shows
4. States initialize (load data from DB)
5. Navigation to appropriate screen (Login/Home)
6. Widgets consume state via Provider
```

### State Update Flow

```dart
1. User action (e.g., tap button)
2. Widget calls state method (context.read)
3. State updates internal data
4. State calls service layer
5. Service persists to database
6. State calls notifyListeners()
7. Consuming widgets rebuild
```

---

## 🧪 Testing State

### Unit Testing

```dart
test('TaskState adds task correctly', () async {
  final taskState = TaskState();
  
  final task = Task(
    id: 'test_123',
    title: 'Test Task',
  );
  
  await taskState.addTask(task);
  
  expect(taskState.tasks.length, 1);
  expect(taskState.tasks.first.title, 'Test Task');
});
```

### Widget Testing

```dart
testWidgets('displays tasks from TaskState', (tester) async {
  final taskState = TaskState();
  taskState.addTask(Task(id: '1', title: 'Task 1'));
  
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: taskState,
      child: MaterialApp(home: TasksPage()),
    ),
  );
  
  expect(find.text('Task 1'), findsOneWidget);
});
```

---

## 🚀 Advanced Patterns

### Combining Multiple States

```dart
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserState>().currentUser;
    final taskState = context.watch<TaskState>();
    final teamState = context.watch<TeamState>();
    
    if (user == null) return LoginPage();
    
    return Column(
      children: [
        Text('Welcome, ${user.fullName}'),
        Text('Tasks: ${taskState.totalTasks}'),
        Text('Teams: ${teamState.totalTeams}'),
      ],
    );
  }
}
```

### Conditional State Access

```dart
final taskState = context.watch<TaskState>();
final userState = context.watch<UserState>();

if (userState.isAuthenticated) {
  final myTasks = taskState.getMyTasks(userState.currentUser!.id);
  return MyTasksList(tasks: myTasks);
}
```

---

## 📊 Performance Optimization

### 1. Use const Widgets

```dart
// ✅ Good
const Text('Static Text')

// ❌ Bad
Text('Static Text')
```

### 2. Split Widgets

Break large widgets into smaller ones to minimize rebuild scope:

```dart
// ✅ Good
class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskState>().tasks;
    return ListView.builder(
      itemBuilder: (context, index) => TaskItem(task: tasks[index]),
    );
  }
}
```

### 3. Use Keys

Preserve widget state across rebuilds:

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return TaskCard(
      key: ValueKey(tasks[index].id),
      task: tasks[index],
    );
  },
)
```

---

## 🔮 Future Enhancements

Planned improvements:
- [ ] State persistence across app restarts
- [ ] Undo/redo functionality
- [ ] Optimistic updates with rollback
- [ ] State migration tools
- [ ] Developer tools integration
- [ ] State analytics and monitoring

---

## 📚 Related Documentation

- [Architecture](./ARCHITECTURE.md) - Overall architecture
- [API & Services](./API_SERVICES.md) - Service layer
- [Tech Stack](./TECH_STACK.md) - Technologies used

---

**Last Updated**: January 2026
