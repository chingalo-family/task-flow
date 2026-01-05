# Getting Started with Task Flow

This guide will help you get Task Flow up and running on your local machine for development and testing purposes.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required
- **Flutter SDK**: Version 3.10.4 or higher
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Comes bundled with Flutter
- **Git**: For version control

### Platform-Specific Requirements

#### For iOS Development
- macOS with Xcode 14.0 or higher
- CocoaPods (installed via `sudo gem install cocoapods`)
- iOS Simulator or physical iOS device

#### For Android Development
- Android Studio or Android SDK
- Android SDK Build-Tools
- Android Emulator or physical Android device

#### For Web Development
- Chrome browser (recommended for debugging)

#### For Desktop Development
- **Windows**: Visual Studio 2022 with C++ development tools
- **macOS**: Xcode Command Line Tools
- **Linux**: clang, cmake, ninja-build, libgtk-3-dev

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/chingalo-family/task-flow.git
cd task-flow
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all required packages defined in `pubspec.yaml`.

### 3. Generate ObjectBox Code

Task Flow uses ObjectBox for local data persistence. Generate the required ObjectBox code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or using dart directly:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `lib/objectbox.g.dart` - ObjectBox entity bindings
- `objectbox-model.json` - Database schema definition

> **Note:** This step is required whenever you modify entity classes (UserEntity, TaskEntity, TeamEntity, NotificationEntity).

### 4. Configure Environment (Optional)

If you plan to use email features or DHIS2 integration:

#### Email Configuration
```bash
# Copy the example file
cp lib/core/constants/email_connection.example.dart lib/core/constants/email_connection.dart

# Edit with your credentials (DO NOT commit real credentials)
nano lib/core/constants/email_connection.dart
```

#### DHIS2 Configuration
```bash
# Copy the example file
cp lib/core/constants/dhis2_connection.example.dart lib/core/constants/dhis2_connection.dart

# Edit with your DHIS2 instance details
nano lib/core/constants/dhis2_connection.dart
```

> **Security Warning**: Never commit real credentials to version control. These files are in `.gitignore` for security.

## 🏃 Running the App

### Run on All Platforms

```bash
# For web
flutter run -d chrome

# For iOS (macOS only)
flutter run -d ios

# For Android
flutter run -d android

# For Windows
flutter run -d windows

# For macOS
flutter run -d macos

# For Linux
flutter run -d linux
```

### Select Device

List available devices:
```bash
flutter devices
```

Run on specific device:
```bash
flutter run -d <device-id>
```

### Development Mode

For hot reload during development:
```bash
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
# Press 'q' to quit
```

## 🔧 Development Workflow

### 1. First-Time Setup

When you first run the app:
1. The app will show a splash screen
2. Then the onboarding screens (on first launch)
3. Finally, the login page

### 2. Create an Account

On the login page:
- Click "Sign Up" or "Request Account"
- Fill in your details:
  - Username
  - Email
  - Password
  - First Name
  - Surname
  - Phone Number
- Submit to create account

> **Note**: If DHIS2 backend is not configured, you can still use the app with local-only data.

### 3. Explore the App

After logging in, you'll see the main home screen with tabs:
- **My Tasks**: View and manage your tasks
- **Teams**: Create and collaborate with teams
- **Alerts**: View notifications
- **Settings**: Manage preferences and account

## 📁 Project Structure

```
task-flow/
├── android/              # Android platform code
├── ios/                  # iOS platform code
├── web/                  # Web platform code
├── windows/              # Windows platform code
├── macos/                # macOS platform code
├── linux/                # Linux platform code
├── lib/
│   ├── app_state/        # State management (Provider)
│   │   ├── user_state/
│   │   ├── task_state/
│   │   ├── team_state/
│   │   ├── notification_state/
│   │   └── ...
│   ├── core/
│   │   ├── components/   # Reusable UI components
│   │   ├── constants/    # App constants and configuration
│   │   ├── entities/     # ObjectBox entities
│   │   ├── models/       # Data models
│   │   ├── services/     # Business logic services
│   │   ├── utils/        # Utility functions
│   │   └── offline_db/   # Database providers
│   ├── modules/
│   │   ├── splash/       # Splash screen
│   │   ├── onboarding/   # Onboarding screens
│   │   ├── login/        # Authentication
│   │   ├── home/         # Main app shell
│   │   ├── tasks/        # Task management
│   │   ├── teams/        # Team management
│   │   ├── notifications/# Notifications
│   │   └── settings/     # Settings
│   ├── main.dart         # App entry point
│   └── my_app.dart       # App configuration
├── assets/
│   └── icons/            # App icons
├── test/                 # Test files
├── docs/                 # Documentation
├── pubspec.yaml          # Dependencies
└── README.md             # Project overview
```

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/path/to/test_file.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

