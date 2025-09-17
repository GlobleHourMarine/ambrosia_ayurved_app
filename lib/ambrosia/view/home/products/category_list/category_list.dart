import 'package:ambrosia_ayurved/ambrosia/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/rounded_textfield.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/filter_category/filter_category.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/supplement/supplement_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/cosmetics/cosmetics.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/Hair_care/hari_care.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/skincare/skincare_screen.dart';

import 'package:provider/provider.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List category = [
    {
      "name": "SkinCare",
      "image_asset": "assets/images/category_skin_care.jpg",
      "items_count": "0",
    },
    {
      "name": "Supplements",
      "image_asset": "assets/images/category_supplements.png",
      "items_count": "1",
    },
    {
      "name": "Cosmetics",
      "image_asset": "assets/images/category_makeup.png",
      "items_count": "0",
    },
    {
      "name": "Hair Care",
      "image_asset": "assets/images/category_hair_care.jpg",
      "items_count": "0",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    var media = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 130),
              width: media.width * 0.27,
              height: 492,
              decoration: const BoxDecoration(
                color: Acolors.primary,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomRight: Radius.circular(40)),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Categories',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 24),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CartPage(),
                                    ));
                              },
                              icon: Stack(
                                children: [
                                  const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 35,
                                    color: Acolors.primary,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 7,
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '${cart.totalUniqueItems}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // const RoundedTextfield(
                      //   hinttext: 'Search',
                      //   suffixIcon: Icon(
                      //     Icons.search,
                      //     size: 30,
                      //     color: Acolors.primary,
                      //   ),
                      // ),
                      //  SizedBox(height: 50),
                      const SizedBox(height: 30),
                      ListView.builder(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          var mObj = category[index] as Map? ?? {};

                          return GestureDetector(
                            onTap: () {
                              String categoryName = category[index]['name'];

                              Widget nextScreen;

                              switch (categoryName) {
                                case "SkinCare":
                                  nextScreen = SkincareScreen();
                                  break;
                                case "Supplements":
                                  nextScreen = SupplementScreen();
                                  break;
                                case "Cosmetics":
                                  nextScreen = CosmeticsScreen();
                                  break;
                                case "Hair Care":
                                  nextScreen = ClothesScreen();
                                  break;
                                default:
                                  nextScreen = Container();
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => nextScreen),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CategoryProductScreen(
                              //       categoryName: categoryName,
                              //     ),
                              //   ),
                              // );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => MenuItemsView(
                              //       mObj: mObj,
                              //     ),
                              //   ),
                              // );
                            },
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 20, top: 8, bottom: 8),
                                  width: media.width - 100,
                                  height: 90,
                                  decoration: const BoxDecoration(
                                      color: Acolors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(35),
                                          bottomLeft: Radius.circular(35),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 7,
                                          color: Acolors.primary,
                                          offset: Offset(0, 5),
                                        )
                                      ]),
                                ),
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        category[index]['image_asset'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.fill,

                                        // loadingBuilder:
                                        //     (context, child, progress) {
                                        //   if (progress == null) return child;
                                        //   return const ShimmerEffect(
                                        //       width: 50, height: 50);
                                        // },
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const ShimmerEffect(
                                              width: 80, height: 80);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            category[index]['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24),
                                          ),
                                          Text(
                                            '${category[index]['items_count']} items',
                                            style: const TextStyle(
                                                color: Acolors.secondaryText,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Acolors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 7,
                                            color: Acolors.primary,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Acolors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ]),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: const BottomNav(
        //   selectedIndex: 1, // Category screen selected index
        // ),
      ),
    );
  }
}
