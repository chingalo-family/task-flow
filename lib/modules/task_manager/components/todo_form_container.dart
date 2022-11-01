import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/task_state/task_form_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/sub_task.dart';
import 'package:task_manager/models/task.dart';

class TaskFormContainer extends StatelessWidget {
  const TaskFormContainer({
    Key? key,
    required this.taskFormSections,
    required this.subTasks,
  }) : super(key: key);

  final List<FormSection> taskFormSections;
  final List<SubTask> subTasks;

  onInputValueChange(BuildContext context, String id, dynamic value) {
    Provider.of<TaskFormState>(context, listen: false)
        .setFormFieldState(id, value);
  }

  onSaveTodoForm(
    BuildContext context,
    Map mandatoryFieldObject,
  ) {
    try {
      List mandatoryFields = mandatoryFieldObject.keys.toList();
      Map dataObject =
          Provider.of<TaskFormState>(context, listen: false).formState;
      bool isMandatoryFieldsSet =
          AppUtil.hasAllMandatoryFieldsFilled(mandatoryFields, dataObject);
      if (isMandatoryFieldsSet) {
        Task task = Task.fromMap(dataObject);
        task.subTasks = subTasks;
        Provider.of<TaskState>(context, listen: false).addTodo(task);
        AppUtil.showToastMessage(
          message: 'Todo has been save successfully',
          position: ToastGravity.SNACKBAR,
        );
        Navigator.of(context).pop();
      } else {
        AppUtil.showToastMessage(
          message: 'Please fill all mandatory fields',
          position: ToastGravity.TOP,
        );
      }
    } catch (error) {
      String errorMessage = error.toString();
      AppUtil.showToastMessage(
        message: 'Errror on saving Todo : $errorMessage',
        position: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map mandatoryFieldObject = {};
    mandatoryFieldObject['title'] = true;
    return Consumer<TaskFormState>(
      builder: (context, taskFormState, child) {
        return Consumer<AppThemeState>(
          builder: (context, appThemeState, child) {
            String currentTheme = appThemeState.currentTheme;
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: EntryFormContainer(
                      elevation: 0.0,
                      isEditableMode: taskFormState.isEditableMode,
                      formSections: taskFormSections,
                      dataObject: taskFormState.formState,
                      hiddenFields: taskFormState.hiddenFields,
                      hiddenSections: taskFormState.hiddenSections,
                      mandatoryFieldObject: mandatoryFieldObject,
                      onInputValueChange: (id, value) =>
                          onInputValueChange(context, id, value),
                    ),
                  ),
                  Visibility(
                    visible: taskFormState.isEditableMode,
                    child: Container(
                      margin: const EdgeInsets.symmetric(),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancel',
                                    style: const TextStyle().copyWith(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () => onSaveTodoForm(
                                    context,
                                    mandatoryFieldObject,
                                  ),
                                  child: Text(
                                    'Save',
                                    style: const TextStyle().copyWith(
                                      color: currentTheme ==
                                              ThemeServices.darkTheme
                                          ? AppContant.darkTextColor
                                          : AppContant.ligthTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
