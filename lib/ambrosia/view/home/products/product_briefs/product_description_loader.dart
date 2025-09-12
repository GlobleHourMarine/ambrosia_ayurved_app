// Create a global loading provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductLoadingProvider extends ChangeNotifier {
  bool _showIndividualLoaders = true;

  bool get showIndividualLoaders => _showIndividualLoaders;

  void setShowIndividualLoaders(bool show) {
    _showIndividualLoaders = show;
    notifyListeners();
  }
}
