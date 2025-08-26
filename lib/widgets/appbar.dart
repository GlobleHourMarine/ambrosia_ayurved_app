import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/shiprocket/shipping_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/shiprocket/shiprocket_service.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/address_fetch_service.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/fetch_address_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/new_address_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_now_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/contact/contact_us_new.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/new_order_history.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/new_order_history_ge.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/submit_review.dart';
import 'package:ambrosia_ayurved/home/sign_in_new.dart';
import 'package:ambrosia_ayurved/home/sign_up_new.dart';
import 'package:ambrosia_ayurved/profile/new_forget_password.dart';
import 'package:ambrosia_ayurved/widgets/address/address_form.dart';

import 'package:ambrosia_ayurved/widgets/phonepe/phonepe_service.dart';
import 'package:ambrosia_ayurved/widgets/newaddresssection.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/track_order.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/gemini/screen.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/shiprocket_service.dart';
import 'package:ambrosia_ayurved/widgets/shiprocket/tracking.dart';
import 'package:get/get.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
//import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/category_list/category_list.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/category_list/mediciene/medicine_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/category_list/skincare/skincare_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/Faq/faq.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/about_us/about_us.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/contact/contact_us.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_history_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/cancellation&refund.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/privacy_policy.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/shipping&delivery.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/terms&conditions.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/payment_details_view/payment_details_view.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/main.dart';
import 'package:ambrosia_ayurved/profile/profile.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/footer.dart';

