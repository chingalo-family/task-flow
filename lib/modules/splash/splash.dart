import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/modules/splash/components/app_logo.dart';
import 'package:task_flow/modules/onboarding/onboarding_screen.dart';
import 'package:task_flow/modules/login/login_page.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/modules/home/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    print("Splash Init State");
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AppInfoState>(context, listen: false).initiatizeAppInfo();

      // Simulate loading progress
      for (int i = 0; i <= 100; i += 5) {
        await Future.delayed(const Duration(milliseconds: 30));
        if (mounted) {
          setState(() {
            _progress = i / 100;
          });
        }
      }

      // Wait for UserState to initialize and check auth
      final userState = Provider.of<UserState>(context, listen: false);
      await userState.initialize();

      // Check onboarding status
      final prefs = await SharedPreferences.getInstance();
      final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        _redirectToPages(userState, onboardingComplete);
      }
    });
  }

  void _redirectToPages(UserState userState, bool onboardingComplete) {
    Widget destination;

    if (!onboardingComplete) {
      destination = const OnboardingScreen();
    } else if (userState.isAuthenticated) {
      destination = const Home();
    } else {
      destination = const LoginPage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;

    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstant.spacing24,
                    vertical: isSmallScreen
                        ? AppConstant.spacing16
                        : AppConstant.spacing32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: isSmallScreen
                            ? AppConstant.spacing32
                            : AppConstant.spacing64,
                      ),

                      // Animated Logo
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: AppLogo(size: isSmallScreen ? 80 : 120),
                        ),
                      ),

                      SizedBox(height: AppConstant.spacing12),

                      // Tagline
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Collaborate. Achieve.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppConstant.textSecondary,
                                fontSize: isSmallScreen ? 14 : 18,
                                letterSpacing: 0.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(
                        height: isSmallScreen
                            ? AppConstant.spacing48
                            : AppConstant.spacing64,
                      ),

                      // Loading Progress
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: AppConstant.cardBackground,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstant.primaryBlue,
                                ),
                                minHeight: 4,
                              ),
                            ),
                          ),
                          SizedBox(height: AppConstant.spacing16),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstant.spacing16,
                            ),
                            child: Text(
                              'INITIALIZING WORKSPACE...',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    letterSpacing: 1.5,
                                    color: AppConstant.textSecondary.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: isSmallScreen
                            ? AppConstant.spacing32
                            : AppConstant.spacing48,
                      ),

                      // Version
                      Consumer<AppInfoState>(
                        builder: (context, appInfo, _) {
                          return Text(
                            'V ${appInfo.version.toUpperCase()} • EARLY ACCESS',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: isSmallScreen ? 9 : 11,
                                  letterSpacing: 1.2,
                                  color: AppConstant.textSecondary.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),

                      SizedBox(height: AppConstant.spacing16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
