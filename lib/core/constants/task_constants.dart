/// Task module constants
/// 
/// This file contains all constants used in the task module
/// to ensure consistency and ease of maintenance.
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

  // Task Categories
  static const String categoryDesign = 'design';
  static const String categoryDev = 'dev';
  static const String categoryMarketing = 'marketing';
  static const String categoryResearch = 'research';
  static const String categoryBug = 'bug';
  static const String categoryGeneral = 'general';
  static const String categoryMeeting = 'meeting';

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
}
