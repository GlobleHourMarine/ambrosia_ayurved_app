import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/benefits.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/how_to_use_section.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/ingredients.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_submission.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_2.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    super.key,
    required this.product,
    // required this.imageUrll
  });
  final Product product;
  // final String imageUrll;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final Map<String, dynamic> productDetail = {
    "name": "Face Creame",
    "image": "assets/images/creame.png",
    "tagline":
        "Reduced Blood Sugar by 80% in 3 Months* as per an ICMR-compliant clinical study on subjects with T2DM. Can consume with Allopathic Medicines also.",
    "explanation":
        "Face cream is an essential skincare product used to moisturize, nourish, and protect the skin. It comes in various formulations, designed to address different skin concerns such as dryness, aging, acne, hyperpigmentation, and sun protection. Regular use of a good face cream helps maintain a healthy, youthful, and glowing complexion.",
    "usage":
        "Sugar Medicine Powder is used to help regulate blood sugar levels, often for diabetes management. It is usually mixed with water or taken directly as per dosage instructions.",
    "ingredients": [
      {
        "name": "Gudmar (Gymnema Sylvestre)",
        "image": "assets/images/category_amala.png",
        "description":
            " Reduces sugar cravings and controls blood sugar levels.",
      },
      {
        "name": "Jamun (Black Plum) ",
        "image": "assets/images/incr_jamun.jpg",
        "description":
            " Enhances insulin production and helps maintain glucose balance.",
      },
      {
        "name": " Methi (Fenugreek)",
        "image": "assets/images/category_leaf.png",
        "description":
            "Improves glucose tolerance and supports diabetes control.",
      },
      {
        "name": "Karela (Bitter Gourd) ",
        "image": "assets/images/incr_karela.jpg",
        "description": "Acts as natural insulin and boosts metabolism.",
      },
      {
        "name": "Neem",
        "image": "assets/images/incr_neem.jpg",
        "description":
            "Purifies the blood and is highly beneficial for diabetics.",
      },
      {
        "name": "Tulsi (Holy Basil) ",
        "image": "assets/images/incr_tulsi.jpg",
        "description": "Reduces oxidative stress and strengthens immunity.",
      },
    ],
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Acolors.primary,
          body: ListView(
            children: [
              productDetailHeader(),
              // productImage(),
              Container(
                color: Acolors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _isLoading
                        ? const ShimmerEffect(
                            width: double.infinity, height: 50)
                        : Text(
                            widget.product.name,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _isLoading
                              ? const ShimmerEffect(width: 300, height: 40)
                              : Text(
                                  '\Rs ${widget.product.price}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Acolors.primary),
                                ),
                          _isLoading
                              ? const ShimmerEffect(width: 0, height: 0)
                              : const Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 30),
                                    SizedBox(width: 4),
                                    Text(
                                      '4.3',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        productDetail["tagline"],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            backgroundColor:
                                Color.fromARGB(255, 204, 255, 230)),
                      ),
                    ),
                    const Divider(color: Acolors.primary),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: _isLoading
                            ? Column(
                                children: List.generate(
                                    3,
                                    (index) => const ShimmerEffect(
                                        width: double.infinity, height: 40)))
                            : Text(
                                widget.product.description.toString(),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    bottomCartSection(),
                    SizedBox(height: 50),
                    Divider(color: Acolors.primary),
                    SizedBox(height: 25),
                    Benefits(
                      productId: widget.product.id.toString(),
                    ),
                    Ingredients(),
                    const SizedBox(height: 22),
                    const Divider(color: Acolors.primary),
                    const SizedBox(height: 30),
                    SizedBox(height: 30),
                    CustomerReviewSection(
                      productId: widget.product.id.toString(),
                    ),
                    SizedBox(height: 50),
                    FeaturesSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // SizedBox productImage() {
  //   String imageUrlll = widget.product.imageUrl.startsWith("http")
  //       ? widget.product.imageUrl
  //       : "https://ambrosiaayurved.in/${widget.product.imageUrl}";

  //   return SizedBox(
  //     height: 370,
  //     width: double.infinity,
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: 0,
  //           right: 0,
  //           bottom: 0,
  //           child: Container(
  //             height: 200,
  //             decoration: const BoxDecoration(
  //               color: Acolors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(35),
  //                 topRight: Radius.circular(35),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Center(
  //           child: Container(
  //             decoration: BoxDecoration(
  //               boxShadow: const [
  //                 BoxShadow(
  //                     blurRadius: 15,
  //                     color: Acolors.primary,
  //                     offset: Offset(0, 8)),
  //               ],
  //               borderRadius: BorderRadius.circular(250),
  //             ),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(250),
  //               child: _isLoading
  //                   ? const ShimmerEffect(width: 250, height: 250)
  //                   : Image.network(
  //                       imageUrlll,
  //                       width: 320,
  //                       height: 320,
  //                       fit: BoxFit.cover,
  //                       loadingBuilder: (context, child, progress) {
  //                         if (progress == null) return child;
  //                         return const ShimmerEffect(width: 250, height: 250);
  //                       },
  //                       errorBuilder: (context, error, stackTrace) {
  //                         return const ShimmerEffect(width: 250, height: 250);
  //                       },
  //                     ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Padding productDetailHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.white.withOpacity(0.21),
            borderRadius: BorderRadius.circular(12),
            child: const BackButton(
              color: Acolors.white,
            ),
          ),
          const Text(
            'Product Detail',
            style: TextStyle(fontSize: 24, color: Acolors.white),
          ),
          Container(
            height: 47,
            width: 47,
            child: Material(
              color: Colors.white.withOpacity(0.21),
              borderRadius: BorderRadius.circular(12),
              child: const Icon(
                Icons.favorite_border_outlined,
                color: Acolors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row bottomCartSection() {
    final cart = Provider.of<CartProvider>(context);
    return Row(
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 180,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                color: Acolors.primary,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Container(
                    height: 120,
                    width: 300,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        topLeft: Radius.circular(40),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: Acolors.primary)
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 14),
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        // SizedBox(height: 3),
                        Text(
                          '\Rs ${widget.product.price}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),

                        SizedBox(
                          height: 30,
                          width: 170,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Acolors.primary),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(
                                widget.product.id.toString(),
                                widget.product.name,
                                context,
                              );
                              // SnackbarMessage.showSnackbar(
                              //   context,
                              //   '${widget.product.name} added to cart',
                              //     actionLabel: 'Undo', action: () {
                              //   Provider.of<CartProvider>(context,
                              //           listen: false)
                              //       .removeFromCart(
                              //           widget.product.id.toString());
                              // }
                              //  );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  color: Acolors.white,
                                  size: 20,
                                ),
                                Text(
                                  'Add to Cart',
                                  style: TextStyle(color: Acolors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 330),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CartPage(),
                          ));
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Acolors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              color: Acolors.primary,
                            ),
                          ]),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Acolors.primary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: const Color.fromARGB(255, 245, 114, 74),
                    child: Text(
                      '${cart.totalUniqueItems}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/*

import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Acolors.primary,
      body: ListView(
        children: [
          productDetailHeader(),
          productImage(),
          Container(
            // height: 200,
            color: Acolors.white,
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\Rs ${widget.product.price}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Acolors.primary),
                      ),
                      const Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 30,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.3',
                            // widget.product.rating.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Acolors.primary),
                const SizedBox(height: 3),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.product.description.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const Divider(color: Acolors.primary),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 180,
                          width: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            color: Acolors.primary,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Container(
                                height: 120,
                                width: 300,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(40),
                                    topLeft: Radius.circular(40),
                                    bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12, color: Acolors.primary)
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 14),
                                    Text(
                                      widget.product.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    // SizedBox(height: 3),
                                    Text(
                                      '\Rs ${widget.product.price}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 3),

                                    SizedBox(
                                      height: 30,
                                      width: 170,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Acolors.primary),
                                        onPressed: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addToCart(
                                            widget.product.id.toString(),
                                            //   context
                                          );
                                          SnackbarMessage.showSnackbar(context,
                                              '${widget.product.name} added to cart',
                                              actionLabel: 'Undo', action: () {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .removeFromCart(widget
                                                    .product.id
                                                    .toString());
                                          });
                                        },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              Icons.shopping_cart,
                                              color: Acolors.white,
                                              size: 20,
                                            ),
                                            Text(
                                              'Add to Cart',
                                              style: TextStyle(
                                                  color: Acolors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 330),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CartPage(),
                                      ));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      color: Acolors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 7,
                                          color: Acolors.primary,
                                        ),
                                      ]),
                                  child: const Icon(
                                    Icons.shopping_cart,
                                    color: Acolors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox productImage() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Acolors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 15,
                      color: Acolors.primary,
                      offset: Offset(0, 8)),
                ],
                borderRadius: BorderRadius.circular(250),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(250),
                child: Image.network(
                  widget.product.imageUrl,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding productDetailHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.white.withOpacity(0.21),
            borderRadius: BorderRadius.circular(12),
            child: const BackButton(
              color: Acolors.white,
            ),
          ),
          const Text(
            'Product Detail',
            style: TextStyle(fontSize: 24, color: Acolors.white),
          ),
          Container(
            height: 47,
            width: 47,
            child: Material(
              color: Colors.white.withOpacity(0.21),
              borderRadius: BorderRadius.circular(12),
              child: const Icon(
                Icons.favorite_border_outlined,
                color: Acolors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
