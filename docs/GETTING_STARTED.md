# Getting Started with Task Flow

This guide will help you set up and run Task Flow on your local machine.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

### Required
- **Flutter SDK**: Version 3.10.4 or higher
  - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Version 3.10.4 or higher (comes with Flutter)
- **Git**: For cloning the repository

### Platform-Specific Requirements

#### For Android Development
- Android Studio or Android SDK
- Android SDK Platform-Tools
- An Android device or emulator

#### For iOS Development (macOS only)
- Xcode 14 or higher
- CocoaPods
- iOS device or simulator

#### For Web Development
- Chrome browser (for debugging)

#### For Desktop Development
- **Linux**: GTK 3.0+ development libraries
- **macOS**: Xcode command line tools
- **Windows**: Visual Studio 2019 or later with C++ support

## 🚀 Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/chingalo-family/task-flow.git
cd task-flow
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Generate ObjectBox Files

Task Flow uses ObjectBox for local database storage. Generate the required files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or using flutter pub run (older method):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Note**: This step is crucial. Without it, the app will not compile. See [ObjectBox Setup](./OBJECTBOX_BUILD_REQUIRED.md) for more details.

### 4. Configure Email (Optional)

If you want to enable email notifications:

1. Copy the example configuration:
   ```bash
   cp lib/core/constants/email_connection.example.dart lib/core/constants/email_connection.dart
   ```

2. Edit `lib/core/constants/email_connection.dart` with your email credentials

**⚠️ Security Warning**: Never commit real credentials to version control. The `.gitignore` file is configured to exclude this file.

### 5. Configure API (Optional)

If you want to connect to the Task Flow API backend:

1. Copy the example configuration:
   ```bash
   cp lib/core/constants/api_config.example.dart lib/core/constants/api_config.dart
   ```

2. Edit `lib/core/constants/api_config.dart` with your API details:
   - Set `baseUrl` to your API domain (e.g., `https://vmi2503861.contaboserver.net`)
   - Set `apiPath` to your API path (default: `/task-flow-api`)

**Example Configuration:**
```dart
class ApiConfig {
  static const String baseUrl = 'https://vmi2503861.contaboserver.net';
  static const String apiPath = '/task-flow-api';
  
  // Other configuration remains the same...
}
```

**⚠️ Security Warning**: Never commit real API credentials to version control. The `.gitignore` file is configured to exclude this file.

**Related API Resources:**
- **API**: [https://vmi2503861.contaboserver.net/task-flow-api/](https://vmi2503861.contaboserver.net/task-flow-api/)
- **API Documentation**: [https://vmi2503861.contaboserver.net/task-flow-api-docs/](https://vmi2503861.contaboserver.net/task-flow-api-docs/)
- **API Source Code**: [https://github.com/chingalo-family/task-flow-api](https://github.com/chingalo-family/task-flow-api)

**Design Resources:**
- **Application Design**: [https://stitch.withgoogle.com/projects/14437076708101911838](https://stitch.withgoogle.com/projects/14437076708101911838)

### 6. Verify Installation

Check if everything is set up correctly:

```bash
flutter doctor
```

This command checks your environment and displays a report of the status of your Flutter installation.

## ▶️ Running the Application

### On Mobile (Android/iOS)

1. Connect your device or start an emulator/simulator

2. Check connected devices:
   ```bash
   flutter devices
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### On Web

```bash
flutter run -d chrome
```

Or for a specific browser:
```bash
flutter run -d web-server
```

### On Desktop

#### Linux
```bash
flutter run -d linux
```

#### macOS
```bash
flutter run -d macos
```

#### Windows
```bash
flutter run -d windows
```

## 🔨 Building for Production

### Android APK

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

Output will be in `build/web/`

### Desktop

#### Linux
```bash
flutter build linux --release
```

#### macOS
```bash
flutter build macos --release
```

#### Windows
```bash
flutter build windows --release
```

## 🧪 Running Tests

Run all tests:

```bash
flutter test
```

Run specific test file:

```bash
flutter test test/widget_test.dart
```

## 🔍 Troubleshooting

### Common Issues

#### 1. ObjectBox Build Errors

**Problem**: Error about missing `objectbox.g.dart`

**Solution**: Run the build_runner command:
```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 2. Flutter Doctor Issues

**Problem**: `flutter doctor` shows errors

**Solution**: Follow the specific instructions provided by `flutter doctor` for each issue

#### 3. Dependency Conflicts

**Problem**: Package version conflicts

**Solution**: 
```bash
flutter pub cache clean
flutter pub get
```

#### 4. Platform-Specific Build Errors

**Problem**: Build fails on specific platform

**Solution**: Check platform-specific requirements and ensure all tools are installed

#### 5. Hot Reload Not Working

**Problem**: Changes don't appear after hot reload

**Solution**: Try hot restart (Shift + R in terminal) or full rebuild

## 📱 First Run

When you first run the app:

1. **Splash Screen**: Brief loading screen
2. **Onboarding**: Introduction to app features (first-time users)
3. **Login Screen**: Create an account or log in

## 🎨 Development Tips

### Hot Reload

While the app is running, press `r` in the terminal to hot reload changes.

### Hot Restart

Press `R` (Shift + R) for a hot restart when hot reload doesn't work.

### View Logs

To see detailed logs:
```bash
flutter run --verbose
```

### Debug Mode

The app runs in debug mode by default with:
- Debug banner
- Performance overlay (optional)
- Developer tools

### Release Mode

Test release performance:
```bash
flutter run --release
```

## 🌐 Environment Configuration

### Development vs Production

Task Flow can be configured for different environments:

1. **Local Development**: Default configuration
2. **Production**: Use environment variables for API endpoints and credentials

### API Configuration (if using backend)

If you're integrating with a backend API:

1. Copy the example file:
   ```bash
   cp lib/core/constants/dhis2_connection.example.dart lib/core/constants/dhis2_connection.dart
   ```

2. Configure your API endpoint and credentials

## 📚 Next Steps

Now that you have Task Flow running:

1. ✅ **Explore Features**: Check the [Features Documentation](./FEATURES.md)
2. ✅ **Learn the Architecture**: Read the [Architecture Guide](./ARCHITECTURE.md)
3. ✅ **User Guide**: Learn how to use the app with the [User Guide](./USER_GUIDE.md)
4. ✅ **Start Contributing**: See the [Contributing Guide](./CONTRIBUTING.md)

## 💬 Getting Help

- **Documentation**: Check the [FAQ](./FAQ.md)
- **Issues**: Report bugs or request features on GitHub Issues
- **Community**: Join discussions on GitHub Discussions

---

**Congratulations!** 🎉 You now have Task Flow running on your machine. Happy task managing!
