class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final List<String> imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'] != null
          ? int.parse(json['product_id'].toString())
          : 0,
      name: json['product_name'] ?? '',
      description: json['discription'] ?? '',
      price: json['price'] is double
          ? json['price']
          : double.tryParse(json['price'].toString()) ?? 0.0,
      quantity:
          json['quantity'] != null ? int.parse(json['quantity'].toString()) : 0,
      imageUrl: json['image'] != null ? List<String>.from(json['image']) : [],
    );
  }
}
