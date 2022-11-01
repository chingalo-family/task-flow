import 'package:flutter/material.dart';
import 'package:task_manager/core/components/input_fields/input_field_container.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/input_field.dart';

class EntrySubFormContainer extends StatelessWidget {
  const EntrySubFormContainer({
    Key? key,
    required this.subSections,
    required this.dataObject,
    required this.mandatoryFieldObject,
    required this.hiddenInputFieldOptions,
    this.isEditableMode = true,
    this.onInputValueChange,
    this.hiddenFields,
    this.hiddenSections,
    this.unFilledMandatoryFields,
  }) : super(key: key);

  final List<FormSection>? subSections;
  final Function? onInputValueChange;
  final Map? dataObject;
  final Map? mandatoryFieldObject;
  final Map? hiddenFields;
  final Map? hiddenSections;
  final Map hiddenInputFieldOptions;
  final bool isEditableMode;
  final List? unFilledMandatoryFields;

  void setFieldErrors() {
    if (unFilledMandatoryFields != null &&
        unFilledMandatoryFields!.isNotEmpty) {
      for (var section in subSections!) {
        for (var inputField in section.inputFields!) {
          if (unFilledMandatoryFields!.contains(inputField.id)) {
            inputField.hasError = true;
          } else {
            inputField.hasError = false;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setFieldErrors();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: subSections!
          .map(
            (FormSection subSection) => Visibility(
              visible: hiddenSections == null ||
                  '${hiddenSections![subSection.id]}'.trim() != 'true',
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: subSection.name != '' ? 5.0 : 0.0),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: subSection.borderColor!, width: 8.0)),
                    color: subSection.backgroundColor),
                child: Column(
                  children: [
                    Visibility(
                      visible: subSection.name != '',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                subSection.name,
                                style: const TextStyle().copyWith(
                                    color: subSection.color,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: subSection.description != '',
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                subSection.description!,
                                style: const TextStyle().copyWith(
                                    color: subSection.color,
                                    fontSize: 14.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: subSection.inputFields!
                          .map(
                            (InputField inputField) => Visibility(
                              visible: hiddenFields == null ||
                                  '${hiddenFields![inputField.id]}'.trim() !=
                                      'true',
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: inputField.background ==
                                          Colors.transparent
                                      ? 10.0
                                      : 0.0,
                                ),
                                child: InputFieldContainer(
                                  inputField: inputField,
                                  hiddenFields: hiddenFields,
                                  isEditableMode: isEditableMode,
                                  mandatoryFieldObject: mandatoryFieldObject,
                                  hiddenInputFieldOptions:
                                      hiddenInputFieldOptions,
                                  dataObject: dataObject,
                                  onInputValueChange:
                                      (String id, dynamic value) =>
                                          onInputValueChange!(id, value),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    EntrySubFormContainer(
                      hiddenFields: hiddenFields,
                      hiddenInputFieldOptions: hiddenInputFieldOptions,
                      hiddenSections: hiddenSections,
                      subSections: subSection.subSections,
                      dataObject: dataObject,
                      mandatoryFieldObject: mandatoryFieldObject,
                      onInputValueChange: onInputValueChange,
                      unFilledMandatoryFields: unFilledMandatoryFields,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
