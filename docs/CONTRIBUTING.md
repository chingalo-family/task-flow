# Contributing to Task Flow

First off, thank you for considering contributing to Task Flow! It's people like you that make Task Flow such a great tool.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Community](#community)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

### Our Pledge

We pledge to make participation in our project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:
- Flutter SDK 3.10.4 or higher installed
- Git installed
- A GitHub account
- Basic knowledge of Flutter and Dart

### Setting Up Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/task-flow.git
   cd task-flow
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/chingalo-family/task-flow.git
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Generate ObjectBox code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**:
   ```bash
   flutter run
   ```

## 🤝 How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**When submitting a bug report, include**:
- A clear and descriptive title
- Steps to reproduce the behavior
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Device/platform information
- Flutter and Dart version

**Bug Report Template**:
```markdown
## Description
A clear description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots
If applicable, add screenshots.

## Environment
- Device: [e.g. iPhone 14, Pixel 7]
- OS: [e.g. iOS 16, Android 13]
- App Version: [e.g. 1.0.0]
- Flutter Version: [e.g. 3.10.4]
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues.

**When suggesting an enhancement, include**:
- A clear and descriptive title
- Detailed description of the proposed feature
- Why this enhancement would be useful
- Examples of how it would be used
- Mockups or wireframes (if applicable)

**Enhancement Template**:
```markdown
## Feature Description
A clear description of the feature.

## Use Case
Why this feature would be useful.

## Proposed Solution
How you think this should work.

## Alternatives Considered
Other solutions you've thought about.

## Additional Context
Any other context, screenshots, or mockups.
```

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `beginner friendly` - Easy to tackle

### Pull Requests

1. **Create a new branch** for your feature/fix:
   ```bash
   git checkout -b feature/amazing-feature
   # or
   git checkout -b fix/bug-fix
   ```

2. **Make your changes** following our style guidelines

3. **Test your changes** thoroughly

4. **Commit your changes** with clear commit messages

5. **Push to your fork**:
   ```bash
   git push origin feature/amazing-feature
   ```

6. **Open a Pull Request** on GitHub

## 🔄 Development Workflow

### Branch Naming Convention

- Feature branches: `feature/feature-name`
- Bug fixes: `fix/bug-description`
- Documentation: `docs/doc-description`
- Refactoring: `refactor/refactor-description`
- Performance: `perf/performance-improvement`

### Keeping Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge upstream changes into your main branch
git checkout main
git merge upstream/main

# Push updated main to your fork
git push origin main
```

### Working on Your Branch

```bash
# Create and switch to new branch
git checkout -b feature/new-feature

# Make changes, then stage them
git add .

# Commit changes
git commit -m "feat: add new feature"

# Push to your fork
git push origin feature/new-feature
```

## 🎨 Style Guidelines

### Dart Code Style

Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

**Key points**:
- Use `lowerCamelCase` for variables, functions, and parameters
- Use `UpperCamelCase` for classes and enums
- Use `lowercase_with_underscores` for library and file names
- Use 2 spaces for indentation
- Max line length: 80 characters (100 acceptable)
- Use trailing commas for better formatting

**Good Example**:
```dart
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description ?? ''),
        onTap: onTap,
      ),
    );
  }
}
```

### Code Organization

**File Structure**:
```dart
// 1. Imports (ordered: dart, flutter, package, relative)
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:task_flow/core/constants/app_constant.dart';

import '../components/task_card.dart';

// 2. Class definition
class TasksPage extends StatefulWidget {
  // ...
}

// 3. State class
class _TasksPageState extends State<TasksPage> {
  // 3.1 Fields
  // 3.2 Lifecycle methods
  // 3.3 Custom methods
  // 3.4 Build method
}
```

### Widget Best Practices

1. **Prefer const constructors** when possible:
   ```dart
   const Text('Hello')  // Good
   Text('Hello')        // Not ideal if value is constant
   ```

2. **Extract complex widgets**:
   ```dart
   // Bad: Large build method
   Widget build(BuildContext context) {
     return Column(
       children: [
         // 100 lines of widgets...
       ],
     );
   }

   // Good: Extracted widgets
   Widget build(BuildContext context) {
     return Column(
       children: [
         _buildHeader(),
         _buildBody(),
         _buildFooter(),
       ],
     );
   }
   ```

3. **Use Provider.of vs Consumer appropriately**:
   ```dart
   // Use Provider.of when not rebuilding
   void _handleTap() {
     Provider.of<TaskState>(context, listen: false).addTask(task);
   }

   // Use Consumer when rebuilding UI
   Consumer<TaskState>(
     builder: (context, taskState, child) {
       return Text('${taskState.tasks.length} tasks');
     },
   )
   ```

