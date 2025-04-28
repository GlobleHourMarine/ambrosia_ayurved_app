// with api and shimmer effect

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

class ProductList extends StatefulWidget {
  ProductList({super.key});

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

  @override
  Widget build(BuildContext context) {
    final productNotifier = Provider.of<ProductNotifier>(context);

    if (productNotifier.products.isEmpty && !productNotifier.isLoading) {
      productNotifier.fetchProducts();
    }

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
        : GridView.builder(
            shrinkWrap: true,
            itemCount:
                //1,
                productNotifier.products.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.68,
              //  mainAxisExtent: 275,
            ),
            itemBuilder: (context, index) {
              final product = productNotifier.products[index];

              // convert the image into link
              String imageUrlll = product.imageUrl.startsWith("http")
                  ? product.imageUrl
                  : "https://ambrosiaayurved.in/${product.imageUrl}";
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          product: product,
                          //   imageUrll: imageUrlll,
                        ),
                      ));
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                height: 350,
                                width: double.infinity,
                                child: Image.network(
                                  imageUrlll,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const ShimmerEffect(
                                        width: double.infinity, height: 120);
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const ShimmerEffect(
                                        width: double.infinity, height: 120);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  '\Rs ${product.price}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${product.description}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Acolors.primary),
                                  onPressed: () async {
                                    // final cartProvider =
                                    //     Provider.of<CartProvider>(context,
                                    //         listen: false);
                                    // final userProvider =
                                    //     Provider.of<UserProvider>(context,
                                    //         listen: false);

                                    // // Call the addToCart method from CartProvider
                                    // await cartProvider.addToCart(
                                    //     product.id.toString(), context);

                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .addToCart(
                                      product.id.toString(),
                                      product.name,
                                      context,
                                    );
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
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(color: Colors.white),
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
  }
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