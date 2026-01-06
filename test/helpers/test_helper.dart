import 'package:mockito/annotations.dart';
import 'package:task_flow/core/services/user_service.dart';
import 'package:task_flow/core/services/task_service.dart';
import 'package:task_flow/core/services/team_service.dart';
import 'package:task_flow/core/services/notification_service.dart';
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/system_info_service.dart';

@GenerateMocks([
  UserService,
  TaskService,
  TeamService,
  NotificationService,
  PreferenceService,
  SystemInfoService,
])
void main() {}
