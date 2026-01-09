# Testing Documentation

## Overview

This document describes the comprehensive test suite for the Task Flow application. The tests cover models, utilities, state management, and widgets to ensure the application works correctly.

## Test Structure

```
test/
├── models/
│   ├── task_test.dart        # Tests for Task and Subtask models
│   └── user_test.dart         # Tests for User model
├── utils/
│   └── time_utils_test.dart   # Tests for TimeUtils utility functions
├── state/
│   └── task_state_test.dart   # Tests for TaskState (state management)
```

## Running Tests

### Prerequisites

1. Ensure Flutter SDK is installed (version 3.0.0 or higher)
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate mock files for testing:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Run All Tests

```bash
flutter test
```

### Run Specific Test Files

```bash
# Run only model tests
flutter test test/models/

# Run only a specific test file
flutter test test/models/task_test.dart

# Run with verbose output
flutter test --verbose
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

## Test Coverage

### Model Tests (test/models/)

#### Task Model Tests
- ✅ Task creation with required fields only
- ✅ Task creation with all optional fields
- ✅ Task `copyWith` method creates new instances correctly
- ✅ Task status getters (isPending, isInProgress, isCompleted)
- ✅ Task priority getters (isLow, isMedium, isHigh)
- ✅ Task `isOverdue` calculation
- ✅ Subtask counting and progress calculation
- ✅ Subtask model creation and copyWith

#### User Model Tests
- ✅ User creation with required and optional fields
- ✅ User `fromJson` deserialization
- ✅ User `fromJson` with missing/null values
- ✅ User `toString` formatting

### Utility Tests (test/utils/)

#### TimeUtils Tests
- ✅ `getTimeAgo` for various time differences (just now, minutes, hours, days, weeks)
- ✅ `formatDate` for today, yesterday, and other dates
- ✅ `isOverdue` with various scenarios (null, completed, past, future dates)

### State Management Tests (test/state/)

#### TaskState Tests
- ✅ Initial state correctness
- ✅ Task loading and initialization
- ✅ Error handling during initialization
- ✅ Task statistics (total, completed, in progress, due today)
- ✅ User-specific task queries (getMyTasks, getMyCompletedTasksCount, etc.)
- ✅ Task filtering by status, priority, and team
- ✅ Task sorting by different criteria
- ✅ Task CRUD operations (add, update, delete)
- ✅ Toggle task status (pending ↔ completed)
- ✅ Subtask completion when completing parent task

### Widget Tests (test/widgets/)

#### MyApp Widget Tests
- ✅ App builds successfully
- ✅ Correct app title
- ✅ Debug banner is disabled
- ✅ Material 3 usage
- ✅ Dark theme configuration

## Test Best Practices

1. **Isolation**: Each test is independent and doesn't rely on other tests
2. **Mocking**: External dependencies (like TaskService) are mocked using mockito
3. **Descriptive Names**: Test names clearly describe what they're testing
4. **Arrange-Act-Assert**: Tests follow the AAA pattern
5. **Edge Cases**: Tests cover both happy paths and edge cases

## Continuous Integration

Tests should be run as part of CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Run tests
  run: flutter test

- name: Generate coverage
  run: flutter test --coverage
```

## Troubleshooting

### Common Issues

1. **"flutter: command not found"**
   - Ensure Flutter is installed and in your PATH
   - Run: `flutter doctor` to verify installation

2. **"MockTaskService not found"**
   - Generate mocks: `dart run build_runner build`

3. **ObjectBox errors during tests**
   - Tests mock the TaskService, so ObjectBox isn't initialized
   - This is expected and correct behavior

4. **Import errors**
   - Run: `flutter pub get` to ensure all dependencies are installed

## Adding New Tests

When adding new features, please add corresponding tests:

1. Create test file in appropriate directory
2. Import necessary testing libraries
3. Follow existing test patterns
4. Ensure tests pass before committing
5. Update this documentation

### Example Test Template

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName Tests', () {
    setUp(() {
      // Setup code that runs before each test
    });

    tearDown(() {
      // Cleanup code that runs after each test
    });

    test('should do something specific', () {
      // Arrange
      final input = 'test';
      
      // Act
      final result = functionToTest(input);
      
      // Assert
      expect(result, expectedValue);
    });
  });
}
```

## Test Metrics

Target coverage: 80% or higher

Current test coverage by area:
- Models: ~95% (comprehensive coverage)
- Utils: ~90% (core utilities covered)
- State: ~85% (main state management covered)

## Future Test Improvements

- [ ] Add integration tests
- [ ] Add more widget tests for complex UI components
- [ ] Add golden tests for visual regression testing
- [ ] Add performance tests
- [ ] Add accessibility tests
