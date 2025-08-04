import 'package:ambrosia_ayurved/cosmetics/common/contact_info.dart';
import 'package:ambrosia_ayurved/internet/internet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/carousel/carousel_slider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/footer/footer.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/happy_clients/happy_clients.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/happy_clients/new_shape.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/home_textfield/home_textfield.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/new_desgin.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/benefits.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/how_to_use_section.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/ingredients.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_list.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_new_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/product_category/product_category.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_2.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_section.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/appbar.dart';
import 'package:ambrosia_ayurved/widgets/footer.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Add this mixin
  // Controller to manage scrolling to specific items
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late TabController _tabController; // Use late initialization
  String _searchQuery = '';
  // Define section indices - these would match the positions in your list
  final List<int> sectionIndices = [
    0,
    2,
    3,
    4,
    5
  ]; // Positions of each section in the list

  @override
  void initState() {
    super.initState();
    // Initialize the TabController in initState
    _tabController = TabController(length: 5, vsync: this);

    // Add listener to update selected tab based on scroll position
    itemPositionsListener.itemPositions.addListener(() {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        // Find the first visible item
        final firstVisibleIndex = positions.first.index;

        // Determine which section we're in
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

  // Add this method to launch WhatsApp
  Future<void> _launchWhatsApp() async {
    const phoneNumber =
        '+918000057233'; // Replace with your actual phone number
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print(
      //     "✅ AppLocalization locale: ${AppLocalizations.of(context)?.localeName}");
      // print(
      //     "🌍 Provider locale: ${Provider.of<LanguageProvider>(context, listen: false).selectedLocale.languageCode}");
    });

    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return BasePage(
      fetchDataFunction: () async {},
      child: BaseScaffold(
        title:
            //'Ambrosia Ayurved',
            // 'Cosmetics App',
            ContactInfo.appName,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                HomeTextfield(
                  onSearchChanged: _onSearchChanged,
                  searchQuery: _searchQuery,
                ),
                SizedBox(height: 20),
                // Show carousel only when not searching
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
                  FooterNew(),
                ],
              ],
            ),
          ),
        ),
        /* 
        Stack(
          children: [
            // Main content with all sections in their original order
            Padding(
              padding: EdgeInsets.only(
                  bottom: 60), // Add padding at bottom for the tab bar
              child: ScrollablePositionedList.builder(
                itemCount: 7, // Total number of sections/widgets
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemBuilder: (context, index) {
                  // Return the appropriate widget based on index
                  switch (index) {
                    case 0:
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Carousel(),
                          SizedBox(height: 10),
                          ProductDetailPage(),
                        ],
                      );
                    case 1:
                      return const SizedBox(height: 20);
                    case 2:
                      return Benefits();
                    case 3:
                      return Ingredients();
                    case 4:
                      return AnimatedCountersScreen();
                    case 5:
                      return Column(
                        children: [
                          SizedBox(height: 35),
                          WhyA5Section(),
                          const SizedBox(height: 20),
                          WhyUsScreen(),
                          SizedBox(height: 35),
                          FeaturesSection(),
                        ],
                      );
                    case 6:
                      return FooterNew();
                    default:
                      return Container();
                  }
                },
              ),
            ),

            // Fixed position tab bar at the bottom of the screen
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      // Scroll to the selected section
                      itemScrollController.scrollTo(
                        index: sectionIndices[index],
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.info),
                        text: '${AppLocalizations.of(context)!.tabDetails}',
                        // 'Details',
                      ),
                      Tab(
                        icon: Icon(Icons.health_and_safety),
                        text: '${AppLocalizations.of(context)!.tabBenefits}',
                        //  'Benefits',
                      ),
                      Tab(
                        icon: Icon(Icons.eco),
                        text: '${AppLocalizations.of(context)!.tabUsage}',
                        // 'Usage',
                      ),
                      Tab(
                        icon: Icon(Icons.reviews),
                        text: '${AppLocalizations.of(context)!.tabReviews}',
                        // 'Reviews',
                      ),
                      Tab(
                        icon: Icon(Icons.star),
                        text: '${AppLocalizations.of(context)!.tabWhyUs}',
                        // 'Why Us',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 85, // Position above the tab bar
              right: 20,
              child: FloatingActionButton(
                //   backgroundColor: Colors.white, // WhatsApp green color
                onPressed: _launchWhatsApp,
                child: Image.asset(
                  'assets/images/whatsapp.png',
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ],
        ),
        */
      ),
    );
  }
}








