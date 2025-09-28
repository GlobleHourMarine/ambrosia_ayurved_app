import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/checkout_message/checkout_message.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/order_now_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/phonepe/phonepe_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/shiprocket/shiprocket_auth.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/order_history/order_history_screen.dart';
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
  void showError(String title, String message) async {
    final merchantOrderId = GlobalPaymentData.merchantOrderId.toString();
    try {
      await updateOrderStatus(merchantOrderId, message);
    } catch (apiError) {
      print("Failed to update order status: $apiError");
    }
    Navigator.of(context, rootNavigator: true).pop();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        SuccessPopup.show(
          context: context,
          title: "Order Placed",
          subtitle: "Your order has been placed successfully!",
          iconColor: Colors.green,
          icon: Icons.check_circle,
          navigateToScreen: CheckoutMessageView(),
        );

        // SuccessPopup.show(
        //   context: context,
        //   title: title,
        //   subtitle: message,
        //   iconColor: Colors.red,
        //   icon: Icons.cancel,
        //   autoCloseDuration: 0,
        //   buttonText: "OK",
        // );
      });
    });
  }

  try {
    // ✅ Get Shiprocket token
    String? bearerToken = await ShiprocketAuth.getToken();
    if (bearerToken == null) {
      showError("Failed", "Failed to place order");
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
      "pickup_location": "warehouse-1",
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
      showError("Failed", "${responseData}");
      return;
    }

    print("Order created successfully!");
    print("Order created sucessfully : $responseData");
    final shipmentId = responseData['shipment_id'];

    /// 1️⃣ Assign AWB
    final awbResult = await assignAwbToShipment(
      token: bearerToken,
      shipmentIds: [shipmentId as int],
    );

    final awbAssignStatus = awbResult['data']?['awb_assign_status'];
    final awbData = awbResult['data']?['response']?['data'];
    final assignedAwbCode = awbData?['awb_code'];

    if (awbAssignStatus != 1 ||
        assignedAwbCode == null ||
        assignedAwbCode.isEmpty) {
      print('AWB code result : ${awbResult.toString()}');
      showError("Failed", "${awbResult.toString()}");
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

    // / 2️⃣ Generate Pickup
    // final pickupResult = await generatePickupRequest(
    //   token: bearerToken,
    //   shipmentIds: [shipmentId],
    // );

    // final pickupStatus = pickupResult['data']?['pickup_status'];
    // final pickupMessage = pickupResult['data']?['response']?['data'] ?? '';

    // if (pickupStatus != 1) {
    //   print('Generata Pickup : ${pickupResult}');
    //   showError("Failed", "${pickupResult}");
    //   return;
    // }

    // print("Pickup Generated: $pickupMessage");

    final trackingData = await fetchTrackingInfo(assignedAwbCode, bearerToken);

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

    if (currentStatus == "AWB Assigned") {
      // 2️⃣ Generate Pickup
      final pickupResult = await generatePickupRequest(
        token: bearerToken,
        shipmentIds: [shipmentId],
      );

      final pickupStatus = pickupResult['data']?['pickup_status'];
      final pickupMessage = pickupResult['data']?['response']?['data'] ?? '';

      if (pickupStatus != 1) {
        print('Generate Pickup Failed: ${pickupResult}');
        showError("Failed", "${pickupResult}");
        return;
      }
      print("Pickup Generated: $pickupMessage");
    } else {
      print("Pickup not generated - Current status is: $currentStatus");
    }

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
    // final placeOrderProvider =
    //     Provider.of<PlaceOrderProvider>(context, listen: false);
    // await placeOrderProvider.placeOrder(context);
    /// 5️⃣ Success Popup - Dismiss "Creating Order..." popup first
    ///
    ///
    await updateTrackingStatus(context);
    Navigator.of(context, rootNavigator: true).pop();
    await Future.delayed(Duration(milliseconds: 300));
    SuccessPopup.show(
      context: context,
      title: "Order Placed",
      subtitle: "Your order has been placed successfully ! ",
      //  AWB: $assignedAwbCode",

      iconColor: Colors.green,
      icon: Icons.check_circle,
      navigateToScreen: CheckoutMessageView(),
    );
  } catch (e) {
    print('Error : $e');
    showError("Failed", "${e}");
  }
}

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
    print('assigned awb data : ${responseData}');
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
//

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
    print('Generate pickup Request : $responseData');
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
    throw Exception(
        //'${response.body}'
        'Failed to load tracking information');
  }
}
