import 'package:flutter/foundation.dart';
import 'package:task_flow/core/models/email_notification.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/services/email_service.dart';
import 'package:task_flow/core/services/email_templates.dart';
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/constants/app_constant.dart';

/// Service for sending email notifications for critical events
class EmailNotificationService {
  EmailNotificationService._();
  static final EmailNotificationService _instance =
      EmailNotificationService._();
  factory EmailNotificationService() => _instance;

  final _prefs = PreferenceService();

  /// Check if email notifications are enabled
  Future<bool> areEmailNotificationsEnabled() async {
    return await _prefs.getBool('email_notifications_enabled') ?? false;
  }

  /// Enable or disable email notifications
  Future<void> setEmailNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('email_notifications_enabled', enabled);
  }

  /// Get user's email for notifications
  Future<String?> getUserEmail() async {
    return await _prefs.getString('user_notification_email');
  }

  /// Set user's email for notifications
  Future<void> setUserEmail(String email) async {
    await _prefs.setString('user_notification_email', email);
  }

  /// Send email notification for critical events
  Future<void> sendEmailNotification({
    required Notification notification,
    required String recipientEmail,
  }) async {
    try {
      // Check if email notifications are enabled
      final enabled = await areEmailNotificationsEnabled();
      if (!enabled) {
        return;
      }

      // Check if this is a critical notification type
      if (!_isCriticalNotification(notification.type)) {
        return;
      }

      final emailNotification = _createEmailNotification(
        notification,
        recipientEmail,
      );

      await EmailService.sendEmail(emailNotification: emailNotification);
      debugPrint('Email notification sent for: ${notification.type}');
    } catch (e) {
      debugPrint('Error sending email notification: $e');
    }
  }

  /// Determine if a notification type requires email notification
  bool _isCriticalNotification(String type) {
    // Send emails only for critical notifications
    final criticalTypes = [
      'task_assigned',
      'team_invite',
      'deadline_reminder',
      'task_overdue',
      'system',
    ];
    return criticalTypes.contains(type);
  }

  /// Create email notification from in-app notification
  EmailNotification _createEmailNotification(
    Notification notification,
    String recipientEmail,
  ) {
    final subject = _getEmailSubject(notification);
    final htmlBody = EmailTemplates.getInAppNotificationEmail(
      notificationTitle: notification.title,
      notificationBody: notification.body ?? '',
      notificationType: notification.type,
      createdAt: notification.createdAt,
      appName: AppConstant.appName,
      currentAppVersion: AppConstant.appVersion,
      actorUsername: notification.actorUsername,
    );

    return EmailNotification(
      recipients: [recipientEmail],
      subject: subject,
      htmlBody: htmlBody,
      ccRecipients: const [],
      textBody: '',
    );
  }

  String _getEmailSubject(Notification notification) {
    switch (notification.type) {
      case 'task_assigned':
        return 'New Task Assigned - ${notification.title}';
      case 'team_invite':
        return 'Team Invitation - ${notification.title}';
      case 'deadline_reminder':
        return 'Task Deadline Reminder';
      case 'task_overdue':
        return 'Overdue Task Alert';
      case 'system':
        return 'System Notification - ${notification.title}';
      default:
        return notification.title;
    }
  }
}
