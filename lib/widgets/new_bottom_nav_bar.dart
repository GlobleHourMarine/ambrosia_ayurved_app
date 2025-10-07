// import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
// import 'package:ambrosia_ayurved/ambrosia/common_widgets/tab_button.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/category_list.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/more_view.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/order_history/order_history_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MainTabView extends StatefulWidget {
//   const MainTabView({super.key});

//   @override
//   State<MainTabView> createState() => _MainTabViewState();
// }

// class _MainTabViewState extends State<MainTabView> {
//   int selctTab = 2;
//   PageStorageBucket storageBucket = PageStorageBucket();
//   Widget selectPageView = HomeScreen();

//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//     // final user = Provider.of<UserProvider>(context).user;
//     return PopScope(
//       canPop: selctTab == 2, // Only allow system back if on Home
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           if (selctTab != 2) {
//             setState(() {
//               selctTab = 2;
//               selectPageView = HomeScreen();
//             });
//           }
//         }
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             PageStorage(bucket: storageBucket, child: selectPageView),
//           ],
//         ),
//         backgroundColor: const Color(0xfff5f5f5),
//         floatingActionButtonLocation:
//             FloatingActionButtonLocation.miniCenterDocked,
//         floatingActionButton: SizedBox(
//           width: 60,
//           height: 60,
//           child: FloatingActionButton(
//             onPressed: () {
//               if (selctTab != 2) {
//                 selctTab = 2;
//                 selectPageView = HomeScreen();
//               }
//               if (mounted) {
//                 setState(() {});
//               }
//             },
//             shape: const CircleBorder(),
//             backgroundColor:
//                 selctTab == 2 ? Acolors.primary : Acolors.placeholder,
//             child: Image.asset(
//               "assets/images/tab_home.png",
//               width: 30,
//               height: 30,
//             ),
//           ),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           surfaceTintColor: Acolors.white,
//           shadowColor: Acolors.primary,
//           elevation: 3,
//           notchMargin: 10,
//           height: 64,
//           shape: const CircularNotchedRectangle(),
//           child: SafeArea(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 TabButton(
//                     title: "Orders",
//                     icon: "assets/images/tab_profile.png",
//                     onTap: () {
//                       if (selctTab != 0) {
//                         selctTab = 0;
//                         selectPageView = OrderHistoryScreenN();
//                       }
//                       if (mounted) {
//                         setState(() {});
//                       }
//                     },
//                     isSelected: selctTab == 0),
//                 TabButton(
//                     title: "Category",
//                     icon: "assets/images/tab_menu.png",
//                     onTap: () {
//                       if (selctTab != 1) {
//                         selctTab = 1;
//                         selectPageView = CategoryList();
//                       }
//                       if (mounted) {
//                         setState(() {});
//                       }
//                     },
//                     isSelected: selctTab == 1),
//                 const SizedBox(width: 40),
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     TabButton(
//                         title: "Cart",
//                         icon: "assets/images/tab_offer.png",
//                         onTap: () {
//                           if (selctTab != 3) {
//                             selctTab = 3;
//                             selectPageView = const CartPage();
//                           }
//                           if (mounted) {
//                             setState(() {});
//                           }
//                         },
//                         isSelected: selctTab == 3),
//                     if (cart.totalUniqueItems > 0)
//                       Positioned(
//                         right: -7,
//                         top: -9,
//                         child: CircleAvatar(
//                           radius: 8,
//                           backgroundColor:
//                               const Color.fromARGB(255, 245, 114, 74),
//                           child: Text(
//                             '${cart.totalUniqueItems}',
//                             style: TextStyle(fontSize: 12, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 TabButton(
//                     title: "More",
//                     icon: "assets/images/tab_more.png",
//                     onTap: () {
//                       if (selctTab != 4) {
//                         selctTab = 4;
//                         selectPageView = const MoreView();
//                       }
//                       if (mounted) {
//                         setState(() {});
//                       }
//                     },
//                     isSelected: selctTab == 4),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/tab_button.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/category_list/category_list.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/more_view.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/order_history/order_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    // If not on home tab, navigate to home
    if (selctTab != 2) {
      setState(() {
        selctTab = 2;
        selectPageView = HomeScreen();
      });
      return false;
    }

    // If on home tab, show exit confirmation
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      // Show custom exit dialog
      _showExitConfirmationDialog();
      return false;
    }

    return true;
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildExitDialog();
      },
    );
  }

  Widget _buildExitDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Acolors.primary.withOpacity(0.9),
                    Acolors.primary.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Acolors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Are you sure?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Do you really want to exit Ambrosia Ayurved?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[100]!,
                          Colors.grey[200]!,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.grey[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Acolors.primary,
                          Acolors.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Acolors.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.of(context).pop(true);
                          Future.delayed(const Duration(milliseconds: 300), () {
                            SystemNavigator.pop();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Exit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
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
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
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
      ),
    );
  }
}
