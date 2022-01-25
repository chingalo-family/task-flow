import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/user.dart';

class UserActionSheet extends StatelessWidget {
  const UserActionSheet({
    Key? key,
    required this.maxHeightRatio,
  }) : super(key: key);

  final double maxHeightRatio;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AppThemeState>(builder: (context, appThemeState, child) {
      String currentTheme = appThemeState.currentTheme;
      return Consumer<UserState>(builder: (context, userState, child) {
        String usernameIcon = userState.usernameIcon;
        User user = userState.currrentUser;
        return Container(
          height: size.height * this.maxHeightRatio,
          decoration: BoxDecoration(
            color: currentTheme == ThemeServices.darkTheme
                ? AppContant.darkThemeColor
                : AppContant.lightThemeColor,
          ),
        );
      });
    });
  }
}
