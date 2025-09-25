import 'package:ambrosia_ayurved/ambrosia/view/login&register/user_register.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:provider/provider.dart';

class CartProvider with ChangeNotifier {
  List<CartItemss> _cartItems = [];
  bool _isLoading = false;
  bool _isQuantityLoading = false;

  String? _loadingProductId;
  String? _loadingAction; // 'increment' or 'decrement'

  List<CartItemss> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  bool get isQuantityLoading => _isQuantityLoading;
  String? get loadingProductId => _loadingProductId;
  String? get loadingAction => _loadingAction;

  final CartService _cartService = CartService();

// fetch cart items
// Set loading state for quantity operations
  void _setQuantityLoading(bool loading, {String? productId, String? action}) {
    _isQuantityLoading = loading;
    _loadingProductId = productId;
    _loadingAction = action;
    notifyListeners();
  }

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
      // Call the modal bottom sheet directly here
      RegisterService().showModalBottomSheetregister(context);

      // RegisterService().showRegistrationBottomSheet(context);
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
            _cartItems[existingIndex].productId, updatedQuantity, userId);

        if (success) {
          _cartItems[existingIndex].quantity =
              updatedQuantity.toString(); // Update locally

          SnackbarMessage.showSnackbar(context,
              '$productName is already in cart. We have updated Quantity.');
        }
      } else {
        // Product does not exist, add a new item
        CartItemss? newCartItem =
            await _cartService.addToCart(productId, 1, userId, context);

        if (newCartItem != null) {
          _cartItems.add(newCartItem);
        }
        SnackbarMessage.showSnackbar(context, '$productName added to the cart');
      }

      notifyListeners();

      // Show success message
    } catch (e) {
      print("Error adding to cart: $e"); // Debugging message

      SnackbarMessage.showSnackbar(
          context, 'Failed to add $productName to cart');
    }
  }

  // Remove product from cart with Loading
  Future<void> removeProductFromCart(
      String cartId, BuildContext context) async {
    // Find the product to get its productId for loading state
    final cartItem = _cartItems.firstWhere((item) => item.cartId == cartId);

    // Set loading state for this specific product
    _setQuantityLoading(true, productId: cartItem.productId, action: 'remove');

    try {
      final success = await _cartService.removeProductFromCart(cartId);

      if (success) {
        _cartItems.removeWhere((item) => item.cartId == cartId);

        SnackbarMessage.showSnackbar(
            context, '${cartItem.productName} removed from cart successfully');
        notifyListeners();
      } else {
        SnackbarMessage.showSnackbar(
            context, 'Failed to remove product from cart.');
      }
    } catch (e) {
      print('Error removing product from cart: $e');
      SnackbarMessage.showSnackbar(
          context, 'Failed to remove product from cart.');
    } finally {
      _setQuantityLoading(false);
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

    // Set loading state for this specific product and action
    _setQuantityLoading(true, productId: productId, action: 'increment');

    try {
      final existingItem =
          _cartItems.firstWhere((item) => item.productId == productId);

      if (existingItem != null) {
        final newQuantity = (int.parse(existingItem.quantity) + 1);
        final success =
            await _cartService.updateQuantity(productId, newQuantity, userId!);

        if (success) {
          existingItem.quantity = newQuantity.toString();
          print('updated quantity successfully!');
        } else {
          print('Failed to update quantity');
        }
      }
    } catch (e) {
      print('Error incrementing quantity: $e');
    } finally {
      // Always clear loading state
      _setQuantityLoading(false);
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

    // Set loading state for this specific product and action
    _setQuantityLoading(true, productId: productId, action: 'decrement');

    try {
      final existingItem =
          _cartItems.firstWhere((item) => item.productId == productId);
      if (existingItem != null && int.parse(existingItem.quantity) > 1) {
        final newQuantity = (int.parse(existingItem.quantity) - 1);
        final success =
            await _cartService.updateQuantity(productId, newQuantity, userId!);
        if (success) {
          existingItem.quantity = newQuantity.toString();
          print('updated to quantity successfully');
        } else {
          print('Failed to update quantity');
        }
      } else if (existingItem != null &&
          int.parse(existingItem.quantity) == 1) {
        // Optionally show a message that quantity can't go below 1
        SnackbarMessage.showSnackbar(context, 'Quantity cannot be less than 1');
      }
    } catch (e) {
      print('Error decrementing quantity: $e');
    } finally {
      // Always clear loading state
      _setQuantityLoading(false);
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
