import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
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
    Key? key,
    required this.textColor,
    required this.currentTask,
    required this.currentUser,
  }) : super(key: key);

  final Color textColor;
  final Task currentTask;
  final User currentUser;

  @override
  _SubTaskContainerState createState() => _SubTaskContainerState();
}

class _SubTaskContainerState extends State<SubTaskContainer> {
  onEditTodoTask(
    BuildContext context,
    SubTask subTask,
  ) async {
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

  onDeleteTodoTask(
    BuildContext context,
    SubTask subTask,
  ) async {
    Widget modal = DeleteSubTaskConfirmation(
      subTask: subTask,
    );
    await AppUtil.showPopUpModal(context, modal, false);
  }

  onUpdateTodoTaskStatus(
    BuildContext context,
    SubTask subTask,
    bool isCompleted,
  ) {
    subTask.isCompleted = isCompleted;
    subTask.completedOn = isCompleted ? DateTime.now().toString().split('.')[0] : '';
    subTask.completedBy = isCompleted ? widget.currentUser.fullName : 'default';
    Provider.of<TaskState>(context, listen: false).addSubTask(subTask);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Text(
              "${widget.currentTask.title}'s list of tasks",
              style: TextStyle().copyWith(
                fontSize: 18.0,
                color: widget.textColor,
              ),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.currentTask.subTasks
                  .map(
                    (SubTask subTask) => Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: SubTaskCard(
                        textColor: widget.textColor,
                        subTask: subTask,
                        onEdit: () => onEditTodoTask(context, subTask),
                        onDelete: () => onDeleteTodoTask(context, subTask),
                        onUpdateTodoTaskStatus: (bool isCompleted) => onUpdateTodoTaskStatus(
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
