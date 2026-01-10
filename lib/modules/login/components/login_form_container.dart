import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/user_list_state/user_list_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/core/services/user_service.dart';
import 'package:task_flow/modules/login/components/modern_login_form.dart';
import 'package:task_flow/modules/login/components/modern_signup_form.dart';

class LoginFormContainer extends StatefulWidget {
  const LoginFormContainer({
    super.key,
    required this.onSuccessLogin,
    required this.onSuccessSignUp,
    this.showSignUp = false,
    this.onToggleAuthMode,
  });

  final Function onSuccessLogin;
  final Function onSuccessSignUp;
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
      final userState = Provider.of<UserState>(context, listen: false);
      final success = await userState.signIn(
        username: username,
        password: password,
      );
      if (success) {
        final user = userState.currentUser!;
        await refreshAppMetadata(user: user);
        onSuccessLogin(user);
      } else {
        _showToastMessage(
          message: 'Login failed. Please check your username and password',
        );
        setState(() {
          isSaving = false;
        });
      }
    } catch (e) {
      _showToastMessage(
        message: 'Error: ${e.toString().replaceAll('Exception: ', '')}',
      );
      setState(() {
        isSaving = false;
      });
    }
  }

  void _showToastMessage({required String message}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void onSignUp(
    String fullName,
    String email,
    String username,
    String phoneNumber,
    String password,
  ) async {
    try {
      setState(() {
        isSaving = true;
      });
      final userState = Provider.of<UserState>(context, listen: false);
      User? user = await userState.signUp(
        name: fullName,
        email: email,
        username: username,
        phoneNumber: phoneNumber,
        password: password,
      );
      if (user != null) {
        await refreshAppMetadata(user: user);
        widget.onSuccessSignUp(user);
      }
    } catch (e) {
      _showToastMessage(message: e.toString());
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
