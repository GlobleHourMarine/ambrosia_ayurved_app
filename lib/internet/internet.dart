import 'dart:async';
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
  bool isConnectedToInternet = true;
  late final StreamSubscription<InternetConnectionStatus> _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _listenForConnectionChanges();
  }
  Future<void> _checkInitialConnection() async {
  try {
    bool initialConnection = await InternetConnectionChecker().hasConnection;
    print('Initial connection check: $initialConnection');

    if (!mounted) return;

    // ✅ run after current build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        isConnectedToInternet = initialConnection;
      });
    });

    if (initialConnection) {
      await NetworkUtils.fetchData(widget.fetchDataFunction);
    }
  } catch (e) {
    print('Error checking initial connection: $e');
  }
}

void _listenForConnectionChanges() {
  _connectionSubscription = InternetConnectionChecker()
      .onStatusChange
      .listen((status) async {
    print('Connection status changed: $status');

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        isConnectedToInternet = (status == InternetConnectionStatus.connected);
      });
    });

    if (status == InternetConnectionStatus.connected) {
      await NetworkUtils.fetchData(widget.fetchDataFunction);
    }
  });
}
  @override
  void dispose() {
    _connectionSubscription.cancel(); // ✅ cancel the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building UI: isConnectedToInternet = $isConnectedToInternet');
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
