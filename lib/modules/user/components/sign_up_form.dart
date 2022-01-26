import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/core/components/circular_process_loader.dart';
import 'package:task_manager/core/components/entry_forms/entry_form_container.dart';
import 'package:task_manager/core/components/material_card.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/models/form_section.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/modules/user/models/sign_in_sign_up_form.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
    required this.currentTheme,
    required this.onSuccessSignUp,
    required this.onFormReady,
  }) : super(key: key);

  final String currentTheme;
  final VoidCallback onFormReady;
  final Function onSuccessSignUp;

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
      widget.onFormReady();
      isFormReady = true;
      setState(() {});
    });
  }

  void onSuccessSignUp(User user) {
    user.isLogin = true;
    widget.onSuccessSignUp(user);
  }

  void setFormMetadata() {
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
    try {
      User user = User(
        id: AppUtil.getUid(),
        username: dataObject['username'] ?? '',
        fullName: dataObject['fullName'] ?? '',
        password: dataObject['password'] ?? '',
        gender: dataObject['gender'] ?? '',
        phoneNumber: dataObject['phoneNumber'] ?? '',
        email: dataObject['email'] ?? '',
      );
      if (user.email!.isNotEmpty && !AppUtil.isEmailValid(user.email!)) {
        AppUtil.showToastMessage(
          message: '${user.email!} is not valid email',
        );
      } else if (!AppUtil.isPasswordValid(user.password!)) {
        AppUtil.showToastMessage(
          message:
              'Password should contain at least one upper case, one lower case, one digit, one special character and 8 characters in length',
        );
      } else {
        isSaving = true;
        setState(() {});
        bool isAccountExist = await UserService().isUserAccountExist(dhisUsername: user.username);
        if (!isAccountExist) {
          // await UserService().createOrUpdateDhis2UserAccount(user: user);
          //  onSuccessSignUp(user);
        } else {
          AppUtil.showToastMessage(
            message: 'User with username ${user.username} has already signed up in the system',
          );
        }
        isSaving = false;
        setState(() {});
      }
    } catch (error) {
      isSaving = false;
      setState(() {});
      AppUtil.showToastMessage(
        message: error.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !isFormReady
          ? Container(
              margin: const EdgeInsets.only(
                top: 10.0,
              ),
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
                      horizontal: 5.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: !signInSignUpFormState.isSignUpFormValid
                                ? null
                                : () => onSignUp(signInSignUpFormState.formState),
                            child: isSaving
                                ? CircularProcessLoader(
                                    color: textColor,
                                    size: 2,
                                  )
                                : MaterialCard(
                                    body: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      width: double.infinity,
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle().copyWith(
                                          color: textColor,
                                        ),
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
