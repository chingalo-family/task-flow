import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/modules/login/login_page.dart';
import 'package:task_flow/modules/onboarding/components/onboarding_illustration.dart';
import 'package:task_flow/modules/onboarding/models/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<OnboardingPage> _pages = OnboardingPage.getPages();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 650;
    final isTinyScreen = size.height < 550;

    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstant.spacing16,
                vertical: AppConstant.spacing12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.layers_rounded,
                        color: AppConstant.primaryBlue,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      SizedBox(width: AppConstant.spacing8),
                      Text(
                        'TaskFlow',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _completeOnboarding,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppConstant.spacing12,
                          vertical: AppConstant.spacing8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppConstant.primaryBlue,
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTinyScreen
                            ? AppConstant.spacing16
                            : AppConstant.spacing24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: isTinyScreen
                                ? AppConstant.spacing16
                                : AppConstant.spacing32,
                          ),
                          OnboardingIllustration(type: page.icon),
                          SizedBox(
                            height: isTinyScreen
                                ? AppConstant.spacing16
                                : AppConstant.spacing24,
                          ),
                          Text(
                            page.title,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontSize: isTinyScreen
                                      ? 20
                                      : (isSmallScreen ? 24 : 28),
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: isTinyScreen
                                ? AppConstant.spacing8
                                : AppConstant.spacing12,
                          ),
                          Text(
                            page.description,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppConstant.textSecondary,
                                  fontSize: isTinyScreen
                                      ? 13
                                      : (isSmallScreen ? 14 : 16),
                                  height: 1.5,
                                ),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: isTinyScreen
                                ? AppConstant.spacing16
                                : AppConstant.spacing24,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Padding(
              padding: EdgeInsets.all(
                isTinyScreen ? AppConstant.spacing16 : AppConstant.spacing24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators
                  PageIndicator(
                    currentPage: _currentPage,
                    pageCount: _pages.length,
                  ),

                  SizedBox(
                    height: isTinyScreen
                        ? AppConstant.spacing16
                        : AppConstant.spacing24,
                  ),

                  // Next/Get Started button
                  SizedBox(
                    width: double.infinity,
                    height: isTinyScreen ? 48 : 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstant.borderRadius12,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _pages[_currentPage].isLastPage
                                  ? 'Create Free Account'
                                  : (_currentPage == 0
                                        ? 'Get Started'
                                        : 'Next'),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!_pages[_currentPage].isLastPage)
                            SizedBox(width: AppConstant.spacing8),
                          if (!_pages[_currentPage].isLastPage)
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: isSmallScreen ? 18 : 20,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Log in link for last page
                  if (_pages[_currentPage].isLastPage) ...[
                    SizedBox(
                      height: isTinyScreen
                          ? AppConstant.spacing8
                          : AppConstant.spacing12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppConstant.textSecondary,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        TextButton(
                          onPressed: _completeOnboarding,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstant.spacing4,
                              vertical: AppConstant.spacing8,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: AppConstant.primaryBlue,
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
