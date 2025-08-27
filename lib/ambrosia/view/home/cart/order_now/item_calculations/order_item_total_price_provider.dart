import 'package:flutter/material.dart';

class ItemTotalPriceProvider extends ChangeNotifier {
  double calculateTotalPrice(String price, String quantity) {
    // Ensure price is treated as a double
    double itemPrice = double.tryParse(price) ?? 0.0;

    // Ensure quantity is treated as an integer
    int itemQuantity = int.tryParse(quantity) ?? 1;

    return itemPrice * itemQuantity;
  }
}