### Comments

- Write self-documenting code when possible
- Add comments for complex logic
- Use dartdoc comments for public APIs

```dart
/// Calculates the completion percentage of a task.
///
/// Returns a value between 0.0 and 1.0 representing the
/// percentage of completed subtasks.
///
/// Returns 0.0 if there are no subtasks.
double calculateCompletionPercentage(Task task) {
  if (task.subtasks.isEmpty) return 0.0;
  final completed = task.subtasks.where((s) => s.completed).length;
  return completed / task.subtasks.length;
}
```

### Naming Conventions

**Variables**:
```dart
final userName = 'John';        // Good
final user_name = 'John';       // Bad
```

**Private members**:
```dart
String _privateField;           // Good
void _privateMethod() {}        // Good
```

**Boolean variables**:
```dart
bool isLoading = true;          // Good
bool hasData = false;           // Good
bool loading = true;            // Not ideal
```

## 📝 Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `build`: Build system changes
- `ci`: CI configuration changes

### Examples

```bash
# Simple feature
git commit -m "feat: add task priority filter"

# Bug fix with scope
git commit -m "fix(tasks): correct due date calculation"

# Documentation update
git commit -m "docs: update API specification"

# Breaking change
git commit -m "feat!: redesign task entity schema

BREAKING CHANGE: TaskEntity now uses teamId instead of teamName"
```

## 🔍 Pull Request Process

### Before Submitting

1. ✅ Ensure your code follows the style guidelines
2. ✅ Run `flutter analyze` and fix any issues
3. ✅ Run `flutter test` and ensure all tests pass
4. ✅ Generate ObjectBox code if you modified entities
5. ✅ Update documentation if needed
6. ✅ Test on multiple platforms if possible

### PR Template

```markdown
## Description
Brief description of the changes.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Related Issue
Closes #123

## How Has This Been Tested?
Describe the tests you ran.

## Screenshots (if applicable)
Add screenshots to demonstrate the changes.

## Checklist
- [ ] My code follows the style guidelines
- [ ] I have performed a self-review
- [ ] I have commented my code where necessary
- [ ] I have updated the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix/feature works
- [ ] New and existing unit tests pass locally
- [ ] ObjectBox code has been regenerated (if entities changed)
```

### Review Process

1. At least one maintainer will review your PR
2. Address any feedback or requested changes
3. Once approved, a maintainer will merge your PR
4. Your contribution will be included in the next release!

## 🧪 Testing Guidelines

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/task_service_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

**Unit Test Example**:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/utils/date_utils.dart';

void main() {
  group('DateUtils', () {
    test('should format date correctly', () {
      final date = DateTime(2026, 1, 5);
      final formatted = DateUtils.formatDate(date);
      expect(formatted, equals('Jan 5, 2026'));
    });
  });
}
```

**Widget Test Example**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/modules/tasks/components/task_card.dart';

void main() {
  testWidgets('TaskCard displays task title', (tester) async {
    final task = Task(title: 'Test Task');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(task: task),
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
  });
}
```

## 📚 Documentation

### Code Documentation

Use dartdoc comments for public APIs:

```dart
/// Represents a task in the task management system.
///
/// Tasks can be assigned to users, associated with teams,
/// and tracked through various statuses.
class Task {
  /// Creates a new task with the given [title].
  ///
  /// The [title] must not be empty.
  Task({required this.title});

  /// The task's title.
  final String title;
}
```

### Updating Documentation

When adding new features:
1. Update relevant .md files in `docs/`
2. Add code examples if applicable
3. Update README.md if needed
4. Update API_SPECIFICATION.md for API changes

## 🏗️ ObjectBox Changes

When modifying entities:

1. **Make changes to entity files**:
   ```dart
   @Entity()
   class TaskEntity {
     // Add new field
     String? newField;
   }
   ```

2. **Regenerate ObjectBox code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Update documentation** in `docs/OBJECTBOX_BUILD_REQUIRED.md`

4. **Test thoroughly** to ensure schema migration works

## 🌟 Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes
- Special thanks in documentation

Outstanding contributors may be invited to join the core team!

## 💬 Community

### Getting Help

- 💬 GitHub Discussions for questions
- 🐛 GitHub Issues for bugs
- 📧 Email for private matters

### Communication Channels

- GitHub Discussions: General discussions, Q&A
- GitHub Issues: Bug reports, feature requests
- Pull Requests: Code reviews, technical discussions

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## ❓ Questions?

Don't hesitate to ask questions! We're here to help:
- Open a GitHub Discussion
- Comment on an existing issue
- Reach out to maintainers

---

**Thank you for contributing to Task Flow!** 🎉

Your efforts help make Task Flow better for everyone.
