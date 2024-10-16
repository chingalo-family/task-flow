import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/user_group_service.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/task_manager/task_manager_home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setAppInitialData();
  }

  setAppInitialData() async {
    User? user = await UserService().getCurrentUser();
    await setLandingPage(user);
  }

  Future<void> setLandingPage(User? user) async {
    Provider.of<TaskState>(context, listen: false).initiateTaskList();
    Provider.of<AppInfoState>(context, listen: false).setCurrentAppInfo();
    if (user != null && user.isLogin) {
      List<UserGroup> userGroups =
          await UserGroupService().getUserGroupsByUserId(userId: user.id);
      _setUserGroupsInState(user, userGroups);
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

  void _setUserGroupsInState(User user, List<UserGroup> userGroups) {
    Provider.of<UserState>(context, listen: false).setCurrentUser(user);
    Provider.of<UserGroupState>(context, listen: false)
        .setCurrentUserGroups(userGroups);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(
                            AppContant.defaultAppColor,
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
    );
  }
}
