import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/payment_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_grandtotal_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_provider.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentVerificationPage extends StatefulWidget {
  final String addressId;
  const PaymentVerificationPage({
    Key? key,
    required this.addressId,
  }) : super(key: key);

  @override
  _PaymentVerificationPageState createState() =>
      _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).unfocus(); // Ensures no unwanted focus at startup
    });
  }

  Future<bool> _checkAndRequestPermissions() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        Permission cameraPermission = Permission.camera;
        Permission mediaPermission =
            sdkInt >= 33 ? Permission.photos : Permission.storage;

        var cameraStatus = await cameraPermission.status;
        var mediaStatus = await mediaPermission.status;

        if (cameraStatus.isPermanentlyDenied ||
            mediaStatus.isPermanentlyDenied) {
          return await _showSettingsDialog();
        }

        if (!cameraStatus.isGranted || !mediaStatus.isGranted) {
          final shouldRequest = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permissions Needed'),
                  content: const Text(
                      'To add photos, we need access to your camera and media files.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (!shouldRequest) return false;

          if (!cameraStatus.isGranted) await cameraPermission.request();
          if (!mediaStatus.isGranted) await mediaPermission.request();

          cameraStatus = await cameraPermission.status;
          mediaStatus = await mediaPermission.status;

          if (cameraStatus.isGranted && mediaStatus.isGranted) return true;

          if (cameraStatus.isPermanentlyDenied ||
              mediaStatus.isPermanentlyDenied) {
            return await _showSettingsDialog();
          }

          SnackbarMessage.showSnackbar(context, 'Permissions denied.');
          return false;
        }

        return true;
      } else if (Platform.isIOS) {
        var cameraStatus = await Permission.camera.status;
        var photosStatus = await Permission.photos.status;

        if (cameraStatus.isPermanentlyDenied ||
            photosStatus.isPermanentlyDenied) {
          return await _showSettingsDialog();
        }

        if (!cameraStatus.isGranted || !photosStatus.isGranted) {
          final shouldRequest = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Permissions Needed'),
                  content: const Text(
                      'To add photos, we need access to your camera and photo library.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ) ??
              false;

          if (!shouldRequest) return false;

          if (!cameraStatus.isGranted) await Permission.camera.request();
          if (!photosStatus.isGranted) await Permission.photos.request();

          cameraStatus = await Permission.camera.status;
          photosStatus = await Permission.photos.status;

          if (cameraStatus.isGranted && photosStatus.isGranted) return true;

          if (cameraStatus.isPermanentlyDenied ||
              photosStatus.isPermanentlyDenied) {
            return await _showSettingsDialog();
          }

          SnackbarMessage.showSnackbar(context, 'Permissions denied.');
          return false;
        }

        return true;
      }

      return false;
    } catch (e) {
      print("Permission error: $e");
      SnackbarMessage.showSnackbar(context, 'Error requesting permissions: $e');
      return false;
    }
  }

// Add this helper method to your State class
  Future<bool> _showSettingsDialog() async {
    if (!mounted) return false;

    SnackbarMessage.showSnackbar(
        context, 'Permissions denied. Please enable them in app settings.');

    final openSettings = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permissions Denied'),
            content: const Text(
                'Would you like to open app settings to enable permissions?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Not Now'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        ) ??
        false;

    if (openSettings) {
      await openAppSettings();
    }

    return false;
  }

  final TextEditingController _transactionIdController =
      TextEditingController();
  File? _screenshot;
  String? _paymentStatus;
  bool _isLoading = false;
  final FocusNode _transactionFocusNode = FocusNode();

  Future<void> _pickScreenshot() async {
    try {
      final hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        return; // Don't proceed if permissions not granted
      }

      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _screenshot = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
  // // Function to pick screenshot
  // Future<void> _pickScreenshot() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _screenshot = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> handlePaymentAndOrder(BuildContext context,
      TextEditingController transactionIdController, File? screenshot) async {
    if (transactionIdController.text.isEmpty || screenshot == null) {
      SnackbarMessage.showSnackbar(
        context,
        "${AppLocalizations.of(context)!.uploadScreenshot}",
      );
      //    'Please enter transaction ID and upload screenshot');
      return;
    }

    // Show Order Confirmation Dialog
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.confirmOrder}",
              //  "Confirm Order"
            ),
            content:
                Text("${AppLocalizations.of(context)!.confirmOrderPrompt}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("${AppLocalizations.of(context)!.cancel}"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("${AppLocalizations.of(context)!.yes}"),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    setState(() {
      _isLoading = true;
    });
    try {
      setState(() {
        _isLoading = true;
      });
      final placeOrderProvider =
          Provider.of<PlaceOrderProvider>(context, listen: false);
      // In your PaymentScreen or wherever you call placeOrder
      placeOrderProvider.setAddressId(widget.addressId);
      await placeOrderProvider.placeOrder(context);

      // Ensure order ID is available after placing the order
      final orderId = placeOrderProvider.orderId;
      if (orderId == null) {
        print(orderId);
        // SnackbarMessage.showSnackbar(context, 'Order ID not found!');
        return;
      }

//       await Future.delayed(Duration(milliseconds: 100));
// await Provider.of<PlaceOrderProvider>(context, listen: false)
//           .placeOrder(context);

      await Provider.of<PaymentProvider>(context, listen: false).processPayment(
        context,
        orderId,
        transactionId: transactionIdController.text,
        screenshot: _screenshot?.path,
      );
    } catch (e) {
      print('Error verificaion: $e');
      //  SnackbarMessage.showSnackbar(context, '$e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.paymentVerification}",
        // 'Payment Verfication',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: 70,
          //   color: Acolors.primary,
          //   child: Padding(
          //     padding: const EdgeInsets.all(12),
          //     child: Row(
          //       children: [
          //         Material(
          //           color: Colors.white.withOpacity(0.21),
          //           borderRadius: BorderRadius.circular(12),
          //           child: const BackButton(
          //             color: Acolors.white,
          //           ),
          //         ),
          //         const SizedBox(width: 30),
          //         const Text(
          //           'Payment Verification',
          //           style: TextStyle(fontSize: 24, color: Acolors.white),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _transactionIdController,
                    focusNode: _transactionFocusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(18),
                    ],
                    decoration: InputDecoration(
                      labelText:
                          "${AppLocalizations.of(context)!.enterTransactionId}",
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${AppLocalizations.of(context)!.pleaseEnterTransactionId}";
                      } else if (!RegExp(r'^\d{12,18}$').hasMatch(value)) {
                        return "${AppLocalizations.of(context)!.pleaseEnterValidTransactionId}";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickScreenshot,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _screenshot == null
                          ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                          : Image.file(
                              _screenshot!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickScreenshot,
                    child: Text(
                      "${AppLocalizations.of(context)!.uploadScreenshot}",
                      // 'Upload Screenshot'
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Payment Status
          if (_paymentStatus != null)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _paymentStatus!,
                style: TextStyle(
                  fontSize: 18,
                  color: _paymentStatus == 'Payment data fetched successfully!'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          Spacer(),

          /// const SizedBox(height: 280),
          // Submit Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Acolors.primary,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        _transactionFocusNode
                            .unfocus(); // Explicitly remove focus from the TextField
                        FocusScope.of(context).unfocus(); // Extra safeguard
                        if (_formKey.currentState!.validate()) {
                          handlePaymentAndOrder(
                              context, _transactionIdController, _screenshot);
                        }
                      },
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "${AppLocalizations.of(context)!.submitPayment}",
                        //  'Submit Payment'
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
