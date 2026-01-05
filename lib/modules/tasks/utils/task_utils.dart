import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/task_constants.dart';
import 'package:intl/intl.dart';

/// Utility class for task-related helper functions
class TaskUtils {
  TaskUtils._(); // Private constructor to prevent instantiation

  /// Formats a DateTime to a readable string format
  static String formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    return DateFormat('MMM d, h:mm a').format(date);
  }

  /// Formats a DateTime to a short date format
  static String formatDateShort(DateTime? date) {
    if (date == null) return 'No date';
    return DateFormat('MMM d').format(date);
  }

  /// Formats a DateTime to include relative time (Today, Tomorrow, etc.)
  static String formatDateRelative(DateTime? date) {
    if (date == null) return 'No due date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    final difference = dateOnly.difference(today).inDays;
    
    if (difference == 0) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (difference == 1) {
      return 'Tomorrow, ${DateFormat('h:mm a').format(date)}';
    } else if (difference == -1) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return formatDate(date);
    }
  }

  /// Gets color based on task status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case TaskConstants.statusCompleted:
        return AppConstant.successGreen;
      case TaskConstants.statusInProgress:
      case 'in progress':
        return AppConstant.primaryBlue;
      case TaskConstants.statusPending:
        return AppConstant.textSecondary;
      default:
        return AppConstant.textSecondary;
    }
  }

  /// Gets human-readable status label
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case TaskConstants.statusCompleted:
        return 'Completed';
      case TaskConstants.statusInProgress:
        return 'In Progress';
      case TaskConstants.statusPending:
        return 'Pending';
      default:
        return status;
    }
  }

  /// Gets color based on task priority
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case TaskConstants.priorityHigh:
        return AppConstant.errorRed;
      case TaskConstants.priorityMedium:
        return AppConstant.warningYellow;
      case TaskConstants.priorityLow:
        return AppConstant.successGreen;
      default:
        return AppConstant.textSecondary;
    }
  }

  /// Gets human-readable priority label
  static String getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case TaskConstants.priorityHigh:
        return 'High';
      case TaskConstants.priorityMedium:
        return 'Medium';
      case TaskConstants.priorityLow:
        return 'Low';
      default:
        return priority;
    }
  }

  /// Generates user initials from full name or username
  static String getUserInitials(String? fullName, String? username) {
    if (fullName != null && fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return fullName.substring(0, fullName.length >= 2 ? 2 : 1).toUpperCase();
    }
    if (username != null && username.isNotEmpty) {
      return username.substring(0, username.length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'U';
  }

  /// Gets time-based greeting
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Checks if a date is overdue
  static bool isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    return dueDate.isBefore(DateTime.now());
  }

  /// Checks if a date is today
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Checks if a date is in the future
  static bool isFuture(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.isAfter(today);
  }

  /// Generates a unique subtask ID
  static String generateSubtaskId() {
    return 'subtask_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Generates a unique task ID
  static String generateTaskId() {
    return 'task_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Calculates task completion percentage
  static double calculateCompletionPercentage(int completed, int total) {
    if (total == 0) return 0.0;
    return (completed / total).clamp(0.0, 1.0);
  }
}
