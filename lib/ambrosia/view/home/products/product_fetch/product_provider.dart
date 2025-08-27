import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/product_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';

class ProductNotifier extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false; // Track disposal

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ProductService _productService = ProductService();

  Future<void> fetchProducts() async {
    if (_disposed) return; // Prevent fetching after disposal

    _isLoading = true;
    _errorMessage = null;
    notifyListenersSafely();

    try {
      _products = await _productService.fetchProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListenersSafely();
    }
  }

  // Product? getProductById(String productId) {
  //   try {
  //     return _products.firstWhere(
  //       (product) => product.id == productId,
  //       orElse: () => Product(
  //         id: 0, // Default value for id
  //         name: 'Unknown', // Default name
  //         price: 0.0, // Default price
  //         description: 'No description available', // Default description
  //         imageUrl: [], // Default image URL
  //         quantity: 1, // Default quantity
  //         //  category: '',
  //       ),
  //     );
  //   } catch (e) {
  //     return null; // Return null if something goes wrong
  //   }
  // }

  void notifyListenersSafely() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true; // Mark as disposed
    super.dispose();
  }
}


/*
class ProductNotifier extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Mostirizer',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/04/13/22/26/cream-1327847_1280.jpg',
      price: 299,
      rating: 4.3,
      description:
          'A moisturizer is a skincare product designed to hydrate and nourish the skin. It helps retain moisture, prevent dryness, and protect the skin barrier. Suitable for all skin types, moisturizers come in various formulations such as creams, lotions, gels, and oils, often enriched with beneficial ingredients like hyaluronic acid, glycerin, and vitamins. Regular use promotes soft, smooth, and healthy-looking skin.',
    ),
    Product(
      id: '2',
      name: 'Soap',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/01/12/11/45/soap-1135229_1280.png',
      price: 449,
      rating: 4.6,
      description:
          'A moisturizer is a skincare product designed to hydrate and nourish the skin. It helps retain moisture, prevent dryness, and protect the skin barrier. Suitable for all skin types, moisturizers come in various formulations such as creams, lotions, gels, and oils, often enriched with beneficial ingredients like hyaluronic acid, glycerin, and vitamins. Regular use promotes soft, smooth, and healthy-looking skin.',
    ),
    Product(
      id: '3',
      name: 'Shampoo',
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/02/17/20/38/shampoo-268633_1280.jpg',
      price: 699,
      rating: 4.8,
      description:
          'A moisturizer is a skincare product designed to hydrate and nourish the skin. It helps retain moisture, prevent dryness, and protect the skin barrier. Suitable for all skin types, moisturizers come in various formulations such as creams, lotions, gels, and oils, often enriched with beneficial ingredients like hyaluronic acid, glycerin, and vitamins. Regular use promotes soft, smooth, and healthy-looking skin.',
    ),
    Product(
      id: '4',
      name: 'Levo-floxin',
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/05/23/21/01/jar-2338584_1280.jpg',
      price: 199,
      rating: 4.0,
      description:
          'A moisturizer is a skincare product designed to hydrate and nourish the skin. It helps retain moisture, prevent dryness, and protect the skin barrier. Suitable for all skin types, moisturizers come in various formulations such as creams, lotions, gels, and oils, often enriched with beneficial ingredients like hyaluronic acid, glycerin, and vitamins. Regular use promotes soft, smooth, and healthy-looking skin.',
    ),
    Product(
      id: '5',
      name: 'Azee',
      imageUrl:
          'https://cdn.pixabay.com/photo/2014/03/25/16/24/medicine-296966_1280.png',
      price: 49,
      rating: 3.9,
      description:
          'A moisturizer is a skincare product designed to hydrate and nourish the skin. It helps retain moisture, prevent dryness, and protect the skin barrier. Suitable for all skin types, moisturizers come in various formulations such as creams, lotions, gels, and oils, often enriched with beneficial ingredients like hyaluronic acid, glycerin, and vitamins. Regular use promotes soft, smooth, and healthy-looking skin.',
    ),
  ];

  List<Product> get products => _products;
}
*/