import 'package:flutter/material.dart';

class GrandTotalProvider extends ChangeNotifier {
  double _grandTotal = 0.0;
  double _finalTotal = 0.0;
  double _discountAmount = 0.0;
  double _discountPercentage = 0.0;

  double get grandTotal => _grandTotal;
  double get finalTotal => _finalTotal;
  double get discountAmount => _discountAmount;
  double get discountPercentage => _discountPercentage;

  void calculateGrandTotal(List<dynamic> cartList) {
    double total = 0.0;

    for (var item in cartList) {
      double itemPrice = double.tryParse(item.price.toString()) ?? 0.0;
      int itemQuantity = int.tryParse(item.quantity.toString()) ?? 1;

      total += itemPrice * itemQuantity;
    }

    _grandTotal = total;
    _finalTotal = total;
    _discountAmount = 0.0;
    _discountPercentage = 0.0;

    print("Updated Grand Total: $_grandTotal");
    print("Final Total: $_finalTotal");

    notifyListeners();
  }

  void applyDiscount(double discountPercentage) {
    _discountPercentage = discountPercentage;
    _discountAmount = (_grandTotal * discountPercentage) / 100;
    _finalTotal = _grandTotal - _discountAmount;

    print("Applied Discount: $_discountAmount");
    print("Final Total after discount: $_finalTotal");

    notifyListeners();
  }

  void removeDiscount() {
    _discountAmount = 0.0;
    _discountPercentage = 0.0;
    _finalTotal = _grandTotal;

    print("Discount removed. Final Total: $_finalTotal");

    notifyListeners();
  }
}
