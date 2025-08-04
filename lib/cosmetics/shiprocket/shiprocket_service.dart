// shiprocket_service.dart
import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/shiprocket/shiprocket_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShiprocketService {
  static const String baseUrl = 'https://apiv2.shiprocket.in/v1/external';

  // Store your credentials securely
  final String email;
  final String password;
  String? _authToken;

  ShiprocketService({
    required this.email,
    required this.password,
  });

  // Authentication - Get Token
  Future<bool> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return true;
      }
      return false;
    } catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }

  // Get headers with auth token
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      };

  // Create Order
  Future<Map<String, dynamic>?> createOrder({
    required Map<String, dynamic> orderData,
  }) async {
    if (_authToken == null) {
      await authenticate();
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/create/adhoc'),
        headers: _headers,
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Create order error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Create order exception: $e');
      return null;
    }
  }

  // Get shipping rates
  Future<Map<String, dynamic>?> getShippingRates({
    required String pickupPostcode,
    required String deliveryPostcode,
    required double weight,
    required double codAmount,
  }) async {
    if (_authToken == null) {
      await authenticate();
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courier/serviceability?'
            'pickup_postcode=$pickupPostcode&'
            'delivery_postcode=$deliveryPostcode&'
            'weight=$weight&'
            'cod=${codAmount > 0 ? 1 : 0}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Get rates error: $e');
      return null;
    }
  }

  // Track shipment
  Future<Map<String, dynamic>?> trackShipment(String awbCode) async {
    if (_authToken == null) {
      await authenticate();
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courier/track/awb/$awbCode'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Track shipment error: $e');
      return null;
    }
  }

  // Generate AWB (Air Waybill)
  Future<Map<String, dynamic>?> generateAWB({
    required int shipmentId,
    required int courierId,
  }) async {
    if (_authToken == null) {
      await authenticate();
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/courier/assign/awb'),
        headers: _headers,
        body: jsonEncode({
          'shipment_id': shipmentId,
          'courier_id': courierId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Generate AWB error: $e');
      return null;
    }
  }

  // Cancel shipment
  Future<bool> cancelShipment(List<String> awbCodes) async {
    if (_authToken == null) {
      await authenticate();
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/cancel/shipment/awbs'),
        headers: _headers,
        body: jsonEncode({
          'awbs': awbCodes,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Cancel shipment error: $e');
      return false;
    }
  }
}

// Example usage in your Flutter widget
class ShippingScreen extends StatefulWidget {
  @override
  _ShippingScreenState createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  late ShiprocketService _shiprocketService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _shiprocketService = ShiprocketService(
      email: 'yogesh4java44@gmail.com', // Replace with your credentials
      password: '%&^#%RiqI29HYN^o',
    );
  }

  Future<void> _createShipment() async {
    setState(() => _isLoading = true);

    final order = ShipmentOrder(
      orderId: 'ORDER_${DateTime.now().millisecondsSinceEpoch}',
      orderDate: DateTime.now().toIso8601String().split('T')[0],
      pickupLocation: 'Primary', // Your pickup location name
      billingCustomerName: 'John',
      billingLastName: 'Doe',
      billingAddress: '123 Test Street',
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

    try {
      final result = await _shiprocketService.createOrder(
        orderData: order.toJson(),
      );

      if (result != null) {
        print('Order created successfully: $result');
        // Handle success
      } else {
        print('Failed to create order');
        // Handle error
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _getShippingRates() async {
    final rates = await _shiprocketService.getShippingRates(
      pickupPostcode: '110001',
      deliveryPostcode: '400001',
      weight: 0.5,
      codAmount: 0, // 0 for prepaid, amount for COD
    );

    if (rates != null) {
      print('Shipping rates: $rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shiprocket Integration')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _createShipment,
                    child: Text('Create Shipment'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getShippingRates,
                    child: Text('Get Shipping Rates'),
                  ),
                ],
              ),
      ),
    );
  }
}
