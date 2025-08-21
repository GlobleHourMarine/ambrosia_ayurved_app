// with api and shimmer effect

import 'package:ambrosia_ayurved/cosmetics/common_widgets/highlighted_text.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail_new_page.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
//import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_new_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/service.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductList extends StatefulWidget {
  final String searchQuery;
  final VoidCallback? onProductTapped;
  ProductList({super.key, this.searchQuery = '', this.onProductTapped});

  @override
  State<ProductList> createState() => _ProductListState();
}


class _ProductListState extends State<ProductList> {
  @override
  void initState() {
    super.initState();
    final productNotifier =
        Provider.of<ProductNotifier>(context, listen: false);
    if (productNotifier.products.isEmpty && !productNotifier.isLoading) {
      productNotifier.fetchProducts();
    }
  }

  Set<String> _loadingProductIds = {};
  List<dynamic> _getFilteredProducts(List<dynamic> products) {
    if (widget.searchQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      final productName = product.name.toLowerCase();
      final productDescription = product.description.toLowerCase();
      final searchLower = widget.searchQuery.toLowerCase();

      return productName.contains(searchLower) ||
          productDescription.contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);

    if (productNotifier.products.isEmpty && !productNotifier.isLoading) {
      productNotifier.fetchProducts();
    }
    // Get filtered products
    final filteredProducts = _getFilteredProducts(productNotifier.products);

    return productNotifier.isLoading
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: 6, // Show shimmer placeholders
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
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
        : filteredProducts.isEmpty && widget.searchQuery.isNotEmpty
            ? _buildNoResultsWidget()
            : LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate responsive dimensions
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;

                  // Determine cross axis count based on screen width
                  int crossAxisCount = 2;
                  if (screenWidth > 600) {
                    crossAxisCount = 3;
                  } else if (screenWidth > 900) {
                    crossAxisCount = 4;
                  }

                  // Calculate card width and height dynamically
                  final cardWidth =
                      (screenWidth - 32) / crossAxisCount; // 32 for padding
                  final cardHeight =
                      screenHeight * 0.50; // 55% of screen height

                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: filteredProducts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 8,
                      childAspectRatio: cardWidth / cardHeight,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          // Clear search when navigating to product detail
                          if (widget.onProductTapped != null) {
                            widget.onProductTapped!();
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailNewPage(product: product),
                              ));
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image section - responsive height
                                Expanded(
                                  flex: 35,
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        product.imageUrl.isNotEmpty
                                            ? 'https://ambrosiaayurved.in/${product.imageUrl[0]}'
                                            : 'https://via.placeholder.com/150',
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return const ShimmerEffect(
                                              width: double.infinity,
                                              height: double.infinity);
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const ShimmerEffect(
                                              width: double.infinity,
                                              height: double.infinity);
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                // Product name
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 6),
                                  child: HighlightedText(
                                    text: product.name,
                                    searchQuery: widget.searchQuery,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    defaultStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: screenWidth > 600 ? 16 : 14),
                                    highlightStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth > 600 ? 16 : 14,
                                      backgroundColor: Colors.lightGreen,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // Price and rating row
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '\Rs ${product.price}',
                                          style: TextStyle(
                                            fontSize:
                                                screenWidth > 600 ? 14 : 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),

