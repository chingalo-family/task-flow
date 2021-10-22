import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/task_state/sub_task_form_state.dart';
import 'package:task_manager/models/sub_task.dart';

class SubTaskFormStateHelper {
  //
  static updateFormState(
    BuildContext context,
    SubTask subTask,
    bool isEditableMode,
  ) {
    Provider.of<SubTaskFormState>(context, listen: false).resetFormState();
    Provider.of<SubTaskFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('id', subTask.id);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('taskId', subTask.taskId);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('title', subTask.title);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('isCompleted', subTask.isCompleted);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('createdOn', subTask.createdOn);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('createdBy', subTask.createdBy);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('assignedTo', subTask.assignedTo);
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState('dueDate', subTask.dueDate);
  }
}
