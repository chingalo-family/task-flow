import 'package:flutter/material.dart';
import 'package:task_flow/my_app.dart';

import 'package:task_flow/core/services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService().init();
  runApp(const MyApp());
}
