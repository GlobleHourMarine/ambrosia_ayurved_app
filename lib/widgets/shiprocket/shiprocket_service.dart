import 'dart:convert';
import 'dart:math';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/phonepe/phonepe_service.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/shiprocket_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

Future<void> createShiprocketOrder({
  required String billingCustomerName,
  required String billingLastName,
  required String billingAddress,
  required String billingAddress2,
  required String billingCity,
  required String billingPincode,
  required String billingState,
  required String billingCountry,
  required String billingEmail,
  required String billingPhone,
  required List<Map<String, dynamic>> orderItems,
  required String paymentMethod,
  required double shippingCharges,
  required double giftwrapCharges,
  required double transactionCharges,
  required double totalDiscount,
  required double subTotal,
  required double length,
  required double breadth,
  required double height,
  required double weight,
  required BuildContext context,
}) async {
  /// 🔹 Helper to show error popup + snackbar
  void showError(String title, String message) {
    // FIRST: Dismiss the "Creating Order..." popup
    Navigator.of(context, rootNavigator: true).pop();

    // THEN: Show the error popup after a small delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        SuccessPopup.show(
          context: context,
          title: title,
          subtitle: message,
          iconColor: Colors.red,
          icon: Icons.cancel,
          autoCloseDuration: 0,
          buttonText: "OK",
        );
      });
    });
  }

  try {
    // ✅ Get Shiprocket token
    String? bearerToken = await ShiprocketAuth.getToken();
    if (bearerToken == null) {
      showError("Failed", "Failed to authenticate with Shiprocket");
      return;
    }

    final now = DateTime.now();
    final orderDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final merchantOrderId = GlobalPaymentData.merchantOrderId;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    var requestBody = {
      "order_id": merchantOrderId,
      "order_date": orderDate,
      "pickup_location": "warehouse",
      "comment": "Ambrosia",
      "reseller_name": "Ambrosia Ayurved",
      "company_name": "Ambrosia Ayurved",
      "billing_customer_name": billingCustomerName,
      "billing_last_name": billingLastName,
      "billing_address": billingAddress,
      "billing_address_2": billingAddress2,
      "billing_city": billingCity,
      "billing_pincode": billingPincode,
      "billing_state": billingState,
      "billing_country": billingCountry,
      "billing_email": billingEmail,
      "billing_phone": billingPhone,
      "shipping_is_billing": true,
      "shipping_customer_name": "",
      "shipping_last_name": "",
      "shipping_address": "",
      "shipping_address_2": "",
      "shipping_city": "",
      "shipping_pincode": "",
      "shipping_country": "",
      "shipping_state": "",
      "shipping_email": "",
      "shipping_phone": "",
      "order_items": orderItems,
      "payment_method": paymentMethod,
      "shipping_charges": shippingCharges,
      "giftwrap_charges": giftwrapCharges,
      "transaction_charges": transactionCharges,
      "total_discount": totalDiscount,
      "sub_total": subTotal,
      "length": length,
      "breadth": breadth,
      "height": height,
      "weight": weight
    };

    var request = http.Request(
      'POST',
      Uri.parse('https://apiv2.shiprocket.in/v1/external/orders/create/adhoc'),
    );

    request.body = json.encode(requestBody);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = json.decode(responseString);

    if (response.statusCode != 200) {
      showError("Failed", "Error creating order: ${response.reasonPhrase}");
      return;
    }

    print("Order created successfully!");
    print("Order created sucessfully : $responseData");
    final shipmentId = responseData['shipment_id'];

    // if (shipmentId == null) {
    //   showError("Failed", "Shipment ID missing in Shiprocket response.");
    //   return;
    // }

    /// 1️⃣ Assign AWB
    final awbResult = await assignAwbToShipment(
      token: bearerToken,
      shipmentIds: [shipmentId as int],
    );

// Check based on actual API contract
    final awbAssignStatus = awbResult['data']?['awb_assign_status'];
    final awbData = awbResult['data']?['response']?['data'];
    final assignedAwbCode = awbData?['awb_code'];

    if (awbAssignStatus != 1 ||
        assignedAwbCode == null ||
        assignedAwbCode.isEmpty) {
      print('AWB code result : ${awbResult.toString()}');
      showError("Failed", "Error while placing order");
      return;
    }

    final int shipmentIdFromAwb = awbData['shipment_id'];
    final int shiprocketOrderId = awbData['order_id'];
    final String courierName = awbData['courier_name'];
// ✅ AWB assigned successfully
    print("AWB Assigned: $assignedAwbCode");
    print("Shipment ID: $shipmentIdFromAwb");
    print("Order ID: $shiprocketOrderId");
    print("Courier Name: $courierName");

    /// 2️⃣ Generate Pickup
    final pickupResult = await generatePickupRequest(
      token: bearerToken,
      shipmentIds: [shipmentId],
    );
    final pickupStatus = pickupResult['data']?['pickup_status'];
    final pickupMessage = pickupResult['data']?['response']?['data'] ?? '';

    if (pickupStatus != 1) {
      print('Generata Pickup : ${pickupResult}');
      showError("Failed", "Error while placing order.");
      return;
    }

// ✅ Pickup generated successfully
    print("Pickup Generated: $pickupMessage");

    /// 3️⃣ Save Tracking Data
    final trackingData = await fetchTrackingInfo(assignedAwbCode, bearerToken);

// Extract values safely:
    final trackStatus = trackingData['tracking_data']?['track_status'];
    final shipmentTrackList =
        trackingData['tracking_data']?['shipment_track'] as List<dynamic>?;

    String? currentStatus;
    String? edd;

    if (shipmentTrackList != null && shipmentTrackList.isNotEmpty) {
      final firstTrack = shipmentTrackList[0];
      currentStatus = firstTrack['current_status'];
      edd = firstTrack['edd'];
    }

    print('Track Status: $trackStatus');
    print('Current Status: $currentStatus');
    print('Expected Delivery Date (EDD): $edd');

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.id;

    await saveTrackingData(
      userId: userId,
      orderId: merchantOrderId.toString(),
      awbCode: assignedAwbCode,
      shiprocketOrderId: shiprocketOrderId.toString(),
      shipmentId: shipmentIdFromAwb.toString(),
      courierCompany: courierName,
      expectedDeliveryDate: edd.toString(),
      trackStatus: trackStatus.toString(),
      currentStatus: currentStatus.toString(),
    );

    /// 4️⃣ Place Order
    ///
    final placeOrderProvider =
        Provider.of<PlaceOrderProvider>(context, listen: false);
    await placeOrderProvider.placeOrder(context);

    /// 5️⃣ Success Popup - Dismiss "Creating Order..." popup first
    Navigator.of(context, rootNavigator: true).pop();
    await Future.delayed(Duration(milliseconds: 300));
    SuccessPopup.show(
      context: context,
      title: "Order Created",
      subtitle:
          "Your order has been placed successfully! AWB: $assignedAwbCode",
      iconColor: Colors.green,
      icon: Icons.check_circle,
      navigateToScreen: CheckoutMessageView(),
    );
  } catch (e) {
    print('Error : $e');
    showError("Failed", "Error while placing order: $e");
  }
}

