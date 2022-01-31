import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/modules/user/user_action_sheet.dart';

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
            child: Container(),
          ),
        ),
      ),
    );
  }
}
