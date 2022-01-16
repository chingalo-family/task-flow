import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/core/components/circular_process_loader.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/components/user_forms/models/sign_in_sign_up_form.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/user.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
    required this.currentTheme,
  }) : super(key: key);

  final String currentTheme;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  Color? textColor;
  List<FormSection>? formSections;
  Map mandatoryFieldObject = new Map();
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormMetadata();
    Timer(Duration(seconds: 1), () {
      setState(() {
        isFormReady = true;
      });
    });
  }

  void setFormMetadata() {
    try {
      Provider.of<SignInSignUpFormState>(context, listen: false).resetFormState();
    } catch (e) {
      print(e.toString());
    }
    textColor = widget.currentTheme == ThemeServices.darkTheme
        ? AppContant.darkTextColor
        : AppContant.ligthTextColor;
    formSections = SignInSignUpForm.getSignUpFormSections(textColor!);
    mandatoryFieldObject['fullName'] = true;
    mandatoryFieldObject['username'] = true;
    mandatoryFieldObject['password'] = true;
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<SignInSignUpFormState>(context, listen: false).setFormFieldState(id, value);
  }

  void onSignUp(Map dataObject) async {
    //@TODO checking if user name exits on the system
    // create user account if not exist
    User user = User(
      id: AppUtil.getUid(),
      username: dataObject['username'] ?? '',
      fullName: dataObject['fullName'] ?? '',
      password: dataObject['password'] ?? '',
      gender: dataObject['gender'] ?? '',
      phoneNumber: dataObject['phoneNumber'] ?? '',
      email: dataObject['email'] ?? '',
    );
    // generating sign up account for posting or put
    print(user.toDhis2Json());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !isFormReady
          ? Container(
              child: CircularProcessLoader(
                color: Colors.blueGrey,
              ),
            )
          : Consumer<SignInSignUpFormState>(
              builder: (context, signInSignUpFormState, child) => Column(
                children: [
                  EntryFormContainer(
                    elevation: 0.0,
                    onInputValueChange: (String id, dynamic value) => onInputValueChange(id, value),
                    formSections: formSections!,
                    dataObject: signInSignUpFormState.formState,
                    mandatoryFieldObject: mandatoryFieldObject,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                            ),
                            child: TextButton(
                              onPressed: !signInSignUpFormState.isSignUpFormValid
                                  ? null
                                  : () => onSignUp(signInSignUpFormState.formState),
                              child: isSaving
                                  ? CircularProcessLoader(
                                      color: textColor,
                                      size: 2,
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle().copyWith(
                                        color: textColor,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
