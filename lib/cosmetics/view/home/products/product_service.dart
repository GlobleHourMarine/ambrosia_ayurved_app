import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';

class ProductService {
  static const String apiUrl = "https://ambrosiaayurved.in/api/fetch_products";

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      //  print('response');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData["status"] == true && jsonData["data"] is List) {
          List<Product> products = (jsonData["data"] as List)
              .map((jsonItem) => Product.fromJson(jsonItem))
              .toList();
          print("✅ Product list fetched: ${products.length} items");
          return products;
        } else {
          throw Exception(jsonData["message"]);
        }
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
