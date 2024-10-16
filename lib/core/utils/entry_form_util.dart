import 'dart:convert';

import 'package:dhis2_dart_utils/dhis2_dart_utils.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field_option.dart';
import 'package:task_manager/core/constants/app_sync_status.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';

class EntryFormUtil {
  static Dhis2Event getDhis2EventPayLoad({
    required Map dataObject,
    required List<String> dataElementIds,
    required program,
    required programStage,
    required orgUnit,
  }) {
    String event = dataObject['event'] ?? AppUtil.getUid();
    String eventDate = dataObject['eventDate'] ??
        AppUtil.formattedDateTimeIntoString(DateTime.now());
    String storedBy = dataObject['storedBy'] ?? '';
    String completedDate = dataObject['completedDate'] ?? '';
    String status = dataObject['status'] ?? 'COMPLETED';
    completedDate = completedDate.isNotEmpty
        ? completedDate
        : AppUtil.formattedDateTimeIntoString(DateTime.now());
    List<String> keys =
        dataObject.keys.toSet().toList().map((key) => '$key').toList();
    String dataValues = dataElementIds
        .where((id) => keys.contains(id))
        .toSet()
        .toList()
        .where((dataElement) => !['eventDate'].contains(dataElement))
        .toList()
        .map((String dataElement) {
          String value = '${dataObject[dataElement]}';
          return dataElement != ''
              ? '{"dataElement": "$dataElement", "value": "$value"}'
              : '';
        })
        .toList()
        .join(',');
    dynamic eventJson =
        '{"event" : "$event", "storedBy":"$storedBy","completedDate":"$completedDate", "eventDate":"$eventDate", "program":"$program", "programStage":"$programStage", "status":"$status", "orgUnit":"$orgUnit", "syncStatus":"${AppSyncStatus.notSynced}", "dataValues":[$dataValues] }';
    return Dhis2Event.fromJson(json.decode(eventJson));
  }

  static List<String> getInputFieldIds(List<FormSection> formSections) {
    List<String> ids = [];
    for (FormSection formSection in formSections) {
      if (formSection.inputFields!.isNotEmpty) {
        ids.addAll(
          formSection.inputFields!
              .map((InputField inputField) => inputField.id)
              .toList(),
        );
      }
      if (formSection.subSections!.isNotEmpty) {
        ids.addAll(getInputFieldIds(formSection.subSections!));
      }
    }
    return ids.toSet().toList().where((id) => id.isNotEmpty).toList();
  }

  static isEmailValid(String email) {
    return email.isEmpty
        ? true
        : RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(email);
  }

