// Order model
class Order {
  final String id;
  final String orderId;
  final String productName;
  final String image;
  final double productPrice;
  final int productQuantity;
  final String shiprocketOrderId;
  final double totalPrice;
  final String currentStatus;
  final String expectedDeliveryDate;
  final String createdAt;
  final String courierCompany;
  final String awbCode;

  Order({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.shiprocketOrderId,
    required this.image,
    required this.productPrice,
    required this.productQuantity,
    required this.totalPrice,
    required this.currentStatus,
    required this.expectedDeliveryDate,
    required this.createdAt,
    required this.courierCompany,
    required this.awbCode,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderId: json['order_id'],
      productName: json['product_name'],
      shiprocketOrderId: json['shiprocket_order_id'].toString(),
      image: json['image'],
      productPrice: double.parse(json['product_price']),
      productQuantity: int.parse(json['product_quantity']),
      totalPrice: double.parse(json['total_price']),
      currentStatus: json['current_status'],
      expectedDeliveryDate: json['expected_delivery_date'],
      createdAt: json['created_at'],
      courierCompany: json['courier_company'],
      awbCode: json['awb_code'],
    );
  }
}
