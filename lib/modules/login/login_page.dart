import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/core/models/user.dart';
import 'package:task_manager/modules/home/home.dart';
import 'package:task_manager/core/constants/app_constant.dart';
import 'package:task_manager/modules/login/components/login_form_container.dart';
import 'package:task_manager/modules/login/components/user_account_request_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void onSuccessLogin(BuildContext context, User user) async {
    Provider.of<UserState>(context, listen: false).setCurrent(user);
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70.0, bottom: 30.0),
                    child: SizedBox(
                      height: size.shortestSide * 0.4,
                      width: size.shortestSide * 0.5,
                      child: const Icon(
                        Icons.lock_outline,
                        size: 120,
                        color: AppConstant.defaultColor,
                      ),
                    ),
                  ),
                  LoginFormContainer(
                    onSuccessLogin: (User user) =>
                        onSuccessLogin(context, user),
                  ),
                  const UserAccountRequestContainer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
