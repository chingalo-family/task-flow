import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/email_connection.dart';
import 'package:task_flow/core/models/email_notification.dart';
import 'package:task_flow/core/services/email_service.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/modules/login/components/modern_signup_form.dart';

class UserAccountRequestForm extends StatefulWidget {
  const UserAccountRequestForm({super.key});

  @override
  State<UserAccountRequestForm> createState() => _UserAccountRequestFormState();
}

class _UserAccountRequestFormState extends State<UserAccountRequestForm> {
  bool _isSaving = false;

  void onSignUp(
    String firstName,
    String surname,
    String email,
    String phoneNumber,
    String password,
  ) async {
    String fullName = '$firstName $surname';
    if (AppUtil.isEmailValid(email)) {
      if (AppUtil.isPhoneNumberValid(phoneNumber)) {
        setState(() {
          _isSaving = true;
        });

        EmailNotification confirmationEmail = EmailNotification(
          recipients: [email],
          subject: 'Task Flow App Account Request',
          textBody:
              'Hello $fullName,\n\nYour request has been sent successfully, we are currently processing this request and will get back to you within two business days.\n\nRegards\nSupport Team',
          htmlBody:
              '''
                <!DOCTYPE html>
                <html>
                <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                </head>
                <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; margin: 0; padding: 0;">
                  <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                    <!-- Header -->
                    <div style="background-color: #2AADB1; color: #ffffff; padding: 30px 20px; text-align: center;">
                      <h1 style="margin: 0; font-size: 24px;">Task Flow App</h1>
                    </div>
                    
                    <!-- Content -->
                    <div style="padding: 30px 20px;">
                      <h2 style="color: #2AADB1; margin-top: 0;">Hello $fullName,</h2>
                      
                      <p style="font-size: 16px; line-height: 1.8;">
                        Thank you for your interest in Task Flow App! 
                      </p>
                      
                      <p style="font-size: 16px; line-height: 1.8;">
                        Your account request has been <strong>successfully received</strong>. We are currently processing your request and will get back to you within <strong>two business days</strong>.
                      </p>
                      
                      <div style="background-color: #f8f9fa; border-left: 4px solid #2AADB1; padding: 15px; margin: 20px 0; border-radius: 4px;">
                        <p style="margin: 0; font-size: 14px; color: #666;">
                          <strong>What's next?</strong><br>
                          Our team will review your request and send you login credentials via email once your account is ready.
                        </p>
                      </div>
                      
                      <p style="font-size: 16px; line-height: 1.8; margin-bottom: 30px;">
                        If you have any questions, feel free to contact our support team.
                      </p>
                      
                      <p style="font-size: 16px; margin-bottom: 5px;">
                        Best regards,<br>
                        <strong>Support Team</strong><br>
                        Task Flow App
                      </p>
                    </div>
                    
                    <!-- Footer -->
                    <div style="background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #e9ecef;">
                      <p style="margin: 0; font-size: 12px; color: #6c757d;">
                        This is an automated message, please do not reply to this email.
                      </p>
                      <p style="margin: 5px 0 0 0; font-size: 12px; color: #6c757d;">
                        Support Hours: 8AM - 6PM East Africa Time
                      </p>
                    </div>
                  </div>
                </body>
                </html>
                ''',
        );

        // Admin notification email with HTML content
        EmailNotification requestEmail = EmailNotification(
          recipients: EmailConnection.adminEmails,
          subject: '[$fullName] Task Flow App Account Request',
          textBody:
              'Dear Admin Team,\n\n$fullName has requested an account to access Task Flow App. See more information below:\n\nFull name: $fullName\nE-mail: $email\nPhone number: $phoneNumber\n\nPlease review and process this request.',
          htmlBody:
              '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; margin: 0; padding: 0;">
            <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
              <!-- Header -->
              <div style="background-color: #2AADB1; color: #ffffff; padding: 30px 20px; text-align: center;">
                <h1 style="margin: 0; font-size: 24px;">New Account Request</h1>
              </div>
              
              <!-- Content -->
              <div style="padding: 30px 20px;">
                <h2 style="color: #2AADB1; margin-top: 0;">Dear Admin Team,</h2>
                
                <p style="font-size: 16px; line-height: 1.8;">
                  A new user has requested an account to access <strong>Task Flow App</strong>.
                </p>
                
                <!-- User Details Card -->
                <div style="background-color: #f8f9fa; border-radius: 8px; padding: 20px; margin: 25px 0;">
                  <h3 style="margin-top: 0; color: #333; font-size: 18px; border-bottom: 2px solid #2AADB1; padding-bottom: 10px;">
                    User Information
                  </h3>
                  
                  <table style="width: 100%; border-collapse: collapse;">
                    <tr>
                      <td style="padding: 10px 0; font-weight: bold; color: #666; width: 40%;">Full Name:</td>
                      <td style="padding: 10px 0; color: #333;">$fullName</td>
                    </tr>
                    <tr style="background-color: #ffffff;">
                      <td style="padding: 10px 0; font-weight: bold; color: #666;">Email:</td>
                      <td style="padding: 10px 0; color: #333;"><a href="mailto:$email" style="color: #2AADB1; text-decoration: none;">$email</a></td>
                    </tr>
                    <tr>
                      <td style="padding: 10px 0; font-weight: bold; color: #666;">Phone Number:</td>
                      <td style="padding: 10px 0; color: #333;"><a href="tel:$phoneNumber" style="color: #2AADB1; text-decoration: none;">$phoneNumber</a></td>
                    </tr>
                  </table>
                </div>
                
                <div style="background-color: #e0f7f8; border-left: 4px solid #2AADB1; padding: 15px; margin: 20px 0; border-radius: 4px;">
                  <p style="margin: 0; font-size: 14px; color: #1a7f83;">
                    <strong>Action Required:</strong><br>
                    Please review this request and create an account for the user. Send them their login credentials once the account is set up.
                  </p>
                </div>
                
                <p style="font-size: 14px; color: #6c757d; margin-top: 30px;">
                  This is an automated notification sent from Task Flow App.
                </p>
              </div>
              
              <!-- Footer -->
              <div style="background-color: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #e9ecef;">
                <p style="margin: 0; font-size: 12px; color: #6c757d;">
                  Task Flow App - Admin Notification System
                </p>
              </div>
            </div>
          </body>
          </html>
          ''',
        );
        await EmailService.sendEmail(emailNotification: confirmationEmail);
        await EmailService.sendEmail(emailNotification: requestEmail);
        _returnLoginPage(fullName);
      } else {
        AppUtil.showToastMessage(
          message: 'Phone number is not valid, kindly cross check',
        );
      }
    } else {
      AppUtil.showToastMessage(
        message: 'email is not valid, kindly cross check',
      );
    }
    setState(() {
      _isSaving = false;
    });
  }

  void _returnLoginPage(String fullName) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, {'fullName': fullName});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'User Account Request',
                style: const TextStyle().copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ModernSignupForm(isSaving: _isSaving, onSignUp: onSignUp),
          ],
        ),
      ),
    );
  }
}
