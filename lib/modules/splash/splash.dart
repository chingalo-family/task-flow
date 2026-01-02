import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app_state/app_info_state/app_info_state.dart';
import 'package:task_manager/core/components/circular_process_loader.dart';
import 'package:task_manager/core/constants/app_constant.dart';
import 'package:task_manager/modules/login/login_page.dart';
import 'package:task_manager/app_state/user_state/user_state.dart';
import 'package:task_manager/modules/home/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AppInfoState>(context, listen: false).initiatizeAppInfo();
      // Wait for UserState to initialize and check auth
      final userState = Provider.of<UserState>(context, listen: false);
      await userState.initialize();
      Future.delayed(const Duration(milliseconds: 200), () {
        _redirectToPages(userState);
      });
    });
  }

  void _redirectToPages(UserState userState) {
    if (userState.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: const Center(
          child: CircularProcessLoader(
            color: AppConstant.defaultColor,
            size: 3,
          ),
        ),
      ),
    );
  }
}
