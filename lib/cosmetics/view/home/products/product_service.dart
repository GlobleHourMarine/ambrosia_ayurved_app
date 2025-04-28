import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';

class ProductService {
  static const String apiUrl = "https://ambrosiaayurved.in/api/fetch_products";

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData["status"] == true) {
          List<dynamic> productList = jsonData["data"];
          return productList.map((json) => Product.fromJson(json)).toList();
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
