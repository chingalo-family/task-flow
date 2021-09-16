import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/modules/Home/home.dart';

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
          home: Home(),
        ),
      ),
    );
  }
}
