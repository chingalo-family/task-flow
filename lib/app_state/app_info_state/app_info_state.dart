import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:task_flow/core/services/system_info_service.dart';

class AppInfoState extends ChangeNotifier {
  final SystemInfoService _service;

  AppInfoState({SystemInfoService? service})
    : _service = service ?? SystemInfoService();
  bool _loading = true;
  String _appName = '';
  String _packageName = '';
  String _version = '';
  String _buildNumber = '';

  String get appName => _appName;
  String get packageName => _packageName;
  String get version => _version;
  String get buildNumber => _buildNumber;
  bool get loading => _loading;

  void initiatizeAppInfo() async {
    _loading = true;
    notifyListeners();
    try {
      PackageInfo packageInfo = await _service.getPackageInfo();
      _packageName = packageInfo.packageName;
      _appName = packageInfo.appName;
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    } catch (e) {
      //
    }
    _loading = false;
    notifyListeners();
  }
}
