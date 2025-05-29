import 'dart:convert';

import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/address_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_item_total_price_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/payment_method_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_grandtotal_provider.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/razorpay_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class OrderNowPage extends StatefulWidget {
  const OrderNowPage({super.key});

  @override
  State<OrderNowPage> createState() => _OrderNowPageState();
}

class _OrderNowPageState extends State<OrderNowPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Form controllers
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  late Razorpay _razorpay;
  bool _isLoading = false; // Loader State

  // PhonePe configuration
  final String phonePeMerchantId = "TEST-M22NOXGSL1P2A_25052";
  final String phonePeSaltKey =
      "MWRiMWMwMjAtNmRmMy00Mjk1LWI2N2EtZGNkMmU0MmVjOTQ1";
  final int phonePeSaltIndex = 1;
  final bool isPhonePeProd = false;

  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _pincodeController.addListener(_onPincodeChanged);
    _initializePhonePeSDK();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final grandTotalProvider =
          Provider.of<GrandTotalProvider>(context, listen: false);
      // final userProvider = Provider.of(context, listen: false);
      // await cartProvider
      //     .fetchCartData(userProvider.id); // Ensure cart data is loaded
      grandTotalProvider.calculateGrandTotal(cartProvider.cartItems);
    });
  }

  Future<void> _initializePhonePeSDK() async {
    try {
      bool isInitialized = await PhonePePaymentSdk.init(
        isPhonePeProd ? "PRODUCTION" : "SANDBOX", // Environment
        phonePeMerchantId, // Merchant ID
        "USER123", // flowId (unique user/session ID)
        false, // enableLogging (disable in prod)
      );
      debugPrint("PhonePe SDK initialized: $isInitialized");
    } catch (e) {
      debugPrint("PhonePe init error: $e");
    }
  }

  String _generatePhonePeChecksum(String input) {
    final key = utf8.encode(phonePeSaltKey);
    final bytes = utf8.encode(input);
    final hmacSha256 = Hmac(sha256, key);
    return hmacSha256.convert(bytes).toString();
  }

  Future<void> _startPhonePePayment(double amount) async {
    setState(() => _isLoading = true);

    final payload = {
      "merchantId": phonePeMerchantId,
      "merchantTransactionId": "TXN${DateTime.now().millisecondsSinceEpoch}",
      "amount": (amount * 100).toInt(), // Amount in paise
      "callbackUrl": "https://your-callback-url.com",
      "paymentMode": {"type": "PAY_PAGE"}, // Standard checkout
    };

    try {
      final response = await PhonePePaymentSdk.startTransaction(
        jsonEncode(payload), // Request body (JSON string)
        "yourapp://callback", // iOS URL scheme (Android: leave empty or use package name)
      );

      if (response != null) {
        final status = response['status'].toString();
        if (status == 'SUCCESS') {
          _showPaymentSuccessDialog();
        } else {
          print(' Payment failed:${response['error']}');
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Payment failed: ${response['error']}")));
        }
      }
    } catch (e) {
      print('Error starting PhonePe payment: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Payment Successful!"),
        content: Text("Your order has been placed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(ctx, (route) => route.isFirst),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _onPincodeChanged() {
    if (_pincodeController.text.length == 6) {
      _fetchLocationData(_pincodeController.text);
    }
  }

  Future<void> _fetchLocationData(String pincode) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Using Indian Postal Code API
      final response = await http.get(
        Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data[0]['Status'] == 'Success') {
          final postOfficeData = data[0]['PostOffice'][0];

          setState(() {
            _stateController.text = postOfficeData['State'] ?? '';
            //  _districtController.text = postOfficeData['District'] ?? '';
            _cityController.text = postOfficeData['Name'] ?? '';
          });
        } else {
          _showSnackBar('Invalid pincode. Please enter a valid pincode.');
          _clearLocationFields();
        }
      } else {
        _showSnackBar('Failed to fetch location data. Please try again.');
        _clearLocationFields();
      }
    } catch (e) {
      _showSnackBar(
          'Error fetching location data. Please check your internet connection.');
      _clearLocationFields();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearLocationFields() {
    setState(() {
      _stateController.clear();
      //  _districtController.clear();
      _cityController.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    // Dispose all controllers
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  //
  //
  //
  //

  // Razorpay payment handlers
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment success logic
    print(response);

    Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutMessageView(),
        ));

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => AlertDialog(
    //     title: Text("Payment Successful"),
    //     content: Text(
    //         "Payment ID: ${response.paymentId} , order id : ${response.orderId} , "
    //         //response.data
    //         ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.pop(context); // Close dialog
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => HomeScreen(),
    //               ));
    //           // You might want to navigate to order confirmation page here
    //         },
    //         child: Text("OK"),
    //       )
    //     ],
    //   ),
    // );

    // Here you can also save the order to your database
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Payment Failed"),
        content: Text("Code: ${response.code}\nMessage: ${response.message}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("External Wallet Selected"),
        content: Text("Wallet: ${response.walletName}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  void _openRazorpayCheckout(double amount) {
    var options = {
      'key': 'rzp_test_J4DBKJFYTiyeCf',
      'amount': amount * 100, // Convert to paise
      'name': 'Ambrosia Ayurved',
      'description': 'Order Payment',
      'prefill': {
        'contact': _mobileController.text,
        'email': _emailController.text,
        'name': '${_fnameController.text} ${_lnameController.text}'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  //
  //
  //
  //

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    Widget? suffixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: suffixIcon,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      validator: validator ??
          (value) => value == null || value.isEmpty ? '$label' : null,
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _addressController = TextEditingController();
    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final addressProvider = Provider.of<AddressProvider>(context);

    final cartProvider = Provider.of<CartProvider>(context);
    // final grandTotalProvider =
    // Provider.of<GrandTotalProvider>(context, listen: false);

    final cartList = cartProvider.cartItems;
    // // Calculate grand total and update provider
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   grandTotalProvider.calculateGrandTotal(cartList);
    // });

    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.orderNow}",
        //  'Order Now',
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
          //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          //           'Order Now',
          //           style: TextStyle(fontSize: 24, color: Acolors.white),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 2),
          cartProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              :

              // Card(
              //     elevation: 3,
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             "${AppLocalizations.of(context)!.productDetails}",
              //             //'Product Details'
              //           ),
              //           Text(
              //             "${AppLocalizations.of(context)!.totalPrice}",
              //             // 'Total price'
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final item = cartList[index];
                print(item.description);
                // Access the provider
                final totalPriceProvider =
                    Provider.of<ItemTotalPriceProvider>(context, listen: false);
                // Calculate total price using provider
                double totalPrice = totalPriceProvider.calculateTotalPrice(
                  item.price.toString(),
                  item.quantity.toString(),
                );

                //
                //
                // Convert price to double
                double price = double.tryParse(item.price.toString()) ?? 0.0;
                int quantity = int.tryParse(item.quantity.toString()) ?? 1;
                double basePricePerItem = price / 1.12;

                //
                double gstPerItem = price - basePricePerItem;

                //
                double baseTotal = basePricePerItem * quantity;
                double gstTotal = gstPerItem * quantity;
                double totalWithGst = price * quantity;

//
                // // Ensure price is treated as a double
                // double itemPrice =
                //     double.tryParse(item.price.toString()) ?? 0.0;

                // // Ensure quantity is treated as an integer (in case it's a String)
                // int itemQuantity =
                //     int.tryParse(item.quantity.toString()) ?? 1;

                // double totalPrice = itemPrice * itemQuantity;

                return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100, // Adjust as needed
                                height: 120, // Adjust as needed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://ambrosiaayurved.in/${item.image}',
                                    fit: BoxFit.fill,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const ShimmerEffect(
                                          width: 100, height: 100);
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const ShimmerEffect(
                                          width: 100, height: 100);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              //
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Text(
                                        AppLocalizations.of(context)!.a5product,
                                        //  item.productName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .descriptionproduct,
                                      //  item.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   children: [],
                              // ),
                              const SizedBox(height: 8),

                              // Price Card with shadow and rounded corners
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    // Price breakdown header
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          // "Price Break Down : ",
                                          "${AppLocalizations.of(context)!.priceBreakDown}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Acolors.primary,
                                          ),
                                        ),
                                        Text(
                                          "Rs ${totalWithGst.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Acolors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(height: 12, thickness: 1),

                                    // Base price row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 8,
                                                color: Colors.grey[700]),
                                            SizedBox(width: 6),
                                            Text(
                                              //  'Base Price : ',
                                              "${AppLocalizations.of(context)!.basePrice}:",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Rs ${basePricePerItem.toStringAsFixed(2)} × ${item.quantity}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700]),
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "Rs ${baseTotal.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),

                                    // GST row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.circle,
                                                size: 8,
                                                color: Colors.grey[700]),
                                            SizedBox(width: 6),
                                            Text(
                                              "${AppLocalizations.of(context)!.gst}",
                                              //  "Gst  (12%) :",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Rs ${gstPerItem.toStringAsFixed(2)} × ${item.quantity}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700]),
                                            ),
                                            SizedBox(width: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "Rs ${gstTotal.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Divider(height: 12, thickness: 1),

                                    // Total row with highlight
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Acolors.primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Acolors.primary
                                                    .withOpacity(0.3)),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${AppLocalizations.of(context)!.total}: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Consumer<GrandTotalProvider>(
                                                builder: (context,
                                                    grandTotalProvider, child) {
                                                  return Text(
                                                    "Rs ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
                                                    //  "₹${totalWithGst.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Acolors.primary,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ));
              },
            ),
          ),

          //
          //
          //

          //
          //
          //
          // const Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 23),
          //   child: Text(
          //     'Address :',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600),
          //   ),
          // ),
          // Address Form Section
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.shippingAddress}",
                        // 'Shipping Address',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // First name and Last name

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(_fnameController,
                                "${AppLocalizations.of(context)!.firstName}"),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(_lnameController,
                                "${AppLocalizations.of(context)!.lastName}"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // // Email
                      // _buildTextField(_emailController, 'Email'),
                      // const SizedBox(height: 10),

                      // Address and Mobile
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(_addressController,
                                "${AppLocalizations.of(context)!.address}"),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              _pincodeController,
                              "${AppLocalizations.of(context)!.pincode}",
                              keyboardType: TextInputType.number,
                              suffixIcon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    )
                                  : null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "${AppLocalizations.of(context)!.enterPincode}";
                                } else if (!RegExp(r'^\d{6}$')
                                    .hasMatch(value)) {
                                  return "${AppLocalizations.of(context)!.validPincode}";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(width: 10),
                      const SizedBox(height: 10),

                      // City, State, and Pincode
                      Row(
                        children: [
                          // Expanded(
                          //   child: _buildTextField(
                          //     _pincodeController,
                          //     "${AppLocalizations.of(context)!.pincode}",
                          //     keyboardType: TextInputType.number,
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return "${AppLocalizations.of(context)!.enterPincode}";
                          //       } else if (!RegExp(r'^\d{6}$')
                          //           .hasMatch(value)) {
                          //         return "${AppLocalizations.of(context)!.validPincode}";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                          // SizedBox(width: 10),
                          Expanded(
                            // flex: 2,
                            child: _buildTextField(_cityController,
                                "${AppLocalizations.of(context)!.city}"),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(_stateController,
                                "${AppLocalizations.of(context)!.state}"),
                          ),
                          //   const SizedBox(width: 10),
                          // Pincode (6 digits only)
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Country
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(_countryController,
                                  "${AppLocalizations.of(context)!.country}")),
                          const SizedBox(width: 10),
                          // Mobile (12 digits only)
                          Expanded(
                            child: _buildTextField(
                              _mobileController,
                              "${AppLocalizations.of(context)!.mobile}",
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "${AppLocalizations.of(context)!.enterMobile}";
                                } else if (!RegExp(r'^\d{10}$')
                                    .hasMatch(value)) {
                                  return "${AppLocalizations.of(context)!.validMobile}";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // const Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 23),
          //   child: Text(
          //     'Address :',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 18,
          //         fontWeight: FontWeight.w600),
          //   ),
          // ),

          // /// Address Input Field
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          //   child: Form(
          //     key: _formKey,
          //     child: TextFormField(
          //       controller: _addressController,
          //       maxLines: 3,
          //       decoration: InputDecoration(
          //         labelText: "Enter your Address",
          //         alignLabelWithHint: true,
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //       ),
          //       validator: (value) {
          //         if (value == null || value.trim().isEmpty) {
          //           return "Address cannot be empty";
          //         }
          //         return null;
          //       },
          //     ),
          //   ),
          // ),

          if (cartList.isNotEmpty)
            Consumer<GrandTotalProvider>(
              builder: (context, grandTotalProvider, child) {
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.grandTotal} ",
                          //  "Grand Total : ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rs ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Acolors.primary,
                    foregroundColor: Acolors.white),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    String userId = userProvider.id;
                    final grandTotalProvider =
                        Provider.of<GrandTotalProvider>(context, listen: false);

                    // Get the list of productIds from cart
                    List<String> productIds = cartProvider.cartItems
                        .map((item) => item.productId.toString())
                        .toList();
                    print(' product id: $productIds');

                    // Save address information
                    final addressProvider =
                        Provider.of<AddressProvider>(context, listen: false);
                    bool success =
                        await addressProvider.saveCheckoutInformation(
                      productId: productIds.toString(),
                      userid: userId,
                      fname: _fnameController.text,
                      lname: _lnameController.text,
                      address: _addressController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      mobile: _mobileController.text,
                      country: _countryController.text,
                      pincode: _pincodeController.text,
                      context: context,
                    );

                    if (success) {
                      //  _openRazorpayCheckout(grandTotalProvider.grandTotal);
                      _startPhonePePayment(grandTotalProvider.grandTotal);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PaymentScreen(),
                      //   ),
                      // );
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  }

                  // if (_formKey.currentState!.validate()) {
                  //   await addressProvider.updateAddress(
                  //       context, _addressController.text);
                  //   if (addressProvider.message.isNotEmpty) {
                  //     SnackbarMessage.showSnackbar(
                  //         context, addressProvider.message);
                  //   }

                  //   if (addressProvider.address != null) {
                  //     {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => PaymentScreen(),
                  //         ),
                  //       );
                  //     }
                  //   }
                  // }
                },
                child: _isLoading || addressProvider.isLoading
                    ? const CircularProgressIndicator(color: Acolors.white)
                    : Text(
                        "${AppLocalizations.of(context)!.proceedToCheckout}",
                        // "Proceed to Checkout",
                      ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:ambrosia_ayurved/cosmetics/payment/payment_page.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_model.dart';

class OrderNowPage extends StatelessWidget {
  const OrderNowPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Get cartList from CartProvider
    final cartProvider = Provider.of<CartProvider>(context);
    final cartList = cartProvider.cartItems; // Access cart items from provider
    double grandTotal = 0.0;
    // Calculate the total price by iterating over cartList
    for (var item in cartList) {
      double itemPrice = double.tryParse(item.price.toString()) ?? 0.0;
      // Ensure quantity is treated as an integer (in case it's a String)
      int itemQuantity = int.tryParse(item.quantity.toString()) ?? 1;
      double itemTotal = itemPrice * itemQuantity;
      grandTotal += itemTotal;
    }
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              color: Acolors.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.white.withOpacity(0.21),
                      borderRadius: BorderRadius.circular(12),
                      child: const BackButton(
                        color: Acolors.white,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      'Order Now',
                      style: TextStyle(fontSize: 24, color: Acolors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2),
            Card(
              elevation: 3,
              child: Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Product Details'),
                      Text('Total price'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  final item = cartList[index];

                  // Ensure price is treated as a double
                  double itemPrice =
                      double.tryParse(item.price.toString()) ?? 0.0;

                  // Ensure quantity is treated as an integer (in case it's a String)
                  int itemQuantity =
                      int.tryParse(item.quantity.toString()) ?? 1;

                  double totalPrice = itemPrice * itemQuantity;

                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Image.network(
                        item.image,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const ShimmerEffect(width: 50, height: 50);
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const ShimmerEffect(width: 50, height: 50);
                        },
                      ),
                      title: Row(
                        children: [
                          Text(item.productName),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Rs ${itemPrice.toStringAsFixed(2)} * $itemQuantity'),
                          Text('Rs ${totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (cartList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Grand Total : ",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rs ${grandTotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                  grandTotal: grandTotal,
                                ),
                              ));
                          // Proceed with the order process
                          // You can navigate to the payment page or order confirmation page
                        },
                        child: const Text("Proceed to Checkout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Acolors.primary,
                          foregroundColor: Acolors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5)
                ],
              ),
          ],
        ),
      ),
    );
  }
}
*/



