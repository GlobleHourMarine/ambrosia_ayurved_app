import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/track_order_history/row.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/track_order_history/track_order_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import intl package for date parsing

class TrackOrderScreen extends StatefulWidget {
  final String orderId;
  final int orderStatus;
  const TrackOrderScreen(
      {required this.orderId, required this.orderStatus, Key? key})
      : super(key: key);

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  Map<String, String> trackingData = {};
  bool isLoading = true;
  late int orderStatus;

  @override
  void initState() {
    super.initState();
    orderStatus = widget.orderStatus; // Set it before fetching tracking data
    fetchOrderTracking();
  }

  Future<void> fetchOrderTracking() async {
    final String url = 'https://ambrosiaayurved.in/api/track_order_details';
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.id;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'order_id': widget.orderId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          print(jsonResponse);

          final dynamic data = jsonResponse['data'];

          if (data is List && data.isNotEmpty) {
            setState(() {
              trackingData = {
                'expected_delivery': data[0]['expected_delivery'] ?? '',
                'shipped_date': data[0]['shipped_date'] ?? '',
                'out_for_delivery': data[0]['out_for_delivery'] ?? '',
                'product_delivered': data[0]['product_delivered'] ?? '',
              };

              isLoading = false;
            });
          }
          // else if (data is Map<String, dynamic>) {
          //   setState(() {
          //     trackingData = {
          //       'expected_delivery': data['expected_delivery'] ?? '',
          //       'shipped_date': data['shipped_date'] ?? '',
          //       'out_for_delivery': data['out_for_delivery'] ?? '',
          //       'product_delivered': data['product_delivered'] ?? '',
          //     };
          //     isLoading = false;
          //   });
          // }
          else {
            print(data);
            throw Exception("Unexpected data format");
          }
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to load order tracking data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching order tracking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Track History',
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 70,
                  //   color: Acolors.primary,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(12),
                  //     child: Row(
                  //       children: [
                  //         Material(
                  //           color: Colors.white.withOpacity(0.21),
                  //           borderRadius: BorderRadius.circular(12),
                  //           child: const BackButton(color: Acolors.white),
                  //         ),
                  //         const SizedBox(width: 30),
                  //         const Text(
                  //           'My Orders',
                  //           style:
                  //               TextStyle(fontSize: 24, color: Acolors.white),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: ${widget.orderId}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                                'Expected Delivery: ${trackingData['expected_delivery']}',
                                style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            Text('Tracking No: Will alot you soon',
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 8),
                            const Text('Courier: FastExpress',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16),
                    children: [
                      buildTimelineTile(
                        "Order Confirmed",
                        "Your order has been placed.",
                        trackingData['expected_delivery'],
                        isCompleted: widget.orderStatus >= 1,
                      ),
                      buildTimelineTile(
                        "Shipped",
                        "Your item has been shipped.",
                        trackingData['shipped_date'],
                        isCompleted: widget.orderStatus >= 2,
                      ),
                      buildTimelineTile(
                        "Out for delivery",
                        "Your item is out for delivery.",
                        trackingData['out_for_delivery'],
                        isCompleted: widget.orderStatus >= 2,
                      ),
                      buildTimelineTile(
                        "Delivered",
                        "Your item has been delivered.",
                        trackingData['product_delivered'],
                        isCompleted: widget.orderStatus >= 4,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildTimelineTile(String title, String description, String? date,
      {required bool isCompleted}) {
    return TimelineTile(
      isFirst: title == "Order Confirmed",
      isLast: title == "Delivered",
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: isCompleted ? Colors.green : Colors.grey,
      ),
      beforeLineStyle: LineStyle(
        color: isCompleted ? Colors.green : Colors.grey,
      ),
      endChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 4),
                Text(description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 4),
                if (date != null && date.isNotEmpty)
                  Text(date,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/track_order_history/track_order_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;

class TrackOrderScreen extends StatelessWidget {
  final String orderId;
  TrackOrderScreen({required this.orderId});

  Future<List<OrderTracking>> fetchOrderTracking(
      BuildContext context, String orderId) async {
    final String url = 'https://ambrosiaayurved.in/api/track_order_details';
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.id;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'order_id': orderId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 'success') {
          List<dynamic> data = jsonResponse['data'];
          return data.map((item) => OrderTracking.fromJson(item)).toList();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to load order tracking data');
      }
    } catch (e) {
      throw Exception('Error fetching order tracking: $e');
    }
  }

  final List<OrderStatus> orderStatuses = [
    OrderStatus("Order Confirmed", "Your order has been placed.",
        "Sat, 22nd Feb '25 - 12:08am", true),
    OrderStatus("Shipped", "Your item has been shipped.",
        "Sat, 22nd Feb '25 - 2:49am", false),
    OrderStatus("Out For Delivery", "Your item is out for delivery.",
        "Mon, 24th Feb '25 - 10:16am", false),
    OrderStatus("Delivered", "Your item has been delivered",
        "Mon, 24th Feb '25 - 5:17pm", false),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                color: Acolors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.white.withOpacity(0.21),
                        borderRadius: BorderRadius.circular(12),
                        child: const BackButton(
                          color: Acolors.white,
                        ),
                      ),
                      const SizedBox(width: 30),
                      const Text(
                        'My Orders',
                        style: TextStyle(fontSize: 24, color: Acolors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order ID: $orderId',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('Expected Delivery: March 5, 2025',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        Text('Tracking No: TRK12345',
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        const Text('Courier: FastExpress',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: orderStatuses.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return TimelineTile(
                    isFirst: index == 0,
                    isLast: index == orderStatuses.length,
                    indicatorStyle: IndicatorStyle(
                      width: 20,
                      color: orderStatuses[index].isCompleted
                          ? Colors.green
                          : Colors.grey,
                    ),
                    beforeLineStyle: LineStyle(
                      color: orderStatuses[index].isCompleted
                          ? Colors.green
                          : Colors.grey,
                    ),
                    endChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OrderStatusWidget(orderStatuses[index]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStatus {
  final String title;
  final String description;
  final String dateTime;
  final bool isCompleted;

  OrderStatus(this.title, this.description, this.dateTime, this.isCompleted);
}

class OrderStatusWidget extends StatelessWidget {
  final OrderStatus orderStatus;

  const OrderStatusWidget(this.orderStatus);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orderStatus.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(orderStatus.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[700])),
            SizedBox(height: 4),
            Text(orderStatus.dateTime,
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
*/
