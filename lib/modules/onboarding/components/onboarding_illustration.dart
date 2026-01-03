import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class OnboardingIllustration extends StatelessWidget {
  final String type;

  const OnboardingIllustration({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final maxWidth = isTablet ? 500.0 : size.width;
    
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        width: double.infinity,
        padding: EdgeInsets.all(AppConstant.spacing32),
        child: _buildIllustration(context),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    switch (type) {
      case 'tasks':
        return _buildTasksIllustration(context);
      case 'team':
        return _buildTeamIllustration(context);
      case 'progress':
        return _buildProgressIllustration(context);
      case 'master':
        return _buildMasterIllustration(context);
      case 'offline':
        return _buildOfflineIllustration(context);
      case 'get_started':
        return _buildGetStartedIllustration(context);
      default:
        return Container();
    }
  }

  Widget _buildTasksIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final scaleFactor = isTablet ? 1.3 : 1.0;
    
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24 * scaleFactor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Folder icon with progress
          Row(
            children: [
              Icon(Icons.folder, color: AppConstant.primaryBlue, size: 40 * scaleFactor),
              SizedBox(width: AppConstant.spacing16 * scaleFactor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12 * scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6 * scaleFactor),
                      ),
                    ),
                    SizedBox(height: AppConstant.spacing8 * scaleFactor),
                    Container(
                      height: 12 * scaleFactor,
                      width: 100 * scaleFactor,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6 * scaleFactor),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40 * scaleFactor,
                height: 40 * scaleFactor,
                child: CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 4 * scaleFactor,
                  backgroundColor: AppConstant.textSecondary.withValues(
                    alpha: 0.2,
                  ),
                  valueColor: AlwaysStoppedAnimation(AppConstant.primaryBlue),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing24 * scaleFactor),
          // Task items
          _buildTaskItem(true, scaleFactor: scaleFactor),
          SizedBox(height: AppConstant.spacing12 * scaleFactor),
          _buildTaskItem(false, hasProgress: true, scaleFactor: scaleFactor),
          SizedBox(height: AppConstant.spacing12 * scaleFactor),
          _buildTaskItem(false, scaleFactor: scaleFactor),
          SizedBox(height: AppConstant.spacing24 * scaleFactor),
          // Add button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 56 * scaleFactor,
              height: 56 * scaleFactor,
              decoration: BoxDecoration(
                color: AppConstant.primaryBlue,
                borderRadius: BorderRadius.circular(16 * scaleFactor),
              ),
              child: Icon(Icons.add, color: Colors.white, size: 24 * scaleFactor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(bool checked, {bool hasProgress = false, double scaleFactor = 1.0}) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing16 * scaleFactor),
      decoration: BoxDecoration(
        color: checked
            ? AppConstant.primaryBlue.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12 * scaleFactor),
        border: Border.all(
          color: checked
              ? AppConstant.primaryBlue.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24 * scaleFactor,
            height: 24 * scaleFactor,
            decoration: BoxDecoration(
              color: checked ? AppConstant.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(6 * scaleFactor),
              border: Border.all(
                color: checked
                    ? AppConstant.primaryBlue
                    : AppConstant.textSecondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: checked
                ? Icon(Icons.check, size: 16 * scaleFactor, color: Colors.white)
                : null,
          ),
          SizedBox(width: AppConstant.spacing12 * scaleFactor),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12 * scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: checked ? 0.5 : 0.7),
                    borderRadius: BorderRadius.circular(6 * scaleFactor),
                  ),
                ),
                if (hasProgress) ...[
                  SizedBox(height: AppConstant.spacing8 * scaleFactor),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 4 * scaleFactor,
                          decoration: BoxDecoration(
                            color: AppConstant.primaryBlue,
                            borderRadius: BorderRadius.circular(2 * scaleFactor),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 4 * scaleFactor,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2 * scaleFactor),
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

  Widget _buildTeamIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final scaleFactor = isTablet ? 1.3 : 1.0;
    
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24 * scaleFactor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.people, color: AppConstant.primaryBlue, size: 32 * scaleFactor),
              SizedBox(width: AppConstant.spacing12 * scaleFactor),
              Expanded(
                child: Container(
                  height: 12 * scaleFactor,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6 * scaleFactor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing24 * scaleFactor),
          Container(
            padding: EdgeInsets.all(AppConstant.spacing16 * scaleFactor),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12 * scaleFactor),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildAvatar('JD', Colors.purple, scaleFactor),
                    SizedBox(width: AppConstant.spacing8 * scaleFactor),
                    _buildAvatar('KL', Colors.green, scaleFactor),
                    SizedBox(width: AppConstant.spacing8 * scaleFactor),
                    Container(
                      width: 36 * scaleFactor,
                      height: 36 * scaleFactor,
                      decoration: BoxDecoration(
                        color: AppConstant.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '+5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12 * scaleFactor,
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
          SizedBox(height: AppConstant.spacing16 * scaleFactor),
          Container(
            padding: EdgeInsets.all(AppConstant.spacing12 * scaleFactor),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius12 * scaleFactor),
            ),
            child: Row(
              children: [
                Container(
                  width: 8 * scaleFactor,
                  height: 8 * scaleFactor,
                  decoration: BoxDecoration(
                    color: AppConstant.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppConstant.spacing8 * scaleFactor),
                Expanded(
                  child: Container(
                    height: 10 * scaleFactor,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(5 * scaleFactor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppConstant.spacing32 * scaleFactor),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12 * scaleFactor),
                  decoration: BoxDecoration(
                    color: AppConstant.primaryBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                  child: Icon(
                    Icons.schedule,
                    color: AppConstant.warningOrange,
                    size: 24 * scaleFactor,
                  ),
                ),
              ),
              SizedBox(width: AppConstant.spacing16 * scaleFactor),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12 * scaleFactor),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12 * scaleFactor),
                  ),
                  child: Icon(Icons.chat_bubble, color: Colors.green, size: 24 * scaleFactor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String initials, Color color, [double scaleFactor = 1.0]) {
    return Container(
      width: 36 * scaleFactor,
      height: 36 * scaleFactor,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12 * scaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final scaleFactor = isTablet ? 1.3 : 1.0;
    
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24 * scaleFactor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120 * scaleFactor,
                height: 120 * scaleFactor,
                child: CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 12 * scaleFactor,
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
                      fontSize: 32 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Complete',
                    style: TextStyle(
                      fontSize: 12 * scaleFactor,
                      color: AppConstant.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing32 * scaleFactor),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard('12', 'Tasks', AppConstant.primaryBlue, scaleFactor),
              _buildStatCard('8', 'Done', AppConstant.successGreen, scaleFactor),
              _buildStatCard('4', 'Pending', AppConstant.warningOrange, scaleFactor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color, [double scaleFactor = 1.0]) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstant.spacing16 * scaleFactor,
        vertical: AppConstant.spacing12 * scaleFactor,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12 * scaleFactor),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4 * scaleFactor),
          Text(
            label,
            style: TextStyle(fontSize: 12 * scaleFactor, color: AppConstant.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final scaleFactor = isTablet ? 1.3 : 1.0;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstant.illustrationTeal,
            AppConstant.illustrationTealDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32 * scaleFactor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Laptop base
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Laptop screen
              Container(
                width: 180 * scaleFactor,
                height: 120 * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
              ),
              // Laptop keyboard
              Container(
                width: 200 * scaleFactor,
                height: 8 * scaleFactor,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.withValues(alpha: 0.3),
                      Colors.grey.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12 * scaleFactor),
                    bottomRight: Radius.circular(12 * scaleFactor),
                  ),
                ),
              ),
              // Laptop base
              Container(
                width: 220 * scaleFactor,
                height: 4 * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2 * scaleFactor),
                ),
              ),
            ],
          ),
          // Floating task clipboard
          Positioned(
            right: 20 * scaleFactor,
            top: 40 * scaleFactor,
            child: Transform.rotate(
              angle: 0.15,
              child: Container(
                width: 80 * scaleFactor,
                padding: EdgeInsets.all(12 * scaleFactor),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(8 * scaleFactor),
                  border: Border.all(
                    color: AppConstant.illustrationBeige,
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    _buildFloatingCheckItem(true, scaleFactor),
                    SizedBox(height: 6 * scaleFactor),
                    _buildFloatingCheckItem(true, scaleFactor),
                    SizedBox(height: 6 * scaleFactor),
                    _buildFloatingCheckItem(true, scaleFactor),
                    SizedBox(height: 6 * scaleFactor),
                    _buildFloatingCheckItem(true, scaleFactor),
                  ],
                ),
              ),
            ),
          ),
          // Floating pencil
          Positioned(
            left: 40 * scaleFactor,
            top: 50 * scaleFactor,
            child: Transform.rotate(
              angle: -0.5,
              child: Container(
                width: 60 * scaleFactor,
                height: 6 * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3 * scaleFactor),
                ),
              ),
            ),
          ),
          // Floating paper pieces
          Positioned(
            left: 30 * scaleFactor,
            bottom: 60 * scaleFactor,
            child: Container(
              width: 40 * scaleFactor,
              height: 50 * scaleFactor,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4 * scaleFactor),
              ),
            ),
          ),
          // More floating elements
          Positioned(
            right: 30 * scaleFactor,
            bottom: 40 * scaleFactor,
            child: Transform.rotate(
              angle: 0.3,
              child: Container(
                width: 50 * scaleFactor,
                height: 6 * scaleFactor,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(3 * scaleFactor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCheckItem(bool checked, [double scaleFactor = 1.0]) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: AppConstant.primaryBlue,
          size: 12 * scaleFactor,
        ),
        SizedBox(width: 4 * scaleFactor),
        Expanded(
          child: Container(
            height: 6 * scaleFactor,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3 * scaleFactor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfflineIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final scaleFactor = isTablet ? 1.3 : 1.0;
    
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32 * scaleFactor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main rounded square
          Container(
            width: 180 * scaleFactor,
            height: 180 * scaleFactor,
            decoration: BoxDecoration(
              color: AppConstant.illustrationGray.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppConstant.borderRadius24 * scaleFactor),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.wifi_off_rounded,
                size: 80 * scaleFactor,
                color: AppConstant.primaryBlue,
              ),
            ),
          ),
          // Sync icon overlay
          Positioned(
            bottom: 40 * scaleFactor,
            right: 60 * scaleFactor,
            child: Container(
              width: 50 * scaleFactor,
              height: 50 * scaleFactor,
              decoration: BoxDecoration(
                color: AppConstant.illustrationGreen,
                borderRadius: BorderRadius.circular(12 * scaleFactor),
                border: Border.all(color: AppConstant.cardBackground, width: 3),
              ),
              child: Icon(Icons.sync_rounded, color: Colors.white, size: 28 * scaleFactor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedIllustration(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final scaleFactor = isTablet ? 1.3 : 1.0;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstant.illustrationCyan,
            AppConstant.illustrationCyanDark,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstant.borderRadius24),
      ),
      padding: EdgeInsets.all(AppConstant.spacing32 * scaleFactor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stack of coins/discs
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 100 * scaleFactor,
                height: 80 * scaleFactor,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 10 * scaleFactor,
                      child: _buildDisc(0, scaleFactor),
                    ),
                    Positioned(
                      bottom: 12 * scaleFactor,
                      left: 10 * scaleFactor,
                      child: _buildDisc(1, scaleFactor),
                    ),
                    Positioned(
                      bottom: 24 * scaleFactor,
                      left: 10 * scaleFactor,
                      child: _buildDisc(2, scaleFactor),
                    ),
                    Positioned(
                      bottom: 36 * scaleFactor,
                      left: 10 * scaleFactor,
                      child: _buildDisc(3, scaleFactor),
                    ),
                    Positioned(
                      bottom: 48 * scaleFactor,
                      left: 10 * scaleFactor,
                      child: _buildDisc(4, scaleFactor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstant.spacing32 * scaleFactor),
          // Floating checkmarks
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFloatingCheck(-0.3, 30 * scaleFactor, 0.8),
              SizedBox(width: 8 * scaleFactor),
              _buildFloatingCheck(0.0, 35 * scaleFactor, 1.0),
              SizedBox(width: 8 * scaleFactor),
              _buildFloatingCheck(0.2, 40 * scaleFactor, 0.9),
              SizedBox(width: 12 * scaleFactor),
              _buildFloatingCheck(0.15, 25 * scaleFactor, 0.7),
              SizedBox(width: 8 * scaleFactor),
              _buildFloatingCheck(-0.1, 30 * scaleFactor, 0.6),
              SizedBox(width: 8 * scaleFactor),
              _buildFloatingCheck(0.25, 28 * scaleFactor, 0.5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisc(int index, [double scaleFactor = 1.0]) {
    return Container(
      width: 80 * scaleFactor,
      height: 14 * scaleFactor,
      decoration: BoxDecoration(
        color: AppConstant.illustrationBeige,
        borderRadius: BorderRadius.circular(40 * scaleFactor),
        border: Border.all(
          color: AppConstant.illustrationBeigeOutline,
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
