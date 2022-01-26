import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/user.dart';

import 'components/sign_in_sign_up_form_container.dart';

class UserActionSheet extends StatelessWidget {
  const UserActionSheet({
    Key? key,
  }) : super(key: key);

  onSignInOrSignOut(BuildContext context, User user) {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AppThemeState>(builder: (context, appThemeState, child) {
      String currentTheme = appThemeState.currentTheme;
      return Consumer<UserState>(builder: (context, userState, child) {
        String usernameIcon = userState.usernameIcon;
        User user = userState.currrentUser;
        return Container(
          height: size.height,
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
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    bottom: 5.0,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: size.height * 0.05,
                        backgroundColor: currentTheme == ThemeServices.darkTheme
                            ? AppContant.darkThemeColor
                            : AppContant.darkTextColor,
                        child: Text(
                          usernameIcon,
                          style: TextStyle().copyWith(
                            color: currentTheme == ThemeServices.darkTheme
                                ? AppContant.darkTextColor
                                : AppContant.ligthTextColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Container(
                        child: Text('user container',
                            style: TextStyle().copyWith(
                              color: currentTheme == ThemeServices.darkTheme
                                  ? AppContant.darkTextColor
                                  : AppContant.ligthTextColor,
                              fontSize: 20.0,
                            )),
                      )
                    ],
                  ),
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
  }
}
