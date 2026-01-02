import 'dart:io';
import 'package:flutter/services.dart';

class AppInstallerUtil {
  static const platform = MethodChannel(
    'com.chingalo.family.wealth_path_app/installer',
  );

  static Future<void> installApk(String filePath) async {
    if (Platform.isAndroid) {
      try {
        await platform.invokeMethod('installApk', {'filePath': filePath});
      } on PlatformException catch (e) {
        throw Exception('Failed to install APK: ${e.message}');
      }
    }
  }
}
