import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/task_state/sub_task_form_state.dart';
import 'package:task_manager/app_state/task_state/task_form_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/modules/splash/splash.dart';

class App extends StatelessWidget {
  final String title = 'chingalo todo app';

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return buildApp();
  }

  MultiProvider buildApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppInfoState()),
        ChangeNotifierProvider(create: (_) => SignInSignUpFormState()),
        ChangeNotifierProvider(create: (_) => TaskState()),
        ChangeNotifierProvider(create: (_) => TaskFormState()),
        ChangeNotifierProvider(create: (_) => SubTaskFormState()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => UserGroupState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppContant.defaultAppColor,
          ),
          useMaterial3: true,
        ),
        home: Splash(),
      ),
    );
  }
}
