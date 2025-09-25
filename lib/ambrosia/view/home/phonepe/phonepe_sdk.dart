import 'package:flutter/services.dart';

class PhonePePaymentSdk {
  static const MethodChannel _channel = MethodChannel('phonepe_payment_sdk');

  static Future<bool> init(String environment, String merchantId, String flowId,
      bool enableLogging) async {
    bool result = await _channel.invokeMethod('init', {
      'environment': environment,
      'merchantId': merchantId,
      'flowId': flowId,
      'enableLogs': enableLogging,
    });
    print('init : $result');
    return result;
  }

  static Future<Map<dynamic, dynamic>?> startTransaction(
      String request, String appSchema) async {
    var dict = <String, dynamic>{
      'request': request,
      'appSchema': 'com.app.ambrosiaayurved://payment',
    };

    Map<dynamic, dynamic>? result =
        await _channel.invokeMethod('startTransaction', dict);
    print('Transaction : $result');
    print('Transaction : $dict ');
    return result;
  }
}
