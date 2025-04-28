import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_model.dart';

class ReviewService {
  static const String apiUrl =
      "https://ambrosiaayurved.in/api/fetch_all_reviews";

  // Fetch reviews by product ID
  Future<List<Review>> fetchReviews(String productId) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"product_id": productId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData["status"] == "success") {
          List<dynamic> reviewsJson = responseData["data"];
          return reviewsJson.map((json) => Review.fromJson(json)).toList();
        } else {
          throw Exception(
              "Failed to fetch reviews: ${responseData["message"]}");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching reviews: $e");
    }
  }
  // review submission

  // Future<bool> submitReview(
  //     {required String userId,
  //     //  required String productId,
  //     required int starRating,
  //     required String comment,
  //     required String date}) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('sssk_aai.com'),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "name": userId,
  //         //     "product_id": productId,
  //         "star_rating": starRating,
  //         "comment": comment,
  //         "date": date,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       return jsonData['status'] == 'success';
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
