# macOS Setup Guide

This guide provides specific instructions for running Task Flow on macOS, including solutions to common issues.

## ObjectBox and macOS Sandboxing

### Background

Task Flow uses ObjectBox for local database storage. ObjectBox is a high-performance embedded database that uses memory-mapped files and native C libraries. On macOS, this can create compatibility issues with Apple's app sandboxing security feature.

### The Issue

When macOS app sandboxing is enabled, ObjectBox may fail to initialize with an error like:

```
Opening ObjectBox store at: /Users/username/Library/Containers/chingalo.family.task-flow/Data/Library/Application Support/chingalo.family.task-flow
Storage error "Operation not permitted" (code 1)
Failed to initialize ObjectBox: StorageException: failed to create store: Could not open database environment; please check options and file system (1: Operation not permitted) (OBX_ERROR code 10199)
```

This occurs because ObjectBox's native code needs to create lock files and memory-mapped database files, which the macOS sandbox restricts even within the app's own container directory.

### Solution

For non-App Store distribution (direct downloads, enterprise distribution, etc.), we've disabled app sandboxing in both Debug and Release builds. This allows ObjectBox to function properly without restrictions.

**Current Configuration:**

- **DebugProfile.entitlements**: Sandboxing disabled (`com.apple.security.app-sandbox` = `false`)
- **Release.entitlements**: Sandboxing disabled (`com.apple.security.app-sandbox` = `false`)

### App Store Distribution

**⚠️ IMPORTANT**: If you plan to distribute Task Flow through the Mac App Store, you **MUST** address the sandboxing requirements. Options include:

1. **Wait for ObjectBox Sandbox Support**: Monitor ObjectBox releases for official sandbox compatibility
2. **Alternative Database**: Consider switching to a sandbox-compatible database solution (e.g., Core Data, Realm, SQLite with proper configuration)
3. **Hybrid Approach**: Use sandboxing with temporary exceptions (not recommended for App Store)

### Verifying the Fix

After applying this configuration, ObjectBox should initialize successfully. You can verify this by:

1. **Run the clean build script** (recommended):
   ```bash
   chmod +x macos_clean_build.sh
   ./macos_clean_build.sh
   flutter run -d macos
   ```
   
   This script ensures all caches are cleared and entitlements are properly applied.

2. **Or manually clean and build**:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   rm -rf ~/Library/Developer/Xcode/DerivedData
   rm -rf build/macos
   flutter run -d macos
   ```

3. Check the console output for:
   ```
   ✅ ObjectBox initialized successfully
   Opening ObjectBox store at: /Users/username/Library/Documents/objectbox
   ```
   
   **Important**: The database is now stored in the Documents directory for better compatibility with macOS when sandboxing is disabled.

4. If you still see "Operation not permitted" errors:
   - **Clean Xcode's derived data**: `rm -rf ~/Library/Developer/Xcode/DerivedData`
   - **Clean pods**: `cd macos && rm -rf Pods && pod install && cd ..`
   - **Open in Xcode** and verify entitlements:
     - Open `macos/Runner.xcworkspace` in Xcode
     - Select 'Runner' target
     - Go to 'Signing & Capabilities' tab
     - Verify 'App Sandbox' shows as **OFF** or **disabled**
     - Clean Build Folder (⌘⇧K)
     - Build and Run (⌘R)
   - **Check directory permissions**: `ls -la ~/Library/Documents/`
   - **Try removing old database**: `rm -rf ~/Library/Documents/objectbox`

## Development vs Production Builds

### Debug/Development Builds

For local development, sandboxing is disabled to ensure maximum compatibility and ease of debugging.

**Entitlements:** `macos/Runner/DebugProfile.entitlements`

### Release Builds

For direct distribution (not App Store), sandboxing is also disabled to ensure ObjectBox works correctly.

**Entitlements:** `macos/Runner/Release.entitlements`

## Security Considerations

### With Sandboxing Disabled

When app sandboxing is disabled:

- ✅ **Pro**: ObjectBox works without restrictions
- ✅ **Pro**: Simpler configuration and debugging
- ⚠️ **Con**: Cannot distribute through Mac App Store
- ⚠️ **Con**: Reduced security isolation from the system

### Mitigations

Even with sandboxing disabled, Task Flow maintains security through:

1. **Minimal Permissions**: Only requests necessary entitlements
2. **Secure Storage**: Uses `flutter_secure_storage` for sensitive data
3. **Local-First**: Data stays on the user's device by default
4. **User Control**: Users control what data to sync and share

## File System Access

### Database Location

ObjectBox stores its database files in a dedicated subdirectory:

**Current configuration (sandboxing disabled)**:
- macOS: `~/Library/Documents/objectbox/`

This location is used because:
- Documents directory has better compatibility with ObjectBox when sandboxing is disabled
- Avoids permission issues that can occur with Application Support directory
- Provides reliable read/write access for ObjectBox's memory-mapped files

**Previous locations (if you're migrating)**:
- Application Support: `~/Library/Application Support/chingalo.family.task-flow/`
- Sandboxed: `~/Library/Containers/chingalo.family.task-flow/Data/Library/Application Support/`

**Note**: If you have existing data in a previous location, you may need to migrate it manually or start fresh. The database files are in the `objectbox` subdirectory.

This directory is:
- Automatically created by the app
- Backed up by Time Machine (unless user excludes it)
- Preserved during app updates
- Remains on system after uninstall (manual cleanup needed for complete removal)

### Entitlements Granted

The app requests these file system entitlements:

- `com.apple.security.files.application-support`: Access to Application Support directory
- `com.apple.security.files.user-selected.read-write`: Access to user-selected files (for future import/export features)

## Network Access

Task Flow requires network access for:
- API communication with Task Flow backend
- Email notifications (SMTP)
- Future sync features

### Entitlements:
- `com.apple.security.network.client`: Outgoing network connections
- `com.apple.security.network.server`: Local network server (for future features)

## Troubleshooting

### ObjectBox Still Fails to Initialize

1. **Check Console Logs**: Look for specific error messages
2. **Verify Entitlements**: Ensure the `.entitlements` files are correctly configured
3. **Clean Build**: 
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   flutter run -d macos
   ```
