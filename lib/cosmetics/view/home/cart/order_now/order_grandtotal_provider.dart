import 'package:flutter/material.dart';

class GrandTotalProvider extends ChangeNotifier {
  double _grandTotal = 0.0;

  double get grandTotal => _grandTotal;

  void calculateGrandTotal(List<dynamic> cartList) {
    double total = 0.0;

    for (var item in cartList) {
      double itemPrice = double.tryParse(item.price.toString()) ?? 0.0;
      int itemQuantity = int.tryParse(item.quantity.toString()) ?? 1;

      total += itemPrice * itemQuantity;
    }

    _grandTotal = total;

    print("Updated Grand Total: $_grandTotal");

    notifyListeners();
  }
}
