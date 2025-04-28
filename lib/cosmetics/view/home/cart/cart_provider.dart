import 'package:flutter/material.dart';

import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_model.dart';

class CartProvider with ChangeNotifier {
  //final Map<String, dynamic> _cartItems = {}; // Keeps track of product IDs and their quantity
  List<CartItemss> _cartList = []; // Stores fetched cart items

  List<CartItemss> get cartList => _cartList;

  Map<String, dynamic> _cartItems = {}; // Product ID as key, quantity as value
  Map<String, dynamic> get cartItems => _cartItems;
/*
  void addToCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = _cartItems[productId]! + 1;
    } else {
      _cartItems[productId] = 1;
    }
    notifyListeners();
  }
*/

  void removeFromCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      // Remove the product completely from the cart
      _cartItems.remove(productId);
    }
    notifyListeners(); // Notify listeners to update the UI
  }
/*
  void updateQuantity(String productId, int qty) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = qty;
      notifyListeners();
    }
  }
  */

  CartItemss? _cartItemss;
  String _cartid = '';
  String _productid = '';

  CartItemss? get cartItemss => _cartItemss;
  String get cartid => _cartid;
  String get productid => _productid;

  // bool get isLoggedIn => _user != null;

  void setCart(CartItemss cartItemss) {
    _cartItemss = cartItemss;

    _cartid = cartItemss.cartId;
    _productid = cartItemss.productId;

    print('Database ID: ${_cartid}');
    notifyListeners();
  }

  void setcartid(String cartid) {
    _cartid = cartid;
    notifyListeners();
  }

  void setfname(String fname) {
    _productid = productid;
    notifyListeners();
  }

  Future<void> addToCart(
    String productId,
    BuildContext context,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;

    if (userId == null) {
      print('User not logged in');
      return;
    }

    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = _cartItems[productId]! + 1;
    } else {
      _cartItems[productId] = 1;
    }

    // Update UI
    notifyListeners();

    // Send data to API and get the stored cart item
    CartItemss? newCartItem = await _storeCartItemInDatabase(
        productId, _cartItems[productId]!, userId, context);

    if (newCartItem != null) {
      _cartList.add(newCartItem);
      notifyListeners();
    }
  }

  Future<CartItemss?> _storeCartItemInDatabase(String productId, int quantity,
      String userId, BuildContext context) async {
    final url = 'http://192.168.1.10/klizard/api/add_product_into_cart';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity.toString(),
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print(responseBody); // Debugging

        if (responseBody.containsKey('status') &&
            responseBody['status'] == 'success') {
          print('Item added to cart in database.');

          if (responseBody.containsKey('data') &&
              responseBody['data'] is List &&
              responseBody['data'].isNotEmpty) {
            Map<String, dynamic> itemData = responseBody['data'][0];

            // Ensure quantity is stored as int
            int parsedQuantity =
                int.tryParse(itemData['cart_quantity'].toString()) ?? 1;

            // Update local cart items with correct int values
            _cartItems[productId] = parsedQuantity;

            return CartItemss.fromJson(itemData);
          }
        }
      } else {
        print(
            'Failed to add item to cart in database. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
    return null;
  }

  static const String updateQuantityUrl =
      'http://192.168.1.10/klizard/api/update_quantity';

  // Increment Quantity
  Future<void> incrementQuantity(String productId, BuildContext context) async {
    final newQuantity = (cartItems[productId] ?? 1) + 1;
    await _updateCartQuantity(productId, newQuantity, context);
  }

  // Decrement Quantity
  Future<void> decrementQuantity(String productId, BuildContext context) async {
    if (cartItems[productId] != null && cartItems[productId]! > 1) {
      final newQuantity = cartItems[productId]! - 1;
      await _updateCartQuantity(productId, newQuantity, context);
    }
  }

  // API Call to Update Quantity
  Future<void> _updateCartQuantity(
      String productId, int quantity, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;
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
        print(responseData);
        if (responseData['status'] == 'success') {
          cartItems[productId] = quantity;
          notifyListeners();

          print('updated Successfully');
        }
      }
    } catch (error) {
      print('Error: $error');
      SnackbarMessage.showSnackbar(context, 'Error: $error');
    }
  }

  // Method to remove the product from the cart
  Future<void> removeProductFromCart(
      BuildContext context, String cartId) async {
    const String apiUrl =
        'http://192.168.1.8/klizard/api/delete_product_from_cart';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({"cart_id": cartId}),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Remove product from the cart list in provider
          _cartList.removeWhere((item) => item.cartId == cartId);

          // Show success message
          SnackbarMessage.showSnackbar(
              context, 'Product deleted from cart successfully!');

          // Notify listeners to update the UI
          notifyListeners();
        } else {
          SnackbarMessage.showSnackbar(
              context, 'Failed to remove product from cart.');
        }
      } else {
        throw Exception('Failed to remove product');
      }
    } catch (error) {
      SnackbarMessage.showSnackbar(context, 'Error: $error');
    }
  }

  // Future<void> addToCart(String productId, BuildContext context) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final userId = userProvider.id;

  //   if (userId == null) {
  //     // Handle the case where the user is not logged in
  //     print('User not logged in');
  //     return;
  //   }
  //   if (_cartItems.containsKey(productId)) {
  //     _cartItems[productId] = _cartItems[productId]! + 1;
  //   } else {
  //     _cartItems[productId] = 1;
  //   }

  //   // Update UI
  //   notifyListeners();

  //   // Send data to the API to store it in the database
  //   await _storeCartItemInDatabase(productId, _cartItems[productId]!, userId);
  // }

  // Future<void> _storeCartItemInDatabase(
  //   String productId,
  //   int quantity,
  //   String userId,
  //   //  BuildContext context
  // ) async {
  //   final url =
  //       'http://192.168.1.9/klizard/api/add_product_into_cart'; // Replace with your actual endpoint

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json' // Include token if needed
  //       },
  //       body: json.encode({
  //         'user_id': userId,
  //         'product_id': productId,
  //         'quantity': quantity.toString(),
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       // Success - Cart item stored
  //       Map<String, dynamic> responseBody = jsonDecode(response.body);
  //       print(responseBody); // Print the response body for debugging purposes
  //       if (responseBody.containsKey('status') &&
  //           responseBody['status'] == 'success') {
  //         print('Item added to cart in database.');
  //         //     CartItem cartItem = cartItem.fromJson(responseBody['data'][0]);
  //         //    Provider.of<CartProvider>(context, listen: false).setCart(cartItem);
  //       }
  //     } else {
  //       // Handle the error from the API
  //       print(
  //           'Failed to add item to cart in database. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Handle network or other errors
  //     print('Error: $error');
  //   }
  // }

