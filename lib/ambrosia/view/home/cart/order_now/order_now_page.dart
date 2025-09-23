import 'dart:convert';
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

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final cartList = cartProvider.cartItems;

    return Scaffold(
      appBar: CustomAppBar(
        leading: BackButton(color: Colors.black),
        title: "${AppLocalizations.of(context)!.orderNow}",
        //  'Order Now',
      ),
      body: Stack(
        children: [
          SafeArea(
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
                        double basePricePerItem = price / 1.12;

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
                                          fit: BoxFit.contain,
                                          loadingBuilder:
                                              (context, child, progress) {
                                            if (progress == null) return child;
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
                                                      BorderRadius.circular(8),
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
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            color:
                                                                Acolors.primary,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 0),
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
                                                            "Rs ${totalWithGst.toStringAsFixed(2)}",
                                                            style: TextStyle(
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
                                                                  .grey[700]),
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 2),
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
                                                            "Rs ${baseTotal.toStringAsFixed(2)}",
                                                            style: TextStyle(
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
                                                            Icon(Icons.circle,
                                                                size: 8,
                                                                color: Colors
                                                                    .grey[700]),
                                                            SizedBox(width: 3),
                                                            Text(
                                                              "${AppLocalizations.of(context)!.gst} (${item.quantity})",
                                                              //  "Gst  (12%) :",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            // Text(
                                                            //   "Rs ${gstPerItem.toStringAsFixed(2)} × ${item.quantity}",
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
                                                                    .grey[200],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Text(
                                                                "Rs ${gstTotal.toStringAsFixed(2)}",
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
                                      builder:
                                          (context, grandTotalProvider, child) {
                                        return Text(
                                          "Rs ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
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
                                //   "Rs ${totalWithGst.toStringAsFixed(2)}",
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
                                        1.12; // Calculate base price (grandTotal / (1 + 0.12))
                                    double gstAmount = grandTotal - basePrice;
                                    double finalTotal =
                                        grandTotalProvider.finalTotal;

                                    return Column(
                                      children: [
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
                                                  "${AppLocalizations.of(context)!.basePrice}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "Rs ${basePrice.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
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
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "Rs ${gstAmount.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.circle,
                                                    size: 8,
                                                    color: Colors.grey[700]),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Delivery charges :',
                                                  // "${AppLocalizations.of(context)!.gst}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "Rs 0",
                                                //"Rs ${gstAmount.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (grandTotalProvider.discountAmount >
                                            0) ...[
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[50],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  "-₹${grandTotalProvider.discountAmount.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                                        color: Acolors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
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
                                                "Rs ${grandTotalProvider.finalTotal.toStringAsFixed(2)}",
                                                //  "₹${totalWithGst.toStringAsFixed(2)}",
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
                                    : TextButton(
                                        onPressed: _applyCoupon,
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                              color: Acolors.primary,
                                              fontSize: 16),
                                        ),
                                      ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                              ),
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
                                    color:
                                        _couponMessage.contains('successfully')
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(12.0),
            //   child: AddressSelectionWidget(
            //     title: "Select Delivery Address",
            //     onAddressSelected: (Address address) {
            //       setState(() {
            //         selectedAddress = address;
            //       });
            //       print('Selected: ${address.fname} ${address.lname}');
            //     },
            //   ),
            // ),
            // // Show selected address info
            // if (selectedAddress != null)
            //   Container(
            //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            //     child: Text(
            //       'Delivering to: ${selectedAddress!.fname} ${selectedAddress!.lname}',
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      : () async {
                          setState(() => _isLoading = true);

                          try {
                            if (selectedAddress == null) {
                              SnackbarMessage.showSnackbar(
                                  context, 'Please select a delivery address');
                              return;
                            }

                            //
                            final cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            final grandTotalProvider =
                                Provider.of<GrandTotalProvider>(context,
                                    listen: false);

                            // 1️⃣ Show loader popup immediately
                            SuccessPopup.show(
                              context: context,
                              title: "Processing...",
                              subtitle:
                                  "Please wait while we complete your payment and order.",
                              icon: Icons.hourglass_empty,
                              iconColor: Colors.orange,
                              autoCloseDuration: 0,
                              showButtonLoader: true,
                            );

                            String paymentResult =
                                await PhonePePaymentService.initiatePayment(
                              amount: 100, context: context,

                              // (grandTotalProvider.grandTotal * 100)
                              //     .toInt(), // amount in paisa
                            );
                            final merchantOrderId =
                                GlobalPaymentData.merchantOrderId.toString();

                            final placeOrderProvider =
                                Provider.of<PlaceOrderProvider>(context,
                                    listen: false);

                            placeOrderProvider
                                .setAddressId(selectedAddress!.id.toString());
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

                              subtotal:
                                  grandTotalProvider.grandTotal.toString(),
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
                            SuccessPopup.show(
                              context: context,
                              title: "Failed",
                              subtitle: "Failed to place Order",
                              // e.toString(),
                              iconColor: Colors.red,
                              icon: Icons.error,
                              autoCloseDuration: 0,
                              buttonText: "OK",
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
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
                      : Text("Checkout"),
                ),
              ),
            ),
          ],
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
