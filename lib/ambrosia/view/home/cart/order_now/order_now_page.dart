import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/checkout_message/checkout_message.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_fetch_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/phonepe/phonepe_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/shiprocket/shiprocket_service.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/item_calculations/order_grandtotal_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class OrderNowPage extends StatefulWidget {
  const OrderNowPage({super.key});

  @override
  State<OrderNowPage> createState() => _OrderNowPageState();
}

class _OrderNowPageState extends State<OrderNowPage> {
  Address? selectedAddress;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  bool _isLoading = false; // Loader State
  String _couponCode = '';
  bool _isApplyingCoupon = false;
  bool _showDiscountAnimation = false;
  double _discountAmount = 0.0;
  double _discountPercentage = 0.0;
  String _couponMessage = '';

  void initState() {
    super.initState();

    _pincodeController.addListener(_onPincodeChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final grandTotalProvider =
          Provider.of<GrandTotalProvider>(context, listen: false);

      grandTotalProvider.calculateGrandTotal(cartProvider.cartItems);
    });
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

// coupon code
// Add this method to apply coupon
  Future<void> _applyCoupon() async {
    if (_couponCode.isEmpty) {
      setState(() {
        _couponMessage = 'Please enter a coupon code';
      });
      return;
    }
    setState(() {
      _isApplyingCoupon = true;
      _couponMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://ambrosiaayurved.in/api/coupon?coupon=$_couponCode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true &&
            data['data'] != null &&
            data['data'].isNotEmpty) {
          final couponData = data['data'][0];
          final discountPercentage =
              double.tryParse(couponData['discount']) ?? 0.0;
          final expiryDate = DateTime.parse(couponData['expiry_date']);
          final currentDate = DateTime.now();

          if (currentDate.isAfter(expiryDate)) {
            setState(() {
              _couponMessage = 'Coupon has expired';
            });

            final grandTotalProvider =
                Provider.of<GrandTotalProvider>(context, listen: false);
            grandTotalProvider.removeDiscount();
            return;
          }

          if (couponData['status'] != 'active') {
            setState(() {
              _couponMessage = 'Coupon is not active';
            });

            final grandTotalProvider =
                Provider.of<GrandTotalProvider>(context, listen: false);
            grandTotalProvider.removeDiscount();
            return;
          }

          final grandTotalProvider =
              Provider.of<GrandTotalProvider>(context, listen: false);
          grandTotalProvider.applyDiscount(discountPercentage);

          setState(() {
            _couponMessage =
                'Coupon applied successfully! You saved ₹${grandTotalProvider.discountAmount.toStringAsFixed(2)}';
            _showDiscountAnimation = true;
          });
          Future.delayed(Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _showDiscountAnimation = false;
              });
            }
          });
        } else {
          setState(() {
            _couponMessage = 'Invalid coupon code';
          });

          final grandTotalProvider =
              Provider.of<GrandTotalProvider>(context, listen: false);
          grandTotalProvider.removeDiscount();
        }
      } else {
        setState(() {
          _couponMessage = 'Failed to validate coupon';
        });

        final grandTotalProvider =
            Provider.of<GrandTotalProvider>(context, listen: false);
        grandTotalProvider.removeDiscount();
      }
    } catch (e) {
      setState(() {
        _couponMessage = 'Error applying coupon';
      });

      final grandTotalProvider =
          Provider.of<GrandTotalProvider>(context, listen: false);
      grandTotalProvider.removeDiscount();
    } finally {
      setState(() {
        _isApplyingCoupon = false;
      });
    }
  }
