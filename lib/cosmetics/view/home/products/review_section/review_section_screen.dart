import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_model.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_service.dart';

class CustomerReviewSection extends StatefulWidget {
  final String productId;

  CustomerReviewSection({required this.productId});

  @override
  _CustomerReviewSectionState createState() => _CustomerReviewSectionState();
}

class _CustomerReviewSectionState extends State<CustomerReviewSection> {
  List<Review> reviews = [];
  bool isLoading = true;
  double averageRating = 0.0;
  bool showAllReviews = false; // Track whether to show all reviews

  @override
  void initState() {
    super.initState();
    getProductReviews();
  }

  Future<void> getProductReviews() async {
    try {
      List<Review> fetchedReviews =
          await ReviewService().fetchReviews(widget.productId);
      setState(() {
        reviews = fetchedReviews;
        isLoading = false;
        calculateAverageRating();
      });
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void calculateAverageRating() {
    if (reviews.isNotEmpty) {
      double totalRating = reviews
          .map((review) => double.tryParse(review.rating) ?? 0.0)
          .fold(0.0, (prev, rating) => prev + rating);
      averageRating = totalRating / reviews.length;
    }
  }

  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    int reviewsToShow =
        showAllReviews ? reviews.length : 4; // Limit to 4 initially

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "CUSTOMER REVIEWS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(height: 10),
                  buildStarRating(averageRating.toInt()),
                  const SizedBox(width: 10),
                  Text(
                    "${averageRating.toStringAsFixed(1)} / 5.0",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text("Based on ${reviews.length} Reviews"),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : reviews.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("No reviews yet.",
                            style: TextStyle(fontSize: 16)),
                      )
                    : Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviewsToShow,
                            itemBuilder: (context, index) {
                              final review = reviews[index];
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.fname,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        review.date,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      const SizedBox(height: 5),
                                      buildStarRating(int.parse(review.rating)),
                                      const SizedBox(height: 5),
                                      Text(
                                        review.message,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (reviews.length >
                              4) // Show "Read More" only if there are more than 4 reviews
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showAllReviews = !showAllReviews;
                                });
                              },
                              child: Text(
                                showAllReviews ? "Show Less" : "Read More",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ),
                        ],
                      ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
