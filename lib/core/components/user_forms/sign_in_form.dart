import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager/core/components/circular_process_loader.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/components/user_forms/models/sign_in_sign_up_form.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/user.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
    required this.currentTheme,
    required this.onSuccessLogin,
  }) : super(key: key);

  final String currentTheme;
  final Function onSuccessLogin;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  Color? textColor;
  List<FormSection>? formSections;
  bool isFormReady = false;
  bool isSaving = false;

  onLogin() {
    //@TODO login for login

    User user = new User(
      username: 'username',
      fullName: 'fullName',
      password: 'password',
    );
    widget.onSuccessLogin(user);
  }

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
    textColor = widget.currentTheme == ThemeServices.darkTheme
        ? AppContant.darkTextColor
        : AppContant.ligthTextColor;
    formSections = SignInSignUpForm.getSignInFormSections(textColor!);
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
          : Column(
              children: [
                EntryFormContainer(
                  formSections: formSections!,
                  dataObject: Map(),
                  mandatoryFieldObject: Map(),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  child: Text(
                    'Button',
                    style: TextStyle().copyWith(
                      color: textColor,
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: TextButton(
                      onPressed: onLogin,
                      child: Text(
                        'log in',
                        style: TextStyle().copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
