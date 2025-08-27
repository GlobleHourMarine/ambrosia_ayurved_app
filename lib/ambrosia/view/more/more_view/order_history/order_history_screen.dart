// import 'dart:convert';
// import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/submit_review.dart';
// import 'package:flutter/material.dart';
// import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
// import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
// import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_provider.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/track_order_history/track_order_history.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/track_order_history/track_order_model.dart';
// import 'package:ambrosia_ayurved/home/provider/user_provider.dart';
// import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class OrderHistoryScreen extends StatefulWidget {
//   @override
//   _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
// }

// class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() => Provider.of<OrderProvider>(context, listen: false)
//         .fetchOrders(context));
//   }

//   void _showCancelDialog(
//     BuildContext context,
//     OrderProvider orderProvider,
//     String orderId,
//   ) {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userId = userProvider.id;
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text(
//             AppLocalizations.of(context)!.cancelOrder,
//             //  "Cancel Order"
//           ),
//           content: Text(AppLocalizations.of(context)!.cancelOrderConfirmation
//               //  "Are you sure you want to cancel this order?"
//               ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(); // Close dialog
//               },
//               child: Text(
//                 AppLocalizations.of(context)!.no,
//                 //  "No"
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(dialogContext).pop(); // Close dialog

//                 // Call cancel order function
//                 bool success =
//                     await orderProvider.cancelOrder(orderId, userId, context);

//                 if (success) {
//                   orderProvider
//                       .fetchOrders(context); // Refresh orders after canceling
//                 }

//                 //  (context, orderProvider, orderId); // Proceed with cancellation
//               },
//               child: Text(AppLocalizations.of(context)!.yes,
//                   //   "Yes",
//                   style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Set<int> submittedReviews = {}; // Track reviewed order IDs

//   void showReviewDialogIfAllowed(
//       BuildContext context, int productId, int orderId) {
//     if (submittedReviews.contains(orderId)) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(AppLocalizations.of(context)!.reviewAlreadySubmitted
//                 //  "Review Already Submitted"

//                 ),
//             content: Text(AppLocalizations.of(context)!.reviewAlreadySubmitted
//                 //  "You have already submitted a review for this order."
//                 ),
//             actions: [
//               TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     AppLocalizations.of(context)!.ok,
//                     //   "OK"
//                   )),
//             ],
//           );
//         },
//       );
//     } else {
//       showReviewDialog(context, productId, orderId);
//     }
//   }

//   void showReviewDialog(BuildContext context, int productId, int orderId) {
//     // First, check if review already submitted
//     if (submittedReviews.contains(orderId)) {
//       // Show a popup that review is already submitted
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(AppLocalizations.of(context)!.reviewAlreadySubmitted
//               // 'Review Already Submitted'
//               ),
//           content: Text(AppLocalizations.of(context)!.reviewAlreadySubmitted
//               // 'You have already submitted a review for this order.'
//               ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 AppLocalizations.of(context)!.ok,
//                 //  'OK',
//               ),
//             )
//           ],
//         ),
//       );
//       return;
//     }
//     TextEditingController _commentController = TextEditingController();
//     int _selectedRating = 0;
//     bool _isSubmitting = false;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(AppLocalizations.of(context)!.submitYourReview,
//                       //  "Submit Your Review",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 5),
//                   _buildStarSelector(_selectedRating, (rating) {
//                     setState(() => _selectedRating = rating);
//                   }),
//                   const SizedBox(height: 10),
//                   TextFormField(
//                     controller: _commentController,
//                     maxLines: 4,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: AppLocalizations.of(context)!.writeYourReview
//                         // "Write your review here...",
//                         ),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Acolors.primary,
//                         foregroundColor: Colors.white),
//                     onPressed: _isSubmitting
//                         ? null
//                         : () async {
//                             setState(() => _isSubmitting = true);
//                             await submitReview(context, productId, orderId,
//                                 _selectedRating, _commentController.text);
//                             setState(() => _isSubmitting = false);
//                           },
//                     child: _isSubmitting
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(AppLocalizations.of(context)!.submit
//                             // "Submit"
//                             ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> submitReview(BuildContext context, int productId, int orderId,
//       int rating, String message) async {
//     if (submittedReviews.contains(orderId)) {
//       SnackbarMessage.showSnackbar(
//           context, '${AppLocalizations.of(context)!.reviewAlreadySubmitted}'
//           // 'Review already submitted'
//           );
//       return;
//     }
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userId = userProvider.id;
//     final String url = "https://ambrosiaayurved.in/api/submit_review";

//     final Map<String, dynamic> requestBody = {
//       "user_id": userId,
//       "product_id": productId.toString(),
//       "rating": rating.toString(),
//       "message": message,
//       "order_id": orderId.toString(),
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestBody),
//       );

//       final Map<String, dynamic> responseData = jsonDecode(response.body);

//       if (response.statusCode == 200 && responseData["status"] == true) {
//         Navigator.pop(context);
//         SnackbarMessage.showSnackbar(context, responseData["message"]);
//         setState(() {
//           submittedReviews.add(orderId);
//         });
//       } else {
//         Navigator.pop(context);
//         SnackbarMessage.showSnackbar(context, responseData["message"]);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred. Please try again. $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderProvider>(context);

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: AppLocalizations.of(context)!.myOrders,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header
//             // Container(
//             //   height: 70,
//             //   color: Acolors.primary,
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(12),
//             //     child: Row(
//             //       children: [
//             //         Material(
//             //           color: Colors.white.withOpacity(0.21),
//             //           borderRadius: BorderRadius.circular(12),
//             //           child: const BackButton(
//             //             color: Acolors.white,
//             //           ),
//             //         ),
//             //         const SizedBox(width: 30),
//             //         const Text(
//             //           'My Orders',
//             //           style: TextStyle(fontSize: 24, color: Acolors.white),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),

//             const SizedBox(height: 10),

//             // Order List
//             Expanded(
//               child: orderProvider.isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : orderProvider.orders.isEmpty
//                       ? Center(
//                           child: Text(
//                           AppLocalizations.of(context)!.noOrdersFound,
//                           //  'No orders found'
//                         ))
//                       : ListView.builder(
//                           padding: const EdgeInsets.all(10),
//                           itemCount: orderProvider.orders.length,
//                           itemBuilder: (context, index) {
//                             final order = orderProvider.orders[index];
//                             // Debugging
//                             print(
//                                 "Order ID: ${order.orderId}, Status: ${order.status}");

//                             // final bool isCancelled =
//                             //     _cancelRequests[order.orderId] ??
//                             //         false; // Fix here
//                             return InkWell(
//                               // onTap: () {
//                               //   Navigator.push(
//                               //       context,
//                               //       MaterialPageRoute(
//                               //         builder: (context) => TrackOrderScreen(
//                               //             orderId: order.orderId),
//                               //       ));
//                               // },
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 elevation: 3,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             '${AppLocalizations.of(context)!.order} #${order.orderId}',
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                             ),
//                                           ),

//                                           // Updated Order Status Widget

//                                           Text(
//                                             getOrderStatusText(
//                                                     order.status, context)
//                                                 .toUpperCase(),
//                                             style: TextStyle(
//                                               color: getOrderStatusColor(
//                                                   order.status),
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const Divider(),

//                                       // Product details
//                                       Row(
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius: BorderRadius.circular(
//                                                 8), // Optional: Adds rounded corners
//                                             child: Image.network(
//                                               'https://ambrosiaayurved.in/${order.image}',
//                                               //    order.image, // Replace with your actual image URL field
//                                               width:
//                                                   100, // Adjust size as needed
//                                               height: 100,
//                                               fit: BoxFit.cover,
//                                               errorBuilder:
//                                                   (context, error, stackTrace) {
//                                                 return const Icon(
//                                                     Icons.image_not_supported,
//                                                     color: Colors.grey,
//                                                     size: 100);
//                                               },
//                                             ),
//                                           ),

//                                           // const Icon(Icons.shopping_bag,
//                                           //     color: Acolors.primary, size: 30),
//                                           const SizedBox(width: 10),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   ' ${order.productName}',
//                                                   style: const TextStyle(
//                                                       fontSize: 18,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 ),
//                                                 SizedBox(height: 2),
//                                                 // Text(
//                                                 //   'Product ID: ${order.productId}',
//                                                 //   style: const TextStyle(
//                                                 //       fontSize: 14),
//                                                 // ),

//                                                 Text(
//                                                   //  'Quantity: ${order.productQuantity}',
//                                                   '  ${AppLocalizations.of(context)!.quantity} : ${order.productQuantity}',
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                           FontWeight.w400),
//                                                 ),
//                                                 SizedBox(height: 15),
//                                                 Text(
//                                                   '\ ${AppLocalizations.of(context)!.rs} ${order.productPrice}',
//                                                   //   '\Rs ${order.productPrice}',
//                                                   style: const TextStyle(
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                           FontWeight.w500),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 8),

