# Architecture Documentation

This document describes the architecture and structure of the Task Flow application.

## 🏗️ Overall Architecture

Task Flow follows a **modular, layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│    (UI Widgets & Screens)               │
├─────────────────────────────────────────┤
│         State Management Layer          │
│    (Provider - App State)               │
├─────────────────────────────────────────┤
│         Business Logic Layer            │
│    (Services & Use Cases)               │
├─────────────────────────────────────────┤
│         Data Layer                      │
│    (Repositories & Data Sources)        │
├─────────────────────────────────────────┤
│         Persistence Layer               │
│    (ObjectBox, Secure Storage)          │
└─────────────────────────────────────────┘
```

## 📁 Project Structure

### Directory Organization

```
lib/
├── app_state/                  # State Management (Provider)
│   ├── app_info_state/        # App metadata state
│   ├── notification_state/    # Notification state
│   ├── task_state/            # Task management state
│   ├── team_state/            # Team management state
│   ├── user_list_state/       # User directory state
│   └── user_state/            # Authentication & user state
│
├── core/                       # Core/Shared functionality
│   ├── components/            # Reusable UI components
│   │   ├── buttons/
│   │   ├── cards/
│   │   ├── inputs/
│   │   └── ...
│   │
│   ├── constants/             # App-wide constants
│   │   ├── app_constant.dart          # UI constants
│   │   ├── task_constants.dart        # Task-related constants
│   │   ├── email_connection.dart      # Email config (gitignored)
│   │   └── dhis2_connection.dart      # API config (gitignored)
│   │
│   ├── entities/              # ObjectBox database entities
│   │   ├── notification_entity.dart
│   │   ├── task_entity.dart
│   │   ├── team_entity.dart
│   │   └── user_entity.dart
│   │
│   ├── models/                # Data models (Business objects)
│   │   ├── notification.dart
│   │   ├── task.dart
│   │   ├── task_category.dart
│   │   ├── task_status.dart
│   │   ├── team.dart
│   │   ├── user.dart
│   │   └── email_notification.dart
│   │
│   ├── offline_db/            # ObjectBox database configuration
│   │
│   ├── services/              # Business logic services
│   │   ├── db_service.dart            # Database initialization
│   │   ├── task_service.dart          # Task operations
│   │   ├── team_service.dart          # Team operations
│   │   ├── user_service.dart          # User management
│   │   ├── notification_service.dart  # Notifications
│   │   ├── email_service.dart         # Email integration
│   │   ├── preference_service.dart    # User preferences
│   │   └── http_service.dart          # API communication
│   │
│   └── utils/                 # Utility functions
│       ├── notification_filter_utils.dart
│       ├── task_entity_mapper.dart
│       └── ...
│
├── modules/                    # Feature modules
│   ├── home/                  # Home screen
│   │   ├── components/
│   │   ├── home_page.dart
│   │   └── ...
│   │
│   ├── tasks/                 # Task management
│   │   ├── components/
│   │   ├── models/
│   │   ├── pages/
│   │   ├── utils/
│   │   └── tasks_page.dart
│   │
│   ├── teams/                 # Team collaboration
│   │   ├── components/
│   │   ├── dialogs/
│   │   ├── models/
│   │   ├── pages/
│   │   └── teams_page.dart
│   │
│   ├── notifications/         # Notifications center
│   │   ├── components/
│   │   ├── notifications_page.dart
│   │   └── ...
│   │
│   ├── settings/              # App settings
│   │   ├── components/
│   │   ├── settings_page.dart
│   │   └── ...
│   │
│   ├── login/                 # Authentication
│   │   └── login_screen.dart
│   │
│   ├── onboarding/            # First-time user experience
│   │   ├── components/
│   │   ├── models/
│   │   └── onboarding_screen.dart
│   │
│   └── splash/                # Launch screen
│       └── splash.dart
│
├── main.dart                   # App entry point
├── my_app.dart                 # App configuration
├── objectbox-model.json        # ObjectBox schema
└── objectbox.g.dart            # Generated ObjectBox code
```

## 🔄 State Management Architecture

### Provider Pattern Implementation

Task Flow uses the **Provider pattern** for state management:

```dart
MultiProvider
├── AppInfoState       → App version, build info
├── UserState          → Current user, authentication
├── TaskState          → Task CRUD operations
├── TeamState          → Team management
├── NotificationState  → Notification handling
└── UserListState      → User directory
```

### State Class Structure

Each state class extends `ChangeNotifier`:

```dart
class TaskState extends ChangeNotifier {
  // Private state
  List<Task> _tasks = [];
  
