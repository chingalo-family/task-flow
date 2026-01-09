# Task Flow

**"Collaborate and Achieve"**

A modern, cross-platform task management and team collaboration application built with Flutter.

[![Flutter](https://img.shields.io/badge/Flutter-3.10.4+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10.4+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

- ✅ **Task Management**: Create, organize, and track tasks with ease
- 🎯 **Prioritization**: High, Medium, and Low priority levels
- 👥 **Team Collaboration**: Create teams and work together
- 📊 **Progress Tracking**: Subtasks and visual progress indicators
- 🔔 **Smart Notifications**: Stay updated on task changes
- 💾 **Offline-First**: Work anywhere with local ObjectBox database
- 🎨 **Beautiful UI**: Modern dark theme with Material Design 3
- 📱 **Cross-Platform**: iOS, Android, Web, macOS, Linux, Windows

## 🚀 Quick Start

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

3. **Generate ObjectBox files**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run tests** (optional but recommended)
   ```bash
   flutter test
   # Or use the test runner script
   ./run_tests.sh
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

For detailed setup instructions, see the [Getting Started Guide](docs/GETTING_STARTED.md).

## 📚 Documentation

Comprehensive documentation is available in the [`docs/`](docs/) directory:

- **[Overview](docs/OVERVIEW.md)** - Introduction and key benefits
- **[Quick Start](docs/QUICK_START.md)** - Get up and running in 5 minutes
- **[Getting Started](docs/GETTING_STARTED.md)** - Detailed installation guide
- **[macOS Setup](docs/MACOS_SETUP.md)** - macOS-specific setup and troubleshooting
- **[Features](docs/FEATURES.md)** - Complete feature list
- **[User Guide](docs/USER_GUIDE.md)** - How to use Task Flow
- **[Architecture](docs/ARCHITECTURE.md)** - Technical architecture
- **[Technology Stack](docs/TECH_STACK.md)** - Technologies used
- **[Contributing](docs/CONTRIBUTING.md)** - Contribution guidelines
- **[Roadmap](docs/ROADMAP.md)** - Future plans
- **[FAQ](docs/FAQ.md)** - Frequently asked questions
- **[Changelog](docs/CHANGELOG.md)** - Version history


## 🌐 Related Resources

- **Website**: [https://chingalo-family.github.io/task-flow-website/](https://chingalo-family.github.io/task-flow-website/)
- **Website Source Code**: [https://github.com/chingalo-family/task-flow-website](https://github.com/chingalo-family/task-flow-website)
- **API**: [https://vmi2503861.contaboserver.net/task-flow-api/](https://vmi2503861.contaboserver.net/task-flow-api/)
- **API Documentation**: [https://vmi2503861.contaboserver.net/task-flow-api-docs/](https://vmi2503861.contaboserver.net/task-flow-api-docs/)
- **API Source Code**: [https://github.com/chingalo-family/task-flow-api](https://github.com/chingalo-family/task-flow-api)
- **Design Resources**: [https://stitch.withgoogle.com/projects/14437076708101911838](https://stitch.withgoogle.com/projects/14437076708101911838)

## 🎯 Why Task Flow?

Task Flow helps you:
- 📋 Stay organized with intuitive task management
- ⏰ Never miss deadlines with due dates and reminders
- 🤝 Collaborate seamlessly with your team
- 📈 Track progress with visual indicators
- 🌐 Work anywhere with offline support

## 🛠️ Technology Stack

- **Framework**: Flutter 3.10.4+
- **Language**: Dart 3.10.4+
- **Database**: ObjectBox 5.1.0
- **State Management**: Provider 6.1.5+1
- **UI**: Material Design 3
- **Security**: flutter_secure_storage

See [Technology Stack](docs/TECH_STACK.md) for more details.

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. 🐛 **Report Bugs**: [Open an issue](https://github.com/chingalo-family/task-flow/issues)
2. 💡 **Suggest Features**: Share your ideas
3. 💻 **Submit PRs**: Fix bugs or add features
4. 📖 **Improve Docs**: Help make documentation better

See the [Contributing Guide](docs/CONTRIBUTING.md) for detailed instructions.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Built with ❤️ using Flutter and open-source technologies.

## 📞 Support

- **Documentation**: [docs/](docs/)
- **Issues**: [GitHub Issues](https://github.com/chingalo-family/task-flow/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chingalo-family/task-flow/discussions)

---

## 🔧 Developer Notes

### Testing

Task Flow includes a comprehensive test suite with **196 tests** covering models, utilities, state management, and widgets.

**Quick Test Commands:**
```bash
flutter test                    # Run all tests
flutter test --coverage         # Run with coverage report
./run_tests.sh                  # Use test runner script
```

**Test Coverage:**
- ✅ **87 Model Tests**: All data models (Task, User, Team, Notification, etc.)
- ✅ **63 Utility Tests**: Validation, formatting, and helper functions
- ✅ **66 State Tests**: Complete state management coverage
- ✅ **4 Widget Tests**: Core widget initialization

For detailed testing documentation, see [test/README.md](test/README.md).

### ObjectBox Setup

Task Flow uses ObjectBox for local database storage. You must generate the ObjectBox files before running the app:

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Generate ObjectBox code:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   
   The generated `lib/objectbox.g.dart` file is required for the app to run.

3. **Run the app:**
   ```bash
   flutter run
   ```

#### macOS Users - Important!

If you encounter "Operation not permitted" errors on macOS, use the clean build script:

```bash
chmod +x macos_clean_build.sh
./macos_clean_build.sh
flutter run -d macos
```

This ensures Xcode properly applies the entitlements that allow ObjectBox to work. See [macOS Setup Guide](docs/MACOS_SETUP.md) for detailed troubleshooting.


### Email Configuration (Optional)

For email notifications:

1. **Copy example configuration:**
   ```bash
   cp lib/core/constants/email_connection.example.dart lib/core/constants/email_connection.dart
   ```

2. **Edit with your credentials** (⚠️ Never commit real credentials!)

### API Configuration (Optional)

For connecting to the Task Flow API backend:

1. **Copy example configuration:**
   ```bash
   cp lib/core/constants/api_config.example.dart lib/core/constants/api_config.dart
   ```

2. **Edit the configuration** with your API details:
   - Set `baseUrl` to your API domain (e.g., `vmi2503861.contaboserver.net`)
   - Set `apiPath` to your API path (default: `/task-flow-api`)

**⚠️ Security Warning**: Never commit real API credentials to version control. The `.gitignore` file is configured to exclude this file.

See [Getting Started](docs/GETTING_STARTED.md) for complete setup instructions.

---

**Ready to boost your productivity?** Start with the [Quick Start Guide](docs/QUICK_START.md)!
