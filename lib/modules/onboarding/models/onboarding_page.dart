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
        title: 'Manage tasks\nefficiently',
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
        title: 'Track Progress',
        description:
            'Monitor task completion, view analytics, and stay on top of your projects with real-time updates.',
        icon: 'progress',
      ),
      OnboardingPage(
        title: 'Master Your Day',
        description:
            'The modern way to manage tasks and subtasks effortlessly.',
        icon: 'master',
        isLastPage: true,
      ),
    ];
  }
}