  // Public getters
  List<Task> get tasks => _tasks;
  
  // State mutations
  Future<void> addTask(Task task) async {
    // Business logic
    _tasks.add(task);
    notifyListeners(); // Trigger UI rebuild
  }
}
```

### Benefits
- **Reactive UI**: Automatic widget rebuilds on state changes
- **Dependency Injection**: Easy access to state across the app
- **Testability**: Mock states for testing
- **Scalability**: Add new states without affecting existing ones

## 💾 Data Flow Architecture

### Unidirectional Data Flow

```
┌──────────┐         ┌──────────┐         ┌──────────┐
│    UI    │────────>│  State   │────────>│ Service  │
│  Widget  │<────────│ Provider │<────────│  Layer   │
└──────────┘  notify └──────────┘  result └──────────┘
                           │                    │
                           │                    │
                           ▼                    ▼
                      ┌──────────┐         ┌──────────┐
                      │ Database │         │   API    │
                      │ ObjectBox│         │  (HTTP)  │
                      └──────────┘         └──────────┘
```

### Flow Example: Adding a Task

1. **User Action**: User clicks "Add Task" button
2. **UI Event**: Widget calls `TaskState.addTask(task)`
3. **State Update**: State processes the request
4. **Service Call**: State calls `TaskService.createTask()`
5. **Data Persistence**: Service saves to ObjectBox
6. **State Mutation**: State updates internal task list
7. **Notification**: `notifyListeners()` triggered
8. **UI Rebuild**: Widgets consuming TaskState rebuild

## 🗄️ Database Architecture

### ObjectBox Integration

```dart
// Entity (Database Schema)
@Entity()
class TaskEntity {
  @Id()
  int id = 0;
  String taskId;
  String title;
  // ... other fields
}

// Service Layer
class TaskState {
  final _box = DBService().taskBox;
  
  Future<void> saveTask(Task task) async {
    final entity = TaskEntityMapper.toEntity(task);
    await _box.putAsync(entity);
  }
}
```

### Data Layer Pattern

1. **Entities**: ObjectBox database models (`*_entity.dart`)
2. **Models**: Business logic models (`*.dart` in models/)
3. **Mappers**: Convert between entities and models
4. **Repositories**: Abstract data sources (implicit in services)

### Why This Separation?

- **Entities**: Optimized for database storage
- **Models**: Optimized for business logic
- **Mappers**: Handle conversions, keep layers independent

## 🎯 Module Architecture

Each feature module follows a consistent structure:

```
module_name/
├── components/          # Module-specific UI components
│   ├── card_widget.dart
│   └── list_item.dart
│
├── models/              # Module-specific models
│   └── module_model.dart
│
├── pages/               # Sub-screens
│   ├── detail_page.dart
│   └── list_page.dart
│
├── utils/               # Module utilities
│   └── module_utils.dart
│
└── module_page.dart     # Main module screen
```

### Module Isolation

- **Self-contained**: Each module contains its own components
- **Shared Core**: Common functionality in `core/`
- **Clear Dependencies**: Modules depend on core, not on each other
- **Reusability**: Components can be promoted to core if needed

## 🔌 Service Layer Architecture

### Service Responsibilities

```dart
class TaskService {
  // 1. Business Logic
  static List<Task> getPendingTasks(List<Task> tasks) { }
  
  // 2. Data Transformation
  static Task fromJson(Map<String, dynamic> json) { }
  
  // 3. Validation
  static bool isValidTask(Task task) { }
  
  // 4. External Communication
  static Future<void> syncWithServer() { }
}
```

### Available Services

| Service | Responsibility |
|---------|---------------|
| `DBService` | Database initialization |
| `TaskService` | Task business logic |
| `TeamService` | Team operations |
| `UserService` | User management |
| `NotificationService` | Notification handling |
| `EmailService` | Email notifications |
| `PreferenceService` | User preferences |
| `HttpService` | API communication |

## 🎨 UI Component Architecture

### Component Hierarchy

```
App (MyApp)
└── MaterialApp
    └── Splash
        └── (Navigation Decision)
            ├── Onboarding → Login → Home
            └── Home (Bottom Navigation)
                ├── HomePage
                ├── TasksPage
                ├── TeamsPage
                ├── NotificationsPage
                └── SettingsPage
