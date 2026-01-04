import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/notification_state/notification_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/models/user.dart';
import 'package:task_flow/modules/home/home.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/login/components/login_form_container.dart';
import 'package:task_flow/modules/splash/components/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showSignUp = false;

  void onSuccessLogin(BuildContext context, User user) async {
    Provider.of<UserState>(context, listen: false).setCurrent(user);
    Provider.of<NotificationState>(context, listen: false).initialize();
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const Home(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }

  void toggleAuthMode() {
    setState(() {
      _showSignUp = !_showSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppConstant.darkBackground,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppConstant.spacing24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    AppLogo(size: 80, showText: true),

                    SizedBox(height: AppConstant.spacing8),

                    // Tagline
                    Text(
                      _showSignUp ? 'Create your account' : 'Welcome back',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontSize: 24),
                    ),
                    SizedBox(height: AppConstant.spacing8),
                    Text(
                      _showSignUp
                          ? 'Start managing your tasks efficiently'
                          : 'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppConstant.spacing32),
                    // Login/Signup Form
                    LoginFormContainer(
                      onSuccessLogin: (User user) =>
                          onSuccessLogin(context, user),
                      showSignUp: _showSignUp,
                      onToggleAuthMode: toggleAuthMode,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
