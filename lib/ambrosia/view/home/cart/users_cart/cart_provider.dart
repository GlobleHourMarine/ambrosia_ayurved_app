import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/register_onpop.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CartProvider with ChangeNotifier {
  List<CartItemss> _cartItems = [];
  bool _isLoading = false;

  List<CartItemss> get cartItems => _cartItems;
  bool get isLoading => _isLoading;

  final CartService _cartService = CartService();

// fetch cart items

  Future<void> fetchCartData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cartItems = await _cartService.fetchCartData(userId);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print('Error fetching cart data: $error');
    }
  }

  // add to cart
  Future<void> addToCart(
      String productId, String productName, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Check login state before proceeding

    final userId = userProvider.id;

    if (userId == null || userId.isEmpty) {
      // Show login required dialog
      print('User Id not found');
      RegisterService().showRegistrationBottomSheet(context);
      return;

      //   // showDialog(
      //   //   context: context,
      //   //   builder: (BuildContext context) {
      //   //     return AlertDialog(
      //   //       title: Text('Login Required'),
      //   //       content: Text('Please log in to add products to the cart.'),
      //   //       actions: [
      //   //         ElevatedButton(
      //   //           onPressed: () {
      //   //             Navigator.pop(context);
      //   //           },
      //   //           child: Text('OK'),
      //   //         ),
      //   //       ],
      //   //     );
      //   //   },
      //   // );
      //   // return;
    }

    try {
      // Check if product already exists in the cart
      int existingIndex =
          _cartItems.indexWhere((item) => item.productId == productId);

      if (existingIndex != -1) {
        // Product exists, update its quantity
        int updatedQuantity = int.parse(_cartItems[existingIndex].quantity) + 1;

        // Update on the server
        bool success = await _cartService.updateQuantity(
            _cartItems[existingIndex].cartId, updatedQuantity, userId);

        if (success) {
          _cartItems[existingIndex].quantity =
              updatedQuantity.toString(); // Update locally
        }
      } else {
        // Product does not exist, add a new item
        CartItemss? newCartItem =
            await _cartService.addToCart(productId, 1, userId, context);

        if (newCartItem != null) {
          _cartItems.add(newCartItem);
        }
      }

      notifyListeners();

      // Show success message
      SnackbarMessage.showSnackbar(context, '$productName added to the cart');
    } catch (e) {
      print("Error adding to cart: $e"); // Debugging message

      SnackbarMessage.showSnackbar(
          context, 'Failed to add $productName to cart');
      // RegisterService().showRegistrationDialog(context);
      //   return;
      // Handle error and show failure message
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Login Required'),
      //       content: Text('Please log in to add products to the cart.'),
      //       actions: [
      //         ElevatedButton(
      //           onPressed: () {
      //             Navigator.pop(context);
      //             Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => SignInScreen(),
      //                 ));
      //           },
      //           child: Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }
  }

  // Remove product from cart
  Future<void> removeProductFromCart(
      String cartId, BuildContext context) async {
    final success = await _cartService.removeProductFromCart(cartId);

    if (success) {
      // Remove the product from the cartItems list
      _cartItems.removeWhere((item) => item.cartId == cartId);
      // Show success message using a Snackbar
      SnackbarMessage.showSnackbar(
          context, 'Product removed from cart successfully');
      notifyListeners(); // Update the UI
    } else {
      SnackbarMessage.showSnackbar(
          context, 'Failed to remove product from cart.');
    }
  }

  // Increment Quantity
  Future<void> incrementQuantity(String productId, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;

    if (userId == null) {
      print('User not logged in');
      return;
    }

    final existingItem =
        _cartItems.firstWhere((item) => item.productId == productId);

    if (existingItem != null) {
      final newQuantity = (int.parse(existingItem.quantity) + 1);
      final success =
          await _cartService.updateQuantity(productId, newQuantity, userId!);

      if (success) {
        existingItem.quantity = newQuantity.toString();
        print('updated quantity successfully!');
        notifyListeners();
      } else {
        print('Failed to update quantity');
      }
    }
  }

  // Decrement Quantity
  Future<void> decrementQuantity(String productId, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;

    if (userId == null) {
      print('User not logged in');
      return;
    }

    final existingItem =
        _cartItems.firstWhere((item) => item.productId == productId);

    if (existingItem != null && int.parse(existingItem.quantity) > 1) {
      final newQuantity = (int.parse(existingItem.quantity) - 1);
      final success =
          await _cartService.updateQuantity(productId, newQuantity, userId!);

      if (success) {
        existingItem.quantity = newQuantity.toString();
        print('updated to quantity succes fully');
        notifyListeners();
      } else {
        print('Failed to update quantity');
      }
    }
  }

  // // Clear the entire cart
  // Future<void> clearCart() async {
  //   _cartItems.clear();
  //   notifyListeners();
  //   print("Cart cleared, total items: ${_cartItems.length}");
  // }

  int get totalUniqueItems => _cartItems.length;
}
