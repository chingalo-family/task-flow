class OnboardingPage {
  final String title;
  final String description;
  final String icon;
  final bool isLastPage;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    this.isLastPage = false,
  });

  static List<OnboardingPage> getPages() {
    return [
      OnboardingPage(
        title: 'Master Your Day',
        description:
            'The modern way to manage tasks and subtasks effortlessly.',
        icon: 'master',
      ),
      OnboardingPage(
        title: 'Manage tasks efficiently',
        description:
            'Break complex projects into manageable subtasks. Organize your team\'s workflow and stay ahead of deadlines.',
        icon: 'tasks',
      ),
      OnboardingPage(
        title: 'Team Collaboration',
        description:
            'Share tasks, manage projects, and communicate with your team in TaskFlow\'s unified workspace.',
        icon: 'team',
      ),
      OnboardingPage(
        title: 'Offline mode supported',
        description:
            'Keep working even when your internet isn\'t. Your tasks sync automatically the moment you\'re back online.',
        icon: 'offline',
      ),
      OnboardingPage(
        title: 'Get Started with TaskFlow',
        description:
            'Join thousands of teams using TaskFlow to manage tasks effortlessly, online or offline. Let\'s get to work.',
        icon: 'get_started',
        isLastPage: true,
      ),
    ];
  }
}
