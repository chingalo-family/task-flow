import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:task_manager/app_state/task_state/sub_task_form_state.dart';
import 'package:task_manager/app_state/task_state/task_form_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/modules/splash/splash.dart';

class App extends StatelessWidget {
  final String title = 'Task Manager';

  @override
  Widget build(BuildContext context) {
    return buildApp();
  }

  MultiProvider buildApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoState()),
        ChangeNotifierProvider(create: (_) => DeviceConnectivityState()),
        ChangeNotifierProvider(create: (_) => AppThemeState()),
        ChangeNotifierProvider(create: (_) => SignInSignUpFormState()),
        ChangeNotifierProvider(create: (_) => TaskState()),
        ChangeNotifierProvider(create: (_) => TaskFormState()),
        ChangeNotifierProvider(create: (_) => SubTaskFormState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => UserGroupState()),
      ],
      child: Consumer<AppThemeState>(
        builder: (context, appThemeState, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appThemeState.currentTheme == ThemeServices.darkTheme
              ? ThemeData.dark().copyWith(
                  textTheme: GoogleFonts.robotoTextTheme(
                    Theme.of(context).textTheme,
                  ),
                )
              : ThemeData.light().copyWith(
                  textTheme: GoogleFonts.robotoTextTheme(
                    Theme.of(context).textTheme,
                  ),
                ),
          home: Splash(),
        ),
      ),
    );
  }
}
