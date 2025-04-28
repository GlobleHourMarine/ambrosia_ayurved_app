// import 'package:flutter/material.dart';
// import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
// import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
// import 'package:ambrosia_ayurved/provider/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_service.dart';
// import 'package:intl/intl.dart';

// class ReviewSubmissionSection extends StatefulWidget {
//   @override
//   _ReviewSubmissionSectionState createState() =>
//       _ReviewSubmissionSectionState();
// }

// class _ReviewSubmissionSectionState extends State<ReviewSubmissionSection> {
//   int _starRating = 0;
//   final TextEditingController _commentController = TextEditingController();
//   bool _isSubmitting = false;

//   void _submitReview() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userId = userProvider.id;
//     String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

//     if (_starRating == 0) {
//       SnackbarMessage.showSnackbar(context, 'Please provide a star rating');

//       return;
//     }

//     setState(() => _isSubmitting = true);

//     bool success = await ReviewService().submitReview(
//       userId: userId,
//       date: currentDate,
//       starRating: _starRating,
//       comment: _commentController.text,
//     );

//     setState(() => _isSubmitting = false);

//     if (success) {
//       SnackbarMessage.showSnackbar(context, 'Review submitted successfully!');

//       _commentController.clear();
//       setState(() => _starRating = 0);
//     } else {
//       SnackbarMessage.showSnackbar(
//           context, 'Failed to submit review. Try again.');
//     }
//   }

//   Widget _buildStarSelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: List.generate(
//         5,
//         (index) {
//           return IconButton(
//             icon: Icon(
//               index < _starRating ? Icons.star : Icons.star_border,
//               color: Colors.green,
//               size: 40,
//             ),
//             onPressed: () {
//               setState(() => _starRating = index + 1);
//             },
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.green),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text("Submit Your Review",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 5),
//             _buildStarSelector(),
//             SizedBox(height: 10),
//             TextField(
//               controller: _commentController,
//               maxLines: 3,
//               onSubmitted: (value) {
//                 FocusScope.of(context).unfocus();
//               },
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                     borderSide: BorderSide(width: 1, color: Colors.green)),
//                 focusedBorder: OutlineInputBorder(),
//                 hintText: "Write your review here...",
//               ),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.center,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Acolors.primary,
//                   foregroundColor: Acolors.white,
//                 ),
//                 onPressed: _isSubmitting ? null : _submitReview,
//                 child: _isSubmitting
//                     ? CircularProgressIndicator()
//                     : Text("Submit"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
