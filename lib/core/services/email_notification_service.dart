import 'package:flutter/foundation.dart';
import 'package:task_flow/core/models/email_notification.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/services/email_service.dart';
import 'package:task_flow/core/services/preference_service.dart';

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
    final htmlBody = _getEmailHtmlBody(notification);

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

  String _getEmailHtmlBody(Notification notification) {
    final actorInfo = notification.actorUsername != null
        ? '<p><strong>From:</strong> ${notification.actorUsername}</p>'
        : '';

    return '''
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .header {
      background-color: #4A90E2;
      color: white;
      padding: 20px;
      border-radius: 5px 5px 0 0;
    }
    .content {
      background-color: #f4f4f4;
      padding: 20px;
      border-radius: 0 0 5px 5px;
    }
    .notification-type {
      display: inline-block;
      padding: 5px 10px;
      background-color: ${_getTypeColor(notification.type)};
      color: white;
      border-radius: 3px;
      font-size: 12px;
      margin-bottom: 10px;
    }
    .footer {
      margin-top: 20px;
      padding-top: 20px;
      border-top: 1px solid #ddd;
      font-size: 12px;
      color: #666;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>${notification.title}</h1>
  </div>
  <div class="content">
    <span class="notification-type">${_formatNotificationType(notification.type)}</span>
    <p>${notification.body ?? ''}</p>
    $actorInfo
    <p><small>Created: ${_formatDateTime(notification.createdAt)}</small></p>
  </div>
  <div class="footer">
    <p>This is an automated notification from Task Flow.</p>
    <p>To manage your notification preferences, please visit the app settings.</p>
  </div>
</body>
</html>
''';
  }

  String _getTypeColor(String type) {
    switch (type) {
      case 'task_assigned':
      case 'team_invite':
        return '#4A90E2';
      case 'deadline_reminder':
      case 'task_overdue':
        return '#E74C3C';
      case 'system':
        return '#95A5A6';
      default:
        return '#4A90E2';
    }
  }

  String _formatNotificationType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
