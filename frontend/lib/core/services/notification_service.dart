import 'package:flutter/material.dart';
import '../widgets/app_notification.dart';

class NotificationService {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    bool isError = false,
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppNotification(
          title: title,
          message: message,
          isError: isError,
          onRetry: onRetry,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      ),
    );
  }
}
