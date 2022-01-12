import 'package:flutter/material.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/input_field.dart';

class SignInSignUpForm {
  static List<FormSection> getSignInFormSections(Color textColor) {
    return [
      FormSection(
        name: '',
        color: textColor,
        inputFields: [
          InputField(
            id: 'username',
            name: 'Username',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
          ),
          InputField(
            id: 'password',
            name: 'Password',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
            isPassowrdField: true,
          ),
        ],
      ),
    ];
  }

  static List<FormSection> getSignUpFormSections(Color textColor) {
    return [
      FormSection(
        name: '',
        color: textColor,
        inputFields: [
          InputField(
            id: 'title',
            name: 'Title',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
          ),
          InputField(
            id: 'description',
            name: 'Desctiption',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
          ),
        ],
      ),
    ];
  }
}
