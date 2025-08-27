class PlaceOrderModel {
  final String userId;
  final String addressId;
  final String productId;
  final String quantity;
  final String orderId;
  final String productPrice;
  final String totalPrice;

  PlaceOrderModel({
    required this.userId,
    required this.addressId,
    required this.productId,
    required this.quantity,
    required this.orderId,
    required this.productPrice,
    required this.totalPrice,
  });

  // Factory constructor to create an instance from JSON
  factory PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderModel(
      userId: json['user_id'] ?? '',
      addressId: json['address_id'] ?? '',
      productId: json['product_id'] ?? '',
      quantity: json['quantity'] ?? '',
      orderId: json['order_id'] ?? '',
      productPrice: json['product_price'] ?? '',
      totalPrice: json['total_price'] ?? '',
    );
  }

  // Convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "address_id": addressId,
      "product_id": productId,
      "quantity": quantity,
      "order_id": orderId,
      "product_price": productPrice,
      "total_price": totalPrice,
    };
  }
}
