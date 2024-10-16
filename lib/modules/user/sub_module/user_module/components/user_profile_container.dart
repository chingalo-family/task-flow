import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/components/line_separator.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/user/sub_module/user_group_module/user_group_manager.dart';

class UserProfileContainer extends StatelessWidget {
  const UserProfileContainer({
    super.key,
    required this.size,
    required this.usernameIcon,
    required this.user,
    required this.userGroups,
  });

  final Size size;
  final String usernameIcon;
  final User user;
  final List<UserGroup> userGroups;

  TextButton _getAcctionButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return TextButton(
      onPressed: onTap,
      child: MaterialCard(
        elevation: 0.5,
        borderRadius: 5.0,
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Text(
            title,
            style: const TextStyle().copyWith(),
          ),
        ),
      ),
    );
  }

  void onUpdateProfile(BuildContext context) {
    AppUtil.showToastMessage(message: 'On update profile');
  }

  void onViewAndManageUserGroup(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserGroupManager(),
      ),
    );
  }

  void onLogOut(BuildContext context) async {
    try {
      await UserService().logout();
      AppUtil.showToastMessage(
        message: 'You have uccessfully log out',
      );
      Provider.of<UserState>(context, listen: false).resetCurrentUser();
      Provider.of<UserGroupState>(context, listen: false)
          .resetCurrentUserGroups();
      Navigator.pop(context);
    } catch (error) {
      AppUtil.showToastMessage(
        message: 'Fail to log out :: ${error.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 5.0,
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: size.height * 0.05,
            backgroundColor: AppContant.defaultAppColor.withOpacity(0.3),
            child: Text(
              usernameIcon,
              style: const TextStyle().copyWith(
                fontSize: 20.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 20.0,
            ),
            child: Text(
              user.fullName,
              style: const TextStyle().copyWith(
                fontSize: 20.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 20.0,
            ),
            child: Text(
              user.email!,
              style: const TextStyle().copyWith(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 20.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _getAcctionButton(
                    title: 'Update Profile',
                    onTap: () => onUpdateProfile(context),
                  ),
                ),
                Expanded(
                  child: _getAcctionButton(
                    title: 'Log out',
                    onTap: () => onLogOut(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: LineSeparator(
              color: AppContant.defaultAppColor.withOpacity(0.5),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: ListTile(
              iconColor: AppContant.defaultAppColor,
              title: Text('Assinged Groups ${userGroups.length}'),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () => onViewAndManageUserGroup(context),
            ),
          ),
        ],
      ),
    );
  }
}
