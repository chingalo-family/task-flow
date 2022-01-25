import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/sub_task.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/modules/task_manager/components/todo_form_container.dart';
import 'package:task_manager/modules/task_manager/helpers/sub_task_form_state_helper.dart';
import 'package:task_manager/modules/task_manager/helpers/task_form_state_helper.dart';
import 'package:task_manager/modules/task_manager/models/sub_task_form.dart';
import 'package:task_manager/modules/task_manager/models/task_form.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/delete_task_confirmation.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/sub_task_form_container.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/todo_view_container.dart';
import 'package:task_manager/modules/user/user_action_sheet.dart';

class TaskMangerView extends StatelessWidget {
  const TaskMangerView({Key? key}) : super(key: key);

  onAddSubTask(
    BuildContext context,
    Task currentTask,
    User currentUser,
  ) async {
    SubTask subTask = SubTask(taskId: currentTask.id, title: '', isCompleted: false);
    subTask.assignedTo = currentUser != null ? currentUser.id : AppContant.defaultUserId;
    subTask.createdBy = currentUser != null ? currentUser.fullName : '';
    SubTaskFormStateHelper.updateFormState(context, subTask, !subTask.isCompleted!);
    String currentTheme = Provider.of<AppThemeState>(context, listen: false).currentTheme;
    Color textColor = currentTheme == ThemeServices.darkTheme
        ? AppContant.darkTextColor
        : AppContant.ligthTextColor;
    final List<FormSection> subTaskFormSections = SubTaskForm.getFormSections(textColor);
    Widget modal = SubTaskFormContainer(
      subTaskFormSections: subTaskFormSections,
    );
    await AppUtil.showPopUpModal(context, modal, false);
  }

  onEditTask(BuildContext context, Task currentTask) async {
    bool isEditableMode = true;
    TaskFormStateHelper.updateFormState(
      context,
      currentTask,
      isEditableMode,
    );
    String currentTheme = Provider.of<AppThemeState>(context, listen: false).currentTheme;
    Color textColor = currentTheme == ThemeServices.darkTheme
        ? AppContant.darkTextColor
        : AppContant.ligthTextColor;
    final List<FormSection> taskFormSections = TaskForm.getFormSections(textColor);
    Widget modal = TaskFormContainer(
      taskFormSections: taskFormSections,
      subTasks: currentTask.subTasks,
    );
    await AppUtil.showPopUpModal(context, modal, false);
  }

  onDeleteTask(BuildContext context, Task currentTask) async {
    Widget modal = DeleteTaskConfirmation(
      currentTask: currentTask,
    );
    bool hasTodoDeleted = await AppUtil.showPopUpModal(context, modal, false);
    try {
      if (hasTodoDeleted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  onOpenUserActionSheet(BuildContext context) {
    double maxHeightRatio = 0.8;
    double initialHeightRatio = 0.45;
    AppUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: initialHeightRatio,
      maxHeightRatio: maxHeightRatio,
      containerBody: UserActionSheet(
        maxHeightRatio: maxHeightRatio,
      ),
    );
  }

  onOpenTodoChartSummary(BuildContext context, Task currentTask) {
    print('on opening todo chart $currentTask');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        return Consumer<TaskState>(
          builder: (context, todoState, child) {
            Task currentTask = todoState.currentTask!;
            return SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(AppContant.appBarHeight),
                  child: AppBarContainer(
                    title: currentTask.title!,
                    isAboutPage: false,
                    isAddVisible: true,
                    isViewChartVisible: true,
                    isDeleteVisible: true,
                    isEditVisible: true,
                    isUserVisible: true,
                    onOpenUserActionSheet: () => onOpenUserActionSheet(context),
                    onAdd: () => onAddSubTask(context, currentTask, userState.currrentUser),
                    onEdit: () => onEditTask(context, currentTask),
                    onDelete: () => onDeleteTask(context, currentTask),
                    onOpenChart: () => onOpenTodoChartSummary(context, currentTask),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    child: TaskViewContainer(
                      currentTask: currentTask,
                      onTapCurrentTask: () => onEditTask(context, currentTask),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