```

### Reusable Components

Located in `core/components/`:
- **ProfileAvatarWithEdit**: User avatar with edit button
- **InfoDisplayField**: Read-only info display
- **PreferenceToggleItem**: Settings toggle
- **FilterChip**: Notification filter chip
- **GroupedNotificationList**: Grouped notifications

See [REUSABLE_COMPONENTS.md](./REUSABLE_COMPONENTS.md) for details.

## 🔐 Security Architecture

### Authentication Flow

```
┌─────────┐     ┌──────────┐     ┌─────────────┐
│  Login  │────>│UserState │────>│UserService  │
│  Screen │     │          │     │             │
└─────────┘     └──────────┘     └─────────────┘
                     │                  │
                     │                  ▼
                     │            ┌─────────────┐
                     │            │  ObjectBox  │
                     │            │  (UserDB)   │
                     │            └─────────────┘
                     ▼
              ┌─────────────┐
              │   Secure    │
              │   Storage   │
              └─────────────┘
```

### Security Layers

1. **Secure Storage**: Credentials encrypted with flutter_secure_storage
2. **Local Database**: ObjectBox with optional encryption
3. **Password Hashing**: Secure password storage
4. **HTTPS**: Encrypted API communication
5. **Input Validation**: Prevent injection attacks

## 🚀 Performance Optimizations

### 1. Lazy Loading
- Load data on demand
- Paginated lists (when needed)
- Progressive image loading

### 2. Caching Strategy
- **Memory Cache**: State holds current data
- **Disk Cache**: ObjectBox for persistence
- **Cache Invalidation**: Smart refresh logic

### 3. Build Optimization
- **Const Constructors**: Reduce rebuilds
- **Selective Rebuilds**: Provider selector pattern
- **Widget Keys**: Preserve widget state

### 4. Database Optimization
- **Indexed Fields**: Fast queries
- **Batch Operations**: Bulk inserts/updates
- **Query Optimization**: Efficient ObjectBox queries

## 🧪 Testing Architecture

### Test Structure (Planned)

```
test/
├── unit/                # Unit tests
│   ├── models/
│   ├── services/
│   └── utils/
│
├── widget/              # Widget tests
│   ├── components/
│   └── pages/
│
└── integration/         # E2E tests
    └── user_flows/
```

### Testing Strategy

1. **Unit Tests**: Services, utils, models
2. **Widget Tests**: UI components
3. **Integration Tests**: Complete user flows
4. **Mock Data**: Test with predictable data

## 🔮 Future Architecture Enhancements

### Planned Improvements

1. **Backend Integration**
   - RESTful API or GraphQL
   - Real-time sync with WebSockets
   - Cloud backup

2. **Advanced State Management**
   - Consider Riverpod for more features
   - State persistence
   - Undo/redo functionality

3. **Microservices**
   - Separate notification service
   - Analytics service
   - Search service

4. **Caching Layer**
   - HTTP response caching
   - Image caching
   - Smarter data refresh

## 📚 Architecture Principles

### SOLID Principles

- **S**ingle Responsibility: Each class has one purpose
- **O**pen/Closed: Extensible without modification
- **L**iskov Substitution: Interfaces are substitutable
- **I**nterface Segregation: Focused interfaces
- **D**ependency Inversion: Depend on abstractions

### Clean Architecture Concepts

1. **Separation of Concerns**: Layered architecture
2. **Dependency Rule**: Inner layers don't know outer layers
3. **Testability**: Easy to mock and test
4. **Flexibility**: Easy to change implementations

## 🎓 Learning Path

To understand the architecture:

1. Start with `main.dart` and `my_app.dart`
2. Explore `app_state/` for state management
3. Review `core/services/` for business logic
4. Examine a feature module (e.g., `modules/tasks/`)
5. Study the data flow from UI to database
6. Review reusable components in `core/components/`

---

**Ready to dive deeper?** Check out the [Contributing Guide](./CONTRIBUTING.md) to start working with this architecture!
