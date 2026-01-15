class EmailTemplates {
  // App theme colors matching the dark theme
  static const String _primaryBlue = '#2E90FA';
  static const String _darkBackground = '#1A2332';
  static const String _cardBackground = '#243447';
  static const String _textPrimary = '#FFFFFF';
  static const String _textSecondary = '#94A3B8';
  static const String _successGreen = '#10B981';
  static const String _warningOrange = '#F59E0B';

  // TaskFlow logo as SVG (inline for email compatibility)
  static const String _appLogoSvg = '''
          <svg width="64" height="64" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
            <defs>
              <linearGradient id="taskFlowGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                <stop offset="0%" style="stop-color:#2E90FA;stop-opacity:1" />
                <stop offset="100%" style="stop-color:#1E6FD9;stop-opacity:1" />
              </linearGradient>
            </defs>
            <!-- App Icon Background -->
            <rect width="64" height="64" rx="14" fill="url(#taskFlowGradient)"/>
            <!-- Checkmark Icon -->
            <path d="M18 32L28 42L46 24" stroke="white" stroke-width="4" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
            <!-- List Lines -->
            <line x1="12" y1="18" x2="28" y2="18" stroke="white" stroke-width="3" stroke-linecap="round" opacity="0.8"/>
            <line x1="12" y1="48" x2="24" y2="48" stroke="white" stroke-width="3" stroke-linecap="round" opacity="0.8"/>
          </svg>
          ''';

  static String _getEmailTemplate({
    required String title,
    required String content,
    required String appName,
    required String currentAppVersion,
    String? footerText,
  }) {
    return '''
          <!DOCTYPE html>
          <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>$title</title>
              <style>
                  @media only screen and (max-width: 600px) {
                      .email-container {
                          width: 100% !important;
                      }
                      .email-header {
                          padding: 30px 20px 15px !important;
                      }
                      .email-content {
                          padding: 30px 20px !important;
                      }
                  }
              </style>
          </head>
          <body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: $_darkBackground;">
              <table role="presentation" style="width: 100%; border-collapse: collapse; background-color: $_darkBackground;">
                  <tr>
                      <td align="center" style="padding: 40px 20px;">
                          <!-- Main Email Container -->
                          <table role="presentation" class="email-container" style="width: 600px; max-width: 100%; border-collapse: collapse; background-color: $_cardBackground; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.3); overflow: hidden;">
                              
                              <!-- Header with App Logo and Branding -->
                              <tr>
                                  <td class="email-header" style="padding: 40px 40px 20px; text-align: center; background: linear-gradient(135deg, $_primaryBlue 0%, #1E6FD9 100%);">
                                      <!-- App Logo -->
                                      <div style="margin-bottom: 16px;">
                                          $_appLogoSvg
                                      </div>
                                      <!-- App Name -->
                                      <h1 style="margin: 0; color: $_textPrimary; font-size: 32px; font-weight: 700; letter-spacing: -0.5px;">$appName</h1>
                                      <p style="margin: 8px 0 0; color: rgba(255,255,255,0.95); font-size: 15px; font-weight: 500;">Organize. Collaborate. Achieve.</p>
                                  </td>
                              </tr>
                              
                              <!-- Content Area -->
                              <tr>
                                  <td class="email-content" style="padding: 40px; background-color: $_cardBackground;">
                                      $content
                                  </td>
                              </tr>
                              
                              <!-- Decorative Divider -->
                              <tr>
                                  <td style="padding: 0 40px;">
                                      <div style="height: 1px; background: linear-gradient(90deg, transparent 0%, $_textSecondary 50%, transparent 100%); opacity: 0.2;"></div>
                                  </td>
                              </tr>
                              
                              <!-- Footer -->
                              <tr>
                                  <td style="padding: 30px 40px; background-color: $_darkBackground; text-align: center;">
                                      <p style="margin: 0 0 12px; color: $_textSecondary; font-size: 14px; line-height: 1.6;">${footerText ?? 'Organize your work. Get things done!'}</p>
                                      <div style="margin: 12px 0;">
                                          <span style="display: inline-block; width: 32px; height: 32px; border-radius: 8px; background-color: $_cardBackground; padding: 6px; margin: 0 4px;">
                                              <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                                  <path d="M5 10L9 14L15 8" stroke="$_primaryBlue" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                              </svg>
                                          </span>
                                      </div>
                                      <p style="margin: 12px 0 0; color: $_textSecondary; font-size: 12px; opacity: 0.7;">
                                          © ${DateTime.now().year} $appName · Version $currentAppVersion
                                      </p>
                                  </td>
                              </tr>
                          </table>
                          
                          <!-- Email Client Support Message -->
                          <table role="presentation" style="width: 600px; max-width: 100%; margin-top: 20px;">
                              <tr>
                                  <td style="text-align: center; padding: 0 20px;">
                                      <p style="margin: 0; color: $_textSecondary; font-size: 11px; opacity: 0.6;">
                                          This email was sent by $appName. If you have any questions, please contact our support team.
                                      </p>
                                  </td>
                              </tr>
                          </table>
                      </td>
                  </tr>
              </table>
          </body>
          </html>
        ''';
  }

  /// Contact form submission email to admins
  static String getContactFormEmail({
    required String category,
    required String subject,
    required String message,
    required String senderEmail,
    required String appName,
    required String currentAppVersion,
  }) {
    final content =
        '''
        <h2 style="margin: 0 0 24px; color: $_textPrimary; font-size: 24px; font-weight: 600;">New Contact Form Submission</h2>
        <div style="background-color: $_darkBackground; border-left: 4px solid $_primaryBlue; padding: 20px; margin-bottom: 20px; border-radius: 8px;">
            <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Category</p>
            <p style="margin: 0; color: $_textPrimary; font-size: 16px; font-weight: 500;">$category</p>
        </div>

        <div style="background-color: $_darkBackground; border-left: 4px solid $_primaryBlue; padding: 20px; margin-bottom: 20px; border-radius: 8px;">
            <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Subject</p>
            <p style="margin: 0; color: $_textPrimary; font-size: 16px; font-weight: 500;">$subject</p>
        </div>

        <div style="background-color: $_darkBackground; border-left: 4px solid $_primaryBlue; padding: 20px; margin-bottom: 24px; border-radius: 8px;">
            <p style="margin: 0 0 12px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Message</p>
            <p style="margin: 0; color: $_textPrimary; font-size: 15px; line-height: 1.6; white-space: pre-wrap;">$message</p>
        </div>

        <div style="padding: 20px; background: linear-gradient(135deg, $_primaryBlue 0%, #1E6FD9 100%); border-radius: 8px; margin-top: 24px;">
            <p style="margin: 0; color: rgba(255,255,255,0.9); font-size: 14px;">
                <strong style="color: white;">Reply to:</strong> <a href="mailto:$senderEmail" style="color: white; text-decoration: none; border-bottom: 1px solid rgba(255,255,255,0.5);">$senderEmail</a>
            </p>
        </div>
        ''';

    return _getEmailTemplate(
      title: 'New Contact Form Submission',
      content: content,
      footerText: 'This message was sent from $appName contact form',
      appName: appName,
      currentAppVersion: currentAppVersion,
    );
  }

  /// Welcome email to new user
  static String getWelcomeEmail({
    required String username,
    required String fullName,
    required String appName,
    required String currentAppVersion,
  }) {
    final content =
        '''
        <h2 style="margin: 0 0 16px; color: $_textPrimary; font-size: 26px; font-weight: 600;">Welcome to $appName! 🎉</h2>

        <p style="margin: 0 0 20px; color: $_textSecondary; font-size: 16px; line-height: 1.6;">
            Hi <strong style="color: $_textPrimary;">$fullName</strong>,
        </p>

        <p style="margin: 0 0 24px; color: $_textSecondary; font-size: 16px; line-height: 1.6;">
            Thank you for joining $appName! Your account has been created, and you're ready to organize your tasks and boost your productivity.
        </p>

        <div style="background: linear-gradient(135deg, $_primaryBlue 0%, #1E6FD9 100%); padding: 24px; border-radius: 12px; margin: 24px 0;">
            <h3 style="margin: 0 0 16px; color: white; font-size: 20px; font-weight: 600;">Your Account Details</h3>
            <p style="margin: 0; color: rgba(255,255,255,0.95); font-size: 15px;">
                <strong>Username:</strong> $username
            </p>
        </div>

        <h3 style="margin: 32px 0 16px; color: $_textPrimary; font-size: 20px; font-weight: 600;">Get Started</h3>

        <div style="margin-bottom: 16px;">
            <div style="padding: 20px; background-color: $_darkBackground; border-radius: 8px; margin-bottom: 12px; border-left: 3px solid $_successGreen;">
                <div style="margin-bottom: 8px;">
                    <span style="display: inline-block; width: 32px; height: 32px; line-height: 32px; text-align: center; font-size: 18px; background-color: $_cardBackground; border-radius: 6px;">✅</span>
                </div>
                <strong style="color: $_textPrimary; font-size: 16px; display: block; margin-bottom: 4px;">Create and Manage Tasks</strong>
                <p style="margin: 0; color: $_textSecondary; font-size: 14px; line-height: 1.5;">Stay organized by creating, editing, and tracking your tasks.</p>
            </div>
            
            <div style="padding: 20px; background-color: $_darkBackground; border-radius: 8px; margin-bottom: 12px; border-left: 3px solid $_primaryBlue;">
                <div style="margin-bottom: 8px;">
                    <span style="display: inline-block; width: 32px; height: 32px; line-height: 32px; text-align: center; font-size: 18px; background-color: $_cardBackground; border-radius: 6px;">🤝</span>
                </div>
                <strong style="color: $_textPrimary; font-size: 16px; display: block; margin-bottom: 4px;">Collaborate with Your Team</strong>
                <p style="margin: 0; color: $_textSecondary; font-size: 14px; line-height: 1.5;">Assign tasks, set deadlines, and work together efficiently.</p>
            </div>
            
            <div style="padding: 20px; background-color: $_darkBackground; border-radius: 8px; border-left: 3px solid $_warningOrange;">
                <div style="margin-bottom: 8px;">
                    <span style="display: inline-block; width: 32px; height: 32px; line-height: 32px; text-align: center; font-size: 18px; background-color: $_cardBackground; border-radius: 6px;">📈</span>
                </div>
                <strong style="color: $_textPrimary; font-size: 16px; display: block; margin-bottom: 4px;">Track Your Progress</strong>
                <p style="margin: 0; color: $_textSecondary; font-size: 14px; line-height: 1.5;">Monitor your productivity and achieve your goals.</p>
            </div>
        </div>

        <p style="margin: 32px 0 0; color: $_textSecondary; font-size: 15px; line-height: 1.6;">
            Need help? Contact our support team anytime. We're here to help you succeed!
        </p>
        ''';

    return _getEmailTemplate(
      title: 'Welcome to $appName',
      content: content,
      appName: appName,
      currentAppVersion: currentAppVersion,
    );
  }

  /// New signup notification to admins
  static String getNewSignupNotificationEmail({
    required String username,
    required String fullName,
    required String email,
    required String appName,
    required String currentAppVersion,
  }) {
    final content =
        '''
          <h2 style="margin: 0 0 24px; color: $_textPrimary; font-size: 24px; font-weight: 600;">New User Registration 🎉</h2>

          <p style="margin: 0 0 24px; color: $_textSecondary; font-size: 16px; line-height: 1.6;">
              A new user has successfully registered on $appName!
          </p>

          <div style="background-color: $_darkBackground; border-left: 4px solid $_successGreen; padding: 20px; margin-bottom: 16px; border-radius: 8px;">
              <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Full Name</p>
              <p style="margin: 0; color: $_textPrimary; font-size: 16px; font-weight: 500;">$fullName</p>
          </div>

          <div style="background-color: $_darkBackground; border-left: 4px solid $_successGreen; padding: 20px; margin-bottom: 16px; border-radius: 8px;">
              <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Username</p>
              <p style="margin: 0; color: $_textPrimary; font-size: 16px; font-weight: 500;">$username</p>
          </div>

          <div style="background-color: $_darkBackground; border-left: 4px solid $_successGreen; padding: 20px; margin-bottom: 24px; border-radius: 8px;">
              <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Email</p>
              <p style="margin: 0; color: $_textPrimary; font-size: 16px; font-weight: 500;">
                  <a href="mailto:$email" style="color: $_primaryBlue; text-decoration: none; border-bottom: 1px solid $_primaryBlue;">$email</a>
              </p>
          </div>

          <div style="padding: 20px; background: linear-gradient(135deg, $_successGreen 0%, #0D9668 100%); border-radius: 8px; margin-top: 24px;">
              <p style="margin: 0; color: white; font-size: 14px;">
                  <strong>Registration Time:</strong> ${DateTime.now().toString().substring(0, 19)}
              </p>
          </div>
          ''';

    return _getEmailTemplate(
      title: 'New User Registration',
      content: content,
      footerText: 'Admin notification from $appName',
      appName: appName,
      currentAppVersion: currentAppVersion,
    );
  }

  /// In-app notification email template
  static String getInAppNotificationEmail({
    required String notificationTitle,
    required String notificationBody,
    required String notificationType,
    required DateTime createdAt,
    required String appName,
    required String currentAppVersion,
    String? actorUsername,
  }) {
    // Determine notification color based on type
    final typeColor = _getNotificationTypeColor(notificationType);
    final typeIcon = _getNotificationTypeIcon(notificationType);
    
    final actorInfo = actorUsername != null
        ? '''
        <div style="background-color: $_darkBackground; border-left: 4px solid $typeColor; padding: 20px; margin-bottom: 16px; border-radius: 8px;">
            <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">From</p>
            <p style="margin: 0; color: $_textPrimary; font-size: 16px; font-weight: 500;">$actorUsername</p>
        </div>
        '''
        : '';

    final content = '''
        <h2 style="margin: 0 0 24px; color: $_textPrimary; font-size: 24px; font-weight: 600;">$notificationTitle</h2>

        <div style="background: linear-gradient(135deg, $typeColor 0%, ${_getDarkerShade(typeColor)} 100%); padding: 20px; border-radius: 12px; margin: 24px 0;">
            <div style="margin-bottom: 12px;">
                <span style="display: inline-block; width: 40px; height: 40px; line-height: 40px; text-align: center; font-size: 20px; background-color: rgba(255,255,255,0.2); border-radius: 8px;">$typeIcon</span>
            </div>
            <p style="margin: 0 0 8px; color: rgba(255,255,255,0.9); font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Notification Type</p>
            <p style="margin: 0; color: white; font-size: 16px; font-weight: 500;">${_formatNotificationType(notificationType)}</p>
        </div>

        <div style="background-color: $_darkBackground; border-left: 4px solid $typeColor; padding: 20px; margin-bottom: 20px; border-radius: 8px;">
            <p style="margin: 0 0 8px; color: $_textSecondary; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Message</p>
            <p style="margin: 0; color: $_textPrimary; font-size: 16px; line-height: 1.6; white-space: pre-wrap;">$notificationBody</p>
        </div>

        $actorInfo

        <div style="padding: 20px; background-color: $_darkBackground; border-radius: 8px; margin-top: 24px;">
            <p style="margin: 0; color: $_textSecondary; font-size: 14px;">
                <strong style="color: $_textPrimary;">Notification Time:</strong> ${_formatNotificationDateTime(createdAt)}
            </p>
        </div>

        <p style="margin: 32px 0 0; color: $_textSecondary; font-size: 15px; line-height: 1.6; text-align: center;">
            To manage your notification preferences, open the app and go to <strong style="color: $_textPrimary;">Settings → Notification Preferences</strong>.
        </p>
        ''';

    return _getEmailTemplate(
      title: notificationTitle,
      content: content,
      footerText: 'Stay updated with your tasks and team activities',
      appName: appName,
      currentAppVersion: currentAppVersion,
    );
  }

  /// Helper: Get color for notification type
  static String _getNotificationTypeColor(String type) {
    switch (type) {
      case 'task_assigned':
      case 'team_invite':
        return _primaryBlue;
      case 'deadline_reminder':
      case 'task_overdue':
        return '#EF4444'; // Red
      case 'task_completed':
      case 'team_member_added':
        return _successGreen;
      case 'task_status_change':
      case 'task_priority_change':
        return _warningOrange;
      case 'system':
        return '#94A3B8'; // Gray
      default:
        return _primaryBlue;
    }
  }

  /// Helper: Get icon for notification type
  static String _getNotificationTypeIcon(String type) {
    switch (type) {
      case 'task_assigned':
        return '📋';
      case 'task_completed':
        return '✅';
      case 'task_status_change':
        return '🔄';
      case 'task_priority_change':
        return '⚡';
      case 'deadline_reminder':
        return '⏰';
      case 'task_overdue':
        return '⚠️';
      case 'team_invite':
        return '👥';
      case 'team_member_added':
        return '🤝';
      case 'team_member_removed':
        return '👋';
      case 'system':
        return '🔔';
      default:
        return '📬';
    }
  }

  /// Helper: Get darker shade of color
  static String _getDarkerShade(String color) {
    // Simple darkening by reducing brightness
    switch (color) {
      case '#2E90FA':
        return '#1E6FD9';
      case '#EF4444':
        return '#DC2626';
      case '#10B981':
        return '#0D9668';
      case '#F59E0B':
        return '#D97706';
      case '#94A3B8':
        return '#64748B';
      default:
        return '#1E6FD9';
    }
  }

  /// Helper: Format notification type
  static String _formatNotificationType(String type) {
    return type
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Helper: Format notification date time
  static String _formatNotificationDateTime(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$month $day, $year at $hour:$minute';
  }
}
