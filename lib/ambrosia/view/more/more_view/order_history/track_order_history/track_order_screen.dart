import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common/contact_info.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/track_order_history/track_order_model.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/shiprocket/shiprocket_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingScreen1 extends StatefulWidget {
  final String awbCode;

  const TrackingScreen1({Key? key, required this.awbCode}) : super(key: key);

  @override
  _TrackingScreen1State createState() => _TrackingScreen1State();
}

class _TrackingScreen1State extends State<TrackingScreen1>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, dynamic>? _trackingData;
  String? _error;

  late AnimationController _progressAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _fadeAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _progressAnimationController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _fadeAnimationController, curve: Curves.easeInOut),
    );

    _trackShipment();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _trackShipment() async {
    // ✅ Get Shiprocket token
    String? bearerToken = await ShiprocketAuth.getToken();

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken'
      };

      var request = http.Request(
        'GET',
        Uri.parse(
            'https://apiv2.shiprocket.in/v1/external/courier/track/awb/${widget.awbCode}'),
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response);

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> data = json.decode(responseString);
        print(data);

        setState(() {
          _trackingData = data;
          _isLoading = false;
        });

        _fadeAnimationController.forward();
        _progressAnimationController.forward();
      } else {
        setState(() {
          print('tracking : $response');
          _error = 'Unable to track your order. Please try again later.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('tracking :$e');
      setState(() {
        _error = 'Connection error. Please check your internet connection.';
        _isLoading = false;
      });
    }
  }
  // Updated methods to handle only the specific Shiprocket status terms// Updated methods to handle status progression - stays on current step until next step is confirmed

  List<TrackingStep> _getTrackingSteps(String currentStatus) {
    int currentStepIndex = _getCurrentStepIndex(currentStatus);

    return [
      TrackingStep(
        title: "Order Confirmed",
        subtitle: "Your order has been placed",
        icon: Icons.check_circle,
        isCompleted: currentStepIndex > 0,
        isActive: currentStepIndex == 0,
      ),
      TrackingStep(
        title: "Ready to Ship",
        subtitle: "Your item has been packed",
        icon: Icons.inventory_2,
        isCompleted: currentStepIndex > 1,
        isActive: currentStepIndex == 1,
      ),
      TrackingStep(
        title: "Shipped",
        subtitle: "Your order is on the way",
        icon: Icons.local_shipping,
        isCompleted: currentStepIndex > 2,
        isActive: currentStepIndex == 2,
      ),
      TrackingStep(
        title: "Out for Delivery",
        subtitle: "Your order is out for delivery",
        icon: Icons.delivery_dining,
        isCompleted: currentStepIndex > 3,
        isActive: currentStepIndex == 3,
      ),
      TrackingStep(
        title: "Delivered",
        subtitle: "Order delivered successfully",
        icon: Icons.home,
        isCompleted: currentStepIndex > 4,
        isActive: currentStepIndex == 4,
      ),
    ];
  }

// Determine current step index based on status
  int _getCurrentStepIndex(String currentStatus) {
    String status = currentStatus.toLowerCase().trim();

    // Step 4: Delivered (final step)
    if (status.contains("delivered")) {
      return 4;
    }

    // Step 3: Out for Delivery
    if (status.contains("out for delivery") ||
        status.contains("out-for-delivery") ||
        status.contains("out_for_delivery")) {
      return 3;
    }

    // Step 2: Shipped/Dispatched
    if (status.contains("shipped") ||
        status.contains("dispatched") ||
        status.contains("in transit") ||
        status.contains("in_transit") ||
        status.contains("intransit")) {
      return 2;
    }

    // Step 1: Packed
    if (status.contains("packed") ||
        status.contains("ready to ship") ||
        status.contains("ready_to_ship") ||
        status.contains("manifest")) {
      return 1;
    }

    // Step 0: Order Confirmed (default for all other statuses)
    // This includes: pickup generated, out for pickup, pickup error, pickup exception, etc.
    return 0;
  }

  // bool _isStatusAtLeast(String currentStatus, String targetStatus) {
  //   int currentStepIndex = _getCurrentStepIndex(currentStatus);

  //   // Map target status to step index
  //   Map<String, int> targetStepMap = {
  //     "Pickup Generated": 0,
  //     "Packed": 1,
  //     "Shipped": 2,
  //     "Out For Delivery": 3,
  //     "Delivered": 4,
  //   };

  //   int targetStepIndex = targetStepMap[targetStatus] ?? 0;

  //   return currentStepIndex >= targetStepIndex;
  // }

  Color _getStatusColor(String currentStatus) {
    int stepIndex = _getCurrentStepIndex(currentStatus);

    switch (stepIndex) {
      case 4: // Delivered
        return Colors.green;
      case 3: // Out for Delivery
        return Colors.blue;
      case 2: // Shipped
        return Colors.blue;
      case 1: // Packed
        return const Color.fromARGB(255, 203, 166, 110);
      case 0: // Order Confirmed
      default:
        return const Color.fromARGB(255, 203, 166, 110);
    }
  }

  String _getMainStatus(String currentStatus) {
    int stepIndex = _getCurrentStepIndex(currentStatus);

    List<String> stepTitles = [
      "Order Confirmed",
      "Packed",
      "Shipped",
      "Out for Delivery",
      "Delivered"
    ];

    return stepTitles[stepIndex];
  }

// Helper method to get user-friendly status message
  String _getStatusMessage(String currentStatus) {
    int stepIndex = _getCurrentStepIndex(currentStatus);
    String status = currentStatus.toLowerCase().trim();

    // For error/exception cases, show generic message
    if (status.contains("error") || status.contains("exception")) {
      switch (stepIndex) {
        case 0:
          return "We're processing your order";
        case 1:
          return "Your order is being prepared";
        case 2:
          return "Your order is on the way";
        case 3:
          return "Your order will be delivered soon";
        default:
          return "Your order is being processed";
      }
    }

    // For normal statuses, show appropriate message
    switch (stepIndex) {
      case 4:
        return "Your order has been delivered successfully";
      case 3:
        return "Your order is out for delivery";
      case 2:
        return "Your order is on the way to you";
      case 1:
        return "Your order is ready to ship";
      case 0:
      default:
        return "Your order is being processed";
    }
  }
  // bool _isStatusAtLeast(String currentStatus, String targetStatus) {
  //   // Define the order of statuses
  //   List<String> statusOrder = [
  //     "Pickup Generated",
  //     "Packed",
  //     "Shipped",
  //     "Out For Delivery",
  //     "Delivered"
  //   ];

  //   int currentIndex = statusOrder.indexOf(currentStatus);
  //   int targetIndex = statusOrder.indexOf(targetStatus);

  //   // If current status is not found, return false
  //   if (currentIndex == -1) return false;

  //   // If target status is not found, return false
  //   if (targetIndex == -1) return false;

  //   // Return true if current status is at or beyond target status
  //   return currentIndex >= targetIndex;
  // }

  // Color _getStatusColor(String currentStatus) {
  //   switch (currentStatus) {
  //     case "Delivered":
  //       return Colors.green;
  //     case "Out For Delivery":
  //       return Colors.blue;
  //     case "Shipped":
  //       return Colors.blue;
  //     case "Packed":
  //       return const Color.fromARGB(255, 203, 166, 110);
  //     case "Pickup Generated":
  //       return const Color.fromARGB(255, 203, 166, 110);
  //     default:
  //       return Colors.grey;
  //   }
  // }

  // String _getMainStatus(String currentStatus) {
  //   // Return the exact status from Shiprocket or a default
  //   switch (currentStatus) {
  //     case "Pickup Generated":
  //       return "Pickup Generated";
  //     case "Packed":
  //       return "Packed";
  //     case "Shipped":
  //       return "Shipped";
  //     case "Out For Delivery":
  //       return "Out For Delivery";
  //     case "Delivered":
  //       return "Delivered";
  //     default:
  //       return currentStatus.isNotEmpty ? currentStatus : "Processing";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: "Track Order",
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
                _trackingData = null;
              });
              _trackShipment();
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : _error != null
              ? _buildErrorScreen()
              : _buildTrackingContent(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 15,
                ),
              ],
            ),
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Acolors.primary),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20),
                Text(
                  'Tracking your order...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _trackShipment();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 3. Update the FadeTransition return in _buildTrackingContent:
  Widget _buildTrackingContent() {
    final trackingData = _trackingData!['tracking_data'];

    if (trackingData['error'] != null && trackingData['error'].isNotEmpty) {
      return _buildNoOrderFound();
    }

    final shipmentData = trackingData['shipment_track'] != null &&
            trackingData['shipment_track'].isNotEmpty
        ? trackingData['shipment_track'][0]
        : null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOrderHeader(trackingData, shipmentData),
            SizedBox(height: 20),
            _buildTrackingProgress(shipmentData != null
                ? shipmentData['current_status'] ?? 'Processing'
                : 'Processing'),
            SizedBox(height: 20),
            if (shipmentData != null) _buildOrderDetails(shipmentData),
            SizedBox(height: 20),
            _buildTrackingTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOrderFound() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.orange[300],
            ),
            SizedBox(height: 20),
            Text(
              'Order Not Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We couldn\'t find any order with this tracking number.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Updated _buildOrderHeader method
  Widget _buildOrderHeader(
      Map<String, dynamic> trackingData, Map<String, dynamic>? shipmentData) {
    final currentStatus = shipmentData != null
        ? shipmentData['current_status'] ?? 'Processing'
        : 'Processing';
    final mainStatus = _getMainStatus(currentStatus);
    final statusColor = _getStatusColor(currentStatus);
    final statusMessage = _getStatusMessage(currentStatus);

    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _getCurrentStepIndex(currentStatus) == 4
                          ? Icons.check_circle
                          : Icons.local_shipping,
                      //  color: statusColor,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Current Status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    mainStatus,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              statusMessage,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: 10),
            // Text(
            //   'AWB: ${widget.awbCode}',
            //   style: TextStyle(color: Colors.grey),
            // ),
            if (shipmentData != null && shipmentData['edd'] != null)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Expected delivery: ${_formatDate(shipmentData['edd'])}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

// 2. Update _buildTrackingProgress method signature:
  Widget _buildTrackingProgress(String currentStatus) {
    // String instead of int
    final steps = _getTrackingSteps(currentStatus);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            int index = entry.key;
            TrackingStep step = entry.value;
            bool isLast = index == steps.length - 1;
            return _buildProgressStep(step, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProgressStep(TrackingStep step, bool isLast) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align to start for proper positioning
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? Acolors.primary
                    : step.isActive
                        ? Acolors.primary
                        : Colors.grey[300],
                shape: BoxShape.circle,
                boxShadow: step.isActive
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                step.isCompleted ? Icons.check : step.icon,
                color: step.isCompleted || step.isActive
                    ? Colors.white
                    : Colors.grey[600],
                size: 20,
              ),
            ),
            if (!isLast)
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: 2,
                height: 50,
                color: step.isCompleted ? Colors.green : Colors.grey[300],
              ),
          ],
        ),
        SizedBox(width: 20),
        Expanded(
          child: Container(
            // Add padding top to align text with center of icon (40px height / 2 = 20px, minus text height adjustment)
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: step.isCompleted || step.isActive
                        ? Colors.grey[800]
                        : Colors.grey[500],
                  ),
                ),
                SizedBox(height: 2), // Small spacing between title and subtitle
                Text(
                  step.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: isLast ? 0 : 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(Map<String, dynamic> shipmentData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 15),
          _buildDetailItem(Icons.confirmation_number, 'AWB Code',
              shipmentData['awb_code'] ?? 'N/A'),
          _buildDetailItem(Icons.local_shipping, 'Courier',
              shipmentData['courier_name'] ?? 'N/A'),
          _buildDetailItem(
              Icons.location_on, 'From', shipmentData['origin'] ?? 'N/A'),
          _buildDetailItem(
              Icons.place, 'To', shipmentData['destination'] ?? 'N/A'),
          if (shipmentData['weight'] != null &&
              shipmentData['weight'].toString().isNotEmpty)
            _buildDetailItem(Icons.monitor_weight, 'Weight',
                shipmentData['weight'].toString()),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need Help?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(ContactInfo.whatsappUrl),
                  icon: Icon(Icons.chat, size: 18),
                  label: Text('Chat Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[50],
                    foregroundColor: Colors.blue[600],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _launchURL(ContactInfo.phoneUrl),
                  icon: Icon(Icons.phone, size: 18),
                  label: Text('Call Us'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green[600],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
