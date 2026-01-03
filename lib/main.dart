import 'package:flutter/material.dart';
import 'package:task_flow/my_app.dart';

import 'package:task_flow/core/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize ObjectBox, but don't fail if it's not available
  try {
    await DBService().init();
    debugPrint('✅ ObjectBox initialized successfully');
  } catch (e) {
    debugPrint('⚠️ ObjectBox initialization failed: $e');
    debugPrint('📱 App will run without offline database support');
  }

  runApp(const MyApp());
}
