import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ambrosia_ayurved/ambrosia/common/internet/network.dart';

class BasePage extends StatefulWidget {
  final Widget child;
  final Future<void> Function() fetchDataFunction;

  const BasePage(
      {required this.child, required this.fetchDataFunction, Key? key})
      : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool isConnectedToInternet = true;
  late final StreamSubscription<InternetConnectionStatus>
      _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _checkInitialConnection();
    _listenForConnectionChanges();
  }

  Future<void> _checkInitialConnection() async {
    try {
      bool initialConnection = await NetworkUtils.hasActiveInternetConnection();

      print('Initial connection check (NetworkUtils): $initialConnection');

      if (!mounted) return;

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
    _connectionSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) async {
      print('Connection status changed: $status');

      if (!mounted) return;

      // 🔹 Double-check with NetworkUtils to avoid false negatives
      final connected = status == InternetConnectionStatus.connected;
      final confirmedConnection =
          connected && await NetworkUtils.hasActiveInternetConnection();

      if (!mounted) return;
      setState(() {
        isConnectedToInternet = confirmedConnection;
      });

      if (confirmedConnection) {
        await NetworkUtils.fetchData(widget.fetchDataFunction);
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building UI: isConnectedToInternet = $isConnectedToInternet');
    return isConnectedToInternet ? widget.child : _noInternetUI();
  }

  Widget _noInternetUI() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100, color: const Color(0xFF272829)),
            const SizedBox(height: 20),
            const Text('No Internet Connection',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkInitialConnection,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
