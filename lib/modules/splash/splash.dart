import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/services/user_group_service.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/task_manager/task_manager_home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setAppThemeAndInitialData(context);
  }

  setAppThemeAndInitialData(BuildContext context) async {
    User? user = await UserService().getCurrentUser();
    AppThemeState appThemeState =
        Provider.of<AppThemeState>(context, listen: false);
    String theme = await ThemeServices.getCurrentTheme();
    appThemeState.setCurrentTheme(theme);
    Provider.of<TaskState>(context, listen: false).initiateTaskList();
    Provider.of<AppInfoState>(context, listen: false).setCurrentAppInfo();
    if (user != null && user.isLogin) {
      List<UserGroup> userGroups =
          await UserGroupService().getUserGroupsByUserId(userId: user.id);
      Provider.of<UserState>(context, listen: false).setCurrentUser(user);
      Provider.of<UserGroupState>(context, listen: false)
          .setCurrentUserGroups(userGroups);
    }
    Timer(
      const Duration(
        seconds: 2,
      ),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TaskMangerHome(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.4,
                            width: size.width * 0.3,
                            child: Image.asset(
                              'assets/img/app-icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFF00BFA6),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
