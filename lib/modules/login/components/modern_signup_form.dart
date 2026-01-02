import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/modules/login/components/modern_input_field.dart';
import 'package:task_flow/modules/login/components/modern_primary_button.dart';

class ModernSignupForm extends StatefulWidget {
  final Function(
    String username,
    String email,
    String password,
  ) onSignUp;
  final bool isSaving;

  const ModernSignupForm({
    super.key,
    required this.onSignUp,
    this.isSaving = false,
  });

  @override
  State<ModernSignupForm> createState() => _ModernSignupFormState();
}

class _ModernSignupFormState extends State<ModernSignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _usernameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        AppUtil.showToastMessage(message: 'Passwords do not match');
        return;
      }
      widget.onSignUp(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ModernInputField(
            controller: _usernameController,
            hintText: 'Username',
            icon: Icons.person_outline_rounded,
            enabled: !widget.isSaving,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (value.length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          SizedBox(height: AppConstant.spacing16),
          ModernInputField(
            controller: _emailController,
            hintText: 'Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: !widget.isSaving,
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
          SizedBox(height: AppConstant.spacing16),
          ModernInputField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            enabled: !widget.isSaving,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppConstant.textSecondary,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: AppConstant.spacing16),
          ModernInputField(
            controller: _confirmPasswordController,
            hintText: 'Confirm Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirmPassword,
            enabled: !widget.isSaving,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppConstant.textSecondary,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
          
          SizedBox(height: AppConstant.spacing24),

          ModernPrimaryButton(
            onPressed: (!_isFormValid || widget.isSaving)
                ? null
                : _handleSignup,
            loading: widget.isSaving,
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