//
//

  @override
  void dispose() {
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

  // Future<bool> _onWillPop() async {
  //   final shouldExit = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => ExitConfirmationDialog(),
  //   );

  //   return shouldExit ?? false;
  // }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartList = cartProvider.cartItems;

    void _executeContinueCheckout() async {
      setState(() => _isLoading = true);

      try {
        if (selectedAddress == null) {
          SnackbarMessage.showSnackbar(
              context, 'Please select a delivery address');
          return;
        }

        //
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final grandTotalProvider =
            Provider.of<GrandTotalProvider>(context, listen: false);

        // 1️⃣ Show loader popup immediately
        SuccessPopup.show(
          context: context,
          title: "Processing...",
          subtitle: "Please wait while we complete your payment and order.",
          icon: Icons.hourglass_empty,
          iconColor: Colors.orange,
          autoCloseDuration: 0,
          showButtonLoader: true,
        );

        String paymentResult = await PhonePePaymentService.initiatePayment(
          amount: 100, context: context,

          // (grandTotalProvider.grandTotal * 100)
          //     .toInt(), // amount in paisa
        );
        final merchantOrderId = GlobalPaymentData.merchantOrderId.toString();

        final placeOrderProvider =
            Provider.of<PlaceOrderProvider>(context, listen: false);

        placeOrderProvider.setAddressId(selectedAddress!.id.toString());
        //
        //

        await placeOrderProvider.placeOrder(context);

        List<Map<String, dynamic>> orderItems =
            cartProvider.cartItems.map((cartItem) {
          return {
            "name": cartItem.productName,
            "sku": "AYUR${cartItem.productId}",
            "units": cartItem.quantity,
            "selling_price": cartItem.price,
            "discount": "",
            "tax": "",
            "hsn": 123566
          };
        }).toList();
        // final saveResponse =
        await saveUserCartData(
          orderId: merchantOrderId,
          fname: selectedAddress!.fname,
          lname: selectedAddress!.lname,
          phone: selectedAddress!.mobile,
          address: selectedAddress!.address,
          city: selectedAddress!.city,
          state: selectedAddress!.state,
          pincode: selectedAddress!.pincode,
          country: selectedAddress!.country,
          productData: jsonEncode(orderItems),
          //  jsonEncode(cartProvider.cartItems
          //     .map((item) => {
          //           "product_id": item.productId,
          //           "product_name": item.productName,
          //           "quantity": item.quantity,
          //           "price": item.price,
          //         })
          //     .toList()),

          subtotal: grandTotalProvider.grandTotal.toString(),
        );
        Navigator.of(context).pop();

        // close popup
        // if (saveResponse == null ||
        //     saveResponse["status"] != true) {
        //   Navigator.of(context).pop(); // close popup
        //   SuccessPopup.show(
        //     context: context,
        //     title: "Error",
        //     subtitle:
        //         "Failed to save cart data before creating order",
        //     iconColor: Colors.red,
        //     icon: Icons.error,
        //     autoCloseDuration: 0,
        //     buttonText: "OK",
        //   );
        //   return;
        // }

        if (paymentResult.contains("FAILURE")) {
          SuccessPopup.show(
            context: context,
            title: "Payment Failed",
            subtitle: "Failed to place order",
            //paymentResult,
            iconColor: Colors.red,
            icon: Icons.cancel,
            autoCloseDuration: 0,
            buttonText: "OK",
          );
          return;
        }

        // 3️⃣ If payment success, show "Creating Order..." loader
        SuccessPopup.show(
          context: context,
          title: "Placing Order...",
          subtitle: "Please wait we placing the order",
          icon: Icons.hourglass_empty,
          iconColor: Colors.orange,
          autoCloseDuration: 0,
          showButtonLoader: true,
        );
        await createShiprocketOrder(
            billingCustomerName: selectedAddress!.fname,
            billingLastName: selectedAddress!.lname,
            billingAddress: selectedAddress!.address,
            billingAddress2: "",
            billingCity: selectedAddress!.city,
            billingPincode: selectedAddress!.pincode,
            billingState: selectedAddress!.state,
            billingCountry: selectedAddress!.country,
            billingEmail: selectedAddress!.email,
            //  billingEmail: userProvider.email,
            billingPhone: selectedAddress!.mobile,
            orderItems: orderItems,
            paymentMethod: "Prepaid",
            shippingCharges: 0,
            giftwrapCharges: 0,
            transactionCharges: 0,
            totalDiscount: 0,
            subTotal: grandTotalProvider.grandTotal,
            length: 2,
            breadth: 3,
            height: 4,
            weight: 0.1,
            context: context);
      } catch (e) {
        print(e);

        final merchantOrderId = GlobalPaymentData.merchantOrderId.toString();
        await updateOrderStatus(merchantOrderId, "${e.toString()}");

        // }
        // catch (apiError) {
        //   print("Failed to update order status: $apiError");
        // }

        SuccessPopup.show(
          context: context,
          title: "Order Placed",
          subtitle: "Your order has been placed successfully ! ",
          //  AWB: $assignedAwbCode",

          iconColor: Colors.green,
          icon: Icons.check_circle,
          navigateToScreen: CheckoutMessageView(),
        );
        // SuccessPopup.show(
        //   context: context,
        //   title: "Failed",
        //   subtitle: "Failed to place Order",
        //   // e.toString(),
        //   iconColor: Colors.red,
        //   icon: Icons.error,
        //   autoCloseDuration: 0,
        //   buttonText: "OK",
        // );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        return await OrderExitHandler.showExitConfirmation(
          context,
          _executeContinueCheckout,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          leading: BackButton(
            color: Colors.black,
            onPressed: () async {
              final shouldExit = await OrderExitHandler.showExitConfirmation(
                context,
                _executeContinueCheckout,
              );
              if (shouldExit) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: "${AppLocalizations.of(context)!.orderNow}",
        ),
        body: Stack(
          children: [
            SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cartProvider.isLoading
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox(height: 2),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cartList.length,
                          itemBuilder: (context, index) {
                            final item = cartList[index];
                            print(item.description);

                            // Access the provider
                            // final totalPriceProvider =
                            //     Provider.of<ItemTotalPriceProvider>(context,
                            //         listen: false);
                            // Calculate total price using provider
                            // double totalPrice = totalPriceProvider.calculateTotalPrice(
                            //   item.price.toString(),
                            //   item.quantity.toString(),
                            // );

                            double price =
                                double.tryParse(item.price.toString()) ?? 0.0;
                            int quantity =
                                int.tryParse(item.quantity.toString()) ?? 1;
                            double basePricePerItem = price / 1.05;

                            //
                            double gstPerItem = price - basePricePerItem;
                            //
                            double baseTotal = basePricePerItem * quantity;
                            double gstTotal = gstPerItem * quantity;
                            double totalWithGst = price * quantity;

                            return Card(
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 100, // Adjust as needed
                                          height: 120, // Adjust as needed
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              'https://ambrosiaayurved.in/${item.image}',
                                              fit: BoxFit.contain,
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                if (progress == null)
                                                  return child;
                                                return const ShimmerEffect(
                                                    width: 100, height: 100);
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //    Directionality(
                                              //  textDirection: TextDirection.ltr,
                                              // child:
                                              Text(
                                                //  AppLocalizations.of(context)!.a5product,
                                                item.productName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              //    ),
                                              //  SizedBox(height: 3),
                                              Text(
                                                // AppLocalizations.of(context)!
                                                //     .descriptionproduct,
                                                item.description,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              //
                                              //
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.2),
                                                          spreadRadius: 1,
                                                          blurRadius: 3,
                                                          offset: Offset(0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                    child: Column(
                                                      children: [
                                                        // Price breakdown header
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              // "Price Break Down : ",
                                                              "${AppLocalizations.of(context)!.priceBreakDown}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 12,
                                                                color: Acolors
                                                                    .primary,
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Acolors
                                                                    .primary
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border: Border.all(
                                                                    color: Acolors
                                                                        .primary
                                                                        .withOpacity(
                                                                            0.3)),
                                                              ),
                                                              child: Text(
                                                                "₹ ${totalWithGst.toStringAsFixed(2)}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  color: Acolors
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                            height: 5,
                                                            thickness: 1),

                                                        // Base price row
                                                        Row(
                                                          children: [
                                                            Icon(Icons.circle,
                                                                size: 8,
                                                                color: Colors
                                                                    .grey[700]),
                                                            SizedBox(width: 3),
                                                            Text(
                                                              //  'Base Price : ',
                                                              "${AppLocalizations.of(context)!.basePrice} (${item.quantity})",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                            ),
                                                            Spacer(),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          6,
                                                                      vertical:
                                                                          2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Text(
                                                                "₹ ${baseTotal.toStringAsFixed(2)}",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 1),

                                                        // GST row
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .circle,
                                                                    size: 8,
                                                                    color: Colors
                                                                            .grey[
                                                                        700]),
                                                                SizedBox(
                                                                    width: 3),
                                                                Text(
                                                                  "${AppLocalizations.of(context)!.gst} (${item.quantity})",
                                                                  //  "Gst  (12%) :",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                              .grey[
                                                                          700]),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                // Text(
                                                                //   "₹ ${gstPerItem.toStringAsFixed(2)} × ${item.quantity}",
                                                                //   style: TextStyle(
                                                                //       fontSize: 14,
                                                                //       color: Colors
                                                                //           .grey[700]),
                                                                // ),
                                                                // SizedBox(width: 8),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              6,
                                                                          vertical:
                                                                              2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
                                                                  ),
                                                                  child: Text(
                                                                    "₹ ${gstTotal.toStringAsFixed(2)}",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        //
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
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
                                          'Bill Summary',
                                          // "Price Break Down : ",
                                          // "${AppLocalizations.of(context)!.priceBreakDown}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: Acolors.primary,
                                          ),
                                        ),
                                        Consumer<GrandTotalProvider>(
                                          builder: (context, grandTotalProvider,
                                              child) {
                                            return Text(
                                              "₹ ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Acolors.primary,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    // Text(
                                    //   "₹ ${totalWithGst.toStringAsFixed(2)}",
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 16,
                                    //     color: Acolors.primary,
                                    //   ),
                                    // ),
                                    //      ],
                                    //  ),
                                    Divider(height: 12, thickness: 1),
                                    Consumer<GrandTotalProvider>(
                                      builder:
                                          (context, grandTotalProvider, child) {
                                        double grandTotal =
                                            grandTotalProvider.grandTotal;
                                        double basePrice = grandTotal /
                                            1.05; // Calculate base price (grandTotal / (1 + 0.12))
                                        double gstAmount =
                                            grandTotal - basePrice;
                                        double finalTotal =
                                            grandTotalProvider.finalTotal;

                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle,
                                                        size: 8,
                                                        color:
                                                            Colors.grey[700]),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "${AppLocalizations.of(context)!.basePrice}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    "₹ ${basePrice.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            // GST row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle,
                                                        size: 8,
                                                        color:
                                                            Colors.grey[700]),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "${AppLocalizations.of(context)!.gst}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    "₹ ${gstAmount.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            // GST row
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle,
                                                        size: 8,
                                                        color:
                                                            Colors.grey[700]),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      'Delivery charges :',
                                                      // "${AppLocalizations.of(context)!.gst}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    "₹ 0",
                                                    //"₹ ${gstAmount.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (grandTotalProvider
                                                    .discountAmount >
                                                0) ...[
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.discount,
                                                          size: 16,
                                                          color: Colors.green),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        "Discount (${grandTotalProvider.discountPercentage.toStringAsFixed(0)}% off)",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[50],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      "-₹ ${grandTotalProvider.discountAmount.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        );
                                      },
                                    ),

                                    Divider(height: 12, thickness: 1),

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
                                                    "₹ ${grandTotalProvider.finalTotal.toStringAsFixed(2)}",
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
                          ),
                        ),

                        //
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
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
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Apply Coupon",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Acolors.primary,
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter coupon code',
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(),
                                    suffixIcon: _isApplyingCoupon
                                        ? Transform.scale(
                                            scale: 0.5,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              FocusScope.of(context).unfocus();
                                              _applyCoupon();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 4),
                                              margin: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              //  alignment: Alignment.center,
                                              child: Text(
                                                _couponMessage.contains(
                                                        'successfully')
                                                    ? "Applied"
                                                    : "Apply",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16, // smaller font
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),

                                    //  ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: Colors.green[50],
                                    //       foregroundColor: Colors.green[600],
                                    //       elevation: 0,
                                    //       padding: EdgeInsets.all(12),
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //       ),
                                    //     ),
                                    //     onPressed: () {
                                    //       FocusScope.of(context).unfocus();
                                    //       _applyCoupon();
                                    //     },
                                    //     child: Text(
                                    //       'Apply',
                                    //       style: TextStyle(
                                    //           color: Acolors.primary,
                                    //           fontSize: 16),
                                    //     ),
                                    //   ),

                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Z]')),
                                  ],
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  onChanged: (value) {
                                    setState(() {
                                      _couponCode = value.trim();
                                    });
                                  },
                                ),
                                if (_couponMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      _couponMessage,
                                      style: TextStyle(
                                        color: _couponMessage
                                                .contains('successfully')
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Address section title
                              Text(
                                "Select Delivery Address",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Acolors.primary,
                                ),
                              ),
                              SizedBox(height: 12),
                              // Integrated address selection without container wrapper
                              AddressSelectionContent(
                                onAddressSelected: (Address address) {
                                  setState(() {
                                    selectedAddress = address;
                                  });
                                  print(
                                      'Selected: ${address.fname} ${address.lname}');
                                },
                              ),
                            ],
                          ),
                        ),
                        //
                        //
                        //
                        //
                        //
                        //
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Discount Animation Overlay
            if (_showDiscountAnimation)
              Container(
                color: Colors.white.withOpacity(0.5),
                child: Center(
                  child: Container(
                    child: Lottie.asset(
                      'assets/lottie/discount_animatino.json',
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          // child:
          // Padding(
          //   padding: EdgeInsets.only(
          // left: 16,
          // right: 16,
          //  bottom: MediaQuery.of(context).viewInsets.bottom,
          // ✅ pushes button above keyboard
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Acolors.primary,
                        foregroundColor: Acolors.white),
                    onPressed: _isLoading
                        ? null
                        : _isLoading
                            ? null
                            : _executeContinueCheckout,

                    // () async {
                    //     setState(() => _isLoading = true);

                    //     try {
                    //       if (selectedAddress == null) {
                    //         SnackbarMessage.showSnackbar(context,
                    //             'Please select a delivery address');
                    //         return;
                    //       }

                    //       //
                    //       final cartProvider = Provider.of<CartProvider>(
                    //           context,
                    //           listen: false);
                    //       final grandTotalProvider =
                    //           Provider.of<GrandTotalProvider>(context,
                    //               listen: false);

                    //       // 1️⃣ Show loader popup immediately
                    //       SuccessPopup.show(
                    //         context: context,
                    //         title: "Processing...",
                    //         subtitle:
                    //             "Please wait while we complete your payment and order.",
                    //         icon: Icons.hourglass_empty,
                    //         iconColor: Colors.orange,
                    //         autoCloseDuration: 0,
                    //         showButtonLoader: true,
                    //       );

                    //       String paymentResult =
                    //           await PhonePePaymentService.initiatePayment(
                    //         amount: 100, context: context,

                    //         // (grandTotalProvider.grandTotal * 100)
                    //         //     .toInt(), // amount in paisa
                    //       );
                    //       final merchantOrderId =
                    //           GlobalPaymentData.merchantOrderId.toString();

                    //       final placeOrderProvider =
                    //           Provider.of<PlaceOrderProvider>(context,
                    //               listen: false);

                    //       placeOrderProvider
                    //           .setAddressId(selectedAddress!.id.toString());
                    //       //
                    //       //

                    //       await placeOrderProvider.placeOrder(context);

                    //       List<Map<String, dynamic>> orderItems =
                    //           cartProvider.cartItems.map((cartItem) {
                    //         return {
                    //           "name": cartItem.productName,
                    //           "sku": "AYUR${cartItem.productId}",
                    //           "units": cartItem.quantity,
                    //           "selling_price": cartItem.price,
                    //           "discount": "",
                    //           "tax": "",
                    //           "hsn": 123566
                    //         };
                    //       }).toList();
                    //       // final saveResponse =
                    //       await saveUserCartData(
                    //         orderId: merchantOrderId,
                    //         fname: selectedAddress!.fname,
                    //         lname: selectedAddress!.lname,
                    //         phone: selectedAddress!.mobile,
                    //         address: selectedAddress!.address,
                    //         city: selectedAddress!.city,
                    //         state: selectedAddress!.state,
                    //         pincode: selectedAddress!.pincode,
                    //         country: selectedAddress!.country,
                    //         productData: jsonEncode(orderItems),
                    //         //  jsonEncode(cartProvider.cartItems
                    //         //     .map((item) => {
                    //         //           "product_id": item.productId,
                    //         //           "product_name": item.productName,
                    //         //           "quantity": item.quantity,
                    //         //           "price": item.price,
                    //         //         })
                    //         //     .toList()),

                    //         subtotal:
                    //             grandTotalProvider.grandTotal.toString(),
                    //       );
                    //       Navigator.of(context).pop();

                    //       // close popup
                    //       // if (saveResponse == null ||
                    //       //     saveResponse["status"] != true) {
                    //       //   Navigator.of(context).pop(); // close popup
                    //       //   SuccessPopup.show(
                    //       //     context: context,
                    //       //     title: "Error",
                    //       //     subtitle:
                    //       //         "Failed to save cart data before creating order",
                    //       //     iconColor: Colors.red,
                    //       //     icon: Icons.error,
                    //       //     autoCloseDuration: 0,
                    //       //     buttonText: "OK",
                    //       //   );
                    //       //   return;
                    //       // }

                    //       if (paymentResult.contains("FAILURE")) {
                    //         SuccessPopup.show(
                    //           context: context,
                    //           title: "Payment Failed",
                    //           subtitle: "Failed to place order",
                    //           //paymentResult,
                    //           iconColor: Colors.red,
                    //           icon: Icons.cancel,
                    //           autoCloseDuration: 0,
                    //           buttonText: "OK",
                    //         );
                    //         return;
                    //       }

                    //       // 3️⃣ If payment success, show "Creating Order..." loader
                    //       SuccessPopup.show(
                    //         context: context,
                    //         title: "Placing Order...",
                    //         subtitle: "Please wait we placing the order",
                    //         icon: Icons.hourglass_empty,
                    //         iconColor: Colors.orange,
                    //         autoCloseDuration: 0,
                    //         showButtonLoader: true,
                    //       );
                    //       await createShiprocketOrder(
                    //           billingCustomerName: selectedAddress!.fname,
                    //           billingLastName: selectedAddress!.lname,
                    //           billingAddress: selectedAddress!.address,
                    //           billingAddress2: "",
                    //           billingCity: selectedAddress!.city,
                    //           billingPincode: selectedAddress!.pincode,
                    //           billingState: selectedAddress!.state,
                    //           billingCountry: selectedAddress!.country,
                    //           billingEmail: selectedAddress!.email,
                    //           //  billingEmail: userProvider.email,
                    //           billingPhone: selectedAddress!.mobile,
                    //           orderItems: orderItems,
                    //           paymentMethod: "Prepaid",
                    //           shippingCharges: 0,
                    //           giftwrapCharges: 0,
                    //           transactionCharges: 0,
                    //           totalDiscount: 0,
                    //           subTotal: grandTotalProvider.grandTotal,
                    //           length: 2,
                    //           breadth: 3,
                    //           height: 4,
                    //           weight: 0.1,
                    //           context: context);
                    //     } catch (e) {
                    //       print(e);

                    //       final merchantOrderId =
                    //           GlobalPaymentData.merchantOrderId.toString();
                    //       await updateOrderStatus(
                    //           merchantOrderId, "${e.toString()}");

                    //       // }
                    //       // catch (apiError) {
                    //       //   print("Failed to update order status: $apiError");
                    //       // }

                    //       SuccessPopup.show(
                    //         context: context,
                    //         title: "Order Placed",
                    //         subtitle:
                    //             "Your order has been placed successfully ! ",
                    //         //  AWB: $assignedAwbCode",

                    //         iconColor: Colors.green,
                    //         icon: Icons.check_circle,
                    //         navigateToScreen: CheckoutMessageView(),
                    //       );
                    //       // SuccessPopup.show(
                    //       //   context: context,
                    //       //   title: "Failed",
                    //       //   subtitle: "Failed to place Order",
                    //       //   // e.toString(),
                    //       //   iconColor: Colors.red,
                    //       //   icon: Icons.error,
                    //       //   autoCloseDuration: 0,
                    //       //   buttonText: "OK",
                    //       // );
                    //     } finally {
                    //       if (mounted) {
                    //         setState(() => _isLoading = false);
                    //       }
                    //     }
                    //   },
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text("Continue"),
                  ),
                ),
              ),
            ],
          ),
          //  ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> saveUserCartData({
  required String orderId,
  required String fname,
  required String lname,
  required String phone,
  required String address,
  required String city,
  required String state,
  required String pincode,
  required String country,
  required String productData,
  required String subtotal,
}) async {
  const String url =
      "https://ambrosiaayurved.in/api/save_user_cart_data_for_shiprocket";

  try {
    final body = {
      "order_id": orderId,
      "fname": fname,
      "lname": lname,
      "phone": phone,
      "address": address,
      "city": city,
      "state": state,
      "pincode": pincode,
      "country": country,
      "product_data": productData,
      "subtotal": subtotal,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('✅ Save user data response : ${response.body}');
      return jsonDecode(response.body);
    } else {
      print("Failed with status: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error while saving cart data: $e");
    return null;
  }
}

Future<void> updateOrderStatus(String orderId, String reason) async {
  try {
    final response = await http.post(
      Uri.parse('https://ambrosiaayurved.in/api/update_order_status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'order_id': orderId,
        'reason': reason,
      }),
    );

    if (response.statusCode == 200) {
      print('Success update order status : ${response.body}');
    } else {
      print(
          'Error : upadate order status ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Network error: $e');
  }
}

class ExitConfirmationBottomSheet extends StatefulWidget {
  final VoidCallback onContinueCheckout;

  const ExitConfirmationBottomSheet({
    Key? key,
    required this.onContinueCheckout,
  }) : super(key: key);

  @override
  State<ExitConfirmationBottomSheet> createState() =>
      _ExitConfirmationBottomSheetState();
}

class _ExitConfirmationBottomSheetState
    extends State<ExitConfirmationBottomSheet> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<double> _slideAnimation;
  late Animation<double> _bounceAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    _slideController.forward();
    _bounceController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _handleContinueCheckout() async {
    setState(() {
      _isProcessing = true;
    });

    // Close the bottom sheet first
    Navigator.of(context).pop(false);

    // Execute the continue checkout logic
    widget.onContinueCheckout();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 300),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Close button row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      // Animated warning icon
                      ScaleTransition(
                        scale: _bounceAnimation,
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange[100]!,
                                Colors.red[50]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            size: 45,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Main title
                      Text(
                        'Are You Sure You Want To Exit?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 18),

                      // Urgency message with pulsing animation
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red[50]!,
                              Colors.orange[50]!,
                              Colors.red[50]!,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.orange[400]!,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.red[600],
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Products in huge demand might run Out of Stock',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red[700],
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.red[600],
                              size: 22,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // Action buttons
                      Column(
                        children: [
                          // Continue button (primary action)
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[600],
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                shadowColor: Colors.orange.withOpacity(0.4),
                              ),
                              onPressed: _isProcessing
                                  ? null
                                  : _handleContinueCheckout,
                              child: _isProcessing
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Processing...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'No, continue checkout',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                                padding: EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                              ),
                              onPressed: _isProcessing
                                  ? null
                                  : () => Navigator.of(context).pop(true),
                              child: Text(
                                'Yes, exit checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      // Additional urgency text with timer
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.yellow[300]!),
                        ),
                        child: Text(
                          '⏰ Don\'t miss out on your items!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Extra bottom padding for safe area
                      SizedBox(
                          height: MediaQuery.of(context).viewPadding.bottom),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Usage functions for your OrderNowPage
class OrderExitHandler {
  static Future<bool> showExitConfirmation(
    BuildContext context,
    VoidCallback continueCheckoutCallback,
  ) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ExitConfirmationBottomSheet(
        onContinueCheckout: continueCheckoutCallback,
      ),
    );

    return result ?? false;
  }
}
