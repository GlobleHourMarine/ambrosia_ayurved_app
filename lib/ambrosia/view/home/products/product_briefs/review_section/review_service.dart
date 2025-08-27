import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_model.dart';

class ReviewService {
  static const String apiUrl =
      "https://ambrosiaayurved.in/api/fetch_all_reviews";

  // Fetch reviews by product ID
  Future<List<Review>> fetchReviews(String productId) async {
    try {
      final Uri url = Uri.parse('$apiUrl?product_id=$productId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);
        if (responseData["status"] == true) {
          List<dynamic> reviewsJson = responseData["data"];

          return reviewsJson.map((json) => Review.fromJson(json)).toList();
        } else {
          print(responseData);
          throw Exception(
              "Failed to fetch reviews: ${responseData["message"]}");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print('$e');
      throw Exception("Error fetching reviews: $e");
    }
  }
}
