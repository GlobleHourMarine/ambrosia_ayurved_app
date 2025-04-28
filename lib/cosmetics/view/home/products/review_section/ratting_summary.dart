// import 'package:flutter/material.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_model.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_service.dart';

// class ReviewProvider extends ChangeNotifier {
//   List<Review> _reviews = [];
//   double _averageRating = 0.0;
//   bool _isLoading = true;

//   List<Review> get reviews => _reviews;
//   double get averageRating => _averageRating;
//   bool get isLoading => _isLoading;

//   Future<void> fetchReviews(String productId) async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       List<Review> fetchedReviews =
//           await ReviewService().fetchReviews(productId);
//       _reviews = fetchedReviews;
//       _calculateAverageRating();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching reviews: $e");
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void _calculateAverageRating() {
//     if (_reviews.isNotEmpty) {
//       double totalRating = _reviews
//           .map((review) => double.tryParse(review.rating) ?? 0.0)
//           .fold(0.0, (prev, rating) => prev + rating);
//       _averageRating = totalRating / _reviews.length;
//     }
//   }
// }
