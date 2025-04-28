class OrderTracking {
  final String trackId;
  final String orderId;
  final String userId;
  final String expectedDelivery;
  final String shippedDate;
  final String outForDelivery;
  final String productDelivered;

  OrderTracking({
    required this.trackId,
    required this.orderId,
    required this.userId,
    required this.expectedDelivery,
    required this.shippedDate,
    required this.outForDelivery,
    required this.productDelivered,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      trackId: json['track_id'] ?? '',
      orderId: json['order_id'] ?? '',
      userId: json['user_id'] ?? '',
      expectedDelivery: json['expected_delivery'] ?? '',
      shippedDate: json['shipped_date'] ?? '',
      outForDelivery: json['out_for_delivery'] ?? '',
      productDelivered: json['product_delivered'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'track_id': trackId,
      'order_id': orderId,
      'user_id': userId,
      'expected_delivery': expectedDelivery,
      'shipped_date': shippedDate,
      'out_for_delivery': outForDelivery,
      'product_delivered': productDelivered,
    };
  }
}
