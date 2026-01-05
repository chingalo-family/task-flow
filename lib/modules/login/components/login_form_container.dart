import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/services/user_service.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/modules/login/components/modern_login_form.dart';
import 'package:task_flow/modules/login/components/modern_signup_form.dart';

class LoginFormContainer extends StatefulWidget {
  const LoginFormContainer({
    super.key,
    required this.onSuccessLogin,
    this.showSignUp = false,
    this.onToggleAuthMode,
  });

  final Function onSuccessLogin;
  final bool showSignUp;
  final VoidCallback? onToggleAuthMode;

  @override
  State<LoginFormContainer> createState() => _LoginFormContainerState();
}

class _LoginFormContainerState extends State<LoginFormContainer> {
  User? currentUser;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    setCurrentUser();
  }

  void onSuccessLogin(User user) async {
    widget.onSuccessLogin(user);
  }

  void setCurrentUser() async {
    var user = await UserService().getCurrentUser();
    currentUser =
        user ?? User(username: '', fullName: '', password: '', id: '');
    setState(() {});
  }

  Future<void> refreshAppMetadata({required User user}) async {
    final userListState = Provider.of<UserListState>(context, listen: false);
    await userListState.reSyncUserList();
  }

  void onLogin(String username, String password) async {
    try {
      setState(() {
        isSaving = true;
      });
      currentUser!.username = username;
      currentUser!.password = password;
      var user = await UserService().login(username, password);
      if (user != null) {
        await UserService().setCurrentUser(user);

        await refreshAppMetadata(user: user);
        onSuccessLogin(user);
      } else {
        AppUtil.showToastMessage(
          message: 'Wrong username or password, try again',
        );
        setState(() {
          isSaving = false;
        });
      }
    } catch (e) {
      AppUtil.showToastMessage(message: e.toString());
      setState(() {
        isSaving = false;
      });
    }
  }

  void onSignUp(
    String firstName,
    String surname,
    String email,
    String phoneNumber,
    String password,
  ) async {
    try {
      setState(() {
        isSaving = true;
      });
      // For now, we'll just show a success message
      // In a real app, this would make an API call to create the account
      AppUtil.showToastMessage(
        message: 'Account created successfully! Please log in.',
      );

      // Switch to login mode
      if (widget.onToggleAuthMode != null) {
        widget.onToggleAuthMode!();
      }

      setState(() {
        isSaving = false;
      });
    } catch (e) {
      AppUtil.showToastMessage(message: e.toString());
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: widget.showSignUp
                ? ModernSignupForm(
                    key: ValueKey('signup'),
                    isSaving: isSaving,
                    onSignUp: onSignUp,
                  )
                : ModernLoginForm(
                    key: ValueKey('login'),
                    onLogin: onLogin,
                    isSaving: isSaving,
                    initialUsername: currentUser?.username,
                  ),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Toggle between sign in and sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.showSignUp
                    ? 'Already have an account?'
                    : 'Don\'t have an account?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: widget.onToggleAuthMode,
                child: Text(
                  widget.showSignUp ? 'Log in' : 'Sign up',
                  style: TextStyle(
                    color: AppConstant.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
