class Order {
  final String orderId;
  final String userId;
  final String productId;
  final int status;
  final String productPrice;
  final String productQuantity;
  final String totalPrice;
  final String productName;
  final String date;
  final String image;

  Order(
      {required this.orderId,
      required this.userId,
      required this.productId,
      required this.status,
      required this.productPrice,
      required this.productQuantity,
      required this.productName,
      required this.totalPrice,
      required this.date,
      required this.image});

  // Factory method to create an Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] ?? '',
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      status: int.tryParse(json['status'].toString()) ??
          -1, // Convert to int safely, default to -1 if invalid
      productPrice: json['product_price'] ?? '',
      productQuantity: json['product_quantity'] ?? '',
      productName: json['product_name'] ?? '',
      totalPrice: json['total_price'] ?? '',
      date: json['date'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'product_id': productId,
      'status': status,
      'product_price': productPrice,
      'product_quantity': productQuantity,
      'product_name': productName,
      'total_price': totalPrice,
      'date': date,
      'image': image,
    };
  }
}