4. **Check Permissions**: Verify the app has necessary permissions in System Preferences > Security & Privacy

### Build Errors Related to Entitlements

1. **Xcode Code Signing**: Ensure you have a valid development certificate
2. **Bundle Identifier**: Verify it matches in all configuration files
3. **Provisioning Profile**: Check that your profile includes the necessary entitlements

### Performance Issues

ObjectBox is highly optimized, but if you experience performance issues:

1. **Check Disk Space**: Ensure adequate free space
2. **Monitor Database Size**: Large datasets may require optimization
3. **Update ObjectBox**: Check for newer versions: `flutter pub upgrade objectbox`

## Building for Production

### Direct Distribution (Non-App Store)

1. Build the release version:
   ```bash
   flutter build macos --release
   ```

2. The app bundle will be in: `build/macos/Build/Products/Release/task_flow.app`

3. You can distribute this directly or create a DMG installer

### Code Signing

For distribution outside the App Store, you'll want to code sign the app:

```bash
codesign --deep --force --verify --verbose --sign "Developer ID Application: Your Name" build/macos/Build/Products/Release/task_flow.app
```

### Notarization

For macOS 10.15+, you should notarize the app:

1. Create a DMG or ZIP of your app
2. Submit to Apple for notarization
3. Staple the notarization ticket to your app

See Apple's [Notarizing macOS Software](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution) guide.

## Future Considerations

### ObjectBox Sandbox Support

Monitor these resources for updates:

- [ObjectBox Flutter](https://github.com/objectbox/objectbox-dart)
- [ObjectBox macOS Issues](https://github.com/objectbox/objectbox-dart/issues)

When ObjectBox adds full sandbox support, we can re-enable sandboxing for App Store distribution.

### Alternative Solutions

If App Store distribution becomes a priority before ObjectBox sandbox support:

1. **SQLite with Drift**: Fully sandbox-compatible
2. **Realm**: Has sandbox support
3. **Core Data**: Native macOS, fully sandbox-compatible
4. **Hive**: Flutter-native, should work with sandboxing

## Additional Resources

- [Flutter macOS Development](https://docs.flutter.dev/platform-integration/macos/building)
- [macOS App Sandboxing](https://developer.apple.com/documentation/security/app_sandbox)
- [ObjectBox Flutter Documentation](https://docs.objectbox.io/getting-started)
- [Flutter Desktop Platform Guide](https://docs.flutter.dev/platform-integration/desktop)

## Getting Help

If you encounter issues not covered here:

1. Check the [main documentation](README.md)
2. Search [GitHub Issues](https://github.com/chingalo-family/task-flow/issues)
3. Create a new issue with:
   - macOS version
   - Flutter version (`flutter --version`)
   - Build mode (debug/release)
   - Full error logs
   - Steps to reproduce

---

**Last Updated**: January 2026
