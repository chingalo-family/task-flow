# Architecture Overview

This document provides a comprehensive overview of Task Flow's architecture, design patterns, and technical implementation.

## 🏗️ System Architecture

Task Flow follows a **layered architecture** pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  (UI Components, Pages, Widgets, State Consumers)           │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                    State Management Layer                    │
│        (Provider, ChangeNotifier, State Classes)            │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                      Business Logic Layer                    │
│           (Services, Use Cases, Validators)                 │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                           │
│  (Repository Pattern, Data Sources, API Clients)            │
└─────────────────────────────────────────────────────────────┘
                            ↓↑
┌──────────────────────┬──────────────────────────────────────┐
│   Local Database     │        Remote API                    │
│   (ObjectBox)        │        (REST/DHIS2)                  │
└──────────────────────┴──────────────────────────────────────┘
```

## 📂 Project Structure

### High-Level Directory Layout

```
lib/
├── app_state/           # State management (Provider)
├── core/               # Core functionality
│   ├── components/     # Reusable UI components
│   ├── constants/      # App-wide constants
│   ├── entities/       # ObjectBox entities
│   ├── models/         # Data models
│   ├── services/       # Business logic services
│   ├── utils/          # Utility functions
│   └── offline_db/     # Database providers
├── modules/            # Feature modules
│   ├── splash/
│   ├── onboarding/
│   ├── login/
│   ├── home/
│   ├── tasks/
│   ├── teams/
│   ├── notifications/
│   └── settings/
├── main.dart          # App entry point
└── my_app.dart        # App configuration
```

### Detailed Structure

#### Core Layer (`lib/core/`)

**Components** (`components/`)
- Reusable UI widgets
- Shared components across modules
- Custom widgets

**Constants** (`constants/`)
- `app_constant.dart` - UI constants, colors, spacing
- `task_constants.dart` - Task-related constants
- `*_connection.dart` - API/service configurations

**Entities** (`entities/`)
- ObjectBox annotated classes
- Database schema definitions
- Entity models: `UserEntity`, `TaskEntity`, `TeamEntity`, `NotificationEntity`

**Models** (`models/`)
- Plain Dart classes for data transfer
- API response models
- UI models

**Services** (`services/`)
- Business logic implementations
- API integrations
- Core functionality services

**Utils** (`utils/`)
- Helper functions
- Utility classes
- Mappers and converters

**Offline DB** (`offline_db/`)
- Database providers for each entity
- CRUD operations on ObjectBox
- Query builders

#### Modules Layer (`lib/modules/`)

Each module follows a consistent structure:

```
module_name/
├── pages/              # Page-level widgets
├── components/         # Module-specific components
├── models/            # Module-specific models
├── dialogs/           # Dialog widgets
├── utils/             # Module utilities
└── module_page.dart   # Main module entry
```

## 🔄 Data Flow

### 1. User Interaction Flow

```
User Action
    ↓
UI Widget (e.g., TaskCard)
    ↓
State Provider (e.g., TaskState)
    ↓
Service Layer (e.g., TaskService)
    ↓
Offline Provider (e.g., TaskOfflineProvider)
    ↓
ObjectBox Database
    ↓
State Update (notifyListeners)
    ↓
UI Update (Consumer/Provider.of)
```

### 2. Data Synchronization Flow

```
Background Sync Triggered
    ↓
Service fetches from API
    ↓
Compare with local data
    ↓
Merge changes (conflict resolution)
    ↓
Update ObjectBox
    ↓
Update State
    ↓
UI reflects changes
```

## 🎯 Design Patterns

### 1. State Management Pattern

**Provider + ChangeNotifier**

```dart
class TaskState extends ChangeNotifier {
  List<Task> _tasks = [];
  
  List<Task> get tasks => _tasks;
  
  Future<void> loadTasks() async {
    _tasks = await _taskService.getTasks();
    notifyListeners(); // Notify UI to rebuild
  }
  
