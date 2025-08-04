// screens/shipping_screen.dart
import 'package:ambrosia_ayurved/cosmetics/shiprocket/shiprocket_model.dart';
import 'package:ambrosia_ayurved/cosmetics/shiprocket/shiprocket_service.dart';

import 'package:flutter/material.dart';

class ShippingScreen1 extends StatefulWidget {
  @override
  _ShippingScreen1State createState() => _ShippingScreen1State();
}

class _ShippingScreen1State extends State<ShippingScreen1> {
  late ShiprocketService _shiprocketService;
  bool _isLoading = false;
  String _status = '';
  List<Map<String, dynamic>> _shippingRates = [];
  String? _awbCode;
  Map<String, dynamic>? _trackingInfo;

  @override
  void initState() {
    super.initState();

    // 🔥 AUTHENTICATION FLOW - Initialize service here
    _shiprocketService = ShiprocketService(
      email: ShiprocketConfig.email,
      password: ShiprocketConfig.password,
    );

    // Authenticate on app start
    _authenticateUser();
  }

  // 🔥 AUTHENTICATION FLOW - Method implementation
  Future<void> _authenticateUser() async {
    setState(() {
      _isLoading = true;
      _status = 'Authenticating...';
    });

    try {
      bool success = await _shiprocketService.authenticate();
      setState(() {
        _status =
            success ? 'Authentication successful!' : 'Authentication failed!';
      });
      print(_status);
    } catch (e) {
      setState(() {
        _status = 'Authentication error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔥 CREATE ORDER WORKFLOW - Complete implementation
  Future<void> _createOrderWorkflow() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating order...';
    });

    try {
      // Step 1: Create the order object
      final order = ShipmentOrder(
        orderId: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
        orderDate: DateTime.now().toIso8601String().split('T')[0],
        pickupLocation: 'Primary', // Must match your Shiprocket dashboard
        billingCustomerName: 'John',
        billingLastName: 'Doe',
        billingAddress: '123 Test Street, Area Name',
        billingCity: 'Mumbai',
        billingPincode: '400001',
        billingState: 'Maharashtra',
        billingCountry: 'India',
        billingEmail: 'john@example.com',
        billingPhone: '9876543210',
        orderItems: [
          OrderItem(
            name: 'Test Product',
            sku: 'TEST001',
            units: 1,
            sellingPrice: 100.0,
          ),
        ],
        paymentMethod: 'Prepaid', // or 'COD'
        subTotal: 100.0,
        length: 10.0,
        breadth: 10.0,
        height: 10.0,
        weight: 0.5,
      );

      // Step 2: Create order via API
      final orderResult = await _shiprocketService.createOrder(
        orderData: order.toJson(),
      );

      if (orderResult != null) {
        setState(() {
          _status = 'Order created! Shipment ID: ${orderResult['shipment_id']}';
        });

        // Step 3: Get shipping rates
        await _getShippingRatesWorkflow();

        // Step 4: Generate AWB (you'd typically let user choose courier first)
        if (orderResult['shipment_id'] != null) {
          await _generateAWBWorkflow(
              orderResult['shipment_id'], 12); // 12 is example courier ID
        }
      } else {
        setState(() {
          _status = 'Failed to create order';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Order creation error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Get shipping rates (part of create order workflow)
  Future<void> _getShippingRatesWorkflow() async {
    setState(() => _status = 'Getting shipping rates...');

    try {
      final rates = await _shiprocketService.getShippingRates(
        pickupPostcode: '110001',
        deliveryPostcode: '400001',
        weight: 0.5,
        codAmount: 0, // 0 for prepaid, amount for COD
      );

      if (rates != null && rates['data'] != null) {
        setState(() {
          _shippingRates = List<Map<String, dynamic>>.from(
              rates['data']['available_courier_companies']);
          _status = 'Found ${_shippingRates.length} shipping options';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error getting rates: $e';
      });
    }
  }

  // Generate AWB (part of create order workflow)
  Future<void> _generateAWBWorkflow(int shipmentId, int courierId) async {
    setState(() => _status = 'Generating AWB...');

    try {
      final awbResult = await _shiprocketService.generateAWB(
        shipmentId: shipmentId,
        courierId: courierId,
      );

      if (awbResult != null && awbResult['awb_code'] != null) {
        setState(() {
          _awbCode = awbResult['awb_code'];
          _status = 'AWB Generated: $_awbCode';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'AWB generation error: $e';
      });
    }
  }

  // 🔥 ORDER TRACKING - Implementation
  Future<void> _trackOrderWorkflow() async {
    if (_awbCode == null) {
      setState(() {
        _status = 'No AWB code available for tracking';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Tracking shipment...';
    });

    try {
      final trackingData = await _shiprocketService.trackShipment(_awbCode!);

      if (trackingData != null) {
        setState(() {
          _trackingInfo = trackingData;
          _status = 'Tracking info updated';
        });
      } else {
        setState(() {
          _status = 'No tracking information found';
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Tracking error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Cancel order workflow
  Future<void> _cancelOrderWorkflow() async {
    if (_awbCode == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Cancelling shipment...';
    });

    try {
      bool success = await _shiprocketService.cancelShipment([_awbCode!]);
      setState(() {
        _status = success
            ? 'Shipment cancelled successfully'
            : 'Failed to cancel shipment';
      });
    } catch (e) {
      setState(() {
        _status = 'Cancellation error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shiprocket Integration'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Display
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status.isEmpty ? 'Ready to start...' : _status,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 20),
            // Loading Indicator
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Authentication Section
                      _buildSectionCard(
                        'Authentication',
                        [
                          ElevatedButton.icon(
                            onPressed: _authenticateUser,
                            icon: Icon(Icons.login),
                            label: Text('Re-authenticate'),
                          ),
                        ],
                      ),

                      // Order Creation Section
                      _buildSectionCard(
                        'Create Order Workflow',
                        [
                          ElevatedButton.icon(
                            onPressed: _createOrderWorkflow,
                            icon: Icon(Icons.add_shopping_cart),
                            label: Text('Create Complete Order'),
                          ),
                          if (_shippingRates.isNotEmpty)
                            Column(
                              children: [
                                Text('Available Couriers:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ..._shippingRates.take(3).map(
                                      (rate) => ListTile(
                                        title: Text(
                                            rate['courier_name'] ?? 'Unknown'),
                                        subtitle:
                                            Text('₹${rate['rate'] ?? 'N/A'}'),
                                        dense: true,
                                      ),
                                    ),
                              ],
                            ),
                        ],
                      ),

                      // Tracking Section
                      _buildSectionCard(
                        'Order Tracking',
                        [
                          ElevatedButton.icon(
                            onPressed: _trackOrderWorkflow,
                            icon: Icon(Icons.track_changes),
                            label: Text('Track Shipment'),
                          ),
                          if (_awbCode != null)
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('AWB: $_awbCode',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          if (_trackingInfo != null)
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Status: ${_trackingInfo!['tracking_data']?['track_status'] ?? 'Unknown'}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                        ],
                      ),

                      // Additional Actions
                      _buildSectionCard(
                        'Additional Actions',
                        [
                          ElevatedButton.icon(
                            onPressed: _cancelOrderWorkflow,
                            icon: Icon(Icons.cancel),
                            label: Text('Cancel Shipment'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

// config/shiprocket_config.dart
class ShiprocketConfig {
  // 🔥 Replace these with your actual credentials
  static const String email = 'yogesh4java44@gmail.com';
  static const String password = '%&^#%RiqI29HYN^o';

  static const String baseUrl = 'https://apiv2.shiprocket.in/v1/external';
  static const String defaultPickupLocation = 'Primary';
}

// Alternative: Environment-based config
// Create a .env file in your project root:
// SHIPROCKET_EMAIL=your-email@example.com
// SHIPROCKET_PASSWORD=your-password

// Then use flutter_dotenv package:
// static String get email => dotenv.env['SHIPROCKET_EMAIL'] ?? '';
// static String get password => dotenv.env['SHIPROCKET_PASSWORD'] ?? '';
