// import 'package:flutter/material.dart';
// import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
// import 'package:provider/provider.dart';

// class CategoryProductScreen extends StatelessWidget {
//   final String categoryName;
//   const CategoryProductScreen({super.key, required this.categoryName});

//   @override
//   Widget build(BuildContext context) {
//     // Fetch the ProductNotifier to get the products
//     var productNotifier = Provider.of<ProductNotifier>(context);

//     // If products are not loaded, fetch them
//     if (productNotifier.products.isEmpty && !productNotifier.isLoading) {
//       productNotifier.fetchProducts();
//     }

//     // Filter products by category
//     List<Product> filteredProducts = productNotifier.products
//         .where((product) => product.category == categoryName)
//         .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(categoryName),
//       ),
//       body: productNotifier.isLoading
//           ? Center(child: CircularProgressIndicator())
//           : filteredProducts.isEmpty
//               ? Center(child: Text("No products found in this category"))
//               : ListView.builder(
//                   itemCount: filteredProducts.length,
//                   itemBuilder: (context, index) {
//                     var product = filteredProducts[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ProductDetail(product: product),
//                               ));
//                         },
//                         child: Stack(
//                           alignment: Alignment.bottomLeft,
//                           children: [
//                             Image.network(
//                               product.imageUrl,
//                               // width: double.maxFinite,
//                               //   height: 200,
//                               //   fit: BoxFit.cover,
//                             ),
//                             Container(
//                               width: double.maxFinite,
//                               height: 200,
//                               decoration: const BoxDecoration(
//                                   gradient: LinearGradient(
//                                       colors: [
//                                     Colors.transparent,
//                                     Colors.transparent,
//                                     Colors.black
//                                   ],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter)),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         product.name,
//                                         //  mObj["name"],
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             color: Acolors.white,
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                       const SizedBox(
//                                         height: 4,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Image.asset(
//                                             "assets/img/rate.png",
//                                             width: 10,
//                                             height: 10,
//                                             fit: BoxFit.cover,
//                                           ),
//                                           const SizedBox(
//                                             width: 4,
//                                           ),
//                                           Text(
//                                             "Price: \$${product.price}",
//                                             // mObj["rate"],
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Acolors.primary,
//                                                 fontSize: 11),
//                                           ),
//                                           const SizedBox(
//                                             width: 8,
//                                           ),
//                                           Text(
//                                             'product summ',
//                                             // mObj["type"],
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Acolors.white,
//                                                 fontSize: 11),
//                                           ),
//                                           Text(
//                                             " . ",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Acolors.primary,
//                                                 fontSize: 11),
//                                           ),
//                                           Text(
//                                             'product detail',
//                                             // mObj["food_type"],
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                                 color: Acolors.white,
//                                                 fontSize: 12),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 22,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                     /*
//                      ListTile(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   ProductDetail(product: product),
//                             ));
//                       },
//                       leading: Image.network(product.imageUrl),
//                       title: Text(product.name),
//                       subtitle: Text("Price: \$${product.price}"),
//                     );
//                     */
//                   },
//                 ),
//     );
//   }
// }




// // import 'package:flutter/material.dart';
// // import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
// // import 'package:ambrosia_ayurved/cosmetics/common_widgets/rounded_textfield.dart';
// // import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';


// // class MenuItemsView extends StatefulWidget {
// //   final Map mObj;
// //   const MenuItemsView({super.key, required this.mObj});

// //   @override
// //   State<MenuItemsView> createState() => _MenuItemsViewState();
// // }

// // class _MenuItemsViewState extends State<MenuItemsView> {
// //   TextEditingController txtSearch = TextEditingController();

// //   List menuItemsArr = [
// //     {
// //       "image": "assets/img/dess_1.png",
// //       "name": "French Apple Pie",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Minute by tuk tuk",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_2.png",
// //       "name": "Dark Chocolate Cake",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Cakes by Tella",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_3.png",
// //       "name": "Street Shake",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Café Racer",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_4.png",
// //       "name": "Fudgy Chewy Brownies",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Minute by tuk tuk",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_1.png",
// //       "name": "French Apple Pie",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Minute by tuk tuk",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_2.png",
// //       "name": "Dark Chocolate Cake",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Cakes by Tella",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_3.png",
// //       "name": "Street Shake",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Café Racer",
// //       "food_type": "Desserts"
// //     },
// //     {
// //       "image": "assets/img/dess_4.png",
// //       "name": "Fudgy Chewy Brownies",
// //       "rate": "4.9",
// //       "rating": "124",
// //       "type": "Minute by tuk tuk",
// //       "food_type": "Desserts"
// //     },
// //   ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(vertical: 20),
// //           child: Column(
// //             children: [
// //               const SizedBox(
// //                 height: 46,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 20),
// //                 child: Row(
// //                   children: [
// //                     IconButton(
// //                       onPressed: () {
// //                         Navigator.pop(context);
// //                       },
// //                       icon: Image.asset("assets/img/btn_back.png",
// //                           width: 20, height: 20),
// //                     ),
// //                     const SizedBox(
// //                       width: 8,
// //                     ),
// //                     Expanded(
// //                       child: Text(
// //                         widget.mObj["name"].toString(),
// //                         style: TextStyle(
// //                             color: Acolors.primaryText,
// //                             fontSize: 20,
// //                             fontWeight: FontWeight.w800),
// //                       ),
// //                     ),
// //                     IconButton(
// //                       onPressed: () {
// //                         // Navigator.push(
// //                         //     context,
// //                         //     MaterialPageRoute(
// //                         //         builder: (context) => const MyOrderView()));
// //                       },
// //                       icon: Image.asset(
// //                         "assets/img/shopping_cart.png",
// //                         width: 25,
// //                         height: 25,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               const SizedBox(
// //                 height: 20,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(horizontal: 20),
// //                 child:   RoundedTextfield(
// //                   hinttext: "Search",
                  
// //                   controller: txtSearch,
// //                   left: Container(
// //                     alignment: Alignment.center,
// //                     width: 30,
// //                     child: Image.asset(
// //                       "assets/img/search.png",
// //                       width: 20,
// //                       height: 20,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(
// //                 height: 15,
// //               ),
// //               ListView.builder(
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 shrinkWrap: true,
// //                 padding: EdgeInsets.zero,
// //                 itemCount: menuItemsArr.length,
// //                 itemBuilder: ((context, index) {
// //                   var mObj = menuItemsArr[index] as Map? ?? {};
// //                   return MenuItemRow(
// //                     mObj: mObj,
// //                     onTap: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                             builder: (context) => ProductDetail(product: product,)),
// //                       );
// //                     },
// //                   );
// //                 }),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }