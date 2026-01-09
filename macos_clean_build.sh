#!/bin/bash

# Clean Build Script for macOS ObjectBox Fix
# This script ensures a completely clean build to apply new entitlements

echo "🧹 Cleaning Flutter build cache..."
flutter clean

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🔨 Generating ObjectBox files..."
dart run build_runner build --delete-conflicting-outputs

echo "🗑️  Cleaning Xcode derived data (this helps apply new entitlements)..."
# Clean Xcode derived data to ensure entitlements are re-applied
if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
    echo "Removing Xcode DerivedData..."
    rm -rf ~/Library/Developer/Xcode/DerivedData
fi

# Clean macOS specific build artifacts
if [ -d "build/macos" ]; then
    echo "Removing macOS build directory..."
    rm -rf build/macos
fi

# Clean pod cache for macOS
if [ -d "macos/Pods" ]; then
    echo "Removing macOS Pods..."
    rm -rf macos/Pods
    rm -f macos/Podfile.lock
fi

echo "🏗️  Re-installing CocoaPods dependencies..."
cd macos
pod install --repo-update
cd ..

echo ""
echo "✅ Clean build preparation complete!"
echo ""
echo "Now run the app with:"
echo "  flutter run -d macos --debug"
echo ""
echo "Or build in Xcode to ensure entitlements are properly applied:"
echo "  open macos/Runner.xcworkspace"
echo ""
echo "📝 Note: After opening in Xcode, make sure to:"
echo "   1. Select 'Runner' in the project navigator"
echo "   2. Go to 'Signing & Capabilities' tab"
echo "   3. Verify 'App Sandbox' is disabled (should show as OFF)"
echo "   4. Clean Build Folder (Cmd+Shift+K)"
echo "   5. Build and Run (Cmd+R)"
