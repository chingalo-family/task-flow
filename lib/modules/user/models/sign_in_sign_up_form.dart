import 'package:flutter/material.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/input_field.dart';
import 'package:task_manager/models/input_field_option.dart';

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
            id: 'fullName',
            name: 'Full Name',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
          ),
          //@TODO adding support for email type input field
          InputField(
            id: 'email',
            name: 'E-mail',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
          ),
          InputField(
            id: 'phoneNumber',
            name: 'Phone Number',
            valueType: 'PHONE_NUMBER',
            inputColor: textColor,
            labelColor: textColor,
          ),
          InputField(
            id: 'gender',
            name: 'Gender',
            valueType: 'TEXT',
            inputColor: textColor,
            labelColor: textColor,
            options: [
              InputFieldOption(
                code: 'gender_male',
                name: 'Male',
              ),
              InputFieldOption(
                code: 'gender_female',
                name: 'Female',
              ),
              InputFieldOption(
                code: 'gender_other',
                name: 'Other',
              ),
            ],
          ),
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
}