import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_model.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/profile/profile_model/profile_model.dart';

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
  // String? _imageUrl;
  // String? _userName;
  AddressModel? selectedAddress;

  @override
  void initState() {
    super.initState();

    _fetchCartData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // setState(() {
      //   _imageUrl = userProvider.user?.image;
      //   _userName = userProvider.user?.fname ?? "User";
      // });
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
  Widget build(BuildContext context) {
    // final translator = Provider.of<TranslationProvider>(context);
    //  print("Current locale: ${Localizations.localeOf(context).languageCode}");
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<UserProvider>(context).user;
    if (user != null) {
      print('User data available in build');
    }

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        // Get the current language code for more reliable selection
        final currentLanguage = languageProvider.selectedLocale.languageCode;
        //  print("⚡ Building AppBar with language: $currentLanguage");
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
                    // Bottom Color (Lighter Yellow)
                  ],
                ),
              ),
            ),

            title: Text(
              // AppLocalizations.of(context)!.
              widget.title,
              style: TextStyle(
                //  color: Colors.white,
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
                icon: Icon(Icons.language),
                itemBuilder: (BuildContext context) => LanguageProvider
                    .languages
                    .map((language) => PopupMenuItem<String>(
                          value: language['locale'],
                          child: Row(
                            children: [
                              // Add a checkmark for the currently selected language
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
              // PopupMenuButton<String>(
              //   onSelected: (String value) {
              //     Provider.of<LanguageProvider>(context, listen: false)
              //         .changeLanguage(value);
              //   },
              //   icon: Icon(Icons.language),
              //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              //     PopupMenuItem<String>(
              //       value: 'en',
              //       child: Text('English'),
              //     ),
              //     PopupMenuItem<String>(
              //       value: 'ms',
              //       child: Text('Bahasa Melayu'),
              //     ),
              //   ],
              // ),
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

                    /*
         Consumer<CartProvider>(
        builder: (context, cart, child) {
      return Positioned(
        right: 0,
        top: 0,
        child: cart.totalUniqueItems > 0  // Show only when items are present
            ? CircleAvatar(
                radius: 7,
                backgroundColor: Colors.red,
                child: Text(
                  '${cart.totalUniqueItems}', // Correctly display the number of unique products
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              )
            : SizedBox(), // Hide when cart is empty
      );
        },
      ),
                  */

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
                  ]),
                ),
              ),

              // Language Toggle Button
            ], //

            //   // Circle avatar with admin profile
            // Padding(
            //   padding: const EdgeInsets.only(right: 16.0),
            //   child: GestureDetector(
            //     onTap: () {
            //       // Navigate to ProfileScreen when avatar is clicked
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => ProfileScreen()),
            //       );
            //     },
            //     child: CircleAvatar(
            //       backgroundImage: _imageUrl != null
            //           ? NetworkImage(_imageUrl!)
            //           : AssetImage('assets/images/default_profile.png')
            //       as ImageProvider,
            //       radius: 20,
            //     ),
            //   ),
            // ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen(),
                                      ));
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
                            SizedBox(height: 8),
                            Text(
                              '${AppLocalizations.of(context)!.email} : ${user.email}',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                  },
                  //   trailing: Icon(Icons.arrow_forward_ios_rounded)
                ),
                // ListTile(
                //   leading: const Icon(
                //     Icons.category_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: const Text(
                //     'My Orders',
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => OrderHistoryScreen(),
                //         ));
                //   },
                //   // trailing: Icon(Icons.arrow_forward_ios_rounded)
                // ),
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
                    // Padding(
                    //   padding: EdgeInsets.only(left: 35),
                    //   child: ListTile(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => OrderHistoryScreen(),
                    //           ));
                    //     },
                    //     leading: Icon(
                    //       Icons.shopping_cart_outlined,
                    //       color: Acolors.primary,
                    //     ),
                    //     title: Text(
                    //       AppLocalizations.of(context)!.myOrders,
                    //     ),
                    //   ),
                    // ),
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
                    // Padding(
                    //   padding: EdgeInsets.only(left: 35),
                    //   child: ListTile(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => OrderHistoryScreenG(),
                    //           ));
                    //     },
                    //     leading: Icon(
                    //       Icons.shopping_cart_outlined,
                    //       color: Acolors.primary,
                    //     ),
                    //     title: Text(
                    //       'My orders G',
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 35),
                    //   child: ListTile(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => PaymentDetailsView(),
                    //           ));
                    //     },
                    //     leading: Icon(
                    //       Icons.money_off_csred_rounded,
                    //       color: Acolors.primary,
                    //     ),
                    //     title:
                    //         Text(AppLocalizations.of(context)!.paymentDetails),
                    //   ),
                    // ),
                  ],
                ),

                // ExpansionTile(
                //   leading: Icon(
                //     Icons.vertical_distribute_sharp,
                //     color: Acolors.primary,
                //   ),
                //   // trailing: Icon(
                //   //   Icons.keyboard_arrow_down_outlined,
                //   //   size: 35,
                //   // ),
                //   title: Text(
                //     'Products',
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(left: 35),
                //       child: ListTile(
                //         onTap: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => MedicineScreen(),
                //               ));
                //         },
                //         leading: Icon(
                //           Icons.medical_services_outlined,
                //           color: Acolors.primary,
                //         ),
                //         title: Text(
                //           'Diabities Mediciene',
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(left: 35),
                //       child: ListTile(
                //         onTap: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (context) => SkincareScreen(),
                //               ));
                //         },
                //         leading: Icon(
                //           Icons.face,
                //           color: Acolors.primary,
                //         ),
                //         title: Text('Face Creame'),
                //       ),
                //     ),
                //   ],
                // ),
                ExpansionTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: Acolors.primary,
                  ),
                  // trailing: Icon(
                  //   Icons.keyboard_arrow_down_outlined,
                  //   size: 35,
                  // ),
                  title: Text(
                    '${AppLocalizations.of(context)!.ourPolicies}',
                    //  'Our Policies',
                    //  AppLocalizations.of(context)!.orderHistory,
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
                          //   AppLocalizations.of(context)!.myOrders,
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
                        //  Text(AppLocalizations.of(context)!.paymentDetails),
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
                        //  Text(AppLocalizations.of(context)!.paymentDetails),
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
                        //  Text(AppLocalizations.of(context)!.paymentDetails),
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
                    //  '${AppLocalizations.of(context)!.faq}',
                    //   'FAQ',
                    //  AppLocalizations.of(context)!.contactUs,
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              // AddressSelectionWidget(
                              //   title: "Select Delivery Address",
                              //   onAddressSelected: (AddressModel address) {
                              //     setState(() {
                              //       selectedAddress = address;
                              //     });
                              //     print(
                              //         'Selected: ${address.fname} ${address.lname}');
                              //   },
                              // ),
                              AddressNewScreen(),
                        ));
                  },
                ),

                // ListTile(
                //   leading: Icon(
                //     Icons.person_pin_circle_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     AppLocalizations.of(context)!.contactUs,
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               TrackingScreen1(awbCode: '19041787021862'),
                //           // ContactUsPage(),
                //         ));
                //   },
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.person_pin_circle_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     AppLocalizations.of(context)!.contactUs,
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => TrackingScreen2(),
                //           // ContactUsPage(),
                //         ));
                //   },
                // ),

                // ListTile(
                //   leading: Icon(
                //     Icons.person_pin_circle_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     'Tracking details',
                //     //  AppLocalizations.of(context)!.contactUs,
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     // In any other file
                //     // final awbCode =
                //     //     Provider.of<AwbData>(context, listen: false).awbCode;
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => TrackingScreen(
                //           awbCode: '19041787021862',
                //           token:
                //               'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY3NTMwMzksInNvdXJjZSI6InNyLWF1dGgtaW50IiwiZXhwIjoxNzU1NzcxNzkxLCJqdGkiOiJpWmFwVHdubURDMjRWS1ltIiwiaWF0IjoxNzU0OTA3NzkxLCJpc3MiOiJodHRwczovL3NyLWF1dGguc2hpcHJvY2tldC5pbi9hdXRob3JpemUvdXNlciIsIm5iZiI6MTc1NDkwNzc5MSwiY2lkIjo2NTE3MTM5LCJ0YyI6MzYwLCJ2ZXJib3NlIjpmYWxzZSwidmVuZG9yX2lkIjowLCJ2ZW5kb3JfY29kZSI6IiJ9.tfzREh0gVEGxz3WQ4D-JwM7QPIiQExv0BLcDJujo6D4',
                //         ),
                //         // ContactUsPage(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.person_pin_circle_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     'Phonpe widget',
                //     //   AppLocalizations.of(context)!.contactUs,
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //           PhonePePaymentPage(),
                //           // ContactUsPage(),
                //         ));
                //   },
                // ),
                // ListTile(
                //   leading: Icon(
                //     Icons.add_business_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     'trackingask',
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () => fetchTrackingInfo,
                // ),
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
                          builder: (context) => ContactUsScreenNew(),
                          // ContactUsPage(),
                        ));
                  },
                ),

                ListTile(
                  leading: Icon(
                    Icons.format_quote_outlined,
                    color: Acolors.primary,
                  ),
                  title: Text(
                    '${AppLocalizations.of(context)!.faq}',
                    //   'FAQ',
                    //  AppLocalizations.of(context)!.contactUs,
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

                //
                //

//
//

                // ListTile(
                //   leading: Icon(
                //     Icons.format_quote_outlined,
                //     color: Acolors.primary,
                //   ),
                //   title: Text(
                //     'add address',
                //     //  '${AppLocalizations.of(context)!.faq}',
                //     //   'FAQ',
                //     //  AppLocalizations.of(context)!.contactUs,
                //     style: TextStyle(fontSize: 18),
                //   ),
                //   onTap: () {
                //     Navigator.pop(context);
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => ShippingScreen1(),
                //         ));
                //   },
                // ),

                //
                //
                //
                //

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ));
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

          /* drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Acolors.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.username ?? 'Guest'}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'User ID: ${user?.userId ?? 'null'}', // Use string interpolation to insert the userId
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Rank : ${user?.rank ?? 'Guest'}',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.dashboard,
                ),
                title: Text('Dashboard'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Deposit'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Invest'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvestmentScreen(),
                    ),
                  );
                },
              ),
              ExpansionTile(
                title: Text('Community List'),
                leading: Icon(Icons.group_add),
                children: [
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text('Referral  List'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Referrallist(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list_alt_sharp),
                    title: Text('Team Level  List'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamLevelList(),
                        ),
                      );
                    },
                  )
                ],
              ),
              ExpansionTile(
                title: Text('Community Structure'),
                leading: Icon(Icons.account_tree),
                children: [
                  ListTile(
                    leading: Icon(Icons.integration_instructions),
                    title: Text('Direct Structure'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Directtree(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.interests),
                    title: Text('Indirect Structure'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReferralPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.trending_up),
                title: Text('Income'),
                children: [
                  ListTile(
                    leading: Icon(Icons.account_balance),
                    title: Text('ROI Income'),
                    onTap: () {
                      // Handle ROI Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ROIPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('Direct Income'),
                    onTap: () {
                      // Handle Direct Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DirectIncome(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.money_off),
                    title: Text('Indirect Income'),
                    onTap: () {
                      // Handle Indirect Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndirectIncome(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.money_off),
                    title: Text('Team Earning Income'),
                    onTap: () {
                      // Handle Indirect Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeamLevelEarning(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_tree),
                    title: Text('Reward Income'),
                    onTap: () {
                      // Handle Bonus Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardIncome(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.account_tree),
                    title: Text('Salary Income'),
                    onTap: () {
                      // Handle Bonus Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalaryIncome(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.transfer_within_a_station),
                title: Text('Transactional'),
                children: [
                  ListTile(
                    leading: Icon(Icons.transcribe),
                    title: Text('Transfer'),
                    onTap: () {
                      // Handle ROI Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransferScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.swipe),
                    title: Text('Swipe'),
                    onTap: () {
                      // Handle Direct Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SwipeScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.connect_without_contact_outlined),
                    title: Text('WithDrawal'),
                    onTap: () {
                      // Handle Indirect Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WithdrawalScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.report),
                title: Text('Reports'),
                children: [
                  ListTile(
                    leading: Icon(Icons.transcribe),
                    title: Text('Income Report'),
                    onTap: () {
                      // Handle ROI Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Incomereport(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.swipe),
                    title: Text('Activation Report'),
                    onTap: () {
                      // Handle Direct Income tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Activationreport(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Support Ticket'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person_pin),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),*/
          body: widget.child,

          // bottomNavigationBar: BottomNav(
          //   selectedIndex: 0, // home screen selected index
          // ), // Display the child content
        );
      },
    );
  }
}






//logout function


 