/*
class OrderNowPage extends StatelessWidget {
  const OrderNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    final productNotifier = Provider.of<ProductNotifier>(context);

    // Calculate grand total
    double grandTotal = 0.0;

    cart.cartItems.forEach((productId, quantity) {
      final product =
          productNotifier.products.firstWhere((p) => p.id == productId,
              orElse: () => Product(
                  id: 0,
                  name: 'Unknown',
                  description: '',
                  price: 0,
                  quantity: 0,
                  // quantity: 0,
                  imageUrl: ''));
// Ensure price is a valid String and then parse it to double
      final priceString = product.price.toString(); // This is a String
      final price =
          (priceString.isNotEmpty && double.tryParse(priceString) != null)
              ? double.parse(priceString) // Convert to double
              : 0.0; // Default to 0.0 if it's not a valid number

      final intQuantity =
          int.tryParse(quantity.toString()) ?? 0; // Convert quantity to int

      final totalPrice = price * intQuantity;
      grandTotal += totalPrice;

      print(
          "Product: ${product.name}, Quantity: $quantity, Total: $totalPrice");
    });

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              color: Acolors.primary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Colors.white.withOpacity(0.21),
                      borderRadius: BorderRadius.circular(12),
                      child: const BackButton(
                        color: Acolors.white,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      'Order Now',
                      style: TextStyle(fontSize: 24, color: Acolors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2),
            Card(
              elevation: 3,
              child: Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Product Details'),
                      Text('Total price'),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartItems.length,
                itemBuilder: (context, index) {
                  final productId = cart.cartItems.keys.elementAt(index);
                  final product = productNotifier.products
                      .firstWhere((p) => p.id == productId);
                  final quantity = cart.cartItems[productId];

                  // final totalPrice = product.price * quantity!;
                  final price =
                      double.tryParse(product.price.toString()) ?? 0.0;
                  final totalPrice = price * quantity!;

                  // // Check if price and quantity are valid
                  // if (product.price == null || quantity == null) {
                  //   print("Error: Product price or quantity is null");
                  // }

                  // final totalPrice = product.price * quantity!;
                  // grandTotal += totalPrice;
                  // print(grandTotal);
                  // print(
                  //     "Product: ${product.name}, Quantity: $quantity, Total: $totalPrice");

                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Row(
                        children: [
                          Text(product.name),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Rs ${price.toStringAsFixed(2)} * $quantity '),
                          Text('Rs ${totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (cart.cartItems.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Grand Total : ",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Rs ${grandTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(),
                              ));
                          // Proceed with the order process
                          // You can navigate to the payment page or order confirmation page
                        },
                        child: const Text("Proceed to Checkout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Acolors.primary,
                          foregroundColor: Acolors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 5)
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
*/