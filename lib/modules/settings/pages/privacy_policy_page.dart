import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
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
              // Last Updated
              Center(
                child: Text(
                  'Last Updated: October 24, 2023',
                  style: TextStyle(
                    color: AppConstant.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: AppConstant.spacing32),

              // 1. Introduction
              _buildSectionTitle('1. Introduction'),
              SizedBox(height: AppConstant.spacing12),
              _buildParagraph(
                'We are committed to protecting your privacy. This policy outlines how we handle your data within TaskFlow, specifically focusing on our offline-first and team collaboration features. Your trust is paramount to our mission of boosting productivity.',
              ),
              SizedBox(height: AppConstant.spacing24),

              // 2. Data Collection
              _buildSectionTitle('2. Data Collection'),
              SizedBox(height: AppConstant.spacing12),
              _buildParagraph(
                'We collect minimal data necessary to provide our services. This includes:',
              ),
              SizedBox(height: AppConstant.spacing8),
              _buildBulletPoint('Account information (email, username).'),
              _buildBulletPoint('Task data, project details, and attached files.'),
              _buildBulletPoint(
                'Usage metrics to improve TaskFlow performance and stability.',
              ),
              SizedBox(height: AppConstant.spacing24),

              // 3. Offline Storage
              _buildSectionTitle('3. Offline Storage'),
              SizedBox(height: AppConstant.spacing12),
              _buildInfoBox(
                title: 'LOCAL FIRST',
                description:
                    'TaskFlow is built "Offline-First". This means your data is stored locally on your device before being encrypted and synced to the cloud. This ensures you can work without interruption, even without internet connection.',
              ),
              SizedBox(height: AppConstant.spacing24),

              // 4. Team Collaboration
              _buildSectionTitle('4. Team Collaboration'),
              SizedBox(height: AppConstant.spacing12),
              _buildParagraph(
                'When you invite team members to a project, specific task data is shared securely with them. We do not share your private lists or personal settings with team members unless explicitly authorized by you.',
              ),
              SizedBox(height: AppConstant.spacing24),

              // 5. Security
              _buildSectionTitle('5. Security'),
              SizedBox(height: AppConstant.spacing12),
              _buildParagraph(
                'All data is encrypted in transit using TLS 1.3 and at rest using AES-256 standards. We utilize industry-leading cloud infrastructure to ensure your information remains secure from unauthorized access.',
              ),
              SizedBox(height: AppConstant.spacing24),

              // 6. Contact Us
              _buildSectionTitle('6. Contact Us'),
              SizedBox(height: AppConstant.spacing12),
              _buildParagraph(
                'If you have questions about our privacy practices or would like to exercise your data rights, please contact our Data Protection Officer.',
              ),
              SizedBox(height: AppConstant.spacing16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // TODO: Open email client
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstant.spacing16,
                      vertical: AppConstant.spacing12,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstant.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstant.borderRadius8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: AppConstant.primaryBlue,
                          size: 20,
                        ),
                        SizedBox(width: AppConstant.spacing8),
                        Text(
                          'chingalo.family@gmail.com',
                          style: TextStyle(
                            color: AppConstant.primaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppConstant.spacing32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppConstant.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppConstant.textSecondary,
        fontSize: 14,
        height: 1.6,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppConstant.spacing16,
        bottom: AppConstant.spacing8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: AppConstant.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppConstant.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({required String title, required String description}) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing16),
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
        border: Border.all(
          color: AppConstant.primaryBlue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.offline_bolt,
            color: AppConstant.primaryBlue,
            size: 24,
          ),
          SizedBox(width: AppConstant.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppConstant.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: AppConstant.spacing8),
                Text(
                  description,
                  style: TextStyle(
                    color: AppConstant.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
