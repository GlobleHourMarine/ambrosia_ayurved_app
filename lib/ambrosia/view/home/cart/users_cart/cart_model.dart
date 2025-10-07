class CartItemss {
  final String cartId;
  final String productName;
  final String price;
  String quantity;
  final String image;
  final String productId;
  final String description;
  final String address;
    final String gstPrice; 

  CartItemss({
    required this.cartId,
    required this.productName,
    required this.price,
    required this.image,
    required this.quantity,
    required this.productId,
    required this.description,
    required this.address,
    required this.gstPrice,
    re
  });

  factory CartItemss.fromJson(Map<String, dynamic> json) {
    return CartItemss(
      cartId: json['cart_id']?.toString() ?? '', // Ensure String, default to ''
      productName: json['product_name'] ?? 'Unknown', // Default name
      price:
          json['price']?.toString() ?? '0', // Convert to String, default to '0'
      quantity: json['quantity']?.toString() ?? '1', // Convert to String
      image: json['image'] ?? '', // Default empty string
      productId: json['product_id']?.toString() ?? '', // Convert to String
      description:
          json['discription'] ?? 'No description', // Fix spelling & default
      address: json['address'] ?? 'No address',
         gstPrice: json['gst_price']?.toString() ?? '0',  // Default address
    );
  }
}
