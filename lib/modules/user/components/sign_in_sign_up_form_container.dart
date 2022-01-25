import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/app_state/user_state/sign_in_sign_up_form_state.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/core/services/user_group_service.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/models/user_group.dart';
import 'package:task_manager/modules/user/components/sign_in_form.dart';
import 'package:task_manager/modules/user/components/sign_up_form.dart';

class SignInSignUpFormContainer extends StatefulWidget {
  const SignInSignUpFormContainer({
    Key? key,
  }) : super(key: key);

  @override
  _SignInSignUpFormContainerState createState() => _SignInSignUpFormContainerState();
}

class _SignInSignUpFormContainerState extends State<SignInSignUpFormContainer> {
  bool _showSignInForm = true;

  void onChangeFormState() {
    _showSignInForm = !_showSignInForm;
    Provider.of<SignInSignUpFormState>(context, listen: false).resetFormState();
    setState(() {});
  }

  onSuccessLoginOrSignUp(BuildContext context, User user) async {
    if (Navigator.canPop(context)) {
      print(user);
      List<UserGroup> userGroups = await UserGroupService().getUserGroupsByUserId(userId: user.id);
      //@TODO Set state for user and user groups
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Consumer<AppThemeState>(
      builder: (context, appThemeState, child) {
        String currentTheme = appThemeState.currentTheme;
        Color textColor = currentTheme == ThemeServices.darkTheme
            ? AppContant.darkTextColor
            : AppContant.ligthTextColor;
        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: _showSignInForm
                    ? SignInForm(
                        currentTheme: currentTheme,
                        onSuccessLogin: (User user) => onSuccessLoginOrSignUp(context, user),
                      )
                    : SignUpForm(
                        currentTheme: currentTheme,
                      ),
              ),
              Container(
                child: GestureDetector(
                  onTap: onChangeFormState,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        children: [
                          TextSpan(
                            text: _showSignInForm
                                ? "Don't have account?"
                                : 'Already have an account?',
                            style: TextStyle().copyWith(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.0,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          TextSpan(
                            text: _showSignInForm ? ' Sign up' : ' Log in',
                            style: TextStyle().copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}
