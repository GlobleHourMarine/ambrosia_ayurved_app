import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/tab_button.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/category_list.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/more_view.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/order_history/order_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = HomeScreen();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    // final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Stack(
        children: [
          PageStorage(bucket: storageBucket, child: selectPageView),
        ],
      ),
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selctTab != 2) {
              selctTab = 2;
              selectPageView = HomeScreen();
            }
            if (mounted) {
              setState(() {});
            }
          },
          shape: const CircleBorder(),
          backgroundColor:
              selctTab == 2 ? Acolors.primary : Acolors.placeholder,
          child: Image.asset(
            "assets/images/tab_home.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Acolors.white,
        shadowColor: Acolors.primary,
        elevation: 3,
        notchMargin: 10,
        height: 64,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  title: "Orders",
                  icon: "assets/images/tab_profile.png",
                  onTap: () {
                    if (selctTab != 0) {
                      selctTab = 0;
                      selectPageView = OrderHistoryScreenN();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selctTab == 0),
              TabButton(
                  title: "Category",
                  icon: "assets/images/tab_menu.png",
                  onTap: () {
                    if (selctTab != 1) {
                      selctTab = 1;
                      selectPageView = CategoryList();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selctTab == 1),
              const SizedBox(width: 40),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  TabButton(
                      title: "Cart",
                      icon: "assets/images/tab_offer.png",
                      onTap: () {
                        if (selctTab != 3) {
                          selctTab = 3;
                          selectPageView = const CartPage();
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      isSelected: selctTab == 3),
                  if (cart.totalUniqueItems > 0)
                    Positioned(
                      right: -7,
                      top: -9,
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
              TabButton(
                  title: "More",
                  icon: "assets/images/tab_more.png",
                  onTap: () {
                    if (selctTab != 4) {
                      selctTab = 4;
                      selectPageView = const MoreView();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selctTab == 4),
            ],
          ),
        ),
      ),
    );
  }
}
