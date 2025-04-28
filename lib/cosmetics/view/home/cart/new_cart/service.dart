import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_model.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';

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
        if (responseData['status']) {
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

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('status') &&
            responseBody['status'] == 'success') {
          if (responseBody.containsKey('data') &&
              responseBody['data'] is List &&
              responseBody['data'].isNotEmpty) {
            // Extract the user_id from the response
            //  String userIdfromResponse = responseBody['user_id'].toString();
            // Fix: Properly extract the first item from the list
            Map<String, dynamic> itemData = responseBody['data'][0];

            // // Set user_id in the UserProvider
            // final userProvider =
            //     Provider.of<UserProvider>(context, listen: false);
            // userProvider
            //     .setid(userIdfromResponse); // Update user_id in the provider
            // print('User Id from api =   $userIdfromResponse');
            // print(responseBody);
            // print('Item added to database');

            return CartItemss.fromJson(itemData);
          } else {
            throw Exception('Invalid data format received.');
          }
        } else {
          throw Exception('Failed to add item to cart.');
        }
      } else {
        throw Exception('Failed to add item to cart in database.');
      }
    } catch (error) {
      print('Error: $error'); // Debugging log
      throw Exception('Error: $error');
    }
  }

  // API to remove product from cart
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
          return true; // Return true if product was successfully removed
        }
      } else {
        throw Exception('Failed to remove product');
      }
    } catch (error) {
      print('Error removing product: $error');
      return false; // Return false in case of an error
    }
    throw Exception('failed to remove');
  }

  // update quantity

  static const String updateQuantityUrl =
      'https://ambrosiaayurved.in/api/update_quantity';

  // API Call to Update Quantity
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
          return true; // Return true if update was successful
        }
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
    return false; // Return false in case of error
  }
}
