import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_loading_screen.dart';
import 'package:ambrosia_ayurved/widgets/new_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/order_now_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/shimmer_effect/shimmer_effect.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.fetchCartData(userProvider.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      appBar: CustomAppBar(
        // leading: BackButton(color: Colors.black),
        title: AppLocalizations.of(context)!.cart,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: cartProvider.isLoading
                  ? AnimatedLoadingScreen(
                      message: 'Loading your cart...',
                      primaryColor: Acolors.primary,
                      animationDuration: Duration(milliseconds: 1000),
                    )
                  // ListView.builder(
                  //     itemCount: 5,
                  //     itemBuilder: (context, index) => const Padding(
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //       child:
                  //           ShimmerEffect(width: double.infinity, height: 80),
                  //     ),
                  //   )
                  : cartItems.isEmpty
                      //_cartItems.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(height: 170),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainTabView()),
                                        (route) => false,
                                      );
                                    },
                                    child: Image.asset(
                                      'assets/images/cart_empty_1.png',
                                      width: 250,
                                      height: 250,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.cartEmptyTitle}',
                                //'Your Cart is empty',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w400),
                              ),
                              // SizedBox(height: ),
                              Padding(
                                padding: const EdgeInsets.all(22.0),
                                child: Text(
                                  '${AppLocalizations.of(context)!.cartEmptyMessage}',
                                  // "Looks like you haven't added anything to your cart yet.",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black54),
                                ),
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return Card(
                              elevation: 3,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainTabView()),
                                          (route) => false,
                                        );
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 140,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                'https://ambrosiaayurved.in/${cartItem.image}',
                                                fit: BoxFit.contain,
                                                loadingBuilder:
                                                    (context, child, progress) {
                                                  if (progress == null)
                                                    return child;
                                                  return const ShimmerEffect(
                                                      width: 50, height: 50);
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const ShimmerEffect(
                                                      width: 50, height: 50);
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  child: Text(
                                                    // AppLocalizations.of(context)!
                                                    //     .a5product,
                                                    cartItem.productName,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                                SizedBox(height: 7),
                                                Text(
                                                  // AppLocalizations.of(context)!
                                                  //     .descriptionproduct,
                                                  '${cartItem.description}',
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Rs ${cartItem.price}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Row(
                                    children: [
                                      TextButton.icon(
                                        onPressed:
                                            cartProvider.isQuantityLoading
                                                ? null
                                                : () async {
                                                    await cartProvider
                                                        .removeProductFromCart(
                                                            cartItem.cartId,
                                                            context);
                                                  },
                                        icon: cartProvider.isQuantityLoading &&
                                                cartProvider.loadingProductId ==
                                                    cartItem.productId &&
                                                cartProvider.loadingAction ==
                                                    'remove'
                                            ? SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.delete_outline_outlined),
                                        label: Text(
                                          cartProvider.isQuantityLoading &&
                                                  cartProvider
                                                          .loadingProductId ==
                                                      cartItem.productId &&
                                                  cartProvider.loadingAction ==
                                                      'remove'
                                              ? "Removing..."
                                              : "${AppLocalizations.of(context)!.remove}",
                                        ),
                                      ),
                                      SizedBox(width: 80),

                                      InkWell(
                                        onTap: cartProvider.isQuantityLoading
                                            ? null
                                            : () {
                                                cartProvider.decrementQuantity(
                                                    cartItem.productId,
                                                    context);
                                              },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: cartProvider
                                                          .isQuantityLoading &&
                                                      cartProvider
                                                              .loadingProductId ==
                                                          cartItem.productId &&
                                                      cartProvider
                                                              .loadingAction ==
                                                          'decrement'
                                                  ? Acolors.primary
                                                      .withOpacity(0.5)
                                                  : Acolors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: cartProvider
                                                      .isQuantityLoading &&
                                                  cartProvider
                                                          .loadingProductId ==
                                                      cartItem.productId &&
                                                  cartProvider.loadingAction ==
                                                      'decrement'
                                              ? SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Acolors.white),
                                                  ),
                                                )
                                              : Text(
                                                  "-",
                                                  style: TextStyle(
                                                      color: Acolors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        height: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Acolors.primary,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.5)),
                                        child: Text(
                                          // '${cartProvider.cartItemsQuantity(cartItem.productId)}',
                                          //  quantity.toString(),
                                          '${cartItem.quantity}',
                                          style: TextStyle(
                                              color: Acolors.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),

                                      // Increment Button
                                      InkWell(
                                        onTap: cartProvider.isQuantityLoading
                                            ? null
                                            : () {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .incrementQuantity(
                                                        cartItem.productId,
                                                        context);
                                              },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: cartProvider
                                                          .isQuantityLoading &&
                                                      cartProvider
                                                              .loadingProductId ==
                                                          cartItem.productId &&
                                                      cartProvider
                                                              .loadingAction ==
                                                          'increment'
                                                  ? Acolors.primary
                                                      .withOpacity(0.5)
                                                  : Acolors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: cartProvider
                                                      .isQuantityLoading &&
                                                  cartProvider
                                                          .loadingProductId ==
                                                      cartItem.productId &&
                                                  cartProvider.loadingAction ==
                                                      'increment'
                                              ? SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Acolors.white),
                                                  ),
                                                )
                                              : const Text(
                                                  "+",
                                                  style: TextStyle(
                                                      color: Acolors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            if (cartItems.isNotEmpty && !cartProvider.isLoading)
              //  if (cartItems.isNotEmpty && !_isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: FloatingActionButton(
                    splashColor: Acolors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Acolors.primary,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderNowPage(),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.proceedToBuy,
                      style: TextStyle(fontSize: 18, color: Acolors.white),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/bottom_nav.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/payment_page/payment_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now_page.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // int qty = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final productNotifier = Provider.of<ProductNotifier>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
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
                    'Cart',
                    style: TextStyle(fontSize: 24, color: Acolors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: cart.cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Cart is empty',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final productId = cart.cartItems.keys.elementAt(index);
                      final product = productNotifier.products
                          .firstWhere((p) => p.id == productId);

                      final quantity = cart.cartItems[productId] ?? 1;

                      return Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.network(
                                product.imageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(product.name),

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 3),
                                  Text(
                                    '${product.description}',
                                    maxLines: 2,
                                    overflow: TextOverflow
                                        .ellipsis, // Adds '...' if text overflows
                                    style: TextStyle(fontSize: 12),
                                  ), // Display Description
                                  SizedBox(height: 5),
                                  Text(
                                      'Rs ${product.price.toStringAsFixed(2)}'), // Display Price

                                  //  Text('Quantity: $quantity'), // Existing Quantity
                                ],
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.delete),
                              //   onPressed: () {
                              //     cart.removeFromCart(productId);
                              //   },
                              // ),
                              // Text('Quantity: $quantity'),
                            ),
                            Divider(),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    cart.removeFromCart(productId.toString());
                                    SnackbarMessage.showSnackbar(context,
                                        '${product.name.toString()} removed from cart');
                                  },
                                  icon: Icon(Icons.delete_outline_outlined),
                                  label: Text('Remove'),
                                ),
                                SizedBox(width: 80),
                                InkWell(
                                  onTap: () {
                                    if (quantity > 1) {
                                      cart.updateQuantity(
                                          productId, quantity - 1);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Acolors.primary,
                                        borderRadius:
                                            BorderRadius.circular(12.5)),
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                          color: Acolors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  height: 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Acolors.primary,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.5)),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                        color: Acolors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () {
                                    cart.updateQuantity(
                                        productId, quantity + 1);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Acolors.primary,
                                        borderRadius:
                                            BorderRadius.circular(12.5)),
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                          color: Acolors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (cart.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  splashColor: Acolors.primary,
                  backgroundColor: Acolors.primary,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderNowPage()));
                  },
                  child: const Text(
                    'Order Now',
                    style: TextStyle(fontSize: 20, color: Acolors.white),
                  ),
                ),
              ),
            )
        ]),
        bottomNavigationBar: BottomNav(
          selectedIndex: 2, // Payment screen selected index
        ),
      ),
    );
  }
}
*/