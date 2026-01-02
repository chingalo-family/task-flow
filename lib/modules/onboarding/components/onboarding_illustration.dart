import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class OnboardingIllustration extends StatelessWidget {
  final String type;

  const OnboardingIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      padding: EdgeInsets.all(AppConstant.spacing32),
      child: _buildIllustration(),
    );
  }

  Widget _buildIllustration() {
    switch (type) {
      case 'tasks':
        return _buildTasksIllustration();
      case 'team':
        return _buildTeamIllustration();
      case 'progress':
        return _buildProgressIllustration();
      case 'master':
        return _buildMasterIllustration();
      default:
        return Container();
    }
  }

  Widget _buildTasksIllustration() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Folder icon with progress
          Row(
            children: [
              Icon(Icons.folder, color: AppConstant.primaryBlue, size: 40),
              SizedBox(width: AppConstant.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing8),
                    Container(
                      height: 12,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
              CircularProgressIndicator(
                value: 0.75,
                backgroundColor: AppConstant.textSecondary.withValues(
                  alpha: 0.2,
                ),
                valueColor: AlwaysStoppedAnimation(AppConstant.primaryBlue),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing24),
          // Task items
          _buildTaskItem(true),
          SizedBox(height: AppConstant.spacing12),
          _buildTaskItem(false, hasProgress: true),
          SizedBox(height: AppConstant.spacing12),
          _buildTaskItem(false),
          SizedBox(height: AppConstant.spacing24),
          // Add button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppConstant.primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(bool checked, {bool hasProgress = false}) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing16),
      decoration: BoxDecoration(
        color: checked
            ? AppConstant.primaryBlue.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
        border: Border.all(
          color: checked
              ? AppConstant.primaryBlue.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: checked ? AppConstant.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: checked
                    ? AppConstant.primaryBlue
                    : AppConstant.textSecondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: checked
                ? Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          SizedBox(width: AppConstant.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: checked ? 0.5 : 0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                if (hasProgress) ...[
                  SizedBox(height: AppConstant.spacing8),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppConstant.primaryBlue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamIllustration() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: AppConstant.primaryBlue, size: 32),
              SizedBox(width: AppConstant.spacing12),
              Expanded(
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing24),
          Container(
            padding: EdgeInsets.all(AppConstant.spacing16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildAvatar('JD', Colors.purple),
                    SizedBox(width: AppConstant.spacing8),
                    _buildAvatar('KL', Colors.green),
                    SizedBox(width: AppConstant.spacing8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppConstant.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '+5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          Container(
            padding: EdgeInsets.all(AppConstant.spacing12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppConstant.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppConstant.spacing8),
                Expanded(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstant.spacing32),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppConstant.primaryBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: AppConstant.warningOrange,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(width: AppConstant.spacing16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.chat_bubble, color: Colors.green, size: 24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String initials, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIllustration() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 12,
                  backgroundColor: AppConstant.textSecondary.withValues(
                    alpha: 0.2,
                  ),
                  valueColor: AlwaysStoppedAnimation(AppConstant.primaryBlue),
                ),
              ),
              Column(
                children: [
                  Text(
                    '65%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Complete',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConstant.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing32),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('12', 'Tasks', AppConstant.primaryBlue),
              _buildStatCard('8', 'Done', AppConstant.successGreen),
              _buildStatCard('4', 'Pending', AppConstant.warningOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstant.spacing16,
        vertical: AppConstant.spacing12,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppConstant.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterIllustration() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstant.cardBackground,
            AppConstant.cardBackground.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Laptop illustration
          Icon(
            Icons.laptop_mac,
            size: 80,
            color: AppConstant.primaryBlue.withValues(alpha: 0.7),
          ),
          SizedBox(height: AppConstant.spacing24),
          // Floating task card
          Transform.rotate(
            angle: 0.1,
            child: Container(
              width: 140,
              padding: EdgeInsets.all(AppConstant.spacing12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
                border: Border.all(
                  color: AppConstant.primaryBlue.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppConstant.primaryBlue,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppConstant.primaryBlue,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          // Pencil icon
          Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.edit,
              size: 32,
              color: AppConstant.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
