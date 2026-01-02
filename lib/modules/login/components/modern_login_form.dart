import 'package:flutter/material.dart';
import 'modern_input_field.dart';
import 'modern_primary_button.dart';

class ModernLoginForm extends StatefulWidget {
  final void Function(String username, String password) onLogin;
  final bool isSaving;
  final String? initialUsername;
  const ModernLoginForm({
    super.key,
    required this.onLogin,
    this.isSaving = false,
    this.initialUsername,
  });

  @override
  State<ModernLoginForm> createState() => _ModernLoginFormState();
}

class _ModernLoginFormState extends State<ModernLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialUsername != null) {
      _usernameController.text = widget.initialUsername!;
    }
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(_usernameController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ModernInputField(
            controller: _usernameController,
            hintText: 'Username',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
            enabled: !widget.isSaving,
          ),
          const SizedBox(height: 16),
          ModernInputField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            enabled: !widget.isSaving,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
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
                  color: Colors.grey[400],
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
          const SizedBox(height: 24),
          ModernPrimaryButton(
            onPressed: (!_isFormValid || widget.isSaving) ? null : _handleLogin,
            loading: widget.isSaving,
            child: const Text(
              'Log In',
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
