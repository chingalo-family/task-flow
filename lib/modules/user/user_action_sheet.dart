import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/user/components/user_profile_container.dart';

import 'components/sign_in_sign_up_form_container.dart';

class UserActionSheet extends StatelessWidget {
  const UserActionSheet({
    Key? key,
    required this.initialHeightRatio,
  }) : super(key: key);

  final double initialHeightRatio;

  onSignInOrSignOut(BuildContext context, User user) {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AppThemeState>(builder: (context, appThemeState, child) {
      String currentTheme = appThemeState.currentTheme;
      return Consumer<UserState>(builder: (context, userState, child) {
        String usernameIcon = userState.usernameIcon;
        User user = userState.currrentUser;
        double heightRatio = user.isLogin ? initialHeightRatio : 1;
        return Consumer<UserGroupState>(builder: (context, userGroupState, child) {
          List<UserGroup> userGroups = userGroupState.currentUserGroups;
          return Container(
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            height: size.height * heightRatio,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              color: currentTheme == ThemeServices.darkTheme
                  ? AppContant.darkBackgoundColor
                  : AppContant.lightBackgroundColor,
            ),
            child: Column(
              children: [
                Visibility(
                  visible: user.isLogin,
                  child: UserProfileContainer(
                    size: size,
                    currentTheme: currentTheme,
                    usernameIcon: usernameIcon,
                    user: user,
                    userGroups: userGroups,
                  ),
                ),
                Visibility(
                  visible: !user.isLogin,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    child: SignInSignUpFormContainer(),
                  ),
                ),
              ],
            ),
          );
        });
      });
    });
  }
}