  Future<void> addTask(Task task) async {
    await _taskService.createTask(task);
    _tasks.add(task);
    notifyListeners();
  }
}
```

Usage in UI:
```dart
Consumer<TaskState>(
  builder: (context, taskState, child) {
    return ListView.builder(
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: taskState.tasks[index]);
      },
    );
  },
)
```

### 2. Repository Pattern

Abstracts data sources from business logic:

```dart
// Offline Provider (Repository)
class TaskOfflineProvider {
  final Box<TaskEntity>? _box;
  
  Future<void> addTask(TaskEntity task) async {
    await _box?.put(task);
  }
  
  List<TaskEntity> getAllTasks() {
    return _box?.getAll() ?? [];
  }
}

// Service Layer
class TaskService {
  final _offline = TaskOfflineProvider();
  
  Future<List<Task>> getTasks() async {
    final entities = _offline.getAllTasks();
    return entities.map((e) => Task.fromEntity(e)).toList();
  }
}
```

### 3. Singleton Pattern

Used for services to ensure single instance:

```dart
class UserService {
  UserService._();
  static final UserService _instance = UserService._();
  factory UserService() => _instance;
  
  // Service methods...
}

// Usage
final userService = UserService(); // Always returns same instance
```

### 4. Factory Pattern

Used for model creation:

```dart
class User {
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      // ...
    );
  }
}
```

### 5. Observer Pattern

Implemented through ChangeNotifier:

```dart
class NotificationState extends ChangeNotifier {
  int _unreadCount = 0;
  
  void updateUnreadCount(int count) {
    _unreadCount = count;
    notifyListeners(); // Observers (UI) get notified
  }
}
```

## 💾 Data Persistence Strategy

### ObjectBox Architecture

**Why ObjectBox?**
- ⚡ Extremely fast NoSQL database
- 📴 Perfect for offline-first apps
- 🔄 Efficient sync capabilities
- 💾 Low memory footprint
- 🎯 Native Dart support

**Entity Definition**

```dart
@Entity()
class TaskEntity {
  @Id()
  int id = 0;  // Auto-incremented by ObjectBox
  
  @Index()
  String taskId;  // External API ID
  
  String title;
  
  @Property(type: PropertyType.date)
  DateTime createdAt;
  
  // JSON fields for complex data
  String? tagsJson;
  String? subtasksJson;
}
```

**Query Optimization**

```dart
// Indexed queries for fast lookup
final query = taskBox
    .query(TaskEntity_.status.equals('pending'))
    .order(TaskEntity_.dueDate)
    .build();
final results = query.find();
```

### Sync Strategy

**Offline-First Approach**:
1. All operations work on local data first
2. Changes are queued for sync
3. Background sync when online
4. Conflict resolution on server

**Sync Flow**:
```
Local Change
    ↓
Mark as unsynced (isSynced = false)
    ↓
Queue for sync
    ↓
When online: Send to API
    ↓
API Response
    ↓
Update local with server data
    ↓
Mark as synced (isSynced = true)
```

## 🔐 Security Architecture

### Authentication Flow

```
1. User Login
    ↓
2. Credentials sent to API (HTTPS)
    ↓
3. Server validates & returns JWT token
    ↓
4. Token stored in Flutter Secure Storage
    ↓
5. Token included in subsequent requests
    ↓
6. Refresh token when expired
```

### Data Security

**Local Storage**:
- Flutter Secure Storage for sensitive data (tokens, passwords)
- ObjectBox for general app data
- Encryption at rest for sensitive fields

**Network Security**:
- HTTPS/TLS for all API calls
- Certificate pinning (planned)
- Request/response validation

## 🎨 UI Architecture

### Material Design 3

Task Flow uses Material Design 3 principles:
- Modern, clean aesthetics
- Consistent component system
- Accessible design
- Smooth animations

### Theme System

```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppConstant.primaryBlue,
    secondary: AppConstant.primaryBlue,
    // ...
  ),
)
```

### Component Architecture

**Atomic Design Principles**:
1. **Atoms**: Basic components (buttons, icons, text)
2. **Molecules**: Simple component groups (input fields with labels)
3. **Organisms**: Complex components (cards, forms)
4. **Templates**: Page layouts
5. **Pages**: Complete screens

### Responsive Design

```dart
// Responsive breakpoints
final size = MediaQuery.of(context).size;
final isSmallScreen = size.width < 600;
final isMediumScreen = size.width >= 600 && size.width < 1200;
final isLargeScreen = size.width >= 1200;
```

## 🔄 State Management Deep Dive

### Provider Tree Structure

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AppInfoState()),
    ChangeNotifierProvider(create: (_) => UserState()),
    ChangeNotifierProvider(create: (_) => TaskState()),
    ChangeNotifierProvider(create: (_) => TeamState()),
    ChangeNotifierProvider(create: (_) => NotificationState()),
    ChangeNotifierProvider(create: (_) => UserListState()),
  ],
  child: MaterialApp(...)
)
```