//                                       // Order total and date
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             ' ${AppLocalizations.of(context)!.total} : \Rs ${order.totalPrice}',
//                                             //   'Total: Rs ${order.totalPrice}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           Text(
//                                             '${AppLocalizations.of(context)!.date} : ${order.date}',
//                                             //  'Date: ${order.date}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Divider(),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceEvenly,
//                                         children: [
//                                           order.status == 0
//                                               ? Text(
//                                                   AppLocalizations.of(context)!
//                                                       .cancelled,
//                                                   //  'Cancelled',
//                                                   style: TextStyle(
//                                                     color: Colors.red,
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 )
//                                               : order.status == 4
//                                                   ? TextButton(
//                                                       onPressed: () {
//                                                         Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) =>
//                                                                   SubmitReviewScreen(
//                                                                 orderId: order
//                                                                     .orderId,
//                                                                 productId: order
//                                                                     .productId,
//                                                               ),
//                                                             ));

//                                                         // showReviewDialog(
//                                                         //   context,
//                                                         //   int.parse(order
//                                                         //       .productId), // Convert String to int
//                                                         //   int.parse(
//                                                         //       order.orderId),
//                                                         // );
//                                                       },
//                                                       child: Text(
//                                                         AppLocalizations.of(
//                                                                 context)!
//                                                             .addAReview,
//                                                         //  "Add a Review",
//                                                         style: TextStyle(
//                                                           color: Colors.blue,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 16,
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : TextButton(
//                                                       onPressed: () {
//                                                         if (order.status == 1) {
//                                                           final orderProvider =
//                                                               Provider.of<
//                                                                       OrderProvider>(
//                                                                   context,
//                                                                   listen:
//                                                                       false);

//                                                           // If order is pending, allow cancellation
//                                                           _showCancelDialog(
//                                                               context,
//                                                               orderProvider,
//                                                               order.orderId);
//                                                         } else {
//                                                           showDialog(
//                                                             context: context,
//                                                             builder:
//                                                                 (BuildContext
//                                                                     context) {
//                                                               return AlertDialog(
//                                                                 title: Text(
//                                                                     AppLocalizations.of(
//                                                                             context)!
//                                                                         .cannotCancelOrder
//                                                                     // "Cannot Cancel Order"
//                                                                     ),
//                                                                 content: Text(
//                                                                   AppLocalizations.of(
//                                                                           context)!
//                                                                       .cannotCancelMessage,
//                                                                   //  "This order cannot be canceled because it is already being processed."
//                                                                 ),
//                                                                 actions: [
//                                                                   TextButton(
//                                                                     onPressed:
//                                                                         () {
//                                                                       Navigator.of(
//                                                                               context)
//                                                                           .pop(); // Close the dialog
//                                                                     },
//                                                                     child: Text(
//                                                                       AppLocalizations.of(
//                                                                               context)!
//                                                                           .ok,

//                                                                       //   "OK"
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               );
//                                                             },
//                                                           );
//                                                         }
//                                                       },
//                                                       child: Text(
//                                                         AppLocalizations.of(
//                                                                 context)!
//                                                             .cancelOrder,
//                                                         // "Cancel Order",
//                                                         style: TextStyle(
//                                                           color: Colors.red,
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 16,
//                                                         ),
//                                                       ),
//                                                     ),
//                                           if (order.status !=
//                                               0) // Hide "Track" button if order is cancelled

