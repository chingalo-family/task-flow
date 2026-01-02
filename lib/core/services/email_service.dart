import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:task_flow/core/constants/email_connection.dart';
import 'package:task_flow/core/models/email_notification.dart';

class EmailService {
  static Future<void> sendEmail({
    required EmailNotification emailNotification,
  }) async {
    final smtpServer = gmail(
      EmailConnection.senderEmail,
      EmailConnection.password,
    );
    String textContent = emailNotification.textBody ?? '';
    String htmlContent = emailNotification.htmlBody ?? '';
    if (htmlContent.isEmpty && textContent.isNotEmpty) {
      htmlContent = _convertTextToHtml(textContent);
    }
    if (textContent.isEmpty && htmlContent.isNotEmpty) {
      textContent = _stripHtmlTags(htmlContent);
    }

    final message = Message()
      ..from = const Address(
        EmailConnection.senderEmail,
        EmailConnection.senderName,
      )
      ..recipients.addAll(emailNotification.recipients!)
      ..ccRecipients.addAll(emailNotification.ccRecipients)
      ..subject = emailNotification.subject
      ..text =
          textContent // Plain text version
      ..html = htmlContent; // HTML version

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } on MailerException catch (error) {
      debugPrint('Message not sent.');
      for (var problem in error.problems) {
        debugPrint('Problem: ${problem.code}: ${problem.msg}');
      }
    }
  }

  static String _convertTextToHtml(String text) {
    if (text.isEmpty) return '';
    String escaped = text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
    String withBreaks = escaped.replaceAll('\n', '<br>');
    return '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
              $withBreaks
            </div>
          </body>
          </html>
          ''';
  }

  static String _stripHtmlTags(String html) {
    if (html.isEmpty) return '';
    String text = html.replaceAll(RegExp(r'<[^>]*>'), ' ');
    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('<br />', '\n');
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text;
  }
}
