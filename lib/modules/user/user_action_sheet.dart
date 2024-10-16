import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/user/sub_module/user_module/components/sign_in_sign_up_form_container.dart';
import 'package:task_manager/modules/user/sub_module/user_module/components/user_profile_container.dart';

class UserActionSheet extends StatelessWidget {
  const UserActionSheet({
    super.key,
    required this.initialHeightRatio,
  });

  final double initialHeightRatio;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<UserState>(builder: (context, userState, child) {
      String usernameIcon = userState.usernameIcon;
      User user = userState.currrentUser;
      double heightRatio = user.isLogin ? initialHeightRatio : 1;
      return Consumer<UserGroupState>(
          builder: (context, userGroupState, child) {
        List<UserGroup> userGroups = userGroupState.currentUserGroups;
        return Container(
          margin: const EdgeInsets.only(
            top: 25.0,
          ),
          height: size.height * heightRatio,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
            children: [
              Visibility(
                visible: user.isLogin,
                child: UserProfileContainer(
                  size: size,
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
                  child: const SignInSignUpFormContainer(),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
