import 'package:flutter/material.dart';
import 'dart:async';

class SuccessPopup {
  static void show({
    required BuildContext context,
    required String title,
    String? subtitle,
    String buttonText = 'OK',
    IconData icon = Icons.check_circle,
    Color iconColor = Colors.green,
    Color backgroundColor = Colors.white,
    int autoCloseDuration = 3, // in seconds
    Widget? navigateToScreen,
    VoidCallback? onClose,
  }) {
    // Show the popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Start timer for auto-close if duration is set
        if (autoCloseDuration > 0) {
          Timer(Duration(seconds: autoCloseDuration), () {
            Navigator.of(context).pop(); // Close the popup
            if (navigateToScreen != null) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => navigateToScreen,
                  ));
            }
            onClose?.call();
          });
        }

        return PopScope(
          canPop: false, // Prevent back button from closing
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: backgroundColor,
            content: SizedBox(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Customizable icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      icon,
                      size: 50,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Custom title

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Custom subtitle (optional)
                  if (subtitle != null)
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Show button if no auto-close, otherwise show loader
                  if (autoCloseDuration <= 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: iconColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (navigateToScreen != null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => navigateToScreen,
                              ));
                        }
                        onClose?.call();
                      },
                      child: Text(
                        buttonText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
