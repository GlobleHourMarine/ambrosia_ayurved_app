import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/order_history/order_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/submit_review/submit_review.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/phonepe/phonepe_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/shiprocket/shiprocket_auth.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/track_order_history/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreenN extends StatefulWidget {
  const OrderHistoryScreenN({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreenN> createState() => _OrderHistoryScreenNState();
}

class _OrderHistoryScreenNState extends State<OrderHistoryScreenN>
    with TickerProviderStateMixin {
  List<Order> orders = [];
  bool isLoading = true;
  String? error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _shiprocketCancelMessage;
// Add these variables to your class
  bool _isTrackingLoading = false;
  bool _isCancelLoading = false;
  bool _isReviewLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    updateTrackingStatus(context);
    fetchOrders();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

// Cancel Order Function
  Future<void> _cancelOrder(Order order, String shiprocketOrderId) async {
    try {
      setState(() {
        _isCancelLoading = true;
      });

      // Get Shiprocket token
      String? bearerToken = await ShiprocketAuth.getToken();

      if (bearerToken == null) {
        throw Exception('Unable to get authentication token');
      }

      // Use the provided shiprocket order ID
      final response = await http.post(
        Uri.parse('https://apiv2.shiprocket.in/v1/external/orders/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: json.encode({
          "ids": [int.parse(shiprocketOrderId)]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Cancel response: $responseData');
        // Show success message
        setState(() {
          _shiprocketCancelMessage = responseData['message']; // save to state
        });

        print(_shiprocketCancelMessage);
        SnackbarMessage.showSnackbar(context, 'Order cancelled successfully');

        //  PhonePe refund API here
        final refundResponse =
            await PhonePePaymentService().initiateRefund(order.orderId);
        print('order id : ${order.orderId}');
        if (refundResponse != null) {
          print("Refund initiated: $refundResponse");
          SnackbarMessage.showSnackbar(
              context, 'Order cancelled & refund initiated');
        }

        await updateTrackingStatus(context);
        // Refresh orders to get updated status
        await fetchOrders();

        // Close the bottom sheet
        Navigator.pop(context);
      } else {
        throw Exception('Failed to cancel order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error cancelling order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isCancelLoading = false;
      });
    }
  }

// Show Cancel Confirmation Dialog
  Future<void> _showCancelConfirmation(
      Order order, String shiprocketOrderId) async {
    final bool? shouldCancel = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content:
              Text('Are you sure you want to cancel order ${order.orderId}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );

    if (shouldCancel == true) {
      await _cancelOrder(order, shiprocketOrderId);
    }
  }

  Future<void> fetchOrders() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.id;
      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/fetch_orders_data'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Order data : ${data}');
        if (data['status'] == 'success') {
          setState(() {
            orders = (data['data'] as List)
                .map((orderJson) => Order.fromJson(orderJson))
                .toList();
            // Sort by createdAt descending (latest first)
            orders.sort((a, b) {
              final dateA = DateTime.tryParse(a.createdAt) ?? DateTime(1970);
              final dateB = DateTime.tryParse(b.createdAt) ?? DateTime(1970);
              return dateB.compareTo(dateA); // descending order
            });
            // Extract all shiprocket_order_ids
            List<String> shiprocketOrderIds =
                orders.map((order) => order.shiprocketOrderId).toList();
            print('Shiprocket Order IDs: $shiprocketOrderIds');
            isLoading = false;
          });
          _animationController.forward();
        } else {
          setState(() {
            error = 'Failed to load orders';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
      case 'in transit':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'canceled':
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'shipped':
      case 'in transit':
        return Icons.local_shipping;
      case 'processing':
        return Icons.refresh;
      case 'canceled':
      case 'cancelled':
        return Icons.cancel;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: 'Order History',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
                error = null;
              });
              _animationController.reset();
              fetchOrders();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
            error = null;
          });
          _animationController.reset();
          await fetchOrders();
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Acolors.primary),
            ),
            SizedBox(height: 16),
            Text(
              'Loading your orders...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // if (error != null) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.error_outline,
    //           size: 64,
    //           color: Colors.red[300],
    //         ),
    //         const SizedBox(height: 16),
    //         Text(
    //           'Oops! Something went wrong',
    //           style: TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.grey[700],
    //           ),
    //         ),
    //         // const SizedBox(height: 8),
    //         // Text(
    //         //   error!,
    //         //   textAlign: TextAlign.center,
    //         //   style: TextStyle(
    //         //     fontSize: 14,
    //         //     color: Colors.grey[600],
    //         //   ),
    //         // ),
    //         const SizedBox(height: 24),
    //         ElevatedButton.icon(
    //           onPressed: () {
    //             setState(() {
    //               isLoading = true;
    //               error = null;
    //             });
    //             fetchOrders();
    //           },
    //           icon: const Icon(Icons.refresh),
    //           label: const Text('Try Again'),
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Acolors.primary,
    //             foregroundColor: Colors.white,
    //             padding: const EdgeInsets.symmetric(
    //               horizontal: 24,
    //               vertical: 12,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Orders Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t placed any orders yet.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, index);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            (index * 0.1).clamp(0.0, 1.0),
            1.0,
            curve: Curves.easeOutBack,
          ),
        ));

        return SlideTransition(
          position: slideAnimation,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showOrderDetails(order),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[100],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://ambrosiaayurved.in/${order.image}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[400],
                                    size: 32,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.productName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Order #${order.orderId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    getStatusIcon(order.currentStatus),
                                    size: 16,
                                    color: getStatusColor(order.currentStatus),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(order.currentStatus)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      order.currentStatus,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            getStatusColor(order.currentStatus),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantity: ${order.productQuantity}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ordered: ${formatDate(order.createdAt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${order.totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Acolors.primary,
                                ),
                              ),
                              if (order.productQuantity > 1)
                                Text(
                                  '₹${order.productPrice.toStringAsFixed(0)} each',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) =>
            DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        'Order Details',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow('Order ID', order.orderId),
                      _buildDetailRow('Product', order.productName),
                      _buildDetailRow('Status', order.currentStatus),
                      _buildDetailRow('Quantity', '${order.productQuantity}'),
                      _buildDetailRow('Unit Price',
                          '₹${order.productPrice.toStringAsFixed(0)}'),
                      _buildDetailRow('Total Amount',
                          '₹${order.totalPrice.toStringAsFixed(0)}'),
                      _buildDetailRow(
                          'Ordered Date', formatDate(order.createdAt)),
                      _buildDetailRow('Expected Delivery',
                          formatDate(order.expectedDeliveryDate)),
                      _buildDetailRow('Courier', order.courierCompany),
                      _buildDetailRow('AWB Code', order.awbCode),
                      const SizedBox(height: 10),

                      // Check if order is cancelled
                      if (order.currentStatus.toLowerCase() == 'canceled' ||
                          order.currentStatus.toLowerCase() == 'cancelled')
                        // Show "Cancelled" message in red
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'CANCELLED',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      //  letterSpacing: ,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            //  if (_shiprocketCancelMessage != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 1),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Your request to cancel order id ${order.orderId} has been taken.The freight amount against the order is blocked and will be added back automatically to your wallet in 3-4 working days subject to confirmation from the courier.",
                                      //  _shiprocketCancelMessage!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        )
                      else ...[
                        // Track Order Button
                        ElevatedButton.icon(
                          onPressed: _isTrackingLoading
                              ? null
                              : () async {
                                  // Use setModalState instead of setState
                                  setModalState(() {
                                    _isTrackingLoading = true;
                                  });
                                  try {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TrackingScreen1(
                                              awbCode: order.awbCode),
                                        ));
                                  } finally {
                                    // Use setModalState instead of setState
                                    setModalState(() {
                                      _isTrackingLoading = false;
                                    });
                                  }
                                },
                          icon: _isTrackingLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.track_changes,
                                  color: Colors.white,
                                ),
                          label: Text(_isTrackingLoading
                              ? 'Loading...'
                              : 'Track Order'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Acolors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),

                        const SizedBox(height: 12),
                        if (order.currentStatus.toLowerCase() ==
                            'pickup generated')

                          // Cancel Order Button
                          OutlinedButton.icon(
                            onPressed: _isCancelLoading
                                ? null
                                : () async {
                                    setModalState(() {
                                      _isCancelLoading = true;
                                    });

                                    try {
                                      await _showCancelConfirmation(
                                          order, order.shiprocketOrderId);
                                    } finally {
                                      setModalState(() {
                                        _isCancelLoading = false;
                                      });
                                    }
                                  },
                            icon: _isCancelLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                    ),
                                  )
                                : const Icon(
                                    Icons.cancel_outlined,
                                    color: Acolors.primary,
                                  ),
                            label: Text(
                              _isCancelLoading
                                  ? 'Cancelling...'
                                  : 'Cancel Order',
                              style: const TextStyle(color: Acolors.primary),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Acolors.primary),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        SizedBox(height: 10),
