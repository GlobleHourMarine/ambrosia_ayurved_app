// network_utils.dart
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  // Check if there is an active internet connection
  static Future<bool> hasActiveInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet connection is active
      }
    } catch (e) {
      print('No active internet connection: $e');
    }
    return false; // No active internet connection
  }

  // Fetch data with internet connection check
  static Future<void> fetchData(Function fetchDataFunction) async {
    print('Checking internet connection...');

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection.');
      return; // Exit the method if there's no connection
    }

    // Additional check to ensure there is an active internet connection
    final hasInternet = await hasActiveInternetConnection();
    if (!hasInternet) {
      print('No internet connection detected after checking online.');
      return;
    }

    // Call the provided fetch data function
    await fetchDataFunction();
  }
}