//
//
//

  // // Fetch cart data for the logged-in user
  // Future<void> fetchUserCart(String userId) async {
  //   if (userId == null) {
  //     print('User not logged in');
  //   } else {
  //     print('User Id : ${userId}');
  //   }

  //   final url =
  //       'http://192.168.1.7/klizard/api/fetch_cart_data'; // Use GET request with query parameter

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         'user_id': userId, // Send the id as part of the request body
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseBody = jsonDecode(response.body);

  //       if (responseBody['status'] == true) {
  //         _cartItems = {};
  //         for (var item in responseBody['data']) {
  //           String productId = item['product_id'].toString();
  //           int quantity = int.parse(item['cart_quantity']);
  //           _cartItems[productId] = quantity;
  //         }
  //         notifyListeners();
  //         print('Cart data fetched successfully.');
  //         print(responseBody);
  //         print('Cart items count: ${_cartItems.length}');
  //       } else {
  //         print('Failed to fetch cart data: ${responseBody['message']}');
  //       }
  //     } else {
  //       print('Failed to fetch cart data. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  // }

/*
  // Add product to the cart
  Future<void> addToCartapi(String productId, String userId) async {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = _cartItems[productId]! + 1;
    } else {
      _cartItems[productId] = 1;
    }

    // Add product to the backend API
    final response = await _cartApiService.addToCart(productId, userId);

    if (response['status']) {
      notifyListeners();
    } else {
      print('Failed to add to cart: ${response['message']}');
    }
  }

  // Remove product from the cart
  Future<void> removeFromCartapi(String productId, String userId) async {
    if (_cartItems.containsKey(productId)) {
      _cartItems.remove(productId);
    }

    // Remove product from the backend API
    final response = await _cartApiService.removeFromCart(productId, userId);

    if (response['status']) {
      notifyListeners();
    } else {
      print('Failed to remove from cart: ${response['message']}');
    }
  }

  // Update product quantity in the cart
  Future<void> updateQuantityapi(String productId, int qty, String userId) async {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId] = qty;
    }

    // Update product quantity on the backend
    final response = await _cartApiService.updateQuantity(productId, qty, userId);

    if (response['status']) {
      notifyListeners();
    } else {
      print('Failed to update quantity: ${response['message']}');
    }
  }

  */
  int get totalUniqueItems => _cartItems.length;
}