/*

import 'dart:async';
import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/carousel/carousel_slider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/footer/footer.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/happy_clients/happy_clients.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/happy_clients/new_shape.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/home_textfield/home_textfield.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/new_desgin.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/benefits.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/how_to_use_section.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/ingredients.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_list.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_detail.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_new_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_notifier_class.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/product_category/product_category.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_2.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_section.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/appbar.dart';
import 'package:ambrosia_ayurved/widgets/footer.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_custom_widget.dart';
import 'package:ambrosia_ayurved/widgets/translation/translation_provider_local.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  // void initState() {
  //   super.initState();
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   userProvider
  //       .loadUserFromPrefs(); // ✅ Load saved user data when HomeScreen loads
  // }

  String searchText = '';
  String fullHintText = 'Find something here';
  String visibleHintText = '';
  int hintIndex = 0;
  Timer? typingTimer;
  Duration typingSpeed = const Duration(milliseconds: 100);
  bool isTyping = true;
  String activeUsersCount = "";
  String totalReferrals = "";
  double walletbalance = 0.0;
  int investmentAmount = 0;
  int incomeWallet = 0;
  String teamearnIncome = '0';
  String roiIncome = '0';
  String total_income = '0';
  String salaryIncome = '0';
  bool isLoading = true;
  String directIncome = '\$0.00'; // Placeholder for Direct Income
  String indirectIncome = '\$0.00'; // Placeholder for Indirect Income
  int? withdrawalAmount;
  // bool _isLoading = true;
/*
  @override
  void initState() {
    super.initState();
    // _startTypingEffect();
    _fetchDirectIncome(); // Fetch Direct Income from API
    _fetchIndirectIncome(); // Fetch Indirect Income from API
    _get_active_referral();
    _fetchTotalReferrals();
    _get_investment_amount();
    _fetchWithdrawalAmount();
    _fetchRoiIncome();
    _fetchTeamearningIncome();
    _fetchSalaryIncome();
    _fetchtotalIncome();
  }
*/
/*
  void _startTypingEffect() {
    typingTimer = Timer.periodic(typingSpeed, (timer) {
      setState(() {
        if (isTyping) {
          if (hintIndex < fullHintText.length) {
            visibleHintText += fullHintText[hintIndex];
            hintIndex++;
          } else {
            isTyping = false;
          }
        } else {
          if (hintIndex > 0) {
            visibleHintText = visibleHintText.substring(0, hintIndex - 1);
            hintIndex--;
          } else {
            isTyping = true;
          }
        }
      });
    });
  }
*/

/*
  Future<void> _fetchWithdrawalAmount() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch direct income.');
      return;
    }

    final userId = user.userId; // Retrieve userId
    final url = Uri.parse(
        'https://mmm.klizardtechnology.com/signup/get_withdrawal_amount');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          // print(responseData);

          setState(() {
            // Directly access withdrawal_amount since it's now at the top level
            withdrawalAmount = responseData['withdrawal_amount'] ?? 0;
          });
        } else {
          // Handle API error message
          _showErrorSnackbar(responseData['message']);
        }
      } else {
        // Handle unexpected response status
        _showErrorSnackbar('Failed to fetch withdrawal amount');
      }
    } catch (error) {
      // _showErrorSnackbar('An error occurred: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  */

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

