import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_cached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/product_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDescriptionScreen extends StatefulWidget {
  final Product product;
  ProductDescriptionScreen({super.key, required this.product});
  @override
  _ProductDescriptionScreenState createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen>
    with TickerProviderStateMixin {
  @override
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    return _buildProductDetailsPage(context, widget.product);
  }

  Widget _buildProductDetailsPage(BuildContext context, Product product) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    Size screenSize = MediaQuery.of(context).size;
    return productNotifier.isLoading
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: 6, // Show shimmer placeholders
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 275,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerEffect(width: double.infinity, height: 120),
                      SizedBox(height: 10),
                      ShimmerEffect(width: 100, height: 20),
                      SizedBox(height: 5),
                      ShimmerEffect(width: 60, height: 20),
                      SizedBox(height: 10),
                      ShimmerEffect(width: double.infinity, height: 40),
                    ],
                  ),
                ),
              );
            },
          )
        : ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildProductImagesWidgets(product),
                    _buildProductTitleWidget(product),
                    SizedBox(height: 12.0),
                    _buildPriceWidgets(product),
                    SizedBox(height: 12.0),
                    _buildDivider(screenSize),
                    SizedBox(height: 12.0),
                    _buildStyleNoteData(product),
                    SizedBox(height: 12),
                    if (widget.product.id == 14) ...[
                      _buildBenefitRow(
                          AppLocalizations.of(context)!.a5Benefit1),
                      _buildBenefitRow(
                          AppLocalizations.of(context)!.a5Benefit2),
                      _buildBenefitRow(
                          AppLocalizations.of(context)!.a5Benefit3),
                      _buildBenefitRow(
                          AppLocalizations.of(context)!.a5Benefit4),
                    ],
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
              bottomCartSection(product),
            ],
          );
  }

  Widget _buildProductImagesWidgets(Product product) {
    List<String> imageList = product.imageUrl;

    PageController _pageController = PageController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 400.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return CustomCachedImage(
                  imageUrl: 'https://ambrosiaayurved.in/${imageList[index]}',
                  fit: BoxFit.contain,
                  shimmerWidth: 250,
                  shimmerHeight: 250,
                );

                // CachedNetworkImage(
                //   imageUrl: 'https://ambrosiaayurved.in/${imageList[index]}',
                //   placeholder: (context, url) =>
                //       const ShimmerEffect(width: 250, height: 250),
                //   errorWidget: (context, url, error) => const Icon(
                //     Icons.image_not_supported,
                //     color: Colors.grey,
                //     size: 100,
                //   ),
                //   fit: BoxFit.contain,
                // );

                // Image.network(
                //   'https://ambrosiaayurved.in/${imageList[index]}',
                //   //   imageList[index],
                //   //   fit: BoxFit.contain,
                //   loadingBuilder: (context, child, progress) {
                //     if (progress == null) return child;
                //     return const ShimmerEffect(width: 250, height: 250);
                //   },
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Icon(Icons.image_not_supported,
                //         color: Colors.grey, size: 100);
                //   },
                // );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageList.length, (index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double selected = (_pageController.page ?? 0).roundToDouble();
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: selected == index ? 12.0 : 8.0,
                    height: selected == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected == index ? Colors.grey : Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitleWidget(Product product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            // 'A5 – Ayurveda’s Ultimate Answer to Diabetes',
            //  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // AppLocalizations.of(context)!.a5product,
            product.name,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceWidgets(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: <Widget>[
          Text("\Rs ${product.price}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(width: 8.0),
          Text("11200",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough)),
          SizedBox(width: 8.0),
          Text("50% off", style: TextStyle(fontSize: 14.0, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildDivider(Size screenSize) {
    return Container(
      color: Colors.grey[600],
      width: screenSize.width,
      height: 0.25,
    );
  }

  Widget _buildStyleNoteData(Product product) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        product.description,
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 47, 47, 47)),
      ),
    );
  }

  Widget bottomCartSection(Product product) {
    final cart = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 160,
            width: screenWidth * 0.25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: Acolors.primary,
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 10, right: 20),
                  height: 120,
                  width: screenWidth - 80, // 75% of screen width
                  //  width: 300,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      topLeft: Radius.circular(35),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Acolors.primary)
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          //  AppLocalizations.of(context)!.a5product,
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // SizedBox(height: 3),
                      Text(
                        '\Rs ${product.price}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 30,
                        width: screenWidth * 0.45, // 45% of screen width
                        //   width: 170,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Acolors.primary,
                          ),
                          onPressed: _isAddingToCart
                              ? null
                              : () async {
                                  setState(() {
                                    _isAddingToCart = true;
                                  });

                                  await Provider.of<CartProvider>(context,
                                          listen: false)
                                      .addToCart(
                                    product.id.toString(),
                                    product.name,
                                    context,
                                  );

                                  setState(() {
                                    _isAddingToCart = false;
                                  });
                                },
                          child: _isAddingToCart
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Acolors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.addtocart,
                                      style: TextStyle(color: Acolors.white),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    InkWell(
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
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Acolors.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor:
                            const Color.fromARGB(255, 245, 114, 74),
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
          ),
        ],
      ),
    );
  }
}

