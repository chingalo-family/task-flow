import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/core/components/circular_process_loader.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/components/user_forms/models/sign_in_sign_up_form.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/services/user_group_service.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';

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
    Timer(Duration(seconds: 1), () {
      isFormReady = true;
      setState(() {});
    });
  }

  void onSuccessLogin(User user) {
    widget.onSuccessLogin(user);
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
    try {
      isSaving = true;
      setState(() {});
      String username = dataObject['username'] ?? '';
      String password = dataObject['password'] ?? '';
      currentUser!.username = username;
      currentUser!.password = password;
      var user = await UserService().login(
        username: username,
        password: password,
      );
      if (user != null) {
        List<UserGroup> userGroups = [];
        for (String userGroupId in user.userGroups!) {
          var group = await UserGroupService().getUserGroupById(
            username: username,
            password: password,
            userGroupId: userGroupId,
          );
          userGroups.add(group!);
        }
        await UserService().setCurrentUser(user);
        await UserGroupService().setUserGroups(userGroups);
        isSaving = false;
        setState(() {});
        onSuccessLogin(user);
      } else {
        AppUtil.showToastMessage(
          message: 'Wrong username or password, try again',
        );
        isSaving = false;
        setState(() {});
      }
    } catch (e) {
      isSaving = false;
      setState(() {});
      print('error=>${e.toString()}');
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
                              onPressed: !signInSignUpFormState.isLoginFormValid
                                  ? null
                                  : () => onLogin(signInSignUpFormState.formState),
                              child: isSaving
                                  ? CircularProcessLoader(
                                      color: textColor,
                                      size: 2,
                                    )
                                  : Text(
                                      'Log In',
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
