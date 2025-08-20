// orders_service.dart
import 'dart:convert';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

// Data model for a single order item
class Order {
  final String id;
  final String orderId;
  final String productName;
  final String imageUrl;
  final String totalPrice;
  final String currentStatus;
  final String createdAt;

  Order({
    required this.id,
    required this.orderId,
    required this.productName,
    required this.imageUrl,
    required this.totalPrice,
    required this.currentStatus,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderId: json['order_id'],
      productName: json['product_name'],
      imageUrl: 'https://ambrosiaayurved.in/api/' +
          json['image'], // Construct full URL
      totalPrice: json['total_price'],
      currentStatus: json['current_status'],
      createdAt: json['created_at'],
    );
  }
}

// orders_service.dart
// ...
class OrdersService {
  Future<List<Order>> fetchOrders(String userId) async {
    final response = await http.post(
      Uri.parse('https://ambrosiaayurved.in/api/fetch_orders_data'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId, // Will be a string in JSON
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('orders data : $data');

      if (data['status'] == 'success') {
        List<dynamic> orderData = data['data'];
        print('order data : ${orderData}');
        return orderData.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }
}

class OrderProviderG with ChangeNotifier {
  final OrdersService _ordersService = OrdersService();
  List<Order> _orders = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // This method would be called from the UI, fetching the userId from another provider.
  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print(_orders);
      _orders = await _ordersService.fetchOrders(
        userId,
      );
    } catch (e) {
      _errorMessage = 'Failed to fetch orders. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class OrderHistoryScreenG extends StatefulWidget {
  @override
  _OrderHistoryScreenGState createState() => _OrderHistoryScreenGState();
}

class _OrderHistoryScreenGState extends State<OrderHistoryScreenG> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // It's safe to access providers here because the build phase is complete.
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.id;
      print("user id from provider : $userId");

      Provider.of<OrderProviderG>(context, listen: false).loadOrders(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Consumer<OrderProviderG>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  provider.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (provider.orders.isEmpty) {
            return Center(
              child: Text(
                'You have no orders yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              final order = provider.orders[index];
              return OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderHistoryScreenGAlternative extends StatelessWidget {
  const OrderHistoryScreenGAlternative({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProviderG>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.id;
    // You can call loadOrders here as it's not in initState.
    // It will be called every time the widget is built, but you can add a check
    // to prevent redundant calls if needed.
    provider.loadOrders(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Consumer<OrderProviderG>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                provider.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (provider.orders.isEmpty) {
            return Center(
              child: Text('You have no orders yet.'),
            );
          }
          return ListView.builder(
            itemCount: provider.orders.length,
            itemBuilder: (context, index) {
              return OrderCard(order: provider.orders[index]);
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                order.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 80),
              ),
            ),
            SizedBox(width: 16.0),
            // Order Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Order ID: ${order.orderId}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Status: ${order.currentStatus}',
                    style: TextStyle(
                      color: _getStatusColor(order.currentStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Total Price: ₹${order.totalPrice}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Order Date: ${order.createdAt.split(' ')[0]}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Canceled':
        return Colors.red;
      case 'Shipped':
        return Colors.blue;
      case 'Pending':
      default:
        return Colors.orange;
    }
  }
}
