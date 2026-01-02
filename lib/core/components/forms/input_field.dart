import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enabled;
  final Widget? suffixIcon;
  final int? maxLines;
  final String? labelText;
  final void Function(String)? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.suffixIcon,
    this.maxLines,
    this.labelText,
    this.onChanged,
  });

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
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines ?? (obscureText ? 1 : null),
        minLines: 1,
        onChanged: onChanged,
        style: TextStyle(color: AppConstant.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: AppConstant.textSecondary, fontSize: 14),
          hintText: hintText,
          hintStyle: TextStyle(color: AppConstant.textSecondary, fontSize: 16),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 12, top: maxLines != null && maxLines! > 1 ? 12 : 0),
            child: Icon(icon, color: AppConstant.textSecondary, size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: maxLines != null && maxLines! > 1 ? 16 : 18,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
