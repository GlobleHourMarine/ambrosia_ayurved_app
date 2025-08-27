import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';

class SnackbarMessage {
  SnackbarMessage(BuildContext context, String s);

  /// Show a simple Snackbar with optional text and custom action
  static void showSnackbar(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? action,
    TextStyle? textStyle,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: textStyle ?? const TextStyle(color: Colors.white),
      ),
      backgroundColor: Acolors.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      duration: const Duration(seconds: 1),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: action ?? () {},
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
