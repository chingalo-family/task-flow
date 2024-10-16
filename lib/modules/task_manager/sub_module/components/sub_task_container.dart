import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/utils/app_modal_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/sub_task.dart';
import 'package:task_manager/models/task.dart';

import 'package:task_manager/models/user.dart';
import 'package:task_manager/modules/task_manager/helpers/sub_task_form_state_helper.dart';
import 'package:task_manager/modules/task_manager/models/sub_task_form.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/delete_sub_task_confirmation.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/sub_task_card.dart';
import 'package:task_manager/modules/task_manager/sub_module/components/sub_task_form_container.dart';

class SubTaskContainer extends StatefulWidget {
  const SubTaskContainer({
    super.key,
    required this.currentTask,
    required this.currentUser,
  });

  final Task currentTask;
  final User currentUser;

  @override
  State<SubTaskContainer> createState() => _SubTaskContainerState();
}

class _SubTaskContainerState extends State<SubTaskContainer> {
  final double initialHeightRatio = 0.45;
  onEditTodoTask(
    BuildContext context,
    SubTask subTask,
  ) async {
    SubTaskFormStateHelper.updateFormState(
        context, subTask, !subTask.isCompleted!);
    final List<FormSection> subTaskFormSections =
        SubTaskForm.getFormSections(AppContant.defaultAppColor);
    Widget modal = SubTaskFormContainer(
      subTaskFormSections: subTaskFormSections,
    );
    await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: modal,
      initialHeightRatio: initialHeightRatio,
    );
  }

  onDeleteTodoTask(
    BuildContext context,
    SubTask subTask,
  ) async {
    Widget modal = DeleteSubTaskConfirmation(
      subTask: subTask,
    );
    await AppModalUtil.showActionSheetModal(
      context: context,
      actionSheetContainer: modal,
      initialHeightRatio: initialHeightRatio,
    );
  }

  onUpdateTodoTaskStatus(
    BuildContext context,
    SubTask subTask,
    bool isCompleted,
  ) {
    subTask.isCompleted = isCompleted;
    subTask.completedOn =
        isCompleted ? DateTime.now().toString().split('.')[0] : '';
    subTask.completedBy = isCompleted ? widget.currentUser.fullName : 'default';
    Provider.of<TaskState>(context, listen: false).addSubTask(subTask);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Text(
              "${widget.currentTask.title}'s list of tasks",
              style: const TextStyle().copyWith(
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.currentTask.subTasks
                  .map(
                    (SubTask subTask) => Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: SubTaskCard(
                        subTask: subTask,
                        onEdit: () => onEditTodoTask(context, subTask),
                        onDelete: () => onDeleteTodoTask(context, subTask),
                        onUpdateTodoTaskStatus: (bool isCompleted) =>
                            onUpdateTodoTaskStatus(
                          context,
                          subTask,
                          isCompleted,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
