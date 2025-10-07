// import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
// import 'package:ambrosia_ayurved/ambrosia/common/contact_info.dart';
// import 'package:ambrosia_ayurved/ambrosia/common/internet/internet.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/login&register/user_register.dart';
// import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'dart:async';
// import 'package:ambrosia_ayurved/ambrosia/view/home/carousel/carousel_slider.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/happy_clients/happy_clients.dart';
// import 'package:ambrosia_ayurved/ambrosia/common_widgets/home_textfield/home_textfield.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_list.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/why_us/why_us_2.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/why_us/why_us_screen.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/why_us/why_us_section.dart';
// import 'package:ambrosia_ayurved/widgets/appbar.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/footer/footer_home.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener =
//       ItemPositionsListener.create();
//   late TabController _tabController; // Use late initialization
//   String _searchQuery = '';

//   final List<int> sectionIndices = [
//     0,
//     2,
//     3,
//     4,
//     5
//   ]; // Positions of each section in the list

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the TabController in initState
//     _tabController = TabController(length: 5, vsync: this);

//     itemPositionsListener.itemPositions.addListener(() {
//       final positions = itemPositionsListener.itemPositions.value;
//       if (positions.isNotEmpty) {
//         // Find the first visible item
//         final firstVisibleIndex = positions.first.index;

//         // Determine which section we're in
//         for (int i = 0; i < sectionIndices.length; i++) {
//           if (i == sectionIndices.length - 1 ||
//               (firstVisibleIndex >= sectionIndices[i] &&
//                   firstVisibleIndex < sectionIndices[i + 1])) {
//             if (_tabController.index != i) {
//               setState(() {
//                 _tabController.animateTo(i);
//               });
//             }
//             break;
//           }
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   // Add this method to launch WhatsApp
//   Future<void> _launchWhatsApp() async {
//     const phoneNumber =
//         '+918000057233'; // Replace with your actual phone number
//     const message = 'Hello, I have a question about Ambrosia Ayurved products';
//     final url =
//         'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//     Size size = MediaQuery.of(context).size;
//     final cart = Provider.of<CartProvider>(context);
//     final user = Provider.of<UserProvider>(context).user;
//     return Consumer<LanguageProvider>(
//       builder: (context, languageProvider, child) {
//         final currentLanguage = languageProvider.selectedLocale.languageCode;

