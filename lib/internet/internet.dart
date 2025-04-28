import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ambrosia_ayurved/internet/network.dart';

class BasePage extends StatefulWidget {
  final Widget child; // Child widget that represents the content of the page
  final Future<void> Function() fetchDataFunction; // Function to fetch data

  BasePage({required this.child, required this.fetchDataFunction});

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool isConnectedToInternet =
      true; // Default to true to avoid showing no internet UI at startup

  @override
  void initState() {
    super.initState();
    _checkInitialConnection(); // Check initial connection status
    _listenForConnectionChanges(); // Listen for changes in connection status
  }

  // Check the initial internet connection status
  Future<void> _checkInitialConnection() async {
    try {
      bool initialConnection = await InternetConnectionChecker().hasConnection;
      print('Initial connection check: $initialConnection'); // Debug print
      setState(() {
        isConnectedToInternet = initialConnection;
      });

      // If there's an initial connection, fetch data
      if (initialConnection) {
        await NetworkUtils.fetchData(widget.fetchDataFunction);
      }
    } catch (e) {
      print('Error checking initial connection: $e'); // Debug print
    }
  }

  // Listen for internet connection status changes
  void _listenForConnectionChanges() {
    InternetConnectionChecker().onStatusChange.listen((status) async {
      print('Connection status changed: $status'); // Debug print
      setState(() {
        isConnectedToInternet = (status == InternetConnectionStatus.connected);
      });

      // Fetch data if connected
      if (isConnectedToInternet) {
        await NetworkUtils.fetchData(widget.fetchDataFunction);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Building UI: isConnectedToInternet = $isConnectedToInternet'); // Debug print
    return isConnectedToInternet ? widget.child : _noInternetUI();
  }

  // UI to show when there is no internet connection
  Widget _noInternetUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: const Color(0xFF272829)),
            SizedBox(height: 20),
            Text('No Internet Connection',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkInitialConnection,
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
