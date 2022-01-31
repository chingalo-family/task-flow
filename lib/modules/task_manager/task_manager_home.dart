import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/modules/task_manager/components/task_list_container.dart';
import 'package:task_manager/modules/task_manager/components/task_list_filter.dart';
import 'package:task_manager/modules/task_manager/components/todo_form_container.dart';
import 'package:task_manager/modules/task_manager/helpers/task_form_state_helper.dart';
import 'package:task_manager/modules/task_manager/models/task_form.dart';
import 'package:task_manager/modules/user/user_action_sheet.dart';

class TaskMangerHome extends StatelessWidget {
  const TaskMangerHome({Key? key}) : super(key: key);

  onAddTodo(
    BuildContext context,
    User? currentUser,
  ) async {
    Task task = new Task(title: '', description: '');
    task.assignedTo = currentUser != null ? currentUser.id : AppContant.defaultUserId;
    task.createdBy = currentUser != null ? currentUser.fullName : '';
    TaskFormStateHelper.updateFormState(context, task, true);
    String currentTheme = Provider.of<AppThemeState>(context, listen: false).currentTheme;
    Color textColor = currentTheme == ThemeServices.darkTheme
        ? AppContant.darkTextColor
        : AppContant.ligthTextColor;
    final List<FormSection> taskFormSections = TaskForm.getFormSections(textColor);
    Widget modal = TaskFormContainer(
      taskFormSections: taskFormSections,
      subTasks: task.subTasks,
    );
    await AppUtil.showPopUpModal(context, modal, false);
  }

  onOpenUserActionSheet(BuildContext context) async {
    User? user = Provider.of<UserState>(context, listen: false).currrentUser;
    double initialHeightRatio = 0.45;
    bool isLogin = user.isLogin;
    AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: initialHeightRatio,
      maxHeightRatio: isLogin ? initialHeightRatio : 0,
      containerBody: UserActionSheet(
        initialHeightRatio: initialHeightRatio,
      ),
    );
  }

  onOpenTodoListChartSummary(BuildContext context) {
    print('on opening todo list chart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppContant.appBarHeight),
        child: Consumer<UserState>(
          builder: (context, userState, child) {
            return AppBarContainer(
              title: 'Todo List',
              isAboutPage: false,
              isAddVisible: true,
              isViewChartVisible: true,
              isUserVisible: true,
              onOpenUserActionSheet: () => onOpenUserActionSheet(context),
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
