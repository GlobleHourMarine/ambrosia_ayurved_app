class Review {
  final String reviewId;
  final String userId;
  final String productId;
  final String rating;
  final String message;
  final String date;
  final String productName;
  final String image;
  final String fname;

  Review({
    required this.reviewId,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.message,
    required this.date,
    required this.productName,
    required this.image,
    required this.fname,
  });

  // Factory constructor to create a Review object from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['review_id'] ?? '',
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      rating: json['rating'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      productName: json['product_name'] ?? '',
      image: json['image'] ?? '',
      fname: json['fname'] ?? '',
    );
  }

  // Convert Review object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'review_id': reviewId,
      'user_id': userId,
      'product_id': productId,
      'rating': rating,
      'message': message,
      'date': date,
      'product_name': productName,
      'image': image,
      'fname': fname,
    };
  }
}
