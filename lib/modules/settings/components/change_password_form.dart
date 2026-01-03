import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/app_state/user_state/user_state.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/components/components.dart';
import 'package:task_flow/core/utils/utils.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Current password is required';
    }
    // Note: Password validation is done server-side during the change password request
    // This is just a client-side check for non-empty input
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }
    if (!AppUtil.isPasswordValid(value)) {
      return 'Password must be at least 8 characters with uppercase, lowercase, number and special character';
    }
    if (value == _currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userState = Provider.of<UserState>(context, listen: false);
      final success = await userState.changeCurrentUserPassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );
      
      if (mounted) {
        if (success) {
          AppUtil.showToastMessage(message: 'Password changed successfully!');
          Navigator.pop(context);
        } else {
          AppUtil.showToastMessage(
            message: 'Failed to change password. Please check your current password.',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppUtil.showToastMessage(message: 'Failed to change password: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstant.cardBackground,
        borderRadius: BorderRadius.circular(AppConstant.borderRadius12),
        border: Border.all(
          color: AppConstant.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: AppConstant.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppConstant.textSecondary, fontSize: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 12),
            child: Icon(
              Icons.lock_outline_rounded,
              color: AppConstant.textSecondary,
              size: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppConstant.textSecondary,
                size: 22,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 18,
          ),
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstant.spacing24),
      decoration: BoxDecoration(
        color: AppConstant.darkBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstant.borderRadius24),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppConstant.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: AppConstant.spacing24),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      color: AppConstant.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppConstant.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: AppConstant.spacing8),
              Text(
                'Your new password must be different from your current password',
                style: TextStyle(
                  color: AppConstant.textSecondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: AppConstant.spacing32),

              // Current Password Field
              _buildPasswordField(
                controller: _currentPasswordController,
                hintText: 'Current Password',
                obscureText: _obscureCurrentPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
                validator: _validateCurrentPassword,
              ),
              SizedBox(height: AppConstant.spacing16),

              // New Password Field
              _buildPasswordField(
                controller: _newPasswordController,
                hintText: 'New Password',
                obscureText: _obscureNewPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
                validator: _validateNewPassword,
              ),
              SizedBox(height: AppConstant.spacing16),

              // Confirm Password Field
              _buildPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm New Password',
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                validator: _validateConfirmPassword,
              ),
              SizedBox(height: AppConstant.spacing32),

              // Submit Button
              PrimaryButton(
                onPressed: _handleChangePassword,
                loading: _isLoading,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: AppConstant.spacing16),
            ],
          ),
        ),
      ),
    );
  }
}
