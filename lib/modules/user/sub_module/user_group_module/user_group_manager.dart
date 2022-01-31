import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_group_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/user/sub_module/user_group_module/conponent/user_group_list_container.dart';

class UserGroupManager extends StatelessWidget {
  const UserGroupManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppContant.appBarHeight),
          child: AppBarContainer(
            title: 'User Group Management',
            isAboutPage: false,
            isAddVisible: false,
            isViewChartVisible: false,
            isDeleteVisible: false,
            isEditVisible: false,
            isUserVisible: false,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: Consumer<AppThemeState>(builder: (context, appThemeState, child) {
              String currentTheme = appThemeState.currentTheme;
              return Consumer<UserGroupState>(builder: (context, userGroupState, child) {
                List<UserGroup> userGroups = userGroupState.currentUserGroups;
                return Column(
                  children: [
                    Container(
                      child: MaterialCard(
                        body: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.symmetric(
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
