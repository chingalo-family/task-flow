import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/core/components/circular_process_loader.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/components/user_forms/models/sign_in_sign_up_form.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
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
  Map mandatoryFieldObject = new Map();
  User? currentUser;
  bool isFormReady = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setFormMetadata();
    setCurrentUser();
    Timer(Duration(seconds: 2), () {
      isFormReady = true;
      setState(() {});
    });
  }

  void setCurrentUser() async {
    var user = await UserService().getCurrentUser();
    currentUser = user ?? new User(username: '', fullName: '', password: '', id: '');
    Provider.of<SignInSignUpFormState>(context, listen: false)
        .setFormFieldState('username', currentUser!.username);
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
    formSections = SignInSignUpForm.getSignInFormSections(textColor!);
    mandatoryFieldObject['username'] = true;
    mandatoryFieldObject['password'] = true;
  }

  void onInputValueChange(String id, dynamic value) {
    Provider.of<SignInSignUpFormState>(context, listen: false).setFormFieldState(id, value);
  }

  void onLogin(Map dataObject) async {
    var username = dataObject['username'] ?? '';
    var password = dataObject['password'] ?? '';
    if ('$username'.isNotEmpty && '$password'.isNotEmpty) {
      //@TODO adding loading process
      //@TODO authenticate and loading necessary metadata
      try {
        currentUser!.username = username;
        currentUser!.password = password;
        var user = await UserService().login(
          username: username,
          password: password,
        );
        print('user => $user');
      } catch (e) {
        print('error=>${e.toString()}');
      }
    } else {
      AppUtil.showToastMessage(
        message: 'Enter username and password',
      );
    }
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
              builder: (context, SignInSignUpFormState, child) => Column(
                children: [
                  EntryFormContainer(
                    elevation: 0.0,
                    onInputValueChange: (String id, dynamic value) => onInputValueChange(id, value),
                    formSections: formSections!,
                    dataObject: SignInSignUpFormState.formState,
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
                          child: TextButton(
                            onPressed: () => onLogin(SignInSignUpFormState.formState),
                            child: Text(
                              'log in',
                              style: TextStyle().copyWith(
                                color: textColor,
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
