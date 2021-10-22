import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/modules/task_manager/task_manager_home.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

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
    AppThemeState appThemeState =
        Provider.of<AppThemeState>(context, listen: false);
    Timer(Duration(seconds: 1), () {
      ThemeServices.getCurrentTheme().then((theme) {
        appThemeState.setCurrentTheme(theme);
        Provider.of<TaskState>(context, listen: false).initiateTaskList();
        Provider.of<AppInfoState>(context, listen: false).setCurrentAppInfo();
        Timer(
          Duration(
            seconds: 2,
          ),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TaskMangerHome(),
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
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
                          Container(
                            height: size.height * 0.4,
                            width: size.width * 0.3,
                            child: SvgPicture.asset(
                              'assets/icons/todo-logo.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor: new AlwaysStoppedAnimation(
                              const Color(0xFF00BFA6),
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
