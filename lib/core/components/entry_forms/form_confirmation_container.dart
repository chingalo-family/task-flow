import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_contant.dart';

class FormConfirmationContainer extends StatelessWidget {
  const FormConfirmationContainer({
    super.key,
    required this.onConfirm,
    required this.confirmLabel,
  });

  final VoidCallback onConfirm;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: OutlinedButton(
            style: const ButtonStyle().copyWith(
              foregroundColor:
                  WidgetStatePropertyAll(AppContant.defaultAppColor),
              side: WidgetStatePropertyAll(
                const BorderSide().copyWith(
                  color: AppContant.defaultAppColor,
                ),
              ),
              textStyle: WidgetStateProperty.all(
                const TextStyle().copyWith(
                  color: AppContant.defaultAppColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: FilledButton(
            style: const ButtonStyle().copyWith(
              backgroundColor:
                  WidgetStateProperty.all(AppContant.defaultAppColor),
              textStyle: WidgetStateProperty.all(
                const TextStyle().copyWith(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            onPressed: onConfirm,
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
