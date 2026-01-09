import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_constant.dart';

class DialogUtils {
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstant.cardBackground,
          title: Text(title, style: TextStyle(color: AppConstant.textPrimary)),
          content: Text(
            message,
            style: TextStyle(color: AppConstant.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                confirmText,
                style: TextStyle(color: confirmColor ?? AppConstant.errorRed),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppConstant.cardBackground,
          title: Text(title, style: TextStyle(color: AppConstant.textPrimary)),
          content: Text(
            message,
            style: TextStyle(color: AppConstant.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
