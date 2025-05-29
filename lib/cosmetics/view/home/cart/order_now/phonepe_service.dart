// import 'dart:convert';
// import 'dart:math';
// import 'package:crypto/crypto.dart';
// import 'package:http/http.dart' as http;
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// // PhonePe Service Class (Add this to a separate file: phonepe_service.dart)
// class PhonePePaymentService {
//   // Test credentials
//   static const String merchantId = "TEST-M22NOXGSL1P2A_25052";
//   static const String saltKey = "MWRiMWMwMjAtNmRmMy00Mjk1LWI2N2EtZGNkMmU0MmVjOTQ1";
//   static const int saltIndex = 1;
  
//   // Test URLs
//   static const String baseUrl = "https://api-preprod.phonepe.com/apis/pg-sandbox";
//   static const String payEndpoint = "/pg/v1/pay";
//   static const String statusEndpoint = "/pg/v1/status";
  
//   // Initialize PhonePe SDK
//   static Future<void> initializePhonePe() async {
//     try {
//       await PhonePePaymentSdk.init(
//         "TEST", // Environment: TEST for sandbox, PRODUCTION for live
//         merchantId,
//         null, // App ID (optional for test)
//         true, // Enable logging
//       );
//       print("PhonePe SDK initialized successfully");
//     } catch (e) {
//       print("Error initializing PhonePe SDK: $e");
//     }
//   }
  
//   // Generate unique transaction ID
//   static String generateTransactionId() {
//     return "TXN${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(1000)}";
//   }
  
//   // Generate checksum for API calls
//   static String generateChecksum(String payload) {
//     final data = payload + saltKey;
//     final bytes = utf8.encode(data);
//     final digest = sha256.convert(bytes);
//     return "${digest.toString()}###$saltIndex";
//   }
  
//   // Create payment request
//   static Map<String, dynamic> createPaymentRequest({
//     required String transactionId,
//     required double amount,
//     required String userId,
//     String? mobileNumber,
//     String? callbackUrl,
//   }) {
//     return {
//       "merchantId": merchantId,
//       "merchantTransactionId": transactionId,
//       "merchantUserId": userId,
//       "amount": (amount * 100).round(), // Amount in paise
//       "redirectUrl": callbackUrl ?? "https://webhook.site/redirect-url",
//       "redirectMode": "POST",
//       "callbackUrl": callbackUrl ?? "https://webhook.site/callback-url",
//       "mobileNumber": mobileNumber ?? "9999999999",
//       "paymentInstrument": {
//         "type": "PAY_PAGE"
//       }
//     };
//   }
  
//   // Start payment using PhonePe SDK
//   static Future<Map<String, dynamic>> startPaymentWithSDK({
//     required double amount,
//     required String userId,
//     String? mobileNumber,
//   }) async {
//     try {
//       final transactionId = generateTransactionId();
//       final paymentRequest = createPaymentRequest(
//         transactionId: transactionId,
//         amount: amount,
//         userId: userId,
//         mobileNumber: mobileNumber,
//       );
      
//       final payload = base64Encode(utf8.encode(jsonEncode(paymentRequest)));
//       final checksum = generateChecksum(payload);
      
//       final response = await PhonePePaymentSdk.startTransaction(
//         body: payload,
//         checksum: checksum,
//         packageName: null, // Optional: specify app package name
//       );
      
//       return {
//         'success': true,
//         'transactionId': transactionId,
//         'response': response,
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'SDK Payment Error: $e',
//       };
//     }
//   }
  
//   // Check payment status
//   static Future<Map<String, dynamic>> checkPaymentStatus(String transactionId) async {
//     try {
//       final endpoint = "$baseUrl$statusEndpoint/$merchantId/$transactionId";
//       final checksum = generateChecksum("/pg/v1/status/$merchantId/$transactionId$saltKey");
      
//       final response = await http.get(
//         Uri.parse(endpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'X-VERIFY': checksum,
//           'X-MERCHANT-ID': merchantId,
//         },
//       );
      
//       final responseData = jsonDecode(response.body);
      
//       return {
//         'success': responseData['success'] ?? false,
//         'data': responseData['data'],
//         'message': responseData['message'],
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error checking status: $e',
//       };
//     }
//   }
// }
