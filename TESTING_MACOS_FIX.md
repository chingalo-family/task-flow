# Testing the ObjectBox macOS Fix

This document provides instructions for verifying that the ObjectBox storage error has been resolved on macOS.

## Prerequisites

- macOS 10.15 or later
- Flutter 3.10.4 or later
- Xcode (latest version recommended)
- Task Flow repository cloned

## Verification Steps

### 1. Clean Build

First, ensure you have a clean build environment:

```bash
cd /path/to/task-flow
flutter clean
flutter pub get
```

### 2. Generate ObjectBox Files

Regenerate the ObjectBox files to ensure they're up to date:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected output:
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 2.1s

[INFO] Creating build script snapshot......
[INFO] Creating build script snapshot... completed, took 10.3s

[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 1.2s

[INFO] Checking for unexpected pre-existing outputs....
[INFO] Checking for unexpected pre-existing outputs. completed, took 0.1s

[INFO] Running build...
[INFO] Generating SDK summary...
[INFO] 3.2s elapsed, 0/1 actions completed.
[INFO] Running build completed, took 15.7s

[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 0.1s

[INFO] Succeeded after 15.8s with 2 outputs
```

### 3. Verify Entitlements

Check that the entitlements files have been updated correctly:

#### DebugProfile.entitlements

```bash
cat macos/Runner/DebugProfile.entitlements | grep -A1 "app-sandbox"
```

Expected output:
```xml
<key>com.apple.security.app-sandbox</key>
<false/>
```

#### Release.entitlements

```bash
cat macos/Runner/Release.entitlements | grep -A1 "app-sandbox"
```

Expected output:
```xml
<key>com.apple.security.app-sandbox</key>
<false/>
```

### 4. Run the Application

#### Debug Mode

```bash
flutter run -d macos --debug
```

#### Release Mode

```bash
flutter run -d macos --release
```

### 5. Check Console Output

Look for the following success messages in the console:

**Success Indicators:**
```
Opening ObjectBox store at: /Users/[your-username]/Library/Application Support/chingalo.family.task-flow
✅ ObjectBox initialized successfully
```

**Error Indicators (if something is still wrong):**
```
⚠️ ObjectBox initialization failed: StorageException...
📱 App will run without offline database support
```

### 6. Test Database Functionality

Once the app is running, test that ObjectBox is working properly:

1. **Create a User**
   - Navigate to the user creation screen
   - Create a new user
   - Verify the user is saved

2. **Create a Task**
   - Navigate to the task creation screen
   - Create a new task
   - Verify the task is saved and appears in the task list

3. **Create a Team**
   - Navigate to the team creation screen
   - Create a new team
   - Verify the team is saved and appears in the team list

4. **Test Persistence**
   - Close the app completely
   - Reopen the app
   - Verify that all previously created data is still present

### 7. Check Database Files

Verify that ObjectBox has created its database files:

```bash
ls -la ~/Library/Application\ Support/chingalo.family.task-flow/
```

Expected output (file names may vary):
```
total 128
drwxr-xr-x   7 username  staff    224 Jan  9 12:00 .
drwx------  123 username  staff   3936 Jan  9 12:00 ..
-rw-r--r--   1 username  staff  16384 Jan  9 12:00 data.mdb
-rw-r--r--   1 username  staff   8192 Jan  9 12:00 lock.mdb
```

## Common Issues and Solutions

### Issue: "Operation not permitted" error persists

**Solution:**
1. Ensure you're using the latest code from the PR
2. Run `flutter clean` and rebuild
3. Check that entitlements files are correctly updated
4. Try running with `sudo` (not recommended for production, but useful for debugging)

### Issue: Database files not created

**Solution:**
1. Check directory permissions: `ls -la ~/Library/Application\ Support/`
2. Ensure the app has necessary permissions in System Preferences > Security & Privacy
3. Try manually creating the directory: `mkdir -p ~/Library/Application\ Support/chingalo.family.task-flow`

### Issue: App crashes on startup

**Solution:**
1. Check console logs for specific error messages
2. Verify ObjectBox code generation completed successfully
3. Ensure all dependencies are up to date: `flutter pub upgrade`

### Issue: Data doesn't persist

**Solution:**
1. Verify ObjectBox initialized successfully (check console logs)
2. Check that database files exist in the expected location
3. Ensure the app isn't running in a sandboxed mode (check entitlements)

## Performance Testing

After verifying basic functionality, test performance:

1. **Create Multiple Entities**
   - Create 100+ tasks
   - Create 10+ teams
   - Create 20+ users

2. **Test Query Performance**
   - Search for tasks
   - Filter by category
   - Sort by different fields

3. **Monitor Resource Usage**
   - Open Activity Monitor
   - Monitor memory usage
   - Monitor CPU usage
   - Monitor disk I/O

## Expected Results

After completing these tests, you should see:

✅ ObjectBox initializes without errors
✅ Database files are created in `~/Library/Application Support/chingalo.family.task-flow/`
✅ Data persists after app restarts
✅ All CRUD operations work correctly
✅ No "Operation not permitted" errors
✅ App runs smoothly in both debug and release modes

## Reporting Issues

If you encounter any issues during testing:

1. **Collect Information**
   - macOS version: `sw_vers`
   - Flutter version: `flutter --version`
   - Error logs from console
   - Screenshots of any error messages

2. **Create a Detailed Report**
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Error logs
   - Screenshots

3. **Submit**
   - Comment on the PR
   - Or create a new issue on GitHub

## Success Criteria

The fix is successful if:

- ✅ No "Operation not permitted" errors occur
- ✅ ObjectBox initializes on both debug and release builds
- ✅ Database operations (create, read, update, delete) work correctly
- ✅ Data persists across app restarts
- ✅ No performance degradation
- ✅ No security warnings or alerts

---

**Last Updated**: January 2026
