import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/components/app_drawer_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/modules/task_manager/components/task_list_container.dart';
import 'package:task_manager/modules/task_manager/components/task_list_filter.dart';

class TaskMangerHome extends StatelessWidget {
  const TaskMangerHome({Key? key}) : super(key: key);

  onAddTodo(
    BuildContext context,
    User? currentUser,
  ) async {
    String currentTheme =
        Provider.of<AppThemeState>(context, listen: false).currentTheme;
    Color textColor = currentTheme == ThemeServices.darkTheme
        ? AppContant.darkTextColor
        : AppContant.ligthTextColor;
    Widget modal = Container(
      child: Text(
        'Yeah on add',
        style: TextStyle().copyWith(color: textColor),
      ),
    );
    await AppUtil.showPopUpModal(context, modal, false);
  }

  onOpenTodoListChartSummary(BuildContext context) {
    print('on opening todo list chart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerContainer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppContant.appBarHeight),
        child: Consumer<UserState>(
          builder: (context, userState, child) {
            return AppBarContainer(
              title: 'Todo List',
              isAboutPage: false,
              isAddVisible: true,
              isViewChartVisible: true,
              onAdd: () => onAddTodo(context, userState.currrentUser),
              onOpenChart: () => onOpenTodoListChartSummary(context),
            );
          },
        ),
      ),
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppContant.todoListFilterHeight),
          child: TaskListFilter(),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: TaskListContainer(),
          ),
        ),
      ),
    );
  }
}