                                // Description
                                Expanded(
                                  flex: 10,
                                  child: HighlightedText(
                                    text: '${product.description}',
                                    searchQuery: widget.searchQuery,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    defaultStyle: TextStyle(
                                      fontSize: screenWidth > 600 ? 13 : 12,
                                      color: Colors.black87,
                                    ),
                                    highlightStyle: TextStyle(
                                      fontSize: screenWidth > 600 ? 12 : 11,
                                      backgroundColor: Colors.lightGreen,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                // Add to cart button - always at bottom
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 4),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Acolors.primary,
                                        side: BorderSide(
                                            color: Acolors.primary, width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: screenWidth > 600 ? 8 : 4,
                                        ),
                                      ),
                                      onPressed: _loadingProductIds
                                              .contains(product.id.toString())
                                          ? null
                                          : () async {
                                              setState(() {
                                                _loadingProductIds
                                                    .add(product.id.toString());
                                              });

                                              await Provider.of<CartProvider>(
                                                      context,
                                                      listen: false)
                                                  .addToCart(
                                                product.id.toString(),
                                                product.name,
                                                context,
                                              );
                                              setState(() {
                                                _loadingProductIds.remove(
                                                    product.id.toString());
                                              });
                                            },
                                      child: _loadingProductIds
                                              .contains(product.id.toString())
                                          ? SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                color: Acolors.primary,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .addtocart,
                                                style: TextStyle(
                                                  color: Acolors.primary,
                                                  fontSize: screenWidth > 600
                                                      ? 12
                                                      : 10,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );

//
//
//
// old one without reponsiveness
    /*

        : filteredProducts.isEmpty && widget.searchQuery.isNotEmpty
            ? _buildNoResultsWidget()
            : GridView.builder(
                shrinkWrap: true,
                itemCount: filteredProducts.length,
                //1,
                // productNotifier.products.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 0,
                  //childAspectRatio: 0.53,
                  mainAxisExtent: 375,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  // final product = productNotifier.products[index];

                  return GestureDetector(
                    onTap: () {
                      // Clear search when navigating to product detail
                      if (widget.onProductTapped != null) {
                        widget.onProductTapped!();
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailNewPage(product: product),
                            //  ProductDetail(
                            //   product: product,

                            // ),
                          ));
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: SizedBox(
                                    height: 180,
                                    width: double.infinity,
                                    child: Image.network(
                                      product.imageUrl.isNotEmpty
                                          ? 'https://ambrosiaayurved.in/${product.imageUrl[0]}'
                                          : 'https://via.placeholder.com/150',
                                      fit: BoxFit.fitHeight,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return const ShimmerEffect(
                                            width: double.infinity,
                                            height: 120);
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const ShimmerEffect(
                                            width: double.infinity,
                                            height: 120);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                HighlightedText(
                                  text: product.name,
                                  searchQuery: widget.searchQuery,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  defaultStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 17),
                                  highlightStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    backgroundColor: Colors.lightGreen,
                                    color: Colors.black,
                                  ),
                                ),
                                // Text(
                                //   product.name,
                                //   maxLines: 1,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 17),
                                // ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '\Rs ${product.price}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                HighlightedText(
                                  text: '${product.description}',
                                  searchQuery: widget.searchQuery,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  defaultStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                  highlightStyle: const TextStyle(
                                    fontSize: 13,
                                    backgroundColor: Colors.lightGreen,
                                    color: Colors.black,
                                  ),
                                ),
                                // Text(
                                //   '${product.description}',
                                //   maxLines: 3,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: const TextStyle(
                                //     fontSize: 13,
                                //   ),
                                // ),
                                SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        // backgroundColor: Colors.blue[600],
                                        foregroundColor: Acolors.primary,
                                        side: BorderSide(
                                            color: Acolors.primary, width: 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      onPressed: _loadingProductIds
                                              .contains(product.id.toString())
                                          ? null
                                          : () async {
                                              setState(() {
                                                _loadingProductIds
                                                    .add(product.id.toString());
                                              });

                                              // final cartProvider =
                                              //     Provider.of<CartProvider>(context,
                                              //         listen: false);
                                              // final userProvider =
                                              //     Provider.of<UserProvider>(context,
                                              //         listen: false);

                                              // // Call the addToCart method from CartProvider
                                              // await cartProvider.addToCart(
                                              //     product.id.toString(), context);

                                              await Provider.of<CartProvider>(
                                                      context,
                                                      listen: false)
                                                  .addToCart(
                                                product.id.toString(),
                                                product.name,
                                                context,
                                              );
                                              setState(() {
                                                _loadingProductIds.remove(
                                                    product.id.toString());
                                              });
                                              //   Show SnackBar message
                                              // SnackbarMessage.showSnackbar(
                                              //   context,
                                              //   '${product.name} added to cart',
                                              //   //     actionLabel: 'Undo', action: () {

                                              //   //   // Provider.of<CartProvider>(context,
                                              //   //   //         listen: false)
                                              //   //   //     .removeFromCart(
                                              //   //   //         product.id.toString());
                                              //   // }
                                              // );
                                            },
                                      child: _loadingProductIds
                                              .contains(product.id.toString())
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              AppLocalizations.of(context)!
                                                  .addtocart,
                                              style: TextStyle(
                                                  color: Acolors.primary),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // const Positioned(
                            //   top: 5,
                            //   right: 5,
                            //   child: Icon(
                            //     Icons.favorite_border,
                            //     size: 30,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

              */
  }
}

Widget _buildNoResultsWidget() {
  return Container(
    height: 200,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 64,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),
        Text(
          'No products found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Try searching with different keywords',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    ),
  );
}

/*
// without api
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    return GridView.builder(
      shrinkWrap: true,
      itemCount: productNotifier.products.isEmpty
          ? productNotifier.products.length
          : productNotifier.products.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 275,
      ),
      itemBuilder: (context, index) {
        final product = productNotifier.products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetail(product: product),
                ));
          },
          child: Container(
            height: 500,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          product.imageUrl,
                          height: 120,
                          //  width: 150,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          Text(
                            '\Rs ${product.price}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Acolors.primary),
                            onPressed: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .addToCart(
                                product.id.toString(),
                                //   context
                              );
                              // Show SnackBar message
                              SnackbarMessage.showSnackbar(
                                  context, '${product.name} added to cart',
                                  actionLabel: 'Undo', action: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .removeFromCart(product.id.toString());
                              });
                            },
                            child: const Text(
                              'Add to Cart',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        Icons.favorite_border,
                        size: 30,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
      

// with api


/*
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';

class ProductList extends StatelessWidget {
  ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);
    if (productNotifier.products.isEmpty && !productNotifier.isLoading) {
      productNotifier.fetchProducts();
    }
    return productNotifier.isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            shrinkWrap: true,
            itemCount: productNotifier.products.isEmpty
                ? productNotifier.products.length
                : productNotifier.products.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              mainAxisExtent: 275,
            ),
            itemBuilder: (context, index) {
              final product = productNotifier.products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(product: product),
                      ));
                },
                child: Container(
                  height: 500,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                product.imageUrl,
                                height: 120,
                                //  width: 150,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(children: [
                                Text(
                                  '\Rs ${product.price}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ]),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Acolors.primary),
                                  onPressed: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .addToCart(product.id, context);
                                    // Show SnackBar message
                                    SnackbarMessage.showSnackbar(context,
                                        '${product.name} added to cart',
                                        actionLabel: 'Undo', action: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeFromCart(product.id);
                                    });
                                  },
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Positioned(
                            top: 5,
                            right: 5,
                            child: Icon(
                              Icons.favorite_border,
                              size: 30,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}

*/