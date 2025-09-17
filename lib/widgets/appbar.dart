import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/new_address_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/phone_number_flow/c_flow/user-register_flow.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/user_register.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/contact/contact_us_new.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/order_history/order_history/order_history_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/widgets/new_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/Faq/faq.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/about_us/about_us.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/cancellation&refund.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/privacy_policy.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/shipping&delivery.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/terms&conditions.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/login_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget child;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  Address? selectedAddress;

  @override
  void initState() {
    super.initState();

    _fetchCartData();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context).user;
    if (user != null) {
      print('User data available in build ${user}');
    }

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final currentLanguage = languageProvider.selectedLocale.languageCode;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(166, 207, 250, 187),
                    const Color.fromARGB(255, 90, 196, 80),
                  ],
                ),
              ),
            ),
            title: Text(
              // AppLocalizations.of(context)!.
              widget.title,
              style: TextStyle(
                //  color: Colors.black,
                //   fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
              ),
            ),
            centerTitle: true,
            actions: [
              // Using PopupMenuButton for language selection
              PopupMenuButton<String>(
                onSelected: (String value) {
                  print("🔤 Language selected: $value");
                  if (value != currentLanguage) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .changeLanguage(value);
                  }
                },
                offset: const Offset(0, 60),
                icon: Icon(Icons.language),
                itemBuilder: (BuildContext context) => LanguageProvider
                    .languages
                    .map((language) => PopupMenuItem<String>(
                          value: language['locale'],
                          child: Row(
                            children: [
                              if (language['locale'] == currentLanguage)
                                Icon(Icons.check, size: 16, color: Colors.green)
                              else
                                SizedBox(width: 16),
                              SizedBox(width: 8),
                              Text(language['name']),
                            ],
                          ),
                        ))
                    .toList(),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ));
                  },
                  icon: Stack(alignment: Alignment.center, children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 35,
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
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Acolors.gradientss,
                        Acolors.primary,
                      ],
                    ),
                  ),
                  child: user == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  RegisterService()
                                      .showModalBottomSheetregister(context);
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.welcomeUser,
                                  //'Welcome User \nClick here to Login',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                )),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.welcome} ${user.fname}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            SizedBox(height: 15),
                            Text(
                              '${AppLocalizations.of(context)!.phone} : ${user.mobile}',
                              //   'Email: ${user.email}', // Use string interpolation to insert the userId
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${AppLocalizations.of(context)!.userId} : ${user.id}',
                              //   'User Id: ${user.id}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.home,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainTabView(),
                        ));
                  },
                ),
                ExpansionTile(
                  leading: Icon(
                    Icons.history,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.orderHistory,
                    style: TextStyle(fontSize: 18),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderHistoryScreenN(),
                              ));
                        },
                        leading: Icon(
                          Icons.shopping_cart_outlined,
                          color: Acolors.primary,
                        ),
                        title: Text(
                          'My orders',
                        ),
                      ),
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    '${AppLocalizations.of(context)!.ourPolicies}',
                    //  'Our Policies',

                    style: TextStyle(fontSize: 18),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyScreen()));
                        },
                        leading: Icon(
                          Icons.privacy_tip_outlined,
                          color: Acolors.primary,
                        ),
                        title: Text(
                          '${AppLocalizations.of(context)!.privacyPolicy}',
                          // 'Privacy Policy',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TermsAndConditionsScreen(),
                              ));
                        },
                        leading: Icon(
                          Icons.article_outlined,
                          color: Acolors.primary,
                        ),
                        title: Text(
                          '${AppLocalizations.of(context)!.termsConditions}',
                          // 'Terms & Conditions'
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShippingAndDeliveryPolicyScreen(),
                              ));
                        },
                        leading: Icon(
                          Icons.local_mall_outlined,
                          color: Acolors.primary,
                        ),
                        title: Text(
                          '${AppLocalizations.of(context)!.shippingPolicy}',
                          // 'Shipping and Delivery Policy.'
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CancellationRefundPolicyScreen(),
                              ));
                        },
                        leading: Icon(
                          Icons.receipt_long_outlined,
                          color: Acolors.primary,
                        ),
                        title: Text(
                          '${AppLocalizations.of(context)!.cancellationRefundPolicy}',
                          //  'Cancellation and Refund Policy.'
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location_alt_outlined,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    'Manage address',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressNewScreen(),
                        ));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_business_outlined,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.aboutUs,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUsScreen(),
                        ));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_pin_circle_outlined,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.contactUs,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactUsScreen(),
                          // ContactUsPage(),
                        ));
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.person_pin_circle_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     'register user',
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => RegisterModalSheet(),
                //           // ContactUsPage(),
                //         ));
                //   },
                // ),
                ListTile(
                  leading: Icon(
                    Icons.format_quote_outlined,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    '${AppLocalizations.of(context)!.faq}',
                    //   'FAQ',

                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FAQSection(),
                        ));
                  },
                ),
                ListTile(
                  leading: Icon(
                    user == null ? Icons.login_rounded : Icons.logout_rounded,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    user == null
                        ? AppLocalizations.of(context)!.login
                        : AppLocalizations.of(context)!.logout,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    if (user == null) {
                      Navigator.pop(context);
                      // Use the RegisterService to show the bottom sheet
                      RegisterService().showModalBottomSheetregister(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => SignInScreen(),
                      //     ));
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(AppLocalizations.of(context)!.logout),
                            content: Text(
                              AppLocalizations.of(context)!.logoutmessage,
                              //    "Are you sure you want to logout?"
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                  //  "Cancel"
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .logout(context);
                                },
                                child: Text(
                                    //'a'
                                    AppLocalizations.of(context)!.logout),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          body: widget.child,
        );
      },
    );
  }
}

