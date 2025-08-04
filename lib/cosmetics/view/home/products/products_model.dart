class Product {
  final int id;
  final String name;
  final String description;
  final double price; // Ensure this is still a String
  final int quantity;
  // final String category;
  final List<String> imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    // required this.category,
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
      // category: json['category'],
      quantity:
          json['quantity'] != null ? int.parse(json['quantity'].toString()) : 0,
      imageUrl: json['image'] != null ? List<String>.from(json['image']) : [],
    );
  }
}

/*

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String description;
  int quantity = 0;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.description,
  });
}
*/


