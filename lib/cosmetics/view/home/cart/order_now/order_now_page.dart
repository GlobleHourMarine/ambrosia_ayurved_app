import 'dart:convert';
import 'dart:math';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/address_fetch_service.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/bill_summary_section.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/widgets/phonepe/phonepe_service.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/shiprocket_service.dart';
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
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class OrderNowPage extends StatefulWidget {
  const OrderNowPage({super.key});

  @override
  State<OrderNowPage> createState() => _OrderNowPageState();
}

class _OrderNowPageState extends State<OrderNowPage> {
  AddressModel? selectedAddress;
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
  bool _isPhonePeInitialized = false;

  bool _isLoading = false; // Loader State

  void initState() {
    super.initState();

    _pincodeController.addListener(_onPincodeChanged);

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
    List<TextInputFormatter>? inputFormatters,
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
      inputFormatters: inputFormatters,
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    final cartProvider = Provider.of<CartProvider>(context);
    // final grandTotalProvider =
    // Provider.of<GrandTotalProvider>(context, listen: false);

    final cartList = cartProvider.cartItems;

    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.orderNow}",
        //  'Order Now',
      ),
      body: SafeArea(
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
                    final totalPriceProvider =
                        Provider.of<ItemTotalPriceProvider>(context,
                            listen: false);
                    // Calculate total price using provider
                    double totalPrice = totalPriceProvider.calculateTotalPrice(
                      item.price.toString(),
                      item.quantity.toString(),
                    );

                    //

                    // Convert price to double
                    double price =
                        double.tryParse(item.price.toString()) ?? 0.0;
                    int quantity = int.tryParse(item.quantity.toString()) ?? 1;
                    double basePricePerItem = price / 1.12;

                    //
                    double gstPerItem = price - basePricePerItem;

                    //
                    double baseTotal = basePricePerItem * quantity;
                    double gstTotal = gstPerItem * quantity;
                    double totalWithGst = price * quantity;

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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                        color: Acolors.primary,
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 0),
                                                      decoration: BoxDecoration(
                                                        color: Acolors.primary
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Acolors.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                    height: 5, thickness: 1),

                                                // Base price row
                                                Row(
                                                  children: [
                                                    Icon(Icons.circle,
                                                        size: 8,
                                                        color:
                                                            Colors.grey[700]),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      //  'Base Price : ',
                                                      "${AppLocalizations.of(context)!.basePrice} (${item.quantity})",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[700]),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Text(
                                                        "Rs ${baseTotal.toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                                  .grey[700]),
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
                                                            "Rs ${gstTotal.toStringAsFixed(2)}",
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
                                                  ],
                                                ),

                                                //    Divider(height: 5, thickness: 1),
                                                // Total row with highlight
                                                /*    Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Acolors.primary
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                        border: Border.all(
                                                            color: Acolors.primary
                                                                .withOpacity(
                                                                    0.3)),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${AppLocalizations.of(context)!.total}: ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          Consumer<
                                                              GrandTotalProvider>(
                                                            builder: (context,
                                                                grandTotalProvider,
                                                                child) {
                                                              return Text(
                                                                "Rs ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
                                                                //  "₹${totalWithGst.toStringAsFixed(2)}",
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                  color: Acolors
                                                                      .primary,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                */
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
                            /*
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
                            ),
                            */
                          ],
                        ),
                      ),
                    );
                  },
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
                // Padding(
                //   padding: const EdgeInsets.all(2.0),
                //   child: Card(
                //     elevation: 4,
                //     child: Padding(
                //       padding: const EdgeInsets.all(16.0),
                //       child: Form(
                //         key: _formKey,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               "${AppLocalizations.of(context)!.shippingAddress}",
                //               // 'Shipping Address',
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             const SizedBox(height: 16),

                //             // First name and Last name

                //             Row(
                //               children: [
                //                 Expanded(
                //                   child: _buildTextField(
                //                       _fnameController,
                //                       inputFormatters: [
                //                         FilteringTextInputFormatter.allow(
                //                             RegExp(r'[a-zA-Z]')),
                //                       ],
                //                       "${AppLocalizations.of(context)!.firstName}"),
                //                 ),
                //                 const SizedBox(width: 10),
                //                 Expanded(
                //                   child: _buildTextField(
                //                       _lnameController,
                //                       inputFormatters: [
                //                         FilteringTextInputFormatter.allow(
                //                             RegExp(r'[a-zA-Z]')),
                //                       ],
                //                       "${AppLocalizations.of(context)!.lastName}"),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(height: 10),

                //             // // Email
                //             // _buildTextField(_emailController, 'Email'),
                //             // const SizedBox(height: 10),

                //             // Address and Mobile
                //             Row(
                //               children: [
                //                 Expanded(
                //                   flex: 2,
                //                   child: _buildTextField(_addressController,
                //                       "${AppLocalizations.of(context)!.address}"),
                //                 ),
                //                 SizedBox(width: 10),
                //                 Expanded(
                //                   child: _buildTextField(
                //                     _pincodeController,
                //                     "${AppLocalizations.of(context)!.pincode}",
                //                     keyboardType: TextInputType.number,
                //                     suffixIcon: _isLoading
                //                         ? const SizedBox(
                //                             width: 20,
                //                             height: 20,
                //                             child: Padding(
                //                               padding: EdgeInsets.all(12.0),
                //                               child: CircularProgressIndicator(
                //                                   strokeWidth: 2),
                //                             ),
                //                           )
                //                         : null,
                //                     validator: (value) {
                //                       if (value == null || value.isEmpty) {
                //                         return "${AppLocalizations.of(context)!.enterPincode}";
                //                       } else if (!RegExp(r'^\d{6}$')
                //                           .hasMatch(value)) {
                //                         return "${AppLocalizations.of(context)!.validPincode}";
                //                       }
                //                       return null;
                //                     },
                //                     inputFormatters: [
                //                       FilteringTextInputFormatter.digitsOnly,
                //                       LengthLimitingTextInputFormatter(6),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             // const SizedBox(width: 10),
                //             const SizedBox(height: 10),

                //             // City, State, and Pincode
                //             Row(
                //               children: [
                //                 // Expanded(
                //                 //   child: _buildTextField(
                //                 //     _pincodeController,
                //                 //     "${AppLocalizations.of(context)!.pincode}",
                //                 //     keyboardType: TextInputType.number,
                //                 //     validator: (value) {
                //                 //       if (value == null || value.isEmpty) {
                //                 //         return "${AppLocalizations.of(context)!.enterPincode}";
                //                 //       } else if (!RegExp(r'^\d{6}$')
                //                 //           .hasMatch(value)) {
                //                 //         return "${AppLocalizations.of(context)!.validPincode}";
                //                 //       }
                //                 //       return null;
                //                 //     },
                //                 //   ),
                //                 // ),
                //                 // SizedBox(width: 10),
                //                 Expanded(
                //                   // flex: 2,
                //                   child: _buildTextField(_cityController,
                //                       "${AppLocalizations.of(context)!.city}"),
                //                 ),
                //                 const SizedBox(width: 10),
                //                 Expanded(
                //                   child: _buildTextField(_stateController,
                //                       "${AppLocalizations.of(context)!.state}"),
                //                 ),
                //                 //   const SizedBox(width: 10),
                //                 // Pincode (6 digits only)
                //               ],
                //             ),
                //             const SizedBox(height: 10),

                //             // Country
                //             Row(
                //               children: [
                //                 Expanded(
                //                     child: _buildTextField(_countryController,
                //                         "${AppLocalizations.of(context)!.country}")),
                //                 const SizedBox(width: 10),
                //                 // Mobile (12 digits only)
                //                 Expanded(
                //                   child: _buildTextField(
                //                     _mobileController,
                //                     "${AppLocalizations.of(context)!.mobile}",
                //                     keyboardType: TextInputType.number,
                //                     validator: (value) {
                //                       if (value == null || value.isEmpty) {
                //                         return "${AppLocalizations.of(context)!.enterMobile}";
                //                       } else if (!RegExp(r'^\d{10,13}$')
                //                           .hasMatch(value)) {
                //                         return "${AppLocalizations.of(context)!.validMobile}";
                //                       }
                //                       return null;
                //                     },
                //                     inputFormatters: [
                //                       FilteringTextInputFormatter.digitsOnly,
                //                       LengthLimitingTextInputFormatter(13),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              builder: (context, grandTotalProvider, child) {
                                double grandTotal =
                                    grandTotalProvider.grandTotal;
                                double basePrice = grandTotal /
                                    1.12; // Calculate base price (grandTotal / (1 + 0.12))
                                double gstAmount = grandTotal -
                                    basePrice; // Calculate GST amount

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
                                  ],
                                );
                              },
                            ),
                            // Base price row
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Icon(Icons.circle,
                            //             size: 8, color: Colors.grey[700]),
                            //         SizedBox(width: 6),
                            //         Text(
                            //           //  'Base Price : ',
                            //           "${AppLocalizations.of(context)!.basePrice}:",
                            //           style: TextStyle(
                            //               fontSize: 14, color: Colors.grey[700]),
                            //         ),
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         Text(
                            //           "Rs ${basePricePerItem.toStringAsFixed(2)} × ${item.quantity}",
                            //           style: TextStyle(
                            //               fontSize: 14, color: Colors.grey[700]),
                            //         ),
                            //         SizedBox(width: 8),
                            //         Container(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 6, vertical: 2),
                            //           decoration: BoxDecoration(
                            //             color: Colors.grey[200],
                            //             borderRadius: BorderRadius.circular(4),
                            //           ),
                            //           child: Text(
                            //             "Rs ${baseTotal.toStringAsFixed(2)}",
                            //             style: TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               fontSize: 14,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 8),

                            // // GST row
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Icon(Icons.circle,
                            //             size: 8, color: Colors.grey[700]),
                            //         SizedBox(width: 6),
                            //         Text(
                            //           "${AppLocalizations.of(context)!.gst}",
                            //           //  "Gst  (12%) :",
                            //           style: TextStyle(
                            //               fontSize: 14, color: Colors.grey[700]),
                            //         ),
                            //       ],
                            //     ),
                            //     Row(
                            //       children: [
                            //         Text(
                            //           "Rs ${gstPerItem.toStringAsFixed(2)} × ${item.quantity}",
                            //           style: TextStyle(
                            //               fontSize: 14, color: Colors.grey[700]),
                            //         ),
                            //         SizedBox(width: 8),
                            //         Container(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 6, vertical: 2),
                            //           decoration: BoxDecoration(
                            //             color: Colors.grey[200],
                            //             borderRadius: BorderRadius.circular(4),
                            //           ),
                            //           child: Text(
                            //             "Rs ${gstTotal.toStringAsFixed(2)}",
                            //             style: TextStyle(
                            //               fontWeight: FontWeight.w500,
                            //               fontSize: 14,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // ),

                            Divider(height: 12, thickness: 1),
                            // Total row with highlight
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
                                        color:
                                            Acolors.primary.withOpacity(0.3)),
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
                                        builder: (context, grandTotalProvider,
                                            child) {
                                          return Text(
                                            "Rs ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
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

                AddressSelectionWidget(
                  title: "Select Delivery Address",
                  onAddressSelected: (AddressModel address) {
                    setState(() {
                      selectedAddress = address;
                    });
                    print('Selected: ${address.fname} ${address.lname}');
                  },
                ),

                // Show selected address info
                if (selectedAddress != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Text(
                      'Delivering to: ${selectedAddress!.fname} ${selectedAddress!.lname}',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                //        ),
                //    ),
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
                // if (cartList.isNotEmpty)
                //   Consumer<GrandTotalProvider>(
                //     builder: (context, grandTotalProvider, child) {
                //       return Card(
                //         elevation: 3,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 20, vertical: 10),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text(
                //                 "${AppLocalizations.of(context)!.grandTotal} ",
                //                 //  "Grand Total : ",
                //                 style: TextStyle(
                //                     fontSize: 18, fontWeight: FontWeight.bold),
                //               ),
                //               Text(
                //                 "Rs ${grandTotalProvider.grandTotal.toStringAsFixed(2)}",
                //                 style: const TextStyle(
                //                     fontSize: 18, fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                                  SnackbarMessage.showSnackbar(context,
                                      'Please select a delivery address');
                                  return;
                                }

                                final placeOrderProvider =
                                    Provider.of<PlaceOrderProvider>(context,
                                        listen: false);
                                // ✅ Pass the selected address ID to the provider
                                placeOrderProvider.setAddressId(
                                    selectedAddress!.id.toString());

                                final userProvider = Provider.of<UserProvider>(
                                    context,
                                    listen: false);
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
                                Navigator.of(context)
                                    .pop(); // close loader popup after payment

                                if (paymentResult.contains("FAILURE")) {
                                  SuccessPopup.show(
                                    context: context,
                                    title: "Payment Failed",
                                    subtitle: paymentResult,
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
                                  title: "Creating Order...",
                                  subtitle:
                                      "We are placing your order in Shiprocket.",
                                  icon: Icons.hourglass_empty,
                                  iconColor: Colors.orange,
                                  autoCloseDuration: 0,
                                  showButtonLoader: true,
                                );

                                List<Map<String, dynamic>> orderItems =
                                    cartProvider.cartItems.map((cartItem) {
                                  return {
                                    "name": cartItem.productName,
                                    "sku": "AYUR${cartItem.productId}",
                                    "units": cartItem.quantity,
                                    "selling_price": cartItem.price,
                                    "discount":
                                        "", // You can calculate discount if available
                                    "tax": "", // Add tax if applicable
                                    "hsn":
                                        123566 // Use HSN from product or default
                                  };
                                }).toList();

                                await createShiprocketOrder(
                                    billingCustomerName: selectedAddress!.fname,
                                    billingLastName: selectedAddress!.lname,
                                    billingAddress: selectedAddress!.address,
                                    billingAddress2: "",
                                    billingCity: selectedAddress!.city,
                                    billingPincode: selectedAddress!.pincode,
                                    billingState: selectedAddress!.state,
                                    billingCountry: selectedAddress!.country,
                                    billingEmail: userProvider.email,
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
                                  title: "Error",
                                  subtitle: e.toString(),
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
                          : Text("Create Shiprocket Order"),
                    ),

                    /* 
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Acolors.primary,
                        foregroundColor: Acolors.white,
                      ),
                      onPressed: () async {
                        final grandTotalProvider =
                            Provider.of<GrandTotalProvider>(context,
                                listen: false);
        
                        if (selectedAddress == null) {
                          SnackbarMessage.showSnackbar(
                              context, 'Please select a delivery address');
                          return;
                        }
        
                        if (!_isPhonePeInitialized) {
                          SnackbarMessage.showSnackbar(context,
                              'PhonePe is not initialized. Please try again.');
                          return;
                        }
        
                        // Start PhonePe payment with grand total
                        await _startPhonePePayment(grandTotalProvider.grandTotal);
                        /*    
                         print("Button pressed!");
            
                        // Remove form validation since there's no Form widget
                        print("Selected address: $selectedAddress");
                        print(
                            "AddressProvider loading: ${addressProvider.isLoading}");
            
                        // Only check for selected address
                        if (selectedAddress == null) {
                          print("No address selected");
                          SnackbarMessage.showSnackbar(
                              context, 'Please select a delivery address');
                          return;
                        }
            
                        print("Address selected: ${selectedAddress!.id}");
            
                        setState(() {
                          _isLoading = true;
                        });
            
                        try {
                          print("Navigating to PaymentScreen...");
            
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                addressId: selectedAddress!.id,
                              ),
                            ),
                          );
                        } catch (e) {
                          print("Error occurred: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
            */
                        if (_formKey.currentState!.validate()) {
                          if (selectedAddress == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Please select a delivery address')),
                            );
                            return;
                          }
        
                          setState(() {
                            _isLoading = true;
                          });
        
                          final cartProvider =
                              Provider.of<CartProvider>(context, listen: false);
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          String userId = userProvider.id;
                          final grandTotalProvider =
                              Provider.of<GrandTotalProvider>(context,
                                  listen: false);
        
                          // Get the list of productIds from cart
                          // List<String> productIds = cartProvider.cartItems
                          //     .map((item) => item.productId.toString())
                          //     .toList();
                          // print(' product id: $productIds');
        
                          // Save address information
                          //   final addressProvider =
                          //     Provider.of<AddressProvider>(context, listen: false);
                          //   bool success =
                          //     await addressProvider.saveCheckoutInformation(
                          //   //
                          //   address_type: "home",
                          //   district: _districtController.text,
                          //   userid: userId,
                          //   fname: _fnameController.text,
                          //   lname: _lnameController.text,
                          //   address: _addressController.text,
                          //   city: _cityController.text,
                          //   state: _stateController.text,
                          //   mobile: _mobileController.text,
                          //   country: _countryController.text,
                          //   pincode: _pincodeController.text,
                          //   context: context,
                          // );
        
                          //     if (success) {
                          
                          //   _startPhonePePayment(grandTotalProvider.grandTotal);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentScreen(addressId: selectedAddress!.id),
                            ),
                          );
                          //      }
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: _isLoading || addressProvider.isLoading
                          ? const CircularProgressIndicator(color: Acolors.white)
                          : Text(
                              "${AppLocalizations.of(context)!.proceedToCheckout}",
                              // "Proceed to Checkout",
                            ),
                    ),
                    */
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       try {
                //         final data = await fetchTrackingInfo('19041786623385',
                //             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY3NTMwMzksInNvdXJjZSI6InNyLWF1dGgtaW50IiwiZXhwIjoxNzU1NzcxNzkxLCJqdGkiOiJpWmFwVHdubURDMjRWS1ltIiwiaWF0IjoxNzU0OTA3NzkxLCJpc3MiOiJodHRwczovL3NyLWF1dGguc2hpcHJvY2tldC5pbi9hdXRob3JpemUvdXNlciIsIm5iZiI6MTc1NDkwNzc5MSwiY2lkIjo2NTE3MTM5LCJ0YyI6MzYwLCJ2ZXJib3NlIjpmYWxzZSwidmVuZG9yX2lkIjowLCJ2ZW5kb3JfY29kZSI6IiJ9.tfzREh0gVEGxz3WQ4D-JwM7QPIiQExv0BLcDJujo6D4');
                //         print('Tracking data : $data');
                //       } catch (e) {
                //         print('Error: $e');
                //       }
                //     },
                //     child: Text('click')),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
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



/*
// shiprocket code

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
  // Generate unique order ID (timestamp + random 4-digit number)
  final random = Random();
  final orderId =
      'ORDER_${DateTime.now().millisecondsSinceEpoch}-${random.nextInt(9000) + 1000}';

  // Get current date and time in required format
  final now = DateTime.now();
  final orderDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

  final merchantOrderId = GlobalPaymentData.merchantOrderId;
  print('global merchant id : $merchantOrderId');

  const bearerToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY4NTkzMDcsInNvdXJjZSI6InNyLWF1dGgtaW50IiwiZXhwIjoxNzUxNzk5Njk5LCJqdGkiOiJQcGNxYmJjbllzTU5LT1FQIiwiaWF0IjoxNzUwOTM1Njk5LCJpc3MiOiJodHRwczovL3NyLWF1dGguc2hpcHJvY2tldC5pbi9hdXRob3JpemUvdXNlciIsIm5iZiI6MTc1MDkzNTY5OSwiY2lkIjo2NTE3MTM5LCJ0YyI6MzYwLCJ2ZXJib3NlIjpmYWxzZSwidmVuZG9yX2lkIjowLCJ2ZW5kb3JfY29kZSI6IiJ9.2HUjE-3fSCP9jf-5uer7Khas3rwC0bSt3mJAIgu5KqE';
  
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
      print('Order ID: $orderId');
      print( 'Create order api of shipment :   $responseData');

      final shipmentId = responseData['shipment_id'];
      if (shipmentId != null) {
        List<int> shipmentIds = [shipmentId as int];
        // Call AWB assignment after successful order creation
        final awbResult = await assignAwbToShipment(
          token: bearerToken,
          shipmentIds: shipmentIds,
        );

        if (awbResult['success'] == true) {
          final awbCode =
              awbResult['data']['response']['data']['awb_code']?.toString();

          // Store it in a variable for further use
          String assignedAwbCode =
              awbCode ?? ''; // Provide empty string as fallback

          print('AWB assigned successfully!');
          print('AWB Number: $assignedAwbCode');
          SnackbarMessage.showSnackbar(context,
              'Order and AWB assigned successfully! AWB: $assignedAwbCode');
          // In your original file where you get the AWB
          // final awbData = Provider.of<AwbData>(context, listen: false);
          // awbData.setAwbCode(assignedAwbCode);

          final result = await generatePickupRequest(
              token: bearerToken, shipmentIds: shipmentIds);
          if (result['success'] == true) {
            SnackbarMessage.showSnackbar(context, 'Order Created successfully');
            print('Pickup generated successfully!');
            print('Response: ${result['data']}');
            // Handle success - show confirmation to user
          } else {
            print('Failed to generate pickup: ${result['error']}');
            // Handle error - show error message to user
          }
        } else {
          print('AWB assignment failed: ${awbResult['error']}');
          SnackbarMessage.showSnackbar(context,
              'Order created but AWB assignment failed: ${awbResult['error']}');
        }
      }

      // Example usage
      // if (shipmentId != null) {
      //   List<int> shipmentIds = [shipmentId as int];
      //   final result = await generatePickupRequest(
      //       token: bearerToken, shipmentIds: shipmentIds
      //       // Convert to int and wrap in list
      //       );
      //   if (result['success'] == true) {
      //     SnackbarMessage.showSnackbar(context, 'Order Created successfully');
      //     print('Pickup generated successfully!');
      //     print('Response: ${result['data']}');
      // Handle success - show confirmation to user
      // } else {
      //   print('Failed to generate pickup: ${result['error']}');
      //   // Handle error - show error message to user
      // }
      // }
    } else {
      print('Error creating order: ${response.reasonPhrase}');
      print('Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception occurred: $e');
  }
}

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

    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': responseData,
        'awb_number': responseData['awb_number']
            ?.toString(), 
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

// Example usage:
/*
createShiprocketOrder(
  billingCustomerName: "Naruto",
  billingLastName: "Uzumaki",
  billingAddress: "House 221B, Leaf Village",
  billingAddress2: "Near Hokage House",
  billingCity: "New Delhi",
  billingPincode: "110002",
  billingState: "Delhi",
  billingCountry: "India",
  billingEmail: "naruto@uzumaki.com",
  billingPhone: "9876543210",
  orderItems: [
    {
      "name": "Kunai",
      "sku": "chakra123",
      "units": 10,
      "selling_price": 900,
      "discount": "",
      "tax": "",
      "hsn": 441122
    }
  ],
  paymentMethod: "Prepaid",
  shippingCharges: 0,
  giftwrapCharges: 0,
  transactionCharges: 0,
  totalDiscount: 0,
  subTotal: 9000,
  length: 10,
  breadth: 15,
  height: 20,
  weight: 2.5,
);
*/
*/