import 'package:flutter/material.dart';
import '../widgets/app_notification.dart';

import 'package:flutter/foundation.dart';

class NotificationService {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    bool isError = false,
    VoidCallback? onRetry,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

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
        width: isWide ? 400 : null, // Limitamos el ancho en Web
        margin: isWide ? null : const EdgeInsets.fromLTRB(20, 0, 20, 80),
      ),
    );
  }
}
