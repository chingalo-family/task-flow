import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_theme_state/app_theme_state.dart';
import 'package:task_manager/core/components/user_forms/sign_in_form.dart';
import 'package:task_manager/core/components/user_forms/sign_up_form.dart';
import 'package:task_manager/core/constants/app_contant.dart';
import 'package:task_manager/core/services/theme_service.dart';
import 'package:task_manager/models/user.dart';

class SignInSignUpFormContainer extends StatefulWidget {
  const SignInSignUpFormContainer({
    Key? key,
  }) : super(key: key);

  @override
  _SignInSignUpFormContainerState createState() =>
      _SignInSignUpFormContainerState();
}

class _SignInSignUpFormContainerState extends State<SignInSignUpFormContainer> {
  bool _showSignInForm = true;

  void onChangeFormState() {
    _showSignInForm = !_showSignInForm;
    setState(() {});
  }

  onSuccessLoginOrSignUp(BuildContext context, User user) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, user);
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
                        onSuccessLogin: (User user) =>
                            onSuccessLoginOrSignUp(context, user),
                      )
                    : SignUpForm(
                        currentTheme: currentTheme,
                      ),
              ),
              Container(
                child: GestureDetector(
                  onTap: onChangeFormState,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 70.0,
                      bottom: 5.0,
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
