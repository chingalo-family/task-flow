import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/app_info_state/app_info_state.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/constants/email_connection.dart';
import 'package:task_flow/core/models/email_notification.dart';
import 'package:task_flow/core/services/email_service.dart';
import 'package:task_flow/core/services/email_templates.dart';
import 'package:task_flow/core/utils/utils.dart';
import 'package:task_flow/modules/login/components/modern_input_field.dart';
import 'package:task_flow/modules/login/components/modern_primary_button.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  String selectedCategory = 'Bug Report';
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    // Validate form
    if (_subjectController.text.trim().isEmpty) {
      AppUtil.showToastMessage(message: 'Please enter a subject');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      AppUtil.showToastMessage(message: 'Please enter a message');
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final userState = Provider.of<UserState>(context, listen: false);
      final appInfoState = Provider.of<AppInfoState>(context, listen: false);
      
      // Ensure user is authenticated
      if (userState.currentUser == null) {
        AppUtil.showToastMessage(
          message: 'Please log in to send a message',
        );
        return;
      }
      
      final userEmail = userState.currentUser!.email ?? '';
      if (userEmail.isEmpty) {
        AppUtil.showToastMessage(
          message: 'Email address not found. Please update your profile.',
        );
        return;
      }
      
      final userName = userState.currentUser!.fullName ?? 
                       userState.currentUser!.username ?? 
                       'User';

      // Create HTML email using template
      final htmlBody = EmailTemplates.getContactFormEmail(
        category: selectedCategory,
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        senderEmail: userEmail,
        appName: appInfoState.appName,
        currentAppVersion: appInfoState.version,
      );

      // Create plain text version
      final textBody = '''
Contact Form Submission

Category: $selectedCategory
Subject: ${_subjectController.text.trim()}

Message:
${_messageController.text.trim()}

Reply to: $userEmail
Sent by: $userName
      ''';

      // Send email to admins
      final emailNotification = EmailNotification(
        recipients: EmailConnection.adminEmails,
        subject: '[$selectedCategory] ${_subjectController.text.trim()}',
        htmlBody: htmlBody,
        textBody: textBody,
      );

      await EmailService.sendEmail(emailNotification: emailNotification);

      if (mounted) {
        AppUtil.showToastMessage(message: 'Message sent successfully!');
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      debugPrint('Failed to send contact form email: $e');
      if (mounted) {
        AppUtil.showToastMessage(
          message: 'Failed to send message. Please check your internet connection and try again.',
        );
      }
    } catch (e) {
      debugPrint('Unexpected error sending contact form: $e');
      if (mounted) {
        AppUtil.showToastMessage(
          message: 'An unexpected error occurred. Please try again later.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstant.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstant.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Support',
          style: TextStyle(
            color: AppConstant.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstant.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Having trouble with TaskFlow or have a suggestion? Let us know. We usually respond within 24 hours.',
                style: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              SizedBox(height: AppConstant.spacing32),

              // Category Section
              Text(
                'Category',
                style: TextStyle(
                  color: AppConstant.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppConstant.spacing12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Bug Report', Icons.bug_report),
                    SizedBox(width: AppConstant.spacing8),
                    _buildCategoryChip('Feature Request', Icons.lightbulb_outline),
                    SizedBox(width: AppConstant.spacing8),
                    _buildCategoryChip('General Inquiry', Icons.help_outline),
                    SizedBox(width: AppConstant.spacing8),
                    _buildCategoryChip('Account Issue', Icons.account_circle_outlined),
                    SizedBox(width: AppConstant.spacing8),
                    _buildCategoryChip('Billing', Icons.payment),
                    SizedBox(width: AppConstant.spacing8),
                    _buildCategoryChip('Feedback', Icons.feedback_outlined),
                  ],
                ),
              ),
              SizedBox(height: AppConstant.spacing24),

              // Subject Field
              ModernInputField(
                controller: _subjectController,
                hintText: 'Brief summary of the issue',
                icon: Icons.subject,
              ),
              SizedBox(height: AppConstant.spacing16),

              // Message Field
              Container(
                decoration: BoxDecoration(
                  color: AppConstant.cardBackground,
                  borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
                  border: Border.all(
                    color: AppConstant.textSecondary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _messageController,
                  maxLines: 8,
                  style: TextStyle(color: AppConstant.textPrimary, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Describe your issue or feedback in detail...',
                    hintStyle: TextStyle(
                      color: AppConstant.textSecondary,
                      fontSize: 16,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 12, top: 12),
                      child: Icon(
                        Icons.message_outlined,
                        color: AppConstant.textSecondary,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppConstant.spacing32),

              // Send Button
              ModernPrimaryButton(
                onPressed: _isSending ? null : _sendMessage,
                loading: _isSending,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Send Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: AppConstant.spacing8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstant.spacing12,
          vertical: AppConstant.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstant.primaryBlue
              : AppConstant.cardBackground,
          borderRadius: BorderRadius.circular(AppConstant.borderRadius8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppConstant.textSecondary,
              size: 16,
            ),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppConstant.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
