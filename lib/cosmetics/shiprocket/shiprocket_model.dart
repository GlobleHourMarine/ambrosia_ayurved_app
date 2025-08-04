// shiprocket_models.dart
class ShipmentOrder {
  final String orderId;
  final String orderDate;
  final String pickupLocation;
  final String billingCustomerName;
  final String billingLastName;
  final String billingAddress;
  final String billingCity;
  final String billingPincode;
  final String billingState;
  final String billingCountry;
  final String billingEmail;
  final String billingPhone;
  final bool shippingIsBilling;
  final List<OrderItem> orderItems;
  final String paymentMethod;
  final double subTotal;
  final double length;
  final double breadth;
  final double height;
  final double weight;

  ShipmentOrder({
    required this.orderId,
    required this.orderDate,
    required this.pickupLocation,
    required this.billingCustomerName,
    required this.billingLastName,
    required this.billingAddress,
    required this.billingCity,
    required this.billingPincode,
    required this.billingState,
    required this.billingCountry,
    required this.billingEmail,
    required this.billingPhone,
    this.shippingIsBilling = true,
    required this.orderItems,
    required this.paymentMethod,
    required this.subTotal,
    required this.length,
    required this.breadth,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'order_date': orderDate,
      'pickup_location': pickupLocation,
      'billing_customer_name': billingCustomerName,
      'billing_last_name': billingLastName,
      'billing_address': billingAddress,
      'billing_city': billingCity,
      'billing_pincode': billingPincode,
      'billing_state': billingState,
      'billing_country': billingCountry,
      'billing_email': billingEmail,
      'billing_phone': billingPhone,
      'shipping_is_billing': shippingIsBilling,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
      'payment_method': paymentMethod,
      'sub_total': subTotal,
      'length': length,
      'breadth': breadth,
      'height': height,
      'weight': weight,
    };
  }
}

class OrderItem {
  final String name;
  final String sku;
  final int units;
  final double sellingPrice;

  OrderItem({
    required this.name,
    required this.sku,
    required this.units,
    required this.sellingPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'units': units,
      'selling_price': sellingPrice,
    };
  }
}
