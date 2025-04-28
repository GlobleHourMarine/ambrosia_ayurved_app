import 'dart:convert';
import 'dart:io';
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
  @override
  _PaymentVerificationPageState createState() =>
      _PaymentVerificationPageState();
}

class _PaymentVerificationPageState extends State<PaymentVerificationPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      FocusScope.of(context).unfocus(); // Ensures no unwanted focus at startup
    });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // Permission granted, proceed with camera access
      _getImageFromCamera();
    } else if (status.isDenied) {
      // Permission denied, you might want to show a message
      print('Camera permission denied');
      // Optionally, show a dialog explaining why you need the permission
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, take the user to app settings
      openAppSettings();
    }
  }

  Future<void> _requestPhotosPermission() async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      // Permission granted, proceed with gallery access
      _getImageFromGallery();
    } else if (status.isDenied) {
      // Permission denied, you might want to show a message
      print('Photos permission denied');
      // Optionally, show a dialog explaining why you need the permission
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, take the user to app settings
      openAppSettings();
    }
  }

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Process the picked image (e.g., upload it)
      print('Image picked from camera: ${image.path}');
    }
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Process the picked image (e.g., upload it)
      print('Image picked from gallery: ${image.path}');
    }
  }

// Call these functions when the user initiates the image upload process
  void _handleTakePhoto() {
    _requestCameraPermission();
  }

  void _handleChooseFromGallery() {
    _requestPhotosPermission();
  }

  final TextEditingController _transactionIdController =
      TextEditingController();
  File? _screenshot;
  String? _paymentStatus;
  bool _isLoading = false;
  final FocusNode _transactionFocusNode = FocusNode();

  Future<void> _pickScreenshot() async {
    // Request photos permission first
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _screenshot = File(pickedFile.path);
        });
      }
    } else if (status.isDenied) {
      // Permission denied, show a message
      SnackbarMessage.showSnackbar(context, 'Photos permission denied'
          //'${AppLocalizations.of(context)!.photoPermissionDenied}', // Localized message
          );
      print('Photos permission denied');
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, take the user to app settings
      SnackbarMessage.showSnackbar(
        context, 'Photos Permission Permanently Denied',
        //   '${AppLocalizations.of(context)!.photoPermissionPermanentlyDenied}', // Localized message
      );
      openAppSettings();
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
          //      "${AppLocalizations.of(context)!.}"
          'Please enter transaction ID and upload screenshot');
      return;
    }

    // Show Order Confirmation Dialog
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                //  "${AppLocalizations.of(context)!.}"
                "Confirm Order"),
            content: Text("Are you sure you want to place this order?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Yes"),
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
      body: SingleChildScrollView(
        // Prevents render overflow
        child: Column(
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
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _transactionIdController,
                    focusNode: _transactionFocusNode,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText:
                          "${AppLocalizations.of(context)!.enterTransactionId}",
                      // 'Enter Transaction ID',
                      border: OutlineInputBorder(),
                    ),
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

            // Payment Status
            if (_paymentStatus != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  _paymentStatus!,
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        _paymentStatus == 'Payment data fetched successfully!'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ),

            const SizedBox(height: 280),
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

                          handlePaymentAndOrder(
                              context, _transactionIdController, _screenshot);
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
            const SizedBox(height: 30), // Extra space at bottom
          ],
        ),
      ),
    );
  }
}
