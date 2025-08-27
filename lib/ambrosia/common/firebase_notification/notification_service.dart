/*

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      // Request permissions (iOS)
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Notification permission granted');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('Provisional notification permission granted');
      } else {
        print('Notification permission denied');
      }

      // Subscribe to topic only on real devices
      // Only subscribe on real devices
      if (!Platform.isIOS || !(await isSimulator())) {
        try {
          await _firebaseMessaging.subscribeToTopic("all_users");
          print("Subscribed to topic: all_users");
        } catch (e) {
          print("Failed to subscribe to topic on simulator: $e");
        }
      }
      // Initialize local notifications
      const AndroidInitializationSettings androidInitSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initSettings =
          InitializationSettings(android: androidInitSettings);

      await _localNotificationsPlugin.initialize(initSettings);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground Message: ${message.notification?.title}');
        _showLocalNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Notification tapped: ${message.notification?.title}');
      });

      // Get FCM token safely
      try {
        String? token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');
      } catch (e) {
        print("Failed to get FCM token on simulator: $e");
      }
    } catch (e) {
      print("Notification initialization failed: $e");
    }
  }

  Future<bool> isSimulator() async {
    // Simple iOS simulator detection
    return Platform.isIOS && (await _firebaseMessaging.getAPNSToken()) == null;
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }
}


<<<<<<< HEAD:lib/widgets/notification_service.dart
/*
=======
*/

>>>>>>> bf89126e350fb8f9f56e9cc699c50f40f5d5e837:lib/ambrosia/common/firebase_notification/notification_service.dart
// from andriod one

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('ℹ️ Provisional notification permission granted');
    } else {
      print('❌ Notification permission denied');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        print("📱 APNs token available. Subscribing to topic...");
        await _firebaseMessaging.subscribeToTopic("all_users");
      } else {
        print("⏳ Waiting for APNs token...");
      }
    });
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Notification tapped with payload: ${response.payload}');
        // Handle navigation or logic here
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📬 Foreground Message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification tapped: ${message.notification?.title}');
    });

    String? token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }
}



/*

// directly from firebase 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Local Notifications plugin
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission();

    // Initialize local notification plugin
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings(
            '@mipmap/ic_launcher'); // change icon if needed

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await _localNotificationsPlugin.initialize(initSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Handle when app opened by notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification tapped: ${message.notification?.title}');
    });

    // Optional: print the device FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }
}
*/