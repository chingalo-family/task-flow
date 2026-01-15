import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:task_flow/core/models/email_notification.dart';
import 'package:task_flow/core/models/notification.dart';
import 'package:task_flow/core/services/email_service.dart';
import 'package:task_flow/core/services/email_templates.dart';
import 'package:task_flow/core/services/preference_service.dart';
import 'package:task_flow/core/services/system_info_service.dart';

class EmailNotificationService {
  EmailNotificationService._();
  static final EmailNotificationService _instance =
      EmailNotificationService._();
  factory EmailNotificationService() => _instance;

  final _prefs = PreferenceService();
  Future<bool> areEmailNotificationsEnabled() async {
    return await _prefs.getBool('email_notifications_enabled') ?? false;
  }

  Future<void> setEmailNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('email_notifications_enabled', enabled);
  }

  Future<String?> getUserEmail() async {
    return await _prefs.getString('user_notification_email');
  }

  Future<void> setUserEmail(String email) async {
    await _prefs.setString('user_notification_email', email);
  }

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
      if (!_isCriticalNotification(notification.type)) {
        return;
      }
      final emailNotification = await _createEmailNotification(
        notification,
        recipientEmail,
      );
      await EmailService.sendEmail(emailNotification: emailNotification);
      debugPrint('Email notification sent for: ${notification.type}');
    } catch (e) {
      debugPrint('Error sending email notification: $e');
    }
  }

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

  Future<EmailNotification> _createEmailNotification(
    Notification notification,
    String recipientEmail,
  ) async {
    final SystemInfoService service = SystemInfoService();
    PackageInfo packageInfo = await service.getPackageInfo();
    final subject = _getEmailSubject(notification);
    final htmlBody = EmailTemplates.getInAppNotificationEmail(
      notificationTitle: notification.title,
      notificationBody: notification.body ?? '',
      notificationType: notification.type,
      createdAt: notification.createdAt,
      appName: packageInfo.appName,
      currentAppVersion: packageInfo.version,
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