// Submit Review button if Delivered
                        if (order.currentStatus.toLowerCase() == 'delivered')
                          OutlinedButton.icon(
                            onPressed: _isReviewLoading
                                ? null
                                : () async {
                                    setModalState(() {
                                      _isReviewLoading = true;
                                    });

                                    try {
                                      // Navigate to Submit Review Screen
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SubmitReviewScreen(
                                            orderId: order.orderId,
                                            productId: order.productId,
                                          ),
                                        ),
                                      );
                                    } finally {
                                      setModalState(() {
                                        _isReviewLoading = false;
                                      });
                                    }
                                  },
                            icon: _isReviewLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Acolors.primary),
                                    ),
                                  )
                                : const Icon(
                                    Icons.rate_review_outlined,
                                    color: Acolors.primary,
                                  ),
                            label: Text(
                              _isReviewLoading ? 'Loading...' : 'Submit Review',
                              style: const TextStyle(color: Acolors.primary),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Acolors.primary),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> updateTrackingStatus(BuildContext context) async {
  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id.toString(); // Convert to string
    final url = Uri.parse(
        'https://ambrosiaayurved.in/tracking/update_tracking_status_for_app');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}), // Now userId is a string
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('update tracking response : ${data}');
      // if (data['status'] == true) {
      //   print('✅ Tracking status updated: ${data['message']}');
      // } else {
      //   print('❌ Failed to update tracking status: ${data['message']}');
      // }
    } else {
      print('❌ HTTP Error: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error updating tracking status: $e');
  }
}
