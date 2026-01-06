# Contributing to Task Flow

Thank you for your interest in contributing to Task Flow! This document provides guidelines and instructions for contributing.

## 🌟 Ways to Contribute

There are many ways to contribute to Task Flow:

1. **Report Bugs**: Found a bug? Let us know!
2. **Suggest Features**: Have an idea? We'd love to hear it!
3. **Write Code**: Fix bugs or implement features
4. **Improve Documentation**: Help make our docs better
5. **Write Tests**: Increase code coverage
6. **Review Code**: Help review pull requests
7. **Spread the Word**: Share Task Flow with others!

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:
- Flutter SDK 3.10.4+
- Dart SDK 3.10.4+
- Git
- A GitHub account
- Familiarity with Flutter/Dart

### Setting Up Development Environment

1. **Fork the Repository**
   ```bash
   # Click "Fork" button on GitHub
   # Then clone your fork
   git clone https://github.com/YOUR-USERNAME/task-flow.git
   cd task-flow
   ```

2. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/chingalo-family/task-flow.git
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate Code (ObjectBox, Mocks)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

## 📋 Contribution Workflow

### 1. Choose an Issue

- Browse [open issues](https://github.com/chingalo-family/task-flow/issues)
- Look for issues labeled `good first issue` or `help wanted`
- Comment on the issue to claim it
- Wait for maintainer approval before starting work

### 2. Create a Branch

```bash
# Update your fork
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name
# or for bug fixes
git checkout -b fix/bug-description
```

**Branch Naming Convention**:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Adding tests
- `chore/` - Maintenance tasks

### 3. Make Your Changes

Follow these guidelines:

#### Code Style

**Dart Code Style**:
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `flutter analyze` to check code
- Run `dart format .` before committing
- Keep lines under 80 characters when possible

**File Naming**:
- Use `snake_case` for files: `my_widget.dart`
- Use `PascalCase` for classes: `MyWidget`
- Use `camelCase` for variables: `myVariable`

**Comments**:
- Add comments for complex logic
- Use `///` for documentation comments
- Keep comments concise and clear

#### Architecture Guidelines

**State Management**:
- Use Provider pattern
- Create new state classes in `app_state/`
- Call `notifyListeners()` after state changes

**Component Structure**:
- Keep widgets small and focused
- Extract reusable components to `core/components/`
- Use const constructors when possible

**Service Layer**:
- Business logic goes in `core/services/`
- Keep services stateless
- Use static methods for utilities

**Database**:
- ObjectBox entities in `core/entities/`
- Models in `core/models/`
- Use mappers for conversion

#### Testing

Write tests for your changes:

```dart
// Unit test example
test('should create task with correct data', () {
  final task = Task(
    id: '1',
    title: 'Test Task',
  );
  
  expect(task.id, '1');
  expect(task.title, 'Test Task');
});

// Widget test example
testWidgets('displays task title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TaskCard(task: testTask),
    ),
  );
  
  expect(find.text('Test Task'), findsOneWidget);
});
```

Run tests:
```bash
flutter test
```

### 4. Commit Your Changes

**Commit Message Format**:

```
<type>: <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Example**:
```bash
git add .
git commit -m "feat: add task filtering by priority

- Add priority filter dropdown
- Implement filter logic in TaskState
- Add tests for priority filtering

Closes #123"
```

### 5. Push and Create Pull Request

```bash
# Push to your fork
git push origin feature/your-feature-name

# Go to GitHub and create Pull Request
```

**Pull Request Guidelines**:

- Use a clear, descriptive title
- Reference related issues (e.g., "Fixes #123")
- Describe what changes you made and why
- Include screenshots for UI changes
- Check that all CI checks pass
- Request review from maintainers

**PR Template**:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Changes Made
- Change 1
- Change 2

## Screenshots (if applicable)
[Add screenshots]

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] All tests passing
- [ ] No new warnings

## Related Issues
Fixes #123
```

### 6. Code Review

- Respond to review comments promptly
- Make requested changes
- Push updates to the same branch
- Be open to feedback

### 7. Merge

Once approved:
- Maintainers will merge your PR
- Your changes will be in the main branch
- Celebrate! 🎉

## 📝 Code Standards

### Flutter Best Practices

1. **Widget Organization**
   ```dart
   class MyWidget extends StatelessWidget {
     // 1. Constructor
     const MyWidget({super.key});
     
     // 2. Fields
     final String title;
     
     // 3. Build method
     @override
     Widget build(BuildContext context) {
       return Container();
     }
     
     // 4. Helper methods
     void _handleTap() {}
   }
   ```

2. **State Management**
   ```dart
   class MyState extends ChangeNotifier {
     // Private fields
     List<Task> _tasks = [];
     
     // Public getters
     List<Task> get tasks => _tasks;
     
     // Methods that modify state
     void addTask(Task task) {
       _tasks.add(task);
       notifyListeners();
     }
   }
   ```

3. **Async Operations**
   ```dart
   Future<void> loadTasks() async {
     try {
       final tasks = await taskService.getTasks();
       _tasks = tasks;
       notifyListeners();
     } catch (e) {
       debugPrint('Error loading tasks: $e');
     }
   }
   ```

### Security Guidelines

1. **Never commit sensitive data**:
   - API keys
   - Passwords
   - Email credentials
   - Personal information

2. **Use environment variables** for configuration

3. **Validate all user input**

4. **Use secure storage** for credentials

5. **Follow OWASP guidelines**

## 🐛 Reporting Bugs

### Before Reporting

1. Search existing issues
2. Verify it's reproducible
3. Test on latest version

### Bug Report Template

```markdown
## Bug Description
Clear description of the bug

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. See error

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Screenshots
[Add screenshots]

## Environment
- OS: [e.g., iOS 17, Android 14]
- App Version: [e.g., 1.0.0]
- Device: [e.g., iPhone 14, Pixel 7]

## Additional Context
Any other relevant information
```

## 💡 Suggesting Features

### Feature Request Template

```markdown
## Feature Description
Clear description of the feature

## Problem It Solves
What problem does this solve?

## Proposed Solution
How would this work?

## Alternatives Considered
Other approaches you thought about

## Additional Context
Mockups, examples, etc.
```

## 📚 Documentation

### Documentation Standards

- Use clear, simple language
- Include code examples
- Add screenshots for UI features
- Keep it up to date
- Follow markdown best practices

### Where to Document

- **User features**: `docs/USER_GUIDE.md`
- **API/Technical**: `docs/API_SERVICES.md`
- **Architecture**: `docs/ARCHITECTURE.md`
- **Code comments**: Inline in code

## 🧪 Testing Guidelines

### Test Coverage

Aim for:
- 80%+ unit test coverage
- Widget tests for all components
- Integration tests for critical flows

### Writing Tests

```dart
// Good test
test('addTask should add task to list', () {
  final state = TaskState();
  final task = Task(id: '1', title: 'Test');
  
  state.addTask(task);
  
  expect(state.tasks.length, 1);
  expect(state.tasks.first.title, 'Test');
});

// Avoid
test('it works', () {
  // Too vague
  expect(true, true);
});
```

## 🔄 Keeping Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge into your main
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## 🤝 Code of Conduct

### Our Pledge

We pledge to make participation a harassment-free experience for everyone.

### Our Standards

**Positive behavior**:
- Being respectful
- Accepting constructive criticism
- Focusing on what's best for the community
- Showing empathy

**Unacceptable behavior**:
- Harassment
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

## 📞 Getting Help

Need help contributing?

- Ask questions in GitHub Discussions
- Comment on the issue you're working on
- Reach out to maintainers
- Check the [FAQ](./FAQ.md)

## 🎉 Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes
- CHANGELOG.md

## 📋 Checklist Before Submitting

- [ ] Code follows style guidelines
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated and passing
- [ ] No new warnings or errors
- [ ] Commits follow commit message format
- [ ] PR description is clear
- [ ] Screenshots added (for UI changes)
- [ ] Related issues referenced

---

**Thank you for contributing to Task Flow!** 🙏 Your contributions make this project better for everyone!
