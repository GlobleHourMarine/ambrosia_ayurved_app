import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_model.dart';

class CartService {
// fetch cart items
  Future<List<CartItemss>> fetchCartData(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/fetch_cart_data'),
        body: json.encode({"user_id": userId}),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          List<CartItemss> cartItems = [];
          for (var item in responseData['data']) {
            cartItems.add(CartItemss.fromJson(item));
          }

          print(responseData);
          return cartItems;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load cart data');
      }
    } catch (error) {
      throw Exception('Error fetching cart data: $error');
    }
  }

  // add to cart

  Future<bool> addToCart(String productId, int quantity, String userId,
      BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/add_product_into_cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );
      
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('responseBody of add to cart : $responseBody');

      if (response.statusCode == 200) {
        if (responseBody['status'] == true) {
          return true;
        } else {
          throw Exception(
              responseBody['message'] ?? 'Failed to add item to cart.');
        }
      } else {
        throw Exception(
            'Failed to add item to cart (status code ${response.statusCode}).');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

/*
  Future<CartItemss?> addToCart(String productId, int quantity, String userId,
      BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/add_product_into_cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity.toString(),
        }),
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('responseBody of add to cart : $responseBody');
      if (response.statusCode == 200) {
        if (responseBody.containsKey('status') &&
            responseBody['status'] == true) {
          if (responseBody.containsKey('data') &&
              responseBody['data'] is List &&
              responseBody['data'].isNotEmpty) {
            Map<String, dynamic> itemData = responseBody['data'][0];

            return CartItemss.fromJson(itemData);
          } else {
            throw Exception('Invalid data format received.');
          }
        } else {
          throw Exception('Failed to add item to cart.');
        }
      } else {
        throw Exception('Failed to add item to cart in data.');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }


*/

// remove from cart
  Future<bool> removeProductFromCart(String cartId) async {
    const String apiUrl =
        'https://ambrosiaayurved.in/api/delete_product_from_cart';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({"cart_id": cartId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          print(responseData);
          return true;
        }
      } else {
        throw Exception('Failed to remove product');
      }
    } catch (error) {
      print('Error removing product: $error');
      return false;
    }
    throw Exception('failed to remove');
  }

// update quantity in cart
  static const String updateQuantityUrl =
      'https://ambrosiaayurved.in/api/update_quantity';

  Future<bool> updateQuantity(
      String productId, int quantity, String userId) async {
    try {
      final response = await http.post(
        Uri.parse(updateQuantityUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          print(responseData);
          return true;
        }
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
    return false;
  }
}