//         return BaseScaffold(
//           title: ContactInfo.appName,
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     height: size.height * 0.2,
//                     child: Stack(
//                       children: <Widget>[
//                         Container(
//                           padding: EdgeInsets.only(
//                               // left: 20,
//                               // right: 20,
//                               // bottom: 50,
//                               ),
//                           height: size.height * 0.2 - 27,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Color.fromARGB(166, 207, 250, 187),
//                                 const Color.fromARGB(255, 90, 196, 80),
//                               ],
//                             ),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(36),
//                               bottomRight: Radius.circular(36),
//                             ),
//                           ),
//                           child: Column(
//                             children: [
//                               // Image.asset(
//                               //   "assets/images/logo_final_aa_r.png",
//                               //   width: 60,
//                               //   height: 59,
//                               // ),
//                               SizedBox(height: 25),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 16),
//                                 child: Row(
//                                   children: <Widget>[
//                                     Container(
//                                       //padding: EdgeInsets.all(value),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         // shape: BoxShape.circle,
//                                         color: Colors.black.withOpacity(0.2),
//                                       ),
//                                       child: Image.asset(
//                                         "assets/images/logo_final_aa_r.png",
//                                         width: 50,
//                                         height: 50,
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Welcome back!',
//                                             // '${AppLocalizations.of(context)!.welcome} ${user.fname}',
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 14),
//                                           ),
//                                           user == null
//                                               ? Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () => RegisterService()
//                                                           .showModalBottomSheetregister(
//                                                               context),
//                                                       child: Text(
//                                                         // AppLocalizations.of(
//                                                         //         context)!
//                                                         //     .welcomeUser,
//                                                         'Guest User',
//                                                         style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             fontSize: 16),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 )
//                                               : Column(
//                                                   children: [
//                                                     Text(
//                                                       ' Welcome back!',
//                                                       // '${AppLocalizations.of(context)!.welcome} ${user.fname}',
//                                                       style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontSize: 14),
//                                                     ),
//                                                     Text(
//                                                       '${user.fname}',
//                                                       // '${AppLocalizations.of(context)!.welcome} ${user.fname}',
//                                                       style: TextStyle(
//                                                           color: Colors.black,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           fontSize: 16),
//                                                     ),
//                                                     //  SizedBox(height: 5),
//                                                     // Text(
//                                                     //   '${user.mobile}',
//                                                     //   //   'Email: ${user.email}', // Use string interpolation to insert the userId
//                                                     //   style: TextStyle(
//                                                     //       color: Colors.black, fontSize: 18),
//                                                     // ),
//                                                     // SizedBox(height: 8),
//                                                     // Text(
//                                                     //   '${AppLocalizations.of(context)!.userId} : ${user.id}',
//                                                     //   //   'User Id: ${user.id}',
//                                                     //   style: TextStyle(
//                                                     //       color: Colors.black, fontSize: 14),
//                                                     // ),
//                                                   ],
//                                                 ),
//                                         ]),
//                                     Spacer(),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         //  shape: BoxShape.,
//                                         borderRadius: BorderRadius.circular(12),
//                                         color: Colors.black.withOpacity(0.2),
//                                       ),
//                                       child: PopupMenuButton<String>(
//                                         onSelected: (String value) {
//                                           print("🔤 Language selected: $value");
//                                           if (value != currentLanguage) {
//                                             Provider.of<LanguageProvider>(
//                                                     context,
//                                                     listen: false)
//                                                 .changeLanguage(value);
//                                           }
//                                         },
//                                         offset: const Offset(0, 60),
//                                         icon: Icon(Icons.language),
//                                         itemBuilder: (BuildContext context) =>
//                                             LanguageProvider.languages
//                                                 .map((language) =>
//                                                     PopupMenuItem<String>(
//                                                       value: language['locale'],
//                                                       child: Row(
//                                                         children: [
//                                                           if (language[
//                                                                   'locale'] ==
//                                                               currentLanguage)
//                                                             Icon(Icons.check,
//                                                                 size: 16,
//                                                                 color: Colors
//                                                                     .green)
//                                                           else
//                                                             SizedBox(width: 16),
//                                                           SizedBox(width: 8),
//                                                           Text(
//                                                               language['name']),
//                                                         ],
//                                                       ),
//                                                     ))
//                                                 .toList(),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(12),
//                                         // shape: BoxShape.circle,
//                                         color: Colors.black.withOpacity(0.2),
//                                       ),
//                                       child: IconButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     const CartPage(),
//                                               ));
//                                         },
//                                         icon: Stack(
//                                             alignment: Alignment.center,
//                                             children: [
//                                               const Icon(
//                                                 Icons.shopping_cart_outlined,
//                                                 size: 30,
//                                                 color: Colors.black,
//                                               ),
//                                               Positioned(
//                                                 right: 0,
//                                                 top: 0,
//                                                 child: CircleAvatar(
//                                                   radius: 7,
//                                                   backgroundColor:
//                                                       const Color.fromARGB(
//                                                           255, 245, 114, 74),
//                                                   child: Text(
//                                                     '${cart.totalUniqueItems}',
//                                                     style: TextStyle(
//                                                         fontSize: 10,
//                                                         color: Colors.black),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ]),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           left: 0,
//                           right: 0,
//                           child: Container(
//                             alignment: Alignment.center,
//                             // margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                             // padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
//                             // height: 54,
//                             // decoration: BoxDecoration(
//                             //   color: Colors.white,
//                             //   borderRadius: BorderRadius.circular(20),
//                             //   boxShadow: [
//                             //     BoxShadow(
//                             //       offset: Offset(0, 10),
//                             //       blurRadius: 50,
//                             //       //   color: kPrimaryColor.withOpacity(0.23),
//                             //     ),
//                             //   ],
//                             // ),
//                             child: HomeTextfield(
//                               onSearchChanged: _onSearchChanged,
//                               searchQuery: _searchQuery,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   if (_searchQuery.isEmpty) ...[
//                     Carousel(),
//                     SizedBox(height: 10),
//                   ],
//                   SizedBox(height: 10),
//                   ProductList(searchQuery: _searchQuery),
//                   if (_searchQuery.isEmpty) ...[
//                     SizedBox(height: 10),
//                     AnimatedCountersScreen(),
//                     SizedBox(height: 35),
//                     WhyA5Section(),
//                     SizedBox(height: 20),
//                     WhyUsScreen(),
//                     SizedBox(height: 35),
//                     FeaturesSection(),
//                     SizedBox(height: 20),
//                     FooterHome(),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/user_register.dart';
import 'package:ambrosia_ayurved/widgets/appbar.dart';
import 'package:ambrosia_ayurved/widgets/chatbot/chatbot.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:async';
import 'package:ambrosia_ayurved/ambrosia/view/home/carousel/carousel_slider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/happy_clients/happy_clients.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/home_textfield/home_textfield.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_list.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/why_us/why_us_2.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/why_us/why_us_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/why_us/why_us_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/footer/footer_home.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late TabController _tabController;
  String _searchQuery = '';

  final List<int> sectionIndices = [0, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    _fetchCartData();
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    _tabController = TabController(length: 5, vsync: this);

    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstVisibleIndex = positions.first.index;

        for (int i = 0; i < sectionIndices.length; i++) {
          if (i == sectionIndices.length - 1 ||
              (firstVisibleIndex >= sectionIndices[i] &&
                  firstVisibleIndex < sectionIndices[i + 1])) {
            if (_tabController.index != i) {
              setState(() {
                _tabController.animateTo(i);
              });
            }
            break;
          }
        }
      }
    });
  }

  void _fetchCartData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (userProvider.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cartProvider.fetchCartData(userProvider.id);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  Future<void> _launchWhatsApp() async {
    const phoneNumber = '+918000057233';
    const message = 'Hello, I have a question about Ambrosia Ayurved products';
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    Size size = MediaQuery.of(context).size;
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context).user;
    return BaseScaffold(
      title: 'Ambrosia Ayurved',

      searchQuery: _searchQuery,
      onSearchChanged: _onSearchChanged,
      child:
          // Consumer<LanguageProvider>(
          //   builder: (context, languageProvider, child) {
          //     final currentLanguage = languageProvider.selectedLocale.languageCode;
          //     return Scaffold(
          //       backgroundColor: Colors.white,
          //       appBar: PreferredSize(
          //         preferredSize: Size.fromHeight(size.height * 0.3),
          //         child: Container(
          //           height: size.height * 0.2,
          //           child: Stack(
          //             children: <Widget>[
          //               Container(
          //                 padding: EdgeInsets.only(
          //                   top: MediaQuery.of(context).padding.top,
          //                 ),
          //                 height: size.height * 0.2 - 22,
          //                 decoration: BoxDecoration(
          //                   gradient: LinearGradient(
          //                     begin: Alignment.topCenter,
          //                     end: Alignment.bottomCenter,
          //                     colors: [
          //                       Color.fromARGB(166, 207, 250, 187),
          //                       const Color.fromARGB(255, 90, 196, 80),
          //                     ],
          //                   ),
          //                   borderRadius: BorderRadius.only(
          //                     bottomLeft: Radius.circular(36),
          //                     bottomRight: Radius.circular(36),
          //                   ),
          //                 ),
          //                 child: Column(
          //                   children: [
          //                     SizedBox(height: 10),
          //                     Padding(
          //                       padding: const EdgeInsets.symmetric(horizontal: 16),
          //                       child: Row(
          //                         children: <Widget>[
          //                           Container(
          //                             decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(12),
          //                               color: Colors.black.withOpacity(0.2),
          //                             ),
          //                             child: Image.asset(
          //                               "assets/images/abmrosia_log_woutb.png",
          //                               width: 50,
          //                               height: 50,
          //                             ),
          //                           ),
          //                           SizedBox(width: 10),
          //                           Column(
          //                               mainAxisAlignment: MainAxisAlignment.start,
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   'Welcome back!',
          //                                   style: TextStyle(
          //                                       color: Colors.black, fontSize: 14),
          //                                 ),
          //                                 user == null
          //                                     ? Column(
          //                                         mainAxisAlignment:
          //                                             MainAxisAlignment.start,
          //                                         crossAxisAlignment:
          //                                             CrossAxisAlignment.start,
          //                                         children: [
          //                                           GestureDetector(
          //                                             onTap: () => RegisterService()
          //                                                 .showModalBottomSheetregister(
          //                                                     context),
          //                                             child: Text(
          //                                               'Login',
          //                                               style: TextStyle(
          //                                                   color: Colors.black,
          //                                                   fontWeight:
          //                                                       FontWeight.w600,
          //                                                   fontSize: 16),
          //                                             ),
          //                                           ),
          //                                         ],
          //                                       )
          //                                     : Column(
          //                                         children: [
          //                                           // Text(
          //                                           //   ' Welcome back!',
          //                                           //   style: TextStyle(
          //                                           //       color: Colors.black,
          //                                           //       fontSize: 14),
          //                                           // ),
          //                                           Text(
          //                                             '${user.fname}',
          //                                             style: TextStyle(
          //                                                 color: Colors.black,
          //                                                 fontWeight: FontWeight.w600,
          //                                                 fontSize: 16),
          //                                           ),
          //                                         ],
          //                                       ),
          //                               ]),
          //                           Spacer(),
          //                           Container(
          //                             decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(12),
          //                               color: Colors.black.withOpacity(0.2),
          //                             ),
          //                             child: PopupMenuButton<String>(
          //                               onSelected: (String value) {
          //                                 print("🔤 Language selected: $value");
          //                                 if (value != currentLanguage) {
          //                                   Provider.of<LanguageProvider>(context,
          //                                           listen: false)
          //                                       .changeLanguage(value);
          //                                 }
          //                               },
          //                               offset: const Offset(0, 60),
          //                               icon: Icon(Icons.language),
          //                               itemBuilder: (BuildContext context) =>
          //                                   LanguageProvider.languages
          //                                       .map((language) =>
          //                                           PopupMenuItem<String>(
          //                                             value: language['locale'],
          //                                             child: Row(
          //                                               children: [
          //                                                 if (language['locale'] ==
          //                                                     currentLanguage)
          //                                                   Icon(Icons.check,
          //                                                       size: 16,
          //                                                       color: Colors.green)
          //                                                 else
          //                                                   SizedBox(width: 16),
          //                                                 SizedBox(width: 8),
          //                                                 Text(language['name']),
          //                                               ],
          //                                             ),
          //                                           ))
          //                                       .toList(),
          //                             ),
          //                           ),
          //                           SizedBox(width: 10),
          //                           Container(
          //                             decoration: BoxDecoration(
          //                               borderRadius: BorderRadius.circular(12),
          //                               color: Colors.black.withOpacity(0.2),
          //                             ),
          //                             child: IconButton(
          //                               onPressed: () {
          //                                 Navigator.push(
          //                                     context,
          //                                     MaterialPageRoute(
          //                                       builder: (context) =>
          //                                           const CartPage(),
          //                                     ));
          //                               },
          //                               icon: Stack(
          //                                   alignment: Alignment.center,
          //                                   children: [
          //                                     const Icon(
          //                                       Icons.shopping_cart_outlined,
          //                                       size: 30,
          //                                       color: Colors.black,
          //                                     ),
          //                                     Positioned(
          //                                       right: 0,
          //                                       top: 0,
          //                                       child: CircleAvatar(
          //                                         radius: 7,
          //                                         backgroundColor:
          //                                             const Color.fromARGB(
          //                                                 255, 245, 114, 74),
          //                                         child: Text(
          //                                           '${cart.totalUniqueItems}',
          //                                           style: TextStyle(
          //                                             fontSize: 10,
          //                                             color: Colors.black,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ]),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Positioned(
          //                 bottom: 0,
          //                 left: 0,
          //                 right: 0,
          //                 child: Container(
          //                   alignment: Alignment.center,
          //                   child: HomeTextfield(
          //                     onSearchChanged: _onSearchChanged,
          //                     searchQuery: _searchQuery,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //  body:
          SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            if (_searchQuery.isEmpty) ...[
              Carousel(),
              SizedBox(height: 10),
            ],
            SizedBox(height: 10),
            ProductList(searchQuery: _searchQuery),
            if (_searchQuery.isEmpty) ...[
              SizedBox(height: 10),
              AnimatedCountersScreen(),
              SizedBox(height: 35),
              WhyA5Section(),
              SizedBox(height: 20),
              WhyUsScreen(),
              SizedBox(height: 35),
              FeaturesSection(),
              SizedBox(height: 20),
              FooterHome(),
            ],
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "chat_fab",
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ChatScreen()),
      //     );
      //   },
      //   backgroundColor: Colors.green[50],
      //   child: Padding(
      //     padding: const EdgeInsets.all(6.0),
      //     child: Image.asset('assets/images/chat.png'),
      //   ),
      //   // const Icon(Icons.chat, color: Colors.white),
      // ),
    );
  }
}
