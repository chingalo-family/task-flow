import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/user/sub_module/user_group_module/conponent/user_group_list_container.dart';

class UserGroupManager extends StatelessWidget {
  const UserGroupManager({Key? key}) : super(key: key);

  onAddUserGroupMember(BuildContext context, UserGroup userGroup) {
    AppUtil.showToastMessage(message: 'Add user on $userGroup');
  }

  onAddUserGroup(BuildContext context) {
    AppUtil.showToastMessage(message: 'On add user group');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(AppContant.appBarHeight),
          child: AppBarContainer(
            title: 'User Group Management',
            isAboutPage: false,
            isAddVisible: true,
            isViewChartVisible: false,
            isDeleteVisible: false,
            isEditVisible: false,
            isUserVisible: false,
            onAdd: () => onAddUserGroup(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: Consumer<AppThemeState>(
                builder: (context, appThemeState, child) {
              String currentTheme = appThemeState.currentTheme;
              return Consumer<UserGroupState>(
                  builder: (context, userGroupState, child) {
                List<UserGroup> userGroups = userGroupState.currentUserGroups;
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: MaterialCard(
                        borderRadius: 6.0,
                        body: Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          child: Text(
                            'Search field',
                            style: const TextStyle().copyWith(
                              color: currentTheme == ThemeServices.darkTheme
                                  ? AppContant.darkTextColor
                                  : AppContant.ligthTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...userGroups
                        .where((UserGroup userGroup) {
                          //@TODO  add support for hahndling search
                          return true;
                        })
                        .map(
                          (UserGroup userGroup) => UserGroupListContainer(
                            currentTheme: currentTheme,
                            userGroup: userGroup,
                            onAddUser: () =>
                                onAddUserGroupMember(context, userGroup),
                          ),
                        )
                        .toList()
                  ],
                );
              });
            }),
          ),
        ),
      ),
    );
  }
}
