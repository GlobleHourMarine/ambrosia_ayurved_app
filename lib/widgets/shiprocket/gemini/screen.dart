import 'package:ambrosia_ayurved/widgets/shiprocket/gemini/tracking_model.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/gemini/tracking_service.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class TrackingScreen2 extends StatefulWidget {
  const TrackingScreen2({super.key});

  @override
  State<TrackingScreen2> createState() => _TrackingScreen2State();
}

class _TrackingScreen2State extends State<TrackingScreen2> {
  final TextEditingController _awbController = TextEditingController();
  final ApiService _apiService = ApiService();
  TrackingData? _trackingData;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _trackShipment() async {
    final awbCode = _awbController.text.trim();
    if (awbCode.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid AWB code.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _trackingData = null;
    });

    try {
      final data = await _apiService.getTrackingData(awbCode);
      setState(() {
        _trackingData = data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getStatusDescription(int statusCode) {
    switch (statusCode) {
      case 6:
        return 'Shipped';
      case 7:
        return 'Delivered';
      case 8:
        return 'Canceled';
      case 9:
        return 'RTO Initiated';
      case 10:
        return 'RTO Delivered';
      case 12:
        return 'Lost';
      case 13:
        return 'Pickup Error';
      case 14:
        return 'RTO Acknowledged';
      case 15:
        return 'Pickup Rescheduled';
      case 16:
        return 'Cancellation Requested';
      case 17:
        return 'Out For Delivery';
      case 18:
        return 'In Transit';
      case 19:
        return 'Out For Pickup';
      case 20:
        return 'Pickup Exception';
      case 21:
        return 'Undelivered';
      case 22:
        return 'Delayed';
      case 23:
        return 'Partial Delivered';
      case 24:
        return 'Destroyed';
      case 25:
        return 'Damaged';
      case 26:
        return 'Fulfilled';
      case 27:
        return 'Pickup Booked';
      case 38:
        return 'Reached at Destination Hub';
      case 39:
        return 'Misrouted';
      case 40:
        return 'RTO NDR';
      case 41:
        return 'RTO OFD';
      case 42:
        return 'Picked Up';
      case 43:
        return 'Self Fulfilled';
      case 44:
        return 'Disposed Off';
      case 45:
        return 'Cancelled Before Dispatched';
      case 46:
        return 'RTO in Intransit';
      case 47:
        return 'QC Failed';
      case 48:
        return 'Reached Warehouse';
      case 49:
        return 'Custom Cleared';
      case 50:
        return 'In Flight';
      case 51:
        return 'Handover to Courier';
      case 52:
        return 'Shipment Booked';
      case 54:
        return 'In Transit Overseas';
      case 55:
        return 'Connection Aligned';
      case 56:
        return 'Reached Overseas Warehouse';
      case 57:
        return 'Custom Cleared Overseas';
      case 59:
        return 'Box Packing';
      case 60:
        return 'FC Allocated';
      case 61:
        return 'Picklist Generated';
      case 62:
        return 'Ready To Pack';
      case 63:
        return 'Packed';
      case 67:
        return 'FC Manifest Generated';
      case 68:
        return 'Processed at Warehouse';
      case 71:
        return 'Handover Exception';
      case 72:
        return 'Packed Exception';
      case 75:
        return 'RTO Lock';
      case 76:
        return 'Untraceable';
      case 77:
        return 'Issue Related to the Recipient';
      case 78:
        return 'Reached Back at Seller City';
      default:
        return 'Unknown Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildTrackingResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Track your shipment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _awbController,
            decoration: InputDecoration(
              labelText: 'Enter AWB Code',
              hintText: 'e.g., 788830567028',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              prefixIcon:
                  const Icon(Icons.local_shipping_outlined, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _awbController.clear();
                },
              ),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _trackShipment(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _trackShipment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Track Shipment',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingResult() {
    if (_isLoading) {
      return _buildShimmerLoading();
    } else if (_errorMessage != null) {
      return _buildErrorState(_errorMessage!);
    } else if (_trackingData != null &&
        _trackingData!.error != null &&
        _trackingData!.error!.isNotEmpty) {
      return _buildNotFoundState(_trackingData!.error!);
    } else if (_trackingData != null &&
        _trackingData!.shipmentTrack.isNotEmpty) {
      final shipment = _trackingData!.shipmentTrack.first;
      return _buildTrackingCard(shipment);
    } else {
      return _buildInitialState();
    }
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/delivery_truck.json', // Add a Lottie animation file
          height: 250,
        ),
        const Text(
          'Enter an AWB code to track your package.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/error_animation.json', // Add a Lottie animation file
          height: 200,
        ),
        const SizedBox(height: 16),
        Text(
          'Oops! Something went wrong.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red[700],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNotFoundState(String message) {
    return Column(
      children: [
        Lottie.asset(
          'assets/animations/not_found.json', // Add a Lottie animation file
          height: 250,
        ),
        const SizedBox(height: 16),
        const Text(
          'Shipment not found!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTrackingCard(ShipmentTrack shipment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AWB Code',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      shipment.awbCode,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                _buildInfoRow('Current Status',
                    _getStatusDescription(_trackingData!.shipmentStatus)),
                _buildInfoRow('Courier', shipment.courierName),
                _buildInfoRow('Origin', shipment.origin),
                _buildInfoRow('Destination', shipment.destination),
                _buildInfoRow('Last Updated', shipment.formattedUpdatedTime),
                if (shipment.edd != null && shipment.edd!.isNotEmpty)
                  _buildInfoRow('Expected Delivery', shipment.edd!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Status Timeline',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildTimeline(shipment),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(ShipmentTrack shipment) {
    // In the provided JSON, shipment_track_activities is null.
    // If you get this data from the API, you can build a more detailed timeline.
    // For now, we'll use the 'current_status' from the shipmentTrack.
    final statusHistory = [
      'Shipment Booked',
      'Picked Up',
      'In Transit',
      _getStatusDescription(_trackingData!.shipmentStatus)
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statusHistory.length,
      itemBuilder: (context, index) {
        final isLast = index == statusHistory.length - 1;
        final isActive = index <=
            statusHistory
                .indexOf(_getStatusDescription(_trackingData!.shipmentStatus));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blueAccent : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive ? Icons.check : Icons.circle_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50, // Adjust height as needed
                    color: isActive ? Colors.blueAccent : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusHistory[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    if (isActive)
                      Text(
                        shipment.formattedUpdatedTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
