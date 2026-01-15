# Background Tasks Setup Guide

This guide explains how to set up background task support for the Task Flow app using the `workmanager` plugin.

## Problem

If you see the error:
```
PlatformException(unhandledMethod("registerPeriodicTask") error, Unhandled method registerPeriodicTask, null, null)
```

This means the native platform configuration for `workmanager` is missing or incomplete.

## Platform-Specific Setup

### Android Setup

1. **Update `android/app/src/main/AndroidManifest.xml`**:

Add these permissions:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    
    <application ...>
        <!-- Add this inside application tag -->
        <receiver android:name="androidx.work.impl.background.systemalarm.RescheduleReceiver"
                  android:enabled="true"
                  android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
            </intent-filter>
        </receiver>
    </application>
</manifest>
```

2. **Verify `android/app/build.gradle.kts`** has proper dependencies:

```kotlin
dependencies {
    implementation("androidx.work:work-runtime-ktx:2.8.1")
    // ... other dependencies
}
```

3. **Test on a physical device** - Background tasks may not work reliably on emulators.

### iOS Setup

iOS has strict background task limitations. The `workmanager` plugin on iOS uses background fetch.

1. **Enable Background Modes in Xcode**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the Runner target
   - Go to "Signing & Capabilities"
   - Click "+ Capability" and add "Background Modes"
   - Check "Background fetch" and "Background processing"

2. **Update `ios/Runner/Info.plist`**:

```xml
<dict>
    <!-- Add these entries -->
    <key>BGTaskSchedulerPermittedIdentifiers</key>
    <array>
        <string>com.taskflow.notification.check</string>
    </array>
    
    <key>UIBackgroundModes</key>
    <array>
        <string>fetch</string>
        <string>processing</string>
    </array>
    
    <!-- Rest of your plist entries -->
</dict>
```

3. **Important iOS Notes**:
   - Background tasks on iOS are **not guaranteed** to run at specific times
   - iOS decides when to run background tasks based on user behavior and battery
   - Minimum interval is 15 minutes, not immediate
   - Test on a physical device, not simulator

### macOS

The `workmanager` plugin does **not support macOS**. Background tasks will fail silently on macOS.

**Workaround**: Disable scheduled notifications on macOS or implement an alternative using:
- Timer-based checks when app is open
- Manual trigger button only

## Testing

### Android
```bash
# Enable device to test background tasks
adb shell cmd deviceidle tempwhitelist com.taskflow.app

# Check if tasks are scheduled
adb shell dumpsys jobscheduler | grep taskflow
```

### iOS
Background tasks are hard to test. Use Xcode's debugging:
1. Set a breakpoint in your background task callback
2. In Xcode: Debug → Simulate Background Fetch

## Fallback Strategy

The app now handles missing platform support gracefully:

1. **Error handling**: Shows user-friendly messages when background tasks aren't available
2. **Manual trigger**: Users can always manually trigger notification checks
3. **Graceful degradation**: App continues to work without background tasks

## Limitations

| Platform | Support | Notes |
|----------|---------|-------|
| Android | ✅ Full | Requires proper manifest configuration |
| iOS | ⚠️ Limited | System-controlled, not guaranteed |
| macOS | ❌ No | Plugin not supported |
| Web | ❌ No | Not applicable |
| Linux | ❌ No | Not applicable |
| Windows | ❌ No | Not applicable |

## Debugging

Enable debug mode in the background service:
```dart
await Workmanager().initialize(
  callbackDispatcher,
  isInDebugMode: true, // Enable this for debugging
);
```

Check logs:
- Android: `adb logcat | grep Flutter`
- iOS: View in Xcode console

## References

- [workmanager plugin documentation](https://pub.dev/packages/workmanager)
- [Android WorkManager guide](https://developer.android.com/topic/libraries/architecture/workmanager)
- [iOS Background Tasks guide](https://developer.apple.com/documentation/backgroundtasks)
