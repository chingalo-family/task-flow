import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/task_state/task_form_state.dart';
import 'package:task_manager/models/task.dart';

class TaskFormStateHelper {
  static updateFormState(
    BuildContext context,
    Task task,
    bool isEditableMode,
  ) {
    Provider.of<TaskFormState>(context, listen: false).resetFormState();
    Provider.of<TaskFormState>(context, listen: false)
        .updateFormEditabilityState(isEditableMode: isEditableMode);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('id', task.id);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('title', task.title);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('description', task.description);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('assignedTo', task.assignedTo);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('createdBy', task.createdBy);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('createdOn', task.createdOn);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('dueDate', task.dueDate);
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState('groupId', task.groupId);
  }
}
