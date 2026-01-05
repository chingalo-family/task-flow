# ObjectBox Code Generation Required

## Important: Run Build Runner

After the recent changes to `TaskEntity`, you need to regenerate the ObjectBox code.

### Run this command:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or if using dart directly:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Changes Made to TaskEntity

The following fields were added to support the enhanced task module:

1. `String? category` - Task category
2. `String? assignedUserIdsJson` - JSON array of assigned user IDs for multiple assignees
3. `String? teamId` - Team this task belongs to
4. `String? teamName` - Team name
5. `String? subtasksJson` - JSON array of subtasks
6. `bool? remindMe` - Reminder flag

These fields need to be reflected in the generated `objectbox.g.dart` file.

## After Running Build Runner

Once the build runner completes:
1. The `objectbox.g.dart` file will be updated with the new fields
2. The `objectbox-model.json` will include the new properties
3. The app will be able to properly persist and retrieve all task data

## Files Modified

- `lib/core/entities/task_entity.dart` - Added new fields
- `lib/app_state/task_state/task_state.dart` - Implemented ObjectBox CRUD operations
- `lib/core/utils/task_entity_mapper.dart` - Created mapper utility
- `lib/core/constants/task_constants.dart` - Created constants file

## Note

The build runner command was not available in the CI environment, so this step needs to be performed locally or in the deployment environment.
