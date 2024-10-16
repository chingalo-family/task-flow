import 'package:flutter/material.dart';
import 'package:task_manager/core/components/entry_input_fields/models/input_field.dart';
import 'package:task_manager/models/form_section.dart';

class SubTaskForm {
  static List<FormSection> getFormSections(Color textColor) {
    return [
      FormSection(
        name: 'Task info',
        color: textColor,
        inputFields: [
          InputField(
            id: 'title',
            name: 'Title',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
          ),
        ],
      ),
    ];
  }
}
