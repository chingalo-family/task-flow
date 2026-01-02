import 'package:flutter/material.dart';
import 'package:task_flow/my_app.dart';

import 'package:task_flow/core/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Try to initialize ObjectBox, but don't fail if it's not available
  try {
    await DBService().init();
    print('✅ ObjectBox initialized successfully');
  } catch (e) {
    print('⚠️ ObjectBox initialization failed: $e');
    print('📱 App will run without offline database support');
  }
  
  runApp(const MyApp());
}
