import 'package:flutter_test/flutter_test.dart';
import 'package:task_flow/core/models/email_notification.dart';

void main() {
  group('EmailNotification', () {
    test('should create email notification with required fields', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: 'Test Subject',
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
      );

      expect(email.recipients, ['test@example.com']);
      expect(email.subject, 'Test Subject');
      expect(email.textBody, 'Test body');
      expect(email.htmlBody, '<p>Test body</p>');
      expect(email.ccRecipients, []);
    });

    test('should create email notification with cc recipients', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: 'Test Subject',
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
        ccRecipients: ['cc@example.com', 'cc2@example.com'],
      );

      expect(email.ccRecipients, ['cc@example.com', 'cc2@example.com']);
    });

    test('should default ccRecipients to empty list', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: 'Test Subject',
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
      );

      expect(email.ccRecipients, []);
    });

    test('should create email with multiple recipients', () {
      final email = EmailNotification(
        recipients: ['test1@example.com', 'test2@example.com'],
        subject: 'Test Subject',
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
      );

      expect(email.recipients, ['test1@example.com', 'test2@example.com']);
    });

    test('should have readable toString format', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: 'Test Subject',
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
      );

      final result = email.toString();

      expect(result, contains('Test Subject'));
      expect(result, contains('test@example.com'));
      expect(result, '<Test Subject> [test@example.com]');
    });

    test('should handle null recipients in toString', () {
      final email = EmailNotification(
        recipients: null,
        subject: 'Test Subject',
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
      );

      final result = email.toString();

      expect(result, '<Test Subject> null');
    });

    test('should handle null subject in toString', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: null,
        textBody: 'Test body',
        htmlBody: '<p>Test body</p>',
      );

      final result = email.toString();

      expect(result, '<null> [test@example.com]');
    });

    test('should allow null text body', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: 'Test',
        textBody: null,
        htmlBody: '<p>Test</p>',
      );

      expect(email.textBody, null);
      expect(email.htmlBody, '<p>Test</p>');
    });

    test('should allow null html body', () {
      final email = EmailNotification(
        recipients: ['test@example.com'],
        subject: 'Test',
        textBody: 'Test',
        htmlBody: null,
      );

      expect(email.textBody, 'Test');
      expect(email.htmlBody, null);
    });
  });
}
