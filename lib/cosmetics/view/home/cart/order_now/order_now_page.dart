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

  bool _isLoading = true; // Loader State

  @override
  void initState() {
    super.initState();
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _addressController = TextEditingController();
    // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    bool _isLoading = false;

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
              : Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.productDetails}",
                          //'Product Details'
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.totalPrice}",
                          // 'Total price'
                        ),
                      ],
                    ),
                  ),
                ),
          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                final item = cartList[index];

                // Access the provider

                final totalPriceProvider =
                    Provider.of<ItemTotalPriceProvider>(context, listen: false);

                // Calculate total price using provider
                double totalPrice = totalPriceProvider.calculateTotalPrice(
                  item.price.toString(),
                  item.quantity.toString(),
                );

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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70, // Adjust as needed
                            height: 90, // Adjust as needed
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
                                      width: 50, height: 50);
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const ShimmerEffect(
                                      width: 50, height: 50);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 20),
                                    Text(
                                      item.productName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rs ${item.price} * ${item.quantity}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Rs ${totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              },
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
                            child:
                                _buildTextField(_fnameController, 'First Name'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                _buildTextField(_lnameController, 'Last Name'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // // Email
                      // _buildTextField(_emailController, 'Email'),
                      // const SizedBox(height: 10),

                      // Address and Mobile
                      _buildTextField(_addressController, 'Address'),
                      const SizedBox(width: 10),
                      const SizedBox(height: 10),

                      // City, State, and Pincode
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(_cityController, 'City'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(_stateController, 'State'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                                _buildTextField(_pincodeController, 'Pincode'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Country
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(
                                  _countryController, 'Country')),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(_mobileController, 'Mobile'),
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
                          "${AppLocalizations.of(context)!.grandTotal} : ",
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

                    // Show message
                    //    SnackbarMessage.showSnackbar(context, AddressProvider.message);

                    // Navigate if successful
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ),
                      );
                    }
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
                child: addressProvider.isLoading
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