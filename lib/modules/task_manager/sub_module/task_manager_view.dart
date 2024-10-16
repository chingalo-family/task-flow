import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/components/app_bar_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/utils/app_modal_util.dart';
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
  const TaskMangerView({super.key});

  final double initialHeightRatio = 0.45;

  onAddSubTask(
    BuildContext context,
    Task currentTask,
    User currentUser,
  ) async {
    SubTask subTask =
        SubTask(taskId: currentTask.id, title: '', isCompleted: false);
    subTask.assignedTo =
        currentUser.isLogin ? currentUser.id : AppContant.defaultUserId;
    subTask.createdBy = currentUser.isLogin ? currentUser.fullName : '';
    SubTaskFormStateHelper.updateFormState(
        context, subTask, !subTask.isCompleted!);
    final List<FormSection> subTaskFormSections =
        SubTaskForm.getFormSections(AppContant.defaultAppColor);
    Widget modal = SubTaskFormContainer(
      subTaskFormSections: subTaskFormSections,
    );
    double initialHeightRatio = 0.45;
    AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: modal,
      initialHeightRatio: initialHeightRatio,
    );
  }

  onEditTask(BuildContext context, Task currentTask) async {
    bool isEditableMode = true;
    TaskFormStateHelper.updateFormState(
      context,
      currentTask,
      isEditableMode,
    );
    final List<FormSection> taskFormSections =
        TaskForm.getFormSections(AppContant.defaultAppColor);
    Widget modal = TaskFormContainer(
      taskFormSections: taskFormSections,
      subTasks: currentTask.subTasks,
    );
    await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: modal,
      initialHeightRatio: initialHeightRatio,
    );
  }

  onDeleteTask(BuildContext context, Task currentTask) async {
    Widget modal = DeleteTaskConfirmation(
      currentTask: currentTask,
    );
    await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: modal,
      initialHeightRatio: initialHeightRatio,
    );
  }

  onOpenUserActionSheet(BuildContext context) async {
    User? user = Provider.of<UserState>(context, listen: false).currrentUser;
    double initialHeightRatio = 0.45;
    bool isLogin = user.isLogin;
    AppModalUtil.showActionSheetModal(
      context: context,
      initialHeightRatio: initialHeightRatio,
      maxHeightRatio: isLogin ? initialHeightRatio : 0,
      actionSheetContainer: UserActionSheet(
        initialHeightRatio: initialHeightRatio,
      ),
    );
  }

  onOpenTodoChartSummary(BuildContext context, Task currentTask) {
    debugPrint('on opening todo chart $currentTask');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        return Consumer<TaskState>(
          builder: (context, todoState, child) {
            Task? currentTask = todoState.currentTask;
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(AppContant.appBarHeight),
                child: AppBarContainer(
                  title: currentTask?.title ?? '',
                  isAboutPage: false,
                  isAddVisible: true,
                  isViewChartVisible: true,
                  isDeleteVisible: true,
                  isEditVisible: true,
                  isUserVisible: false,
                  onOpenUserActionSheet: () => onOpenUserActionSheet(context),
                  onAdd: () => onAddSubTask(
                      context, currentTask!, userState.currrentUser),
                  onEdit: () => onEditTask(context, currentTask!),
                  onDelete: () => onDeleteTask(context, currentTask!),
                  onOpenChart: () =>
                      onOpenTodoChartSummary(context, currentTask!),
                ),
              ),
              body: SingleChildScrollView(
                child: currentTask != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: TaskViewContainer(
                          currentTask: currentTask,
                          onTapCurrentTask: () =>
                              onEditTask(context, currentTask),
                        ),
                      )
                    : Container(),
              ),
            );
          },
        );
      },
    );
  }
}
