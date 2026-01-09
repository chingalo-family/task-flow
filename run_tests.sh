#!/bin/bash
# Test runner script for Task Flow application

set -e

echo "========================================="
echo "Task Flow - Test Suite"
echo "========================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Generate mocks
echo "🔨 Generating mock files..."
dart run build_runner build --delete-conflicting-outputs

# Run tests
echo ""
echo "🧪 Running tests..."
echo "========================================="
flutter test --coverage
TEST_EXIT_CODE=$?

# Check if tests passed
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "========================================="
    echo "✅ All tests passed successfully!"
    echo "========================================="
    
    # Show coverage summary if lcov is installed
    if command -v lcov &> /dev/null; then
        echo ""
        echo "📊 Coverage Summary:"
        lcov --summary coverage/lcov.info
    fi
else
    echo ""
    echo "========================================="
    echo "❌ Some tests failed!"
    echo "========================================="
    exit 1
fi
