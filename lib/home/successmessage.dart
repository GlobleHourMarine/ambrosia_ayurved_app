import 'package:flutter/material.dart';

//message type enum
enum MessageType {
  success,
  error,
  warning,
}

//build message
Widget _buildMessage(BuildContext context, String message,
    MessageType messageType, void Function() onClose) {
  // Define the Inter font family.
  const String _fontFamily = 'Inter';

  return Positioned(
    top: 16.0,
    left: 0,
    right: 0,
    child: Center(
      child: AnimatedOpacity(
        opacity: 1.0, // Message is always visible when this function is called
        duration: const Duration(milliseconds: 300),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: _getMessageColor(messageType),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _getMessageIcon(messageType),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: _getMessageTextColor(messageType),
                    fontSize: 16.0,
                    fontFamily: _fontFamily, // Apply the font
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: onClose,
                child: Icon(
                  Icons.close,
                  color: Colors.grey[500],
                  size: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

//get message icon
Widget _getMessageIcon(MessageType type) {
  switch (type) {
    case MessageType.success:
      return const Icon(Icons.check_circle, color: Colors.green, size: 24.0);
    case MessageType.error:
      return const Icon(Icons.error_outline, color: Colors.red, size: 24.0);
    case MessageType.warning:
      return const Icon(Icons.warning_amber_outlined,
          color: Colors.yellow, size: 24.0);
    default:
      return const SizedBox.shrink();
  }
}

//get message color
Color _getMessageColor(MessageType type) {
  switch (type) {
    case MessageType.success:
      return Colors.green[100]!.withOpacity(0.8);
    case MessageType.error:
      return Colors.red[100]!.withOpacity(0.8);
    case MessageType.warning:
      return Colors.yellow[100]!.withOpacity(0.8);
    default:
      return Colors.grey[100]!.withOpacity(0.8);
  }
}

//get message text color
Color _getMessageTextColor(MessageType type) {
  switch (type) {
    case MessageType.success:
      return Colors.green[800]!;
    case MessageType.error:
      return Colors.red[800]!;
    case MessageType.warning:
      return Colors.yellow[800]!;
    default:
      return Colors.grey[800]!;
  }
}
