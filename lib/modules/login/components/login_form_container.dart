import 'package:flutter/material.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/core/services/user_service.dart';
import 'package:task_manager/core/utils/app_util.dart';
import 'package:task_manager/modules/login/components/modern_login_form.dart';

class LoginFormContainer extends StatefulWidget {
  const LoginFormContainer({super.key, required this.onSuccessLogin});

  final Function onSuccessLogin;

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
    //TODO later this can be used to refresh app metadata after login
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: ModernLoginForm(
        onLogin: onLogin,
        isSaving: isSaving,
        initialUsername: currentUser?.username,
      ),
    );
  }
}