/*
// shiprocket code
// shiprocket create order 
Future<void> createShiprocketOrder({
  required String billingCustomerName,
  required String billingLastName,
  required String billingAddress,
  required String billingAddress2,
  required String billingCity,
  required String billingPincode,
  required String billingState,
  required String billingCountry,
  required String billingEmail,
  required String billingPhone,
  required List<Map<String, dynamic>> orderItems,
  required String paymentMethod,
  required double shippingCharges,
  required double giftwrapCharges,
  required double transactionCharges,
  required double totalDiscount,
  required double subTotal,
  required double length,
  required double breadth,
  required double height,
  required double weight,
  required BuildContext context,
}) async {
  // ✅ Fetch cached token or get a new one
  String? bearerToken = await ShiprocketAuth.getToken();

  if (bearerToken == null) {
    SnackbarMessage.showSnackbar(
        context, "Failed to authenticate with Shiprocket");
    return;
  }

  print("🔑 Using Shiprocket token: $bearerToken");

  // await fetchShiprocketToken();
  // final bearerToken = ShiprocketAuth.safeToken; // always non-nullable

  // final random = Random();
  // final orderId =
  //     'ORDER_${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(9000) + 1000}';

  // Get current date and time in required format
  final now = DateTime.now();
  print(DateTime.now());
  final orderDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

  final merchantOrderId = GlobalPaymentData.merchantOrderId;
  print('global merchant id : $merchantOrderId');

  // const bearerToken =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY4NTkzMDcsInNvdXJjZSI6InNyLWF1dGgtaW50IiwiZXhwIjoxNzUxNzk5Njk5LCJqdGkiOiJQcGNxYmJjbllzTU5LT1FQIiwiaWF0IjoxNzUwOTM1Njk5LCJpc3MiOiJodHRwczovL3NyLWF1dGguc2hpcHJvY2tldC5pbi9hdXRob3JpemUvdXNlciIsIm5iZiI6MTc1MDkzNTY5OSwiY2lkIjo2NTE3MTM5LCJ0YyI6MzYwLCJ2ZXJib3NlIjpmYWxzZSwidmVuZG9yX2lkIjowLCJ2ZW5kb3JfY29kZSI6IiJ9.2HUjE-3fSCP9jf-5uer7Khas3rwC0bSt3mJAIgu5KqE';

  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $bearerToken'
  };

  var requestBody = {
    "order_id": merchantOrderId,
    "order_date": orderDate,
    "pickup_location": "warehouse",
    "comment": "Ambrosia",
    "reseller_name": "Ambrosia Ayurved",
    "company_name": "Ambrosia Ayurved",
    "billing_customer_name": billingCustomerName,
    "billing_last_name": billingLastName,
    "billing_address": billingAddress,
    "billing_address_2": billingAddress2,
    "billing_city": billingCity,
    "billing_pincode": billingPincode,
    "billing_state": billingState,
    "billing_country": billingCountry,
    "billing_email": billingEmail,
    "billing_phone": billingPhone,
    "shipping_is_billing": true,
    "shipping_customer_name": "",
    "shipping_last_name": "",
    "shipping_address": "",
    "shipping_address_2": "",
    "shipping_city": "",
    "shipping_pincode": "",
    "shipping_country": "",
    "shipping_state": "",
    "shipping_email": "",
    "shipping_phone": "",
    "order_items": orderItems,
    "payment_method": paymentMethod,
    "shipping_charges": shippingCharges,
    "giftwrap_charges": giftwrapCharges,
    "transaction_charges": transactionCharges,
    "total_discount": totalDiscount,
    "sub_total": subTotal,
    "length": length,
    "breadth": breadth,
    "height": height,
    "weight": weight
  };

  var request = http.Request('POST',
      Uri.parse('https://apiv2.shiprocket.in/v1/external/orders/create/adhoc'));

  request.body = json.encode(requestBody);
  request.headers.addAll(headers);
  print(requestBody);

  try {
    http.StreamedResponse response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseData = json.decode(responseString);

    if (response.statusCode == 200) {
      print('Order created successfully!');

      print('Create order api of shipment :   $responseData');

      final shipmentId = responseData['shipment_id'];
      if (shipmentId != null) {
        List<int> shipmentIds = [shipmentId as int];

        final awbResult = await assignAwbToShipment(
          token: bearerToken,
          shipmentIds: shipmentIds,
        );

        if (awbResult['success'] == true) {
          final assignedAwbCode = awbResult['awb_code'] ?? '';

          print('AWB Number: $assignedAwbCode');
          SnackbarMessage.showSnackbar(context,
              'Order and AWB assigned successfully! AWB: $assignedAwbCode');

          final result = await generatePickupRequest(
              token: bearerToken, shipmentIds: shipmentIds);
          if (result['success'] == true) {
            SnackbarMessage.showSnackbar(context, 'Order Created successfully');
            print('Pickup generated successfully!');
            print('Response: ${result}');

            final placeOrderProvider =
                Provider.of<PlaceOrderProvider>(context, listen: false);

            // Step 2: Call the placeOrder function
            await placeOrderProvider.placeOrder(context);
            // 4️⃣ Show success popup

            final saveTracking = await saveTrackingData(
              userId: "10042",
              orderId: "OREDR_1234567",
              awbCode: "7656567565",
              shiprocketOrderId: "75675765675675",
              shipmentId: "89799989888",
              courierCompany: "Blue Dart",
              expectedDeliveryDate: "2025-08-17",
              trackStatus: "1",
              currentStatus: "Delivered",
            );

            SuccessPopup.show(
              context: context,
              title: "Order Created",
              subtitle: "Your order has been placed successfully.",
              iconColor: Colors.green,
              icon: Icons.check_circle,
              navigateToScreen: CheckoutMessageView(),
            );
          } else {
            print('Failed to generate pickup: ${result['error']}');
            Navigator.of(context, rootNavigator: true).pop();
            // Handle error - show error message to user
            SuccessPopup.show(
              context: context,
              title: "Failed",
              subtitle: "Error while placing order.",
              iconColor: Colors.red,
              icon: Icons.cancel,
              autoCloseDuration: 0,
              buttonText: "OK",
            );
          }
        } else {
          print('AWB assignment failed: ${awbResult['error']}');
          SuccessPopup.show(
            context: context,
            title: "Failed",
            subtitle: "Error while placing order.",
            iconColor: Colors.red,
            icon: Icons.cancel,
            autoCloseDuration: 0,
            buttonText: "OK",
          );
          SnackbarMessage.showSnackbar(context,
              'Order created but AWB assignment failed: ${awbResult['error']}');
        }
      }
    } else {
      SuccessPopup.show(
        context: context,
        title: "Failed",
        subtitle: "Error while placing order.",
        iconColor: Colors.red,
        icon: Icons.cancel,
        autoCloseDuration: 0,
        buttonText: "OK",
      );
      print('Error creating order: ${response.reasonPhrase}');
      print('Status code: ${response.statusCode}');
    }
  } catch (e) {
    SuccessPopup.show(
      context: context,
      title: "Failed",
      subtitle: "Error while placing order. $e",
      iconColor: Colors.red,
      icon: Icons.cancel,
      autoCloseDuration: 0,
      buttonText: "OK",
    );
    print('Exception occurred: $e');
  }
}

*/

