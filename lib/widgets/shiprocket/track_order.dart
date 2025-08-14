import 'package:ambrosia_ayurved/cosmetics/common/contact_info.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/shiprocket_auth.dart';
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

  // final String bearerToken =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY3NTMwMzksInNvdXJjZSI6InNyLWF1dGgtaW50IiwiZXhwIjoxNzU1NzcxNzkxLCJqdGkiOiJpWmFwVHdubURDMjRWS1ltIiwiaWF0IjoxNzU0OTA3NzkxLCJpc3MiOiJodHRwczovL3NyLWF1dGguc2hpcHJvY2tldC5pbi9hdXRob3JpemUvdXNlciIsIm5iZiI6MTc1NDkwNzc5MSwiY2lkIjo2NTE3MTM5LCJ0YyI6MzYwLCJ2ZXJib3NlIjpmYWxzZSwidmVuZG9yX2lkIjowLCJ2ZW5kb3JfY29kZSI6IiJ9.tfzREh0gVEGxz3WQ4D-JwM7QPIiQExv0BLcDJujo6D4";

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

  List<TrackingStep> _getTrackingSteps(int currentStatus) {
    return [
      TrackingStep(
        title: "Order Confirmed",
        subtitle: "Your order has been placed",
        icon: Icons.check_circle,
        isCompleted: currentStatus >= 27,
        isActive: currentStatus == 27,
      ),
      TrackingStep(
        title: "Packed",
        subtitle: "Your item has been packed",
        icon: Icons.inventory_2,
        isCompleted: currentStatus >= 42,
        isActive: currentStatus == 42,
      ),
      TrackingStep(
        title: "Shipped",
        subtitle: "Your order is on the way",
        icon: Icons.local_shipping,
        isCompleted: currentStatus >= 6,
        isActive: currentStatus == 6 || currentStatus == 18,
      ),
      TrackingStep(
        title: "Out for Delivery",
        subtitle: "Your order is out for delivery",
        icon: Icons.delivery_dining,
        isCompleted: currentStatus >= 17,
        isActive: currentStatus == 17,
      ),
      TrackingStep(
        title: "Delivered",
        subtitle: "Order delivered successfully",
        icon: Icons.home,
        isCompleted: currentStatus == 7,
        isActive: currentStatus == 7,
      ),
    ];
  }

  Color _getStatusColor(int statusCode) {
    switch (statusCode) {
      case 7:
      case 26:
        return Colors.green;
      case 8:
      case 12:
      case 24:
      case 25:
        return Colors.red;
      case 17:
      case 18:
      case 42:
      case 6:
        return Colors.blue;
      case 22:
      case 20:
      case 21:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getMainStatus(int statusCode) {
    if (statusCode == 7) return "Delivered";
    if (statusCode == 17) return "Out for Delivery";
    if (statusCode == 18 || statusCode == 6) return "In Transit";
    if (statusCode == 42) return "Picked Up";
    if (statusCode == 27) return "Order Confirmed";
    if (statusCode == 8) return "Cancelled";
    return "Processing";
  }

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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
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
            _buildTrackingProgress(trackingData['track_status'] ?? 0),
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

  Widget _buildOrderHeader(
      Map<String, dynamic> trackingData, Map<String, dynamic>? shipmentData) {
    final statusCode = trackingData['track_status'] ?? 0;
    final mainStatus = _getMainStatus(statusCode);
    final statusColor = _getStatusColor(statusCode);
    return Card(
      elevation: 4,
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
                      statusCode == 7
                          ? Icons.check_circle
                          : Icons.local_shipping,
                      // size: 50,
                      //  color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Current Status',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  mainStatus,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            // SizedBox(height: 10),
            // Text(
            //   mainStatus,
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: statusColor,
            //   ),
            // ),
            SizedBox(height: 10),
            Text(
              // 'Order #${widget.awbCode}',
              'AWB: ${widget.awbCode}',
              style: TextStyle(color: Colors.grey),
            ),
            if (shipmentData != null && shipmentData['edd'] != null)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Expected delivery: ${_formatDate(shipmentData['edd'])}',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    //  color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    // return Container(
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       colors: [statusColor, statusColor.withOpacity(0.8)],
    //       begin: Alignment.topLeft,
    //       end: Alignment.bottomRight,
    //     ),
    //     borderRadius: BorderRadius.circular(15),
    //     boxShadow: [
    //       BoxShadow(
    //         color: statusColor.withOpacity(0.3),
    //         spreadRadius: 2,
    //         blurRadius: 10,
    //         offset: Offset(0, 5),
    //       ),
    //     ],
    //   ),
    //   padding: EdgeInsets.all(20),
    //   child: Column(
    //     children: [
    //       Icon(
    //         statusCode == 7 ? Icons.check_circle : Icons.local_shipping,
    //         size: 50,
    //         color: Colors.white,
    //       ),
    //       SizedBox(height: 15),
    //       Text(
    //         mainStatus,
    //         style: TextStyle(
    //           fontSize: 24,
    //           fontWeight: FontWeight.bold,
    //           color: Colors.white,
    //         ),
    //       ),
    //       SizedBox(height: 8),
    //       Text(
    //         'Order #${widget.awbCode}',
    //         style: TextStyle(
    //           fontSize: 16,
    //           color: Colors.white.withOpacity(0.9),
    //         ),
    //       ),
    //       if (shipmentData != null && shipmentData['edd'] != null)
    //         Padding(
    //           padding: EdgeInsets.only(top: 10),
    //           child: Text(
    //             'Expected delivery: ${_formatDate(shipmentData['edd'])}',
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: Colors.white.withOpacity(0.8),
    //             ),
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }

  Widget _buildTrackingProgress(int currentStatus) {
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
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: step.isCompleted
                    ? Colors.green
                    : step.isActive
                        ? Colors.blue
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
        SizedBox(width: 15),
        Expanded(
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

class TrackingStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;

  TrackingStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCompleted,
    required this.isActive,
  });
}
