class PlaceOrderModel {
  final String userId;
  final String productId;
  final String quantity;
  final String productPrice;
  final String totalPrice;


  PlaceOrderModel({
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.productPrice,
    required this.totalPrice,
  });

  // Factory constructor to create an instance from JSON
  factory PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderModel(
      userId: json['user_id'] ?? '',
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? '',
      productPrice: json['product_price'] ?? '',
      totalPrice: json['total_price'] ?? '',
    );
  }
 

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "product_id": productId,
      "quantity": quantity,
      "product_price": productPrice,
      "total_price": totalPrice,
    };
  }
}
