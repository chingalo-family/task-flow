import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/core/utils/utils.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  String selectedCategory = 'Bug Report';
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    // TODO: Implement email sending functionality
    AppUtil.showToastMessage(message: 'Message sent successfully!');
    Navigator.pop(context);
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
              Row(
                children: [
                  _buildCategoryChip('Bug Report', Icons.bug_report),
                  SizedBox(width: AppConstant.spacing8),
                  _buildCategoryChip('Feature Request', Icons.lightbulb_outline),
                  SizedBox(width: AppConstant.spacing8),
                  _buildCategoryChip('Billing', Icons.payment),
                ],
              ),
              SizedBox(height: AppConstant.spacing24),

              // Subject Field
              InputField(
                controller: _subjectController,
                hintText: 'Brief summary of the issue',
                icon: Icons.subject,
                labelText: 'Subject',
              ),
              SizedBox(height: AppConstant.spacing24),

              // Message Field
              InputField(
                controller: _messageController,
                hintText: 'Describe your issue or feedback in detail...',
                icon: Icons.message_outlined,
                labelText: 'Message',
                maxLines: 8,
              ),
              SizedBox(height: AppConstant.spacing32),

              // Send Button
              PrimaryButton(
                onPressed: _sendMessage,
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