//
// assgin awb
Future<Map<String, dynamic>> assignAwbToShipment({
  required String token,
  required List<int> shipmentIds,
}) async {
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final request = http.Request(
    'POST',
    Uri.parse('https://apiv2.shiprocket.in/v1/external/courier/assign/awb'),
  );

  request.body = json.encode({
    "shipment_id": shipmentIds,
  });

  request.headers.addAll(headers);

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final responseData = json.decode(responseBody);
    final awbCode = responseData['response']?['data']?['awb_code']?.toString();

    if (response.statusCode == 200 &&
        awbCode != null &&
        awbCode.trim().isNotEmpty) {
      return {
        'success': true,
        'data': responseData,
        'awb_code': awbCode,
      };
    } else {
      return {
        'success': false,
        'error': responseData['message'] ?? response.reasonPhrase,
        'statusCode': response.statusCode,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

//
//generate pickup

Future<Map<String, dynamic>> generatePickupRequest({
  required String token,
  required List<int> shipmentIds,
}) async {
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final request = http.Request(
    'POST',
    Uri.parse(
        'https://apiv2.shiprocket.in/v1/external/courier/generate/pickup'),
  );

  request.body = json.encode({
    "shipment_id": shipmentIds,
  });

  request.headers.addAll(headers);

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final responseData = json.decode(responseBody);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': responseData,
      };
    } else {
      return {
        'success': false,
        'error': responseData['message'] ?? response.reasonPhrase,
        'statusCode': response.statusCode,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

// save tracking data in our database :

Future<Map<String, dynamic>> saveTrackingData({
  required String userId,
  required String orderId,
  required String awbCode,
  required String shiprocketOrderId,
  required String shipmentId,
  required String courierCompany,
  required String expectedDeliveryDate,
  required String trackStatus,
  required String currentStatus,
}) async {
  final url = Uri.parse("https://ambrosiaayurved.in/Api/save_tracking_data");

  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "user_id": userId,
    "order_id": orderId,
    "awb_code": awbCode,
    "shiprocket_order_id": shiprocketOrderId,
    "shipment_id": shipmentId,
    "courier_company": courierCompany,
    "expected_delivery_date": expectedDeliveryDate,
    "track_status": trackStatus,
    "current_status": currentStatus,
  });
  print('save tracking data : $body');

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('save tracking data response : $data');
      return data;
    } else {
      print('save tracking data response : $response');
      throw Exception('Failed to save tracking data: ${response.statusCode}');
    }
  } catch (e) {
    print('save tracking data response : $e');
    throw Exception('Error saving tracking data: $e');
  }
}

Future<Map<String, dynamic>> fetchTrackingInfo(
    String awbNumber, String token) async {
  final url = Uri.parse(
      'https://apiv2.shiprocket.in/v1/external/courier/track/awb/$awbNumber');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Tracking Data: $data'); // <-- Print the response data here
    return data;
  } else {
    throw Exception('Failed to load tracking information');
  }
}
