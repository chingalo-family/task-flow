# task_manager

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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