//                                             const SizedBox(
//                                               height: 50,
//                                               child: VerticalDivider(
//                                                 color: Colors.grey,
//                                                 thickness: 1,
//                                               ),
//                                             ),
//                                           if (order.status !=
//                                               0) // Show "Track" button only if order is not cancelled
//                                             TextButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         TrackOrderScreen(
//                                                       orderId: order.orderId,
//                                                       orderStatus: order.status,
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               child: Text(
//                                                 AppLocalizations.of(context)!
//                                                     .track,
//                                                 // "Track",
//                                                 style: TextStyle(
//                                                     color: Acolors.primary,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 16),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Function to get order status text
// String getOrderStatusText(int status, BuildContext context) {
//   switch (status) {
//     case 0:
//       return "${AppLocalizations.of(context)!.cancelled}"
//           //   "Cancelled"
//           ;
//     case 1:
//       return "${AppLocalizations.of(context)!.pending}";
//     //  return "Pending";
//     case 2:
//       return "${AppLocalizations.of(context)!.processing}";
//     //  return "Processing";
//     case 3:
//       return "${AppLocalizations.of(context)!.rejected}";
//     //  return "Rejected";
//     case 4:
//       return "${AppLocalizations.of(context)!.delivered}";
//     //  return "Delivered";
//     default:
//       return "${AppLocalizations.of(context)!.unknown}";
//     //  return "Unknown";
//   }
// }

// // Function to get order status color
// Color getOrderStatusColor(int status) {
//   switch (status) {
//     case 0:
//       return Colors.red; // Cancelled
//     case 1:
//       return Colors.orange; // Pending
//     case 2:
//       return Colors.green; // Processing
//     case 3:
//       return Colors.red; // Rejected
//     case 4:
//       return Colors.blue; // Delivered
//     default:
//       return Colors.black;
//   }
// }

// // void showReviewDialog(BuildContext context, int productId, int orderId) {
// //   TextEditingController _commentController = TextEditingController();
// //   int _selectedRating = 0;
// //   bool _isSubmitting = false;

// //   showDialog(
// //     context: context,
// //     builder: (context) {
// //       return StatefulBuilder(
// //         builder: (context, setState) {
// //           return AlertDialog(
// //             content: Container(
// //               padding: EdgeInsets.all(18),
// //               decoration: BoxDecoration(
// //                 border: Border.all(color: Colors.green),
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   const Text(
// //                     "Submit Your Review",
// //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //                   ),
// //                   const SizedBox(height: 5),
// //                   _buildStarSelector(_selectedRating, (rating) {
// //                     setState(() {
// //                       _selectedRating = rating;
// //                     });
// //                   }),
// //                   const SizedBox(height: 10),
// //                   TextFormField(
// //                     controller: _commentController,
// //                     maxLines: 4,
// //                     decoration: const InputDecoration(
// //                       border: OutlineInputBorder(),
// //                       hintText: "Write your review here...",
// //                     ),
// //                     validator: (value) {
// //                       if (value == null || value.trim().isEmpty) {
// //                         return "Review cannot be empty";
// //                       }
// //                       return null;
// //                     },
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Acolors.primary,
// //                       foregroundColor: Colors.white,
// //                     ),
// //                     onPressed: _isSubmitting
// //                         ? null
// //                         : () async {
// //                             setState(() {
// //                               _isSubmitting = true;
// //                             });
// //                             await submitReview(context, productId, orderId,
// //                                 _selectedRating, _commentController.text);
// //                             setState(() {
// //                               _isSubmitting = false;
// //                             });
// //                           },
// //                     child: _isSubmitting
// //                         ? const CircularProgressIndicator(color: Colors.white)
// //                         : const Text("Submit"),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       );
// //     },
// //   );
// // }

// Widget _buildStarSelector(int selectedRating, Function(int) onRatingChanged) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: List.generate(5, (index) {
//       return IconButton(
//         icon: Icon(
//           index < selectedRating ? Icons.star : Icons.star_border,
//           color: Colors.green,
//           size: 35,
//         ),
//         onPressed: () {
//           onRatingChanged(index + 1);
//         },
//       );
//     }),
//   );
// }

// //  Set<int> submittedReviews = {}; // Track submitted reviews

// //   void showReviewDialogIfAllowed(BuildContext context, int productId, int orderId) {
// //     if (submittedReviews.contains(orderId)) {
// //       // Show dialog if review is already submitted
// //       showDialog(
// //         context: context,
// //         builder: (context) {
// //           return AlertDialog(
// //             title: const Text("Review Already Submitted"),
// //             content: const Text("You have already submitted a review for this order."),
// //             actions: [
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: const Text("OK"),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     } else {
// //       // Open review dialog if not submitted
// //       showReviewDialog(context, productId, orderId);
// //     }
// //   }
// // /// Function to send review to API
// // Future<void> submitReview(BuildContext context, int productId, int orderId,
// //     int rating, String message) async {
// //   final userProvider = Provider.of<UserProvider>(context, listen: false);
// //   final userId = userProvider.id;

// //   final String url = "https://ambrosiaayurved.in/api/submit_review";

// //   final Map<String, dynamic> requestBody = {
// //     "user_id": userId,
// //     "product_id": productId.toString(),
// //     "rating": rating.toString(),
// //     "message": message,
// //     "order_id": orderId.toString(),
// //   };

// //   try {
// //     final response = await http.post(
// //       Uri.parse(url),
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode(requestBody),
// //     );

// //     final Map<String, dynamic> responseData = jsonDecode(response.body);

// //     if (response.statusCode == 200 && responseData["status"] == true) {
// //       // Close the review dialog
// //       Navigator.pop(context);
// //       // Show success message
// //       SnackbarMessage.showSnackbar(context, responseData["message"]);
// //       print(responseData);
// //     } else {
// //       Navigator.pop(context);
// //       // Show error message
// //       print(responseData);
// //       SnackbarMessage.showSnackbar(context, responseData["message"]);
// //     }
// //   } catch (e) {
// //     print('$e');
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text("An error occurred. Please try again. $e")),
// //     );
// //   }
// // }

// /*
// void _showCancelDialog(
//     BuildContext context, OrderProvider orderProvider, String orderId) {
//   showDialog(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: const Text("Cancel Order"),
//         content: const Text("Are you sure you want to cancel this order?"),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(dialogContext).pop(); // Close dialog
//             },
//             child: const Text("No"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(dialogContext).pop(); // Close dialog
//               orderProvider.cancelOrder(
//                   orderId, context); // Proceed with cancellation
//             },
//             child: const Text("Yes", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       );
//     },
//   );
// }
// */
