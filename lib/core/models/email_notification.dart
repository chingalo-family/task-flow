class EmailNotification {
  String? subject;
  List<String>? recipients;
  List<String> ccRecipients;
  String? textBody;
  String? htmlBody;

  EmailNotification({
    required this.recipients,
    required this.subject,
    required this.textBody,
    required this.htmlBody,
    this.ccRecipients = const [],
  });

  @override
  String toString() {
    return '<$subject> $recipients';
  }
}