class A5Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.a5Subheadline,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5.0),
          Text(
            AppLocalizations.of(context)!.a5Description,
            style: TextStyle(
              fontSize: 16.0,
              color: const Color.fromARGB(255, 90, 90, 90),
            ),
          ),
          SizedBox(height: 16.0),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit1),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit2),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit3),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit4),
        ],
      ),
    );
  }
}

Widget _buildBenefitRow(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: <Widget>[
        Icon(Icons.check_box, color: Colors.green),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

// old one with single product
/* import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDescriptionScreen extends StatefulWidget {
  @override
  _ProductDescriptionScreenState createState() => _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    if (productNotifier.products.isEmpty && !productNotifier.isLoading) {
      productNotifier.fetchProducts();
    }
  }

  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);

    if (productNotifier.isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        itemCount: 6, // Show shimmer placeholders
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 275,
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerEffect(width: double.infinity, height: 120),
                  SizedBox(height: 10),
                  ShimmerEffect(width: 100, height: 20),
                  SizedBox(height: 5),
                  ShimmerEffect(width: 60, height: 20),
                  SizedBox(height: 10),
                  ShimmerEffect(width: double.infinity, height: 40),
                ],
              ),
            ),
          );
        },
      );
    }

// // Use safe access
//     final product = productNotifier.products.isNotEmpty
//         ? productNotifier.products.first
//         : null;

//     if (product == null) {
//       return GridView.builder(
//         shrinkWrap: true,
//         itemCount: 6, // Show shimmer placeholders
//         physics: const NeverScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(15),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//           mainAxisExtent: 275,
//         ),
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ShimmerEffect(width: double.infinity, height: 120),
//                   SizedBox(height: 10),
//                   ShimmerEffect(width: 100, height: 20),
//                   SizedBox(height: 5),
//                   ShimmerEffect(width: 60, height: 20),
//                   SizedBox(height: 10),
//                   ShimmerEffect(width: double.infinity, height: 40),
//                 ],
//               ),
//             ),
//           );
//         },
//       );

//       //  Center(child: Text("No valid product found"));
//     }
    // Assuming this returns a list
    final productList = productNotifier.products;

    // Show only product with id 14
    final product = productList.firstWhere((p) => p.id == 14);
    if (product == null) {
      return Center(child: Text("Product not found."));
    }

    return _buildProductDetailsPage(context, product);
  }

  Widget _buildProductDetailsPage(BuildContext context, Product product) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    Size screenSize = MediaQuery.of(context).size;
    return productNotifier.isLoading
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: 6, // Show shimmer placeholders
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 275,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerEffect(width: double.infinity, height: 120),
                      SizedBox(height: 10),
                      ShimmerEffect(width: 100, height: 20),
                      SizedBox(height: 5),
                      ShimmerEffect(width: 60, height: 20),
                      SizedBox(height: 10),
                      ShimmerEffect(width: double.infinity, height: 40),
                    ],
                  ),
                ),
              );
            },
          )
        : ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildProductImagesWidgets(product),
                    _buildProductTitleWidget(product),
                    SizedBox(height: 12.0),
                    _buildPriceWidgets(product),
                    SizedBox(height: 12.0),
                    _buildDivider(screenSize),
                    SizedBox(height: 12.0),
                    // _buildSizeChartWidgets(),
                    // SizedBox(height: 12.0),
                    //    _buildDetailsAndMaterialWidgets(),
                    //   SizedBox(height: 12.0),

                    //    _buildStyleNoteHeader(),
                    A5Description(),
                    //  SizedBox(height: 6.0),
                    // _buildDivider(screenSize),
                    // SizedBox(height: 4.0),
                    //  _buildStyleNoteData(product),
                    SizedBox(height: 20.0),

                    //  _buildMoreInfoHeader(),
                    //   SizedBox(height: 6.0),
                    // _buildDivider(screenSize),
                    // SizedBox(height: 4.0),
                    //  _buildMoreInfoData(product),
                    //   SizedBox(height: 24.0),
                  ],
                ),
              ),
              bottomCartSection(product),
            ],
          );
  }

  Widget _buildProductImagesWidgets(Product product) {
    List<String> imageList = [
      'assets/images/A5_front.webp',
      'assets/images/A5_pack_front.png',
      'assets/images/A5_pack_back.png',
      'assets/images/PH02.webp',
      'assets/images/A5_aboutus.webp',
      // Add more images if available
    ];
    PageController _pageController = PageController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 400.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  imageList[index],
                  //   fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const ShimmerEffect(width: 250, height: 250);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Dots Indicator for Images
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageList.length, (index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double selected = (_pageController.page ?? 0).roundToDouble();
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: selected == index ? 12.0 : 8.0,
                    height: selected == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected == index ? Colors.grey : Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitleWidget(Product product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            // 'A5 – Ayurveda’s Ultimate Answer to Diabetes',
            //  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            AppLocalizations.of(context)!.a5product,
            //  product.name,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceWidgets(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: <Widget>[
          Text("\Rs ${product.price}",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          SizedBox(width: 8.0),
          Text("11200",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough)),
          SizedBox(width: 8.0),
          Text("50% off", style: TextStyle(fontSize: 14.0, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildDivider(Size screenSize) {
    return Container(
      color: Colors.grey[600],
      width: screenSize.width,
      height: 0.25,
    );
  }

  Widget _buildStyleNoteHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          // 'Description',
          AppLocalizations.of(context)!.description,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _buildStyleNoteData(Product product) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        product.description,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildMoreInfoHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text("MORE INFO", style: TextStyle(color: Colors.grey[800])),
    );
  }

  Widget _buildMoreInfoData(Product product) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        "Product Code: ${product.id}\nTax info: Applicable GST will be charged at the time of checkout",
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget bottomCartSection(Product product) {
    final cart = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 180,
                //  width: screenWidth * 0.23, // 25% of screen width
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
                      //  width: screenWidth * 0.70, // 75% of screen width
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
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              AppLocalizations.of(context)!.a5product,
                              //   product.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          // SizedBox(height: 3),
                          Text(
                            '\Rs ${product.price}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 3),
                          SizedBox(
                            height: 30,
                            //  width: screenWidth * 0.4, // 45% of screen width
                            width: 170,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Acolors.primary,
                              ),
                              onPressed: _isAddingToCart
                                  ? null
                                  : () async {
                                      setState(() {
                                        _isAddingToCart = true;
                                      });

                                      await Provider.of<CartProvider>(context,
                                              listen: false)
                                          .addToCart(
                                        product.id.toString(),
                                        product.name,
                                        context,
                                      );

                                      setState(() {
                                        _isAddingToCart = false;
                                      });
                                    },
                              child: _isAddingToCart
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart,
                                          color: Acolors.white,
                                          size: 20,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .addtocart,
                                          style:
                                              TextStyle(color: Acolors.white),
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
                          ],
                        ),
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
      ),
    );
  }
}

//
//
//
//
//

/*


class A5Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   'A5 – Ayurveda’s Ultimate Answer to Diabetes',
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          // ),
          Text(
            '100% Ayurvedic. 0% Chemicals. 3 Months to Freedom.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5.0),
          Text(
            'A5 is not just a medicine — it\'s a breakthrough Ayurvedic formulation designed to eliminate Diabetes from the root. Backed by over 25 rare and potent herbs from India and Malaysia, A5 works with your body, not against it — restoring balance, revitalizing energy, and reversing diabetes from within.',
            style: TextStyle(
                fontSize: 16.0, color: const Color.fromARGB(255, 90, 90, 90)),
          ),
          SizedBox(height: 16.0),
          // Text(
          //   'Price -',
          //   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 16.0),
          _buildBenefitRow('3-Month Diabetes Reversal Guarantee'),
          _buildBenefitRow('25+ Herbal Ingredients (India + Malaysia)'),
          _buildBenefitRow(
              'Clinically Inspired | Expert-Crafted | 100% Natural'),
          _buildBenefitRow('No Side Effects. No Chemicals. No Dependency.'),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.check_box, color: Colors.green),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


*/

class A5Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.a5Subheadline,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5.0),
          Text(
            AppLocalizations.of(context)!.a5Description,
            style: TextStyle(
              fontSize: 16.0,
              color: const Color.fromARGB(255, 90, 90, 90),
            ),
          ),
          SizedBox(height: 16.0),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit1),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit2),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit3),
          _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit4),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.check_box, color: Colors.green),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
*/
