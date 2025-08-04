// tracking_screen.dart
import 'package:ambrosia_ayurved/widgets/shiprocket/shiprocket_tracking.dart';
import 'package:flutter/material.dart';

class TrackingScreen extends StatefulWidget {
  final String awbCode;
  final String token;

  const TrackingScreen({required this.awbCode, required this.token});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late Future<Map<String, dynamic>> _trackingFuture;
  bool _isLoading = true;
  Map<String, dynamic>? _trackingData;

  @override
  void initState() {
    super.initState();
    _fetchTrackingData();
  }

  Future<void> _fetchTrackingData() async {
    setState(() => _isLoading = true);
    final result = await TrackingService.trackShipment(
      token: widget.token,
      awbCode: widget.awbCode,
    );
    setState(() {
      _isLoading = false;
      if (result['success'] == true) {
        _trackingData = result['tracking_data'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Shipment'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchTrackingData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _trackingData == null
              ? Center(child: Text('No tracking data available'))
              : _buildTrackingUI(),
    );
  }

  Widget _buildTrackingUI() {
    final trackStatus = _trackingData!['track_status'] ?? 0;
    final activities = _trackingData!['shipment_track_activities'] ?? [];
    final statusText = TrackingService.getStatusText(trackStatus);
    final statusColor = TrackingService.getStatusColor(trackStatus);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: statusColor),
                      SizedBox(width: 10),
                      Text(
                        'Current Status',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'AWB: ${widget.awbCode}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Timeline
          Text(
            'Shipment Timeline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildTimeline(activities),

          // Details Card
          SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipment Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildDetailRow('Origin',
                      _trackingData!['shipment_track'][0]['origin'] ?? 'N/A'),
                  _buildDetailRow(
                      'Destination',
                      _trackingData!['shipment_track'][0]['destination'] ??
                          'N/A'),
                  _buildDetailRow('Weight',
                      _trackingData!['shipment_track'][0]['weight'] ?? 'N/A'),
                  _buildDetailRow('Estimated Delivery',
                      _trackingData!['shipment_track'][0]['edd'] ?? 'N/A'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<dynamic> activities) {
    if (activities.isEmpty) {
      return Center(child: Text('No tracking activities available'));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: activities.map<Widget>((activity) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                    if (activity != activities.last)
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['status'] ?? 'Update',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        activity['location'] ?? 'Location not available',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        activity['date'] ?? '',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
