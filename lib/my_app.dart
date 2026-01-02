import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/app_state/task_state/task_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/splash/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => TaskState()),
      ],
      child: MaterialApp(
        title: 'Task Flow',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppConstant.darkBackground,
          colorScheme: ColorScheme.dark(
            primary: AppConstant.primaryBlue,
            secondary: AppConstant.primaryBlue,
            surface: AppConstant.cardBackground,
            background: AppConstant.darkBackground,
            error: AppConstant.errorRed,
          ),
          cardTheme: CardTheme(
            color: AppConstant.cardBackground,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstant.borderRadius16),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstant.darkBackground,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: AppConstant.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppConstant.textPrimary,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppConstant.textPrimary,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: AppConstant.textPrimary,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: AppConstant.textSecondary,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              ),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppConstant.cardBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        home: Splash(),
      ),
    );
  }
}