## 🔍 Debugging

### Enable Debug Logging

The app includes debug prints for ObjectBox initialization and other operations. Check the console for:
- ✅ ObjectBox initialized successfully
- ⚠️ Warning messages
- ❌ Error messages

### Flutter DevTools

Launch DevTools for advanced debugging:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Then run your app and open DevTools in browser.

### Common Issues

#### Issue: ObjectBox initialization failed
**Solution**: Make sure you've run the build runner to generate ObjectBox code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Issue: Build errors after pulling latest code
**Solution**: Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### Issue: Gradle build failed (Android)
**Solution**: Ensure Android SDK is properly installed and configured:
```bash
flutter doctor -v
```

#### Issue: Pod install failed (iOS)
**Solution**: Update CocoaPods and try again:
```bash
cd ios
pod repo update
pod install
cd ..
```

## 🏗️ Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
# Build for iOS
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and upload to App Store.

### Web

```bash
# Build for web
flutter build web --release
```

Output: `build/web/`

Deploy the contents to any web server.

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 📦 State Management

Task Flow uses **Provider** for state management:

```dart
// Accessing state
final taskState = Provider.of<TaskState>(context);
final tasks = taskState.tasks;

// Using Consumer
Consumer<TaskState>(
  builder: (context, taskState, child) {
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

Available State Providers:
- `UserState` - User authentication and profile
- `TaskState` - Task management
- `TeamState` - Team management
- `NotificationState` - Notifications
- `UserListState` - User directory
- `AppInfoState` - App information

## 💾 Working with ObjectBox

### Adding/Updating Entities

After modifying entity files in `lib/core/entities/`:

```bash
# Regenerate ObjectBox code
flutter pub run build_runner build --delete-conflicting-outputs
```

### Querying Data

```dart
// Example: Get all pending tasks
final dbService = DBService();
final taskBox = dbService.store?.box<TaskEntity>();
final pendingTasks = taskBox
    ?.query(TaskEntity_.status.equals('pending'))
    .build()
    .find();
```

### Database Location

- **Android**: `/data/data/com.example.task_flow/databases/objectbox`
- **iOS**: `<App Library>/databases/objectbox`
- **Desktop**: User's app data directory

## 🎨 Customizing the Theme

Theme configuration is in `lib/my_app.dart`:

```dart
ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppConstant.darkBackground,
  colorScheme: ColorScheme.dark(
    primary: AppConstant.primaryBlue,
    // ... customize colors
  ),
)
```

Color constants are defined in `lib/core/constants/app_constant.dart`.

## 🔌 Adding New Features

### 1. Create Entity (if needed)
```dart
// lib/core/entities/new_entity.dart
@Entity()
class NewEntity {
  @Id()
  int id = 0;
  String name;
  // ... other fields
}
```

### 2. Generate ObjectBox Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Create Service
```dart
// lib/core/services/new_service.dart
class NewService {
  // Business logic
}
```

### 4. Create State Provider
```dart
// lib/app_state/new_state/new_state.dart
class NewState extends ChangeNotifier {
  // State management
}
```

### 5. Create UI Module
```dart
// lib/modules/new_module/new_page.dart
class NewPage extends StatefulWidget {
  // UI implementation
}
```

## 📚 Learning Resources

### Flutter
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)

### ObjectBox
- [ObjectBox Flutter Documentation](https://docs.objectbox.io/flutter)
- [ObjectBox Queries](https://docs.objectbox.io/queries)

### State Management
- [Provider Package](https://pub.dev/packages/provider)
- [Provider Documentation](https://pub.dev/documentation/provider/latest/)

## 🆘 Getting Help

- **Documentation**: Check the [docs](../docs/) directory
- **Issues**: Open an issue on GitHub
- **Discussions**: Join GitHub Discussions
- **Code Review**: Submit a PR for review

## ✅ Next Steps

Now that you have Task Flow running:

1. ✅ Explore the app features
2. ✅ Read the [Features Documentation](FEATURES.md)
3. ✅ Check out the [API Specification](API_SPECIFICATION.md)
4. ✅ Review the [Architecture Overview](ARCHITECTURE.md)
5. ✅ Start contributing! See [Contributing Guidelines](CONTRIBUTING.md)

---

**Happy Coding!** 🚀

If you encounter any issues, please check the [Common Issues](#common-issues) section or open an issue on GitHub.
