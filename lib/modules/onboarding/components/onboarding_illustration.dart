import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class OnboardingIllustration extends StatelessWidget {
  final String type;

  const OnboardingIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      case 'offline':
        return _buildOfflineIllustration();
      case 'get_started':
        return _buildGetStartedIllustration();
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
            Color(0xFF5A7C8C),
            Color(0xFF4A6C7C),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Laptop base
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Laptop screen
              Container(
                width: 180,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
              // Laptop keyboard
              Container(
                width: 200,
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.3),
                      Colors.grey.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
              // Laptop base
              Container(
                width: 220,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          // Floating task clipboard
          Positioned(
            right: 20,
            top: 40,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                width: 80,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xFFD4A574),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    _buildFloatingCheckItem(true),
                    SizedBox(height: 6),
                    _buildFloatingCheckItem(true),
                    SizedBox(height: 6),
                    _buildFloatingCheckItem(true),
                    SizedBox(height: 6),
                    _buildFloatingCheckItem(true),
                  ],
                ),
              ),
            ),
          ),
          // Floating pencil
          Positioned(
            left: 40,
            top: 50,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          // Floating paper pieces
          Positioned(
            left: 30,
            bottom: 60,
            child: Container(
              width: 40,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // More floating elements
          Positioned(
            right: 30,
            bottom: 40,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 50,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCheckItem(bool checked) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: AppConstant.primaryBlue,
          size: 12,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineIllustration() {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main rounded square
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Color(0xFF2C3E50).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: AppConstant.primaryBlue,
              ),
            ),
          ),
          // Sync icon overlay
          Positioned(
            bottom: 40,
            right: 60,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFF2ECC71),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConstant.cardBackground,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.sync_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedIllustration() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5A9E9E),
            Color(0xFF4A8E8E),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack of coins/discs
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 100,
                height: 80,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: _buildDisc(0),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 10,
                      child: _buildDisc(1),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 10,
                      child: _buildDisc(2),
                    ),
                    Positioned(
                      bottom: 36,
                      left: 10,
                      child: _buildDisc(3),
                    ),
                    Positioned(
                      bottom: 48,
                      left: 10,
                      child: _buildDisc(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing32),
          // Floating checkmarks
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFloatingCheck(-0.3, 30, 0.8),
              SizedBox(width: 8),
              _buildFloatingCheck(0.0, 35, 1.0),
              SizedBox(width: 8),
              _buildFloatingCheck(0.2, 40, 0.9),
              SizedBox(width: 12),
              _buildFloatingCheck(0.15, 25, 0.7),
              SizedBox(width: 8),
              _buildFloatingCheck(-0.1, 30, 0.6),
              SizedBox(width: 8),
              _buildFloatingCheck(0.25, 28, 0.5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisc(int index) {
    return Container(
      width: 80,
      height: 14,
      decoration: BoxDecoration(
        color: Color(0xFFD4A574),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Color(0xFFB8956A),
          width: 1,
        ),
      ),
    );
  }

  Widget _buildFloatingCheck(double rotation, double size, double opacity) {
    return Transform.rotate(
      angle: rotation,
      child: Icon(
        Icons.check,
        color: AppConstant.primaryBlue.withValues(alpha: opacity),
        size: size,
      ),
    );
  }
}
