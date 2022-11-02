import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/task_state/sub_task_form_state.dart';
import 'package:task_manager/app_state/task_state/task_state.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/sub_task.dart';

class SubTaskFormContainer extends StatelessWidget {
  const SubTaskFormContainer({
    Key? key,
    required this.subTaskFormSections,
  }) : super(key: key);

  final List<FormSection> subTaskFormSections;

  onInputValueChange(BuildContext context, String id, dynamic value) {
    Provider.of<SubTaskFormState>(context, listen: false)
        .setFormFieldState(id, value);
  }

  onSaveTodoTaskForm(
    BuildContext context,
    Map mandatoryFieldObject,
  ) {
    try {
      List mandatoryFields = mandatoryFieldObject.keys.toList();
      Map dataObject =
          Provider.of<SubTaskFormState>(context, listen: false).formState;
      bool isMandatoryFieldsSet =
          AppUtil.hasAllMandatoryFieldsFilled(mandatoryFields, dataObject);
      if (isMandatoryFieldsSet) {
        Provider.of<TaskState>(context, listen: false)
            .addSubTask(SubTask.fromMap(dataObject));
        AppUtil.showToastMessage(
          message: 'Task has been save successfully',
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
        message: 'Errror on saving task : $errorMessage',
        position: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map mandatoryFieldObject = {};
    mandatoryFieldObject['title'] = true;
    return Consumer<SubTaskFormState>(
      builder: (context, subTaskFormState, child) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(),
                child: EntryFormContainer(
                  elevation: 0.0,
                  isEditableMode: subTaskFormState.isEditableMode,
                  formSections: subTaskFormSections,
                  dataObject: subTaskFormState.formState,
                  hiddenFields: subTaskFormState.hiddenFields,
                  hiddenSections: subTaskFormState.hiddenSections,
                  mandatoryFieldObject: mandatoryFieldObject,
                  onInputValueChange: (id, value) =>
                      onInputValueChange(context, id, value),
                ),
              ),
              Visibility(
                visible: subTaskFormState.isEditableMode,
                child: Container(
                  margin: const EdgeInsets.symmetric(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Center(
                            child: TextButton(
                              onPressed: () => onSaveTodoTaskForm(
                                context,
                                mandatoryFieldObject,
                              ),
                              child: Text(
                                'Save',
                                style: const TextStyle().copyWith(),
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
  }
}