/*


import 'dart:ffi';

import 'package:ambrosia_ayurved/ambrosia/common_widgets/home_textfield/home_textfield.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/phone_number_flow/c_flow/user-register_flow.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/user_register.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BaseScaffold extends StatefulWidget {
  final String title;
  final Widget child;
  // final Function(String)? onSearchChanged;
  // final String? searchQuery;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.child,
    // this.onSearchChanged,
    // this.searchQuery,
  }) : super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _fetchCartData();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context).user;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final currentLanguage = languageProvider.selectedLocale.languageCode;
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              // Custom App Bar
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(166, 207, 250, 187),
                      const Color.fromARGB(255, 90, 196, 80),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 20),
                    child: Column(
                      children: [
                        // Text(
                        //   widget.title,
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontSize: 22,
                        //     fontWeight: FontWeight.bold,
                        //     letterSpacing: 1.2,
                        //   ),
                        // ),
                        // Top row with user info and actions
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // User Info Section
                            Expanded(
                              child: user != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // CircleAvatar(
                                            //   radius: 20,
                                            //   backgroundColor: Colors.black,
                                            //   child: Icon(
                                            //     Icons.person,
                                            //     color: Acolors.primary,
                                            //     size: 22,
                                            //   ),
                                            // ),
                                            // SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Hi, ${user.fname}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text(
                                                    '${AppLocalizations.of(context)!.phone}: ${user.mobile}',
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.9),
                                                      fontSize: 13,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        RegisterService()
                                            .showModalBottomSheetregister(
                                                context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.person_outline,
                                                color: Colors.black, size: 18),
                                            SizedBox(width: 8),
                                            Text(
                                              'Tap to Login',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),

                            // Actions (Language and Cart)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Language Selector
                                PopupMenuButton<String>(
                                  onSelected: (String value) {
                                    if (value != currentLanguage) {
                                      Provider.of<LanguageProvider>(context,
                                              listen: false)
                                          .changeLanguage(value);
                                    }
                                  },
                                  offset: const Offset(0, 40),
                                  icon: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.language,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                      LanguageProvider.languages
                                          .map((language) =>
                                              PopupMenuItem<String>(
                                                value: language['locale'],
                                                child: Row(
                                                  children: [
                                                    if (language['locale'] ==
                                                        currentLanguage)
                                                      Icon(Icons.check,
                                                          size: 16,
                                                          color: Colors.green)
                                                    else
                                                      SizedBox(width: 16),
                                                    SizedBox(width: 8),
                                                    Text(language['name']),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                ),

                                SizedBox(width: 12),

                                // Cart Button
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartPage()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.black,
                                          size: 22,
                                        ),
                                        if (cart.totalUniqueItems > 0)
                                          Positioned(
                                            right: -4,
                                            top: -4,
                                            child: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                '${cart.totalUniqueItems}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // App Title
                        SizedBox(height: 20),
                        HomeTextfield(
                          onSearchChanged: _onSearchChanged,
                          searchQuery: _searchQuery,
                        ),
                        // Search Field (if provided)
                        // if (widget.onSearchChanged != null) ...[
                        //   SizedBox(height: 16),
                        //   Container(
                        //     decoration: BoxDecoration(
                        //       color: Colors.black,
                        //       borderRadius: BorderRadius.circular(25),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.black.withOpacity(0.1),
                        //           blurRadius: 8,
                        //           offset: Offset(0, 2),
                        //         ),
                        //       ],
                        //     ),
                        //     child: TextField(
                        //       onChanged: widget.onSearchChanged,
                        //       decoration: InputDecoration(
                        //         hintText: 'Search products...',
                        //         hintStyle: TextStyle(color: Colors.grey[500]),
                        //         prefixIcon:
                        //             Icon(Icons.search, color: Acolors.primary),
                        //         border: InputBorder.none,
                        //         contentPadding: EdgeInsets.symmetric(
                        //           horizontal: 20,
                        //           vertical: 15,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ],
                      ],
                    ),
                  ),
                ),
              ),

              // Body
              Expanded(
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }
}


*/
