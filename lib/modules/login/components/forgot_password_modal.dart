import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/modules/login/components/modern_input_field.dart';
import 'package:task_flow/modules/login/components/modern_primary_button.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final userState = Provider.of<UserState>(context, listen: false);
        final success = await userState.requestForgetPassword(
          _emailController.text.trim(),
        );
        if (success) {
          if (mounted) {
            Navigator.of(context).pop();
            AppUtil.showToastMessage(
              message: 'Password reset instructions sent to your email',
            );
          }
        } else {
          if (mounted) {
            AppUtil.showToastMessage(
              message: 'Failed to send reset email. Please try again.',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          AppUtil.showToastMessage(message: 'Error: ${e.toString()}');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
        border: Border.all(
          color: AppConstant.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(AppConstant.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.lock_reset, color: AppConstant.primaryBlue, size: 28),
              SizedBox(width: AppConstant.spacing12),
              Expanded(
                child: Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppConstant.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          SizedBox(height: AppConstant.spacing16),

          // Description
          Text(
            'Enter your email address and we\'ll send you instructions to reset your password.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppConstant.textSecondary),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Form
          Form(
            key: _formKey,
            child: ModernInputField(
              controller: _emailController,
              hintText: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!AppUtil.isEmailValid(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),

          SizedBox(height: AppConstant.spacing24),

          // Submit button
          ModernPrimaryButton(
            onPressed: _isLoading ? null : _handleSubmit,
            loading: _isLoading,
            child: Text(
              'Send Reset Link',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: AppConstant.spacing12),

          // Cancel button
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppConstant.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
