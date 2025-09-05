// ios simulator

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


/*
// new working one
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permissions first
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('ℹ️ Provisional notification permission granted');
    } else {
      print('❌ Notification permission denied');
      return;
    }

    await _initializeLocalNotifications();

    // CRITICAL: Create notification channel for Android 8+
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }

    // Handle token refresh and subscription
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      print('🔄 Token refreshed: $token');
      await _subscribeToTopic();
    });

    // Subscribe to topic initially
    await _subscribeToTopic();

    // Set up message handlers
    _setupMessageHandlers();

    // Get and print initial token
    String? token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');
  }

  Future<void> _initializeLocalNotifications() async {
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
        _handleNotificationTap(response);
      },
    );
  }

  // CRITICAL: Create notification channel for Android 8+
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // Must match your manifest meta-data
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      print('✅ Notification channel created');
    }
  }

  Future<void> _subscribeToTopic() async {
    try {
      if (Platform.isIOS) {
        // For iOS, wait for APNS token
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          print("📱 APNs token available. Subscribing to topic...");
          await _firebaseMessaging.subscribeToTopic("all_users");
          print("✅ Subscribed to topic: all_users");
        } else {
          print("⏳ Waiting for APNs token...");
          // Retry after delay
          await Future.delayed(const Duration(seconds: 2));
          await _subscribeToTopic();
        }
      } else {
        // For Android, subscribe directly
        await _firebaseMessaging.subscribeToTopic("all_users");
        print("✅ Subscribed to topic: all_users");
      }
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📬 Foreground Message: ${message.notification?.title}');
      print('📬 Message data: ${message.data}');
      _showLocalNotification(message);
    });

    // Handle notification taps when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          '📲 Notification tapped (background): ${message.notification?.title}');
      _handleMessageTap(message);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // Must match channel ID
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        notificationDetails,
        payload: message.data.toString(),
      );
      print('✅ Local notification shown');
    } catch (e) {
      print('❌ Error showing local notification: $e');
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    print('🔔 Local notification tapped: ${response.payload}');
    // Handle navigation or logic here
  }

  void _handleMessageTap(RemoteMessage message) {
    print('📲 Firebase message tapped: ${message.data}');
    // Handle navigation or logic here
  }

  // Method to get current FCM token (useful for debugging)
  Future<String?> getCurrentToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Method to manually subscribe to topic (for testing)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
    }
  }
}

*/


/*

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
*/


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