import 'package:flutter/foundation.dart';
import 'package:task_manager/core/constants/app_info_reference.dart';

class AppInfoState with ChangeNotifier {
  String? _currentAppName;
  String? _currentAppVersion;
  String? _currentAppId;
  bool? _canUpdate;

  String get currentAppName => _currentAppName ?? '';
  bool get canUpdate => _canUpdate ?? false;
  String get currentAppVersion => _currentAppVersion ?? '';
  String get currentAppId => _currentAppId ?? '';

  void setCurrentAppInfo() async {
    _currentAppId = AppInfoReference.androidId;
    _currentAppName = AppInfoReference.currentAppName;
    _currentAppVersion = AppInfoReference.currentAppVersion;
    notifyListeners();
  }
}
