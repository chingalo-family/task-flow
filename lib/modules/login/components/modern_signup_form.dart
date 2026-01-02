import 'package:flutter/material.dart';
import 'package:task_flow/core/utils/app_util.dart';
import 'package:task_flow/modules/login/components/modern_input_field.dart';
import 'package:task_flow/modules/login/components/modern_primary_button.dart';

class ModernSignupForm extends StatefulWidget {
  final Function(
    String firstName,
    String surname,
    String email,
    String phoneNumber,
  )
  onSignup;
  final bool isSaving;

  const ModernSignupForm({
    super.key,
    required this.onSignup,
    this.isSaving = false,
  });

  @override
  State<ModernSignupForm> createState() => _ModernSignupFormState();
}

class _ModernSignupFormState extends State<ModernSignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateForm);
    _surnameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneNumberController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _firstNameController.text.isNotEmpty &&
          _surnameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneNumberController.text.isNotEmpty;
    });
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      widget.onSignup(
        _firstNameController.text,
        _surnameController.text,
        _emailController.text,
        _phoneNumberController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ModernInputField(
            controller: _firstNameController,
            hintText: 'First Name',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernInputField(
            controller: _surnameController,
            hintText: 'Surname',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your surname';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernInputField(
            controller: _emailController,
            hintText: 'E-mail',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
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
          const SizedBox(height: 16),
          ModernInputField(
            controller: _phoneNumberController,
            hintText: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (!AppUtil.isPhoneNumberValid(value)) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          ModernPrimaryButton(
            onPressed: (!_isFormValid || widget.isSaving)
                ? null
                : _handleSignup,
            loading: widget.isSaving,
            child: const Text(
              'Request Account',
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