  static isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.isEmpty
        ? true
        : RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(phoneNumber);
  }

  static isPasswordValid(String password) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$%\^&\*~\+\-\=\_\?\.]).{8,}$')
        .hasMatch(password);
  }

  static List<InputField> getInputFieldByValueType({
    required String valueType,
    required List<FormSection> formSections,
  }) {
    List<InputField> inputFields = [];
    for (FormSection formSection in formSections) {
      if (formSection.inputFields!.isNotEmpty) {
        inputFields.addAll(formSection.inputFields!
            .where((InputField inputField) => inputField.valueType == valueType)
            .toList());
      }
      if (formSection.subSections!.isNotEmpty) {
        inputFields.addAll(getInputFieldByValueType(
          valueType: valueType,
          formSections: formSection.subSections!,
        ));
      }
    }
    return inputFields;
  }

  static bool hasAllMandatoryFieldsFilled(
    List mandatoryFields,
    Map dataDynamic, {
    required List<InputField> checkBoxInputFields,
    required Map hiddenFields,
  }) {
    bool hasMandoryFieldCheckPass = true;
    List inputFieldWithData = dataDynamic.keys.toList();
    List hiddenFieldsIds = hiddenFields.keys.toList();
    List checkBoxInputFieldIds = checkBoxInputFields
        .map((InputField inputField) => inputField.id)
        .toSet()
        .toList();
    List filteredMandatoryFields = mandatoryFields
        .where((field) => !hiddenFieldsIds.contains(field))
        .toList();
    for (var mandatoryField in filteredMandatoryFields) {
      if (!inputFieldWithData.contains(mandatoryField)) {
        if (checkBoxInputFieldIds.contains(mandatoryField)) {
          bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
            checkBoxInputFields
                .where(
                    (InputField inputField) => inputField.id == mandatoryField)
                .toList(),
            dataDynamic,
          );
          if (!hasAtLeastOneInputFieldFilled) {
            hasMandoryFieldCheckPass = false;
          }
        } else {
          hasMandoryFieldCheckPass = false;
        }
      } else {
        if ('${dataDynamic[mandatoryField]}'.trim() == '' ||
            '${dataDynamic[mandatoryField]}'.trim() == 'null') {
          if (checkBoxInputFieldIds.contains(mandatoryField)) {
            bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
              checkBoxInputFields
                  .where((InputField inputField) =>
                      inputField.id == mandatoryField)
                  .toList(),
              dataDynamic,
            );
            if (!hasAtLeastOneInputFieldFilled) {
              hasMandoryFieldCheckPass = false;
            }
          } else {
            hasMandoryFieldCheckPass = false;
          }
        }
      }
    }
    return hasMandoryFieldCheckPass;
  }

  static bool isAtLeastOneCheckBoxTicked(
    List<InputField> checkBoxInputFields,
    Map dataDynamic,
  ) {
    bool hasAtLeastOneInputFieldFilled = false;
    List<String> ids = [];
    for (InputField inputField in checkBoxInputFields) {
      for (InputFieldOption option in inputField.options ?? []) {
        ids.add(option.code);
      }
    }
    for (String key in dataDynamic.keys.where((key) => ids.contains(key))) {
      dynamic value = dataDynamic[key];
      if ('$value'.trim().isNotEmpty && '$value'.trim() != 'null') {
        hasAtLeastOneInputFieldFilled = true;
      }
    }
    return hasAtLeastOneInputFieldFilled;
  }

  static List getUnFilledMandatoryFields(
    List mandatoryFields,
    Map dataDynamic, {
    required List<InputField> checkBoxInputFields,
    required Map hiddenFields,
  }) {
    List unFilledMandatoryFields = [];
    List fieldIds = dataDynamic.keys.toList();
    List hiddenFieldsIds = hiddenFields.keys.toList();
    List checkBoxInputFieldIds = checkBoxInputFields
        .map((InputField inputField) => inputField.id)
        .toSet()
        .toList();
    List filteredMandatoryFields = mandatoryFields
        .where((field) => !hiddenFieldsIds.contains(field))
        .toList();
    for (var mandatoryField in filteredMandatoryFields) {
      if (!fieldIds.contains(mandatoryField)) {
        if (checkBoxInputFieldIds.contains(mandatoryField)) {
          bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
            checkBoxInputFields
                .where(
                    (InputField inputField) => inputField.id == mandatoryField)
                .toList(),
            dataDynamic,
          );
          if (!hasAtLeastOneInputFieldFilled) {
            unFilledMandatoryFields.add(mandatoryField);
          }
        } else {
          unFilledMandatoryFields.add(mandatoryField);
        }
      } else {
        if ('${dataDynamic[mandatoryField]}'.trim() == '' ||
            '${dataDynamic[mandatoryField]}'.trim() == 'null') {
          if (checkBoxInputFieldIds.contains(mandatoryField)) {
            bool hasAtLeastOneInputFieldFilled = isAtLeastOneCheckBoxTicked(
              checkBoxInputFields
                  .where((InputField inputField) =>
                      inputField.id == mandatoryField)
                  .toList(),
              dataDynamic,
            );
            if (!hasAtLeastOneInputFieldFilled) {
              unFilledMandatoryFields.add(mandatoryField);
            }
          } else {
            unFilledMandatoryFields.add(mandatoryField);
          }
        }
      }
    }
    return unFilledMandatoryFields;
  }
}