### State Lifecycle

1. **Creation**: Provider creates state on first access
2. **Updates**: State changes trigger `notifyListeners()`
3. **Consumption**: Widgets rebuild via `Consumer` or `Provider.of`
4. **Disposal**: State disposed when provider removed from tree

## 🧪 Testing Strategy

### Unit Tests
- Service layer testing
- Utility function testing
- Model validation testing

### Widget Tests
- Component rendering tests
- User interaction tests
- State changes tests

### Integration Tests
- End-to-end user flows
- API integration tests
- Database operations tests

## 📊 Performance Optimization

### Strategies

1. **Lazy Loading**: Load data on demand
2. **Pagination**: Fetch data in chunks
3. **Caching**: Cache frequently accessed data
4. **Debouncing**: Debounce search and input
5. **Virtual Scrolling**: Efficient list rendering

### ObjectBox Optimization

```dart
// Use indexes for frequent queries
@Index()
String status;

// Limit query results
final query = box.query().build();
query.limit = 50;

// Use relations efficiently
@Backlink()
final tasks = ToMany<TaskEntity>();
```

## 🔌 API Integration

### HTTP Client Architecture

```dart
class Dhis2HttpService {
  final String username;
  final String password;
  
  Future<http.Response> httpGet(String url) async {
    final auth = base64Encode(utf8.encode('$username:$password'));
    return await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Basic $auth'},
    );
  }
}
```

### Error Handling

```dart
try {
  final response = await httpService.get(url);
  if (response.statusCode == 200) {
    return parseData(response.body);
  } else {
    throw ApiException(response.statusCode);
  }
} catch (e) {
  // Handle errors
  logger.error(e);
  rethrow;
}
```

## 📱 Platform-Specific Considerations

### iOS
- Proper Info.plist configuration
- App Transport Security settings
- Background fetch capabilities

### Android
- Permissions in AndroidManifest.xml
- Proguard rules for ObjectBox
- Network security config

### Web
- CORS handling
- Web-specific storage APIs
- Progressive Web App features

### Desktop
- File system access
- Window management
- Native integrations

## 🚀 Deployment Architecture

### Build Process

```bash
# Development
flutter run

# Production builds
flutter build apk --release      # Android
flutter build ios --release      # iOS
flutter build web --release      # Web
flutter build windows --release  # Windows
flutter build macos --release    # macOS
flutter build linux --release    # Linux
```

### Environment Configuration

```dart
// Different configs for dev/staging/prod
const bool isDevelopment = bool.fromEnvironment('dev');
const apiUrl = isDevelopment 
    ? 'https://dev-api.taskflow.com'
    : 'https://api.taskflow.com';
```

## 📈 Scalability Considerations

### Current Scale
- Handles thousands of tasks per user
- Supports hundreds of teams
- Manages thousands of notifications

### Future Scalability
- Cloud database integration
- Horizontal scaling with load balancers
- CDN for static assets
- Microservices architecture (planned)

## 🔍 Monitoring & Logging

### Logging Strategy

```dart
debugPrint('✅ ObjectBox initialized successfully');
debugPrint('⚠️ Warning: Low storage space');
debugPrint('❌ Error: Failed to sync data');
```

### Analytics Integration (Planned)
- User behavior tracking
- Performance monitoring
- Crash reporting
- Feature usage analytics

---

For more information, see:
- [API Specification](API_SPECIFICATION.md)
- [Database Schema](DATABASE_SCHEMA.md)
- [Getting Started Guide](GETTING_STARTED.md)
