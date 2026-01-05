# Task Flow - Collaborate and Achieve

<div align="center">

![Task Flow](https://img.shields.io/badge/Flutter-3.10.4+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-iOS%20|%20Android%20|%20Web%20|%20Desktop-blue?style=for-the-badge)

**A modern, collaborative task management application built with Flutter**

[Features](#-features) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 🎯 What is Task Flow?

Task Flow is a powerful, offline-first task management application that helps teams and individuals organize, track, and complete their work efficiently. Built with Flutter and ObjectBox, it offers seamless collaboration, real-time notifications, and works perfectly even without an internet connection.

### Why Task Flow?

- ✅ **Offline-First**: Full functionality without internet connection
- 🚀 **High Performance**: Built with ObjectBox for lightning-fast data access
- 👥 **Team Collaboration**: Create teams, assign tasks, and work together
- 📱 **Cross-Platform**: iOS, Android, Web, Windows, macOS, and Linux
- 🌙 **Beautiful UI**: Modern dark theme with Material Design 3
- 🔔 **Smart Notifications**: Stay updated with real-time alerts
- 🔐 **Secure**: Encrypted local storage and secure authentication

## ✨ Features

### Task Management
- Create, edit, and delete tasks with rich details
- Set priorities (Low, Medium, High) and statuses
- Add due dates, categories, and tags
- Track progress with subtasks
- Attach files and links
- Search and filter tasks

### Team Collaboration
- Create and manage teams
- Custom team icons and colors
- Add/remove team members
- Team-specific task statuses
- Shared team tasks

### Notifications & Alerts
- Real-time notifications
- Task assignment alerts
- Team invitations
- Mention notifications
- Filter by type and read status

### User Management
- Secure email/password authentication
- Google OAuth (Planned)
- Apple Sign-In (Planned)
- User profiles and preferences

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.4 or higher
- Dart SDK (included with Flutter)
- Your preferred IDE (VS Code, Android Studio, IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/chingalo-family/task-flow.git
   cd task-flow
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate ObjectBox code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

For detailed setup instructions, see the [Getting Started Guide](docs/GETTING_STARTED.md).

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| iOS      | ✅ Supported | iOS 12.0+ |
| Android  | ✅ Supported | Android 5.0+ (API 21+) |
| Web      | ✅ Supported | All modern browsers |
| Windows  | ✅ Supported | Windows 10+ |
| macOS    | ✅ Supported | macOS 10.14+ |
| Linux    | ✅ Supported | Ubuntu 18.04+, Fedora, Debian |

## 📚 Documentation

Comprehensive documentation is available in the [docs](docs/) directory:

- **[Overview](docs/OVERVIEW.md)** - Introduction and key concepts
- **[Getting Started Guide](docs/GETTING_STARTED.md)** - Setup and installation
- **[Features](docs/FEATURES.md)** - Complete feature list
- **[API Specification](docs/API_SPECIFICATION.md)** - Backend API documentation
- **[Architecture](docs/ARCHITECTURE.md)** - Technical architecture
- **[Database Schema](docs/DATABASE_SCHEMA.md)** - ObjectBox database design
- **[Authentication](docs/AUTHENTICATION.md)** - Auth implementation details
- **[Contributing](docs/CONTRIBUTING.md)** - Contribution guidelines
- **[Roadmap](docs/ROADMAP.md)** - Future plans and features

## 🏗️ Tech Stack

- **Framework**: Flutter 3.10.4+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Local Database**: ObjectBox
- **Secure Storage**: Flutter Secure Storage
- **HTTP Client**: http package
- **Email Service**: Mailer
- **UI Design**: Material Design 3

## 🎨 Screenshots

<div align="center">

| Login | Tasks | Teams | Notifications |
|-------|-------|-------|---------------|
| Modern authentication | Task management | Team collaboration | Real-time alerts |

</div>

## 🔮 Roadmap

### Version 1.1.0 (Q1 2026)
- 🔐 Google OAuth Integration
- 🍎 Apple Sign-In
- 🔒 Two-factor authentication
- 📊 Enhanced API documentation

### Version 1.2.0 (Q2 2026)
- 💬 In-app comments
- 📎 Enhanced attachments
- 📅 Calendar integration
- 🎨 Light theme

### Version 1.3.0 (Q3 2026)
- 📊 Analytics dashboard
- ⏱️ Time tracking
- 🤖 Smart suggestions
- 🔗 Third-party integrations

See the complete [Roadmap](docs/ROADMAP.md) for more details.

## 🤝 Contributing

We welcome contributions! Please read our [Contributing Guidelines](docs/CONTRIBUTING.md) before submitting pull requests.

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`flutter test`)
5. Commit your changes (`git commit -m 'feat: add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- Flutter team for the amazing framework
- ObjectBox team for the high-performance database
- All contributors who help improve Task Flow

## 📞 Support

- 📧 Email: support@taskflow.com
- 💬 GitHub Discussions: [Join the conversation](https://github.com/chingalo-family/task-flow/discussions)
- 🐛 Issues: [Report bugs](https://github.com/chingalo-family/task-flow/issues)

---

<div align="center">

**Built with ❤️ using Flutter**

[⭐ Star this repo](https://github.com/chingalo-family/task-flow) if you find it helpful!

</div>

## ObjectBox & auth integration (PR notes)

This branch adds ObjectBox-backed user persistence and a Provider-based `UserState` for auth flows.

Quick setup:

1. Install dependencies:

```bash
flutter pub get
```

2. Run ObjectBox codegen to generate `objectbox.g.dart` (the generated file is imported by `lib/core/services/db_service.dart`):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
# or using objectbox generator if installed:
# dart run objectbox_generator
```

3. Ensure `DBService().init()` is called early in the app (for example in `main()`), and provide the `UserState` to the widget tree:

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

4. Email credentials: edit `lib/core/constants/email_connection.dart` or use a secure backend/CI secrets. Do NOT commit real credentials.

Notes:
- The generated file `lib/objectbox.g.dart` will be created by ObjectBox codegen and must be present for the app to run.
- This PR keeps the `UserService` public API compatible with previous code: `login`, `getCurrentUser`, `setCurrentUser`, `logout`, `changeCurrentUserPassword`.
- The login UI is available under `lib/modules/login/` and demonstrates hooking into `UserState`.
