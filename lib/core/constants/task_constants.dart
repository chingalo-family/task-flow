class TaskConstants {
  // Task Status values
  static const String statusAll = 'all';
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';

  // Task Priority values
  static const String priorityAll = 'all';
  static const String priorityHigh = 'high';
  static const String priorityMedium = 'medium';
  static const String priorityLow = 'low';

  // Sort By values
  static const String sortByDueDate = 'dueDate';
  static const String sortByPriority = 'priority';
  static const String sortByCreatedAt = 'createdAt';
  static const String sortByStatus = 'status';

  // Status lists
  static const List<String> allStatuses = [
    statusAll,
    statusPending,
    statusInProgress,
    statusCompleted,
  ];

  // Priority lists
  static const List<String> allPriorities = [
    priorityAll,
    priorityHigh,
    priorityMedium,
    priorityLow,
  ];

  // Sort by lists
  static const List<String> allSortBy = [
    sortByDueDate,
    sortByPriority,
    sortByCreatedAt,
    sortByStatus,
  ];

  // Default values
  static const String defaultFilterStatus = statusAll;
  static const String defaultFilterPriority = priorityAll;
  static const String defaultSortBy = sortByDueDate;

  // Common tags for tasks
  static const List<String> commonTags = [
    'urgent',
    'important',
    'blocked',
    'documentation',
    'testing',
    'backend',
    'frontend',
    'mobile',
    'web',
    'api',
    'ui',
    'ux',
    'performance',
    'security',
    'refactor',
    'enhancement',
    'feature',
  ];
}