/*
  Future<void> _get_active_referral() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch direct income.');
      return;
    }

    final userId = user.userId; // Retrieve userId
    try {
      // Send the POST request with the user ID
      final response = await http.post(
        Uri.parse('https://mmm.klizardtechnology.com/signup/get_active_users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            activeUsersCount =
                jsonResponse['total_active_users']; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load direct income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  // Function to fetch total referrals
  Future<void> _fetchTotalReferrals() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch direct income.');
      return;
    }

    final userId = user.userId; // Retrieve userId
    try {
      // Send the POST request with the user ID
      final response = await http.post(
        Uri.parse(
            'https://mmm.klizardtechnology.com/signup/get_total_refferals'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        // print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            totalReferrals = jsonResponse['total_referral']; // Keep as string
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load direct income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  Future<void> _get_investment_amount() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch investment amount.');
      return;
    }

    final userId = user.userId; // Retrieve userId
    try {
      // Send the POST request with the user ID
      final response = await http.post(
        Uri.parse(
            'https://mmm.klizardtechnology.com/signup/get_investment_amount'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        // print(response.body);  // Log the response body for debugging
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          setState(() {
            investmentAmount =
                jsonResponse['total_investment']; // No need to convert
          });
        } else {
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        print(
            'Failed to load investment amount. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during request: $e');
    }
  }

  // Fetch Direct Income from the backend
  Future<void> _fetchDirectIncome() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch direct income.');
      return;
    }

    final userId = user.userId; // Retrieve userId

    try {
      final response = await http.post(
        Uri.parse('https://mmm.klizardtechnology.com/signup/get_direct_income'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user_id': userId}), // Pass the userId in the body as JSON
      );

      if (response.statusCode == 200) {
        // print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            directIncome = '\$${jsonResponse['data']}'; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load direct income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  // Fetch Indirect Income from the backend
  Future<void> _fetchIndirectIncome() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch indirect income.');
      return;
    }

    final userId = user.userId; // Retrieve userId

    try {
      final response = await http.post(
        Uri.parse(
            'https://mmm.klizardtechnology.com/signup/get_indirect_income'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user_id': userId}), // Pass the userId in the body as JSON
      );

      if (response.statusCode == 200) {
        // print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            indirectIncome =
                '\$${jsonResponse['data']}'; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load indirect income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  Future<void> _fetchRoiIncome() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch indirect income.');
      return;
    }

    final userId = user.userId; // Retrieve userId

    try {
      final response = await http.post(
        Uri.parse('https://mmm.klizardtechnology.com/signup/get_total_roi'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user_id': userId}), // Pass the userId in the body as JSON
      );

      if (response.statusCode == 200) {
        // print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            roiIncome =
                '\$${jsonResponse['roi_income']}'; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load indirect income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  Future<void> _fetchTeamearningIncome() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch indirect income.');
      return;
    }

    final userId = user.userId; // Retrieve userId

    try {
      final response = await http.post(
        Uri.parse(
            'https://mmm.klizardtechnology.com/signup/get_total_team_earning'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user_id': userId}), // Pass the userId in the body as JSON
      );

      if (response.statusCode == 200) {
        // print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            teamearnIncome =
                '\$${jsonResponse['total_team_earning']}'; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load indirect income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  Future<void> _fetchSalaryIncome() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch indirect income.');
      return;
    }

    final userId = user.userId; // Retrieve userId

    try {
      final response = await http.post(
        Uri.parse(
            'https://mmm.klizardtechnology.com/signup/get_total_salary_income'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user_id': userId}), // Pass the userId in the body as JSON
      );

      if (response.statusCode == 200) {
        print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            salaryIncome =
                '\$${jsonResponse['salary_income']}'; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load indirect income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }

  Future<void> _fetchtotalIncome() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      print('User is null. Cannot fetch indirect income.');
      return;
    }

    final userId = user.userId; // Retrieve userId

    try {
      final response = await http.post(
        Uri.parse('https://mmm.klizardtechnology.com/signup/get_total_income'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user_id': userId}), // Pass the userId in the body as JSON
      );

      if (response.statusCode == 200) {
        print(response.body);
        // Parse the JSON response body
        final jsonResponse = jsonDecode(response.body);

        // Check for the expected structure
        if (jsonResponse['status'] == true) {
          setState(() {
            total_income =
                '\$${jsonResponse['total_income']}'; // Extract income field
          });
        } else {
          // If API returns status as false, handle error
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        // Handle error for non-200 response codes
        print(
            'Failed to load indirect income. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions during the request
      print('Error: $e');
    }
  }
*/
  @override
  void dispose() {
    typingTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          "✅ AppLocalization locale: ${AppLocalizations.of(context)?.localeName}");
      print(
          "🌍 Provider locale: ${Provider.of<LanguageProvider>(context, listen: false).selectedLocale.languageCode}");
    });
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    // Access UserProvider directly within build
    final userProvider = Provider.of<UserProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    // final incomeWallet = userProvider.user?.income_wallet ?? 0;
    // double activationWallet = userProvider.user?.activation_wallet ?? 0.0;

    // This part updates activationWallet dynamically

    /*
    List<Map<String, dynamic>> walletOptions = [
      {
        'title': 'My Investment',
        'icon': Icons.attach_money_rounded,
        'price': '\$$investmentAmount',
      },
      {
        'title': 'Withdrawal',
        'icon': Icons.money_off,
        'price': '\$$withdrawalAmount', // Update with actual data if available
      },
      {
        'title': 'Activation Wallet',
        'icon': Icons.wallet_rounded,
        'price': '\$$activationWallet', // Reflect the updated activationWallet
      },
      {
        'title': 'Income Wallet',
        'icon': Icons.moving_sharp,
        'price': '\$$incomeWallet', // Update with actual data if available
      },
    ];
    */

    return DefaultTabController(
      length: 4,
      child: BaseScaffold(
        title: 'Ambrosia Ayurved',
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView to make it scrollable
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Carousel(),
                const SizedBox(height: 20),
                ProductDetailPage(),
                //   ProductList(),
                SizedBox(height: 30),
                // Tab Bar
                TabBar(
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.teal,
                  tabs: const [
                    Tab(text: 'Benefits'),
                    Tab(text: 'Ingredients'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'More'),
                  ],
                ),

                Benefits(),
                SizedBox(height: 15),
                Ingredients(),
                SizedBox(height: 15),
                AnimatedCountersScreen(),

                SizedBox(height: 50),
                WhyA5Section(),
                const SizedBox(height: 20),
                WhyUsScreen(),
                SizedBox(height: 35),
                FeaturesSection(),
                // SizedBox(height: 10),
                //  Footer(),
                //  AppFooter(),
                FooterNew(),
                //  const SizedBox(height: 50),

                // commented code of mlm
                //
                /*   TextField(
                  decoration: InputDecoration(
                    hintText: visibleHintText,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    // Implement search logic here
                  },
                ), */

                /*       const SizedBox(height: 25),
        
                ProductCategory(),
        
                const SizedBox(height: 25),
        
                Carousel(),
        
                const SizedBox(height: 25),
        
                ProductListPage(),
        
                const SizedBox(height: 25),
                */

                // GridView for displaying wallet options
                /*      GridView.builder(
                  shrinkWrap:
                      true, // Allows GridView to fit inside SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 14.0,
                    mainAxisSpacing: 14.0,
                    childAspectRatio: 1.0, // Make it square
                  ),
                  itemCount: walletOptions.length,
                  itemBuilder: (context, index) {
                    var wallet = walletOptions[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 4,
                      child: InkWell(
                        onTap: () {
                          // Handle on tap for each wallet
                          print('${wallet['title']} tapped');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(wallet['icon'], size: 40, color: Colors.blue),
                              const SizedBox(height: 16),
                              Text(
                                wallet['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                wallet['price'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Referral and Income Cards
                Card(
                  elevation: 4,
                  color: Colors.yellow[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.group, size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "My Referral",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "View your referrals here",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    totalReferrals, // Display total referral count
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const SizedBox(
                                      height:
                                          15), // Space before the progress bar
                                  // Progress Bar
                                  LinearProgressIndicator(
                                    value:
                                        0.3, // Replace with a dynamic value as needed
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    color:
                                        Colors.grey[700], // Color of the progress
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Active Referral Card
                Card(
                  elevation: 4,
                  color: Colors.yellow[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.group_add_rounded,
                                size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Active Referrals",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Manage your active referrals here",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    activeUsersCount, // Display active referral count
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const SizedBox(
                                      height:
                                          15), // Space before the progress bar
                                  // Progress Bar
                                  LinearProgressIndicator(
                                    value:
                                        0.7, // Replace with a dynamic value as needed
                                    backgroundColor:
                                        Colors.white.withOpacity(0.3),
                                    color: Colors.grey, // Color of the progress
                                  ),
                                  const SizedBox(
                                      height: 8), // Space after the progress bar
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Direct Income Card
                Card(
                  elevation: 4,
                  color: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.attach_money,
                                size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Direct Income",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    directIncome,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Indirect Income Card
                Card(
                  elevation: 4,
                  color: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_off, size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Indirect Income",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    indirectIncome,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space at the bottom
        
                // Indirect Income Card
                Card(
                  elevation: 4,
                  color: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_off, size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "ROI Income",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    roiIncome,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space at the bottom
                // Indirect Income Card
                Card(
                  elevation: 4,
                  color: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_off, size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Team Earning Income",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    teamearnIncome,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space at the bottom
        
                // Indirect Income Card
                Card(
                  elevation: 4,
                  color: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_off, size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Salary  Income",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    salaryIncome,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Space at the bottom
        
                // Indirect Income Card
                Card(
                  elevation: 4,
                  color: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.all(35.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money_off, size: 40, color: Colors.white),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Income",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    total_income,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}


*/