import 'dart:convert';

class Review {
  final String reviewId;
  final String userId;
  final String productId;
  final String orderId;
  final String rating;
  final List<String> filePath; // Changed from String to List<String>
  final String message;
  final String date;
  final String productName;
  final String image;
  final String fname;

  Review({
    required this.reviewId,
    required this.userId,
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.filePath,
    required this.message,
    required this.date,
    required this.productName,
    required this.image,
    required this.fname,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '',
      filePath: _parseFilePath(json['file_path']), // Handle the list conversion
      message: json['message']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      fname: json['fname']?.toString() ?? '',
    );
  }

  // Helper method to convert file_path from various formats to List<String>
  static List<String> _parseFilePath(dynamic filePath) {
    if (filePath == null) return [];

    // If it's already a List
    if (filePath is List) {
      return filePath
          .map((item) => item.toString().trim())
          .where((path) => path.isNotEmpty)
          .toList();
    }

    // If it's a String (fallback for backward compatibility)
    if (filePath is String) {
      if (filePath.isEmpty) return [];

      try {
        // Try to decode JSON if it's a JSON array string
        if (filePath.trim().startsWith('[') && filePath.trim().endsWith(']')) {
          List<dynamic> jsonArray = jsonDecode(filePath);
          return jsonArray
              .map((item) => item.toString().trim())
              .where((path) => path.isNotEmpty)
              .toList();
        } else {
          // Handle single file path or comma-separated
          return filePath
              .split(',')
              .map((path) => path.trim())
              .where((path) => path.isNotEmpty)
              .toList();
        }
      } catch (e) {
        // If JSON parsing fails, treat as single path
        return [filePath];
      }
    }

    // Fallback: convert to string and return as single item
    return [filePath.toString()];
  }

  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'user_id': userId,
      'product_id': productId,
      'order_id': orderId,
      'rating': rating,
      'file_path': filePath,
      'message': message,
      'date': date,
      'product_name': productName,
      'image': image,
      'fname': fname,
    };
  }

  // Getter for backward compatibility if you have existing code expecting a single string
  String get firstFilePath => filePath.isNotEmpty ? filePath.first : '';

  // Check if review has media files
  bool get hasMedia => filePath.isNotEmpty;

  // Get count of media files
  int get mediaCount => filePath.length;
}
