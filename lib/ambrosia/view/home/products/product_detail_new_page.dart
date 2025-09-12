import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_loading_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/3_months_plan.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_benefits.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/foods_to_avoid.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_how_to_use_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_ingredients.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/products_faq.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_description_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailNewPage extends StatefulWidget {
  final Product product;
  const ProductDetailNewPage({super.key, required this.product});

  @override
  State<ProductDetailNewPage> createState() => ProductDetailNewPageState();
}

class ProductDetailNewPageState extends State<ProductDetailNewPage>
    with SingleTickerProviderStateMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late TabController _tabController;

  final List<int> sectionIndices = [0, 2, 3, 4, 5];

  // Centralized loading state
  bool _isLoading = true;
  Map<String, bool> _loadingStates = {
    'benefits': true,
    'howToUse': true,
    'ingredients': true,
    'reviews': true,
    'faq': true,
  };

  // Scroll prevention variables
  bool _isUserScrolling = true;
  bool _isProgrammaticScroll = false;
  int _lastTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Initialize all API calls
    _initializeAllData();

    // Setup scroll listener (only after data is loaded)
    itemPositionsListener.itemPositions.addListener(() {
      if (!_isProgrammaticScroll && _isUserScrolling && !_isLoading) {
        _updateTabBasedOnScroll();
      }
    });
  }

  // Initialize all API calls at once
  Future<void> _initializeAllData() async {
    try {
      // Call all APIs simultaneously
      await Future.wait([
        _loadBenefits(),
        _loadHowToUse(),
        _loadIngredients(),
        _loadReviews(),
        _loadFAQ(),
      ]);

      // All APIs completed
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error - you might want to show error state
      print('Error loading data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Individual API loading methods
  Future<void> _loadBenefits() async {
    try {
      // Your benefits API call here
      // await YourBenefitsAPI.fetch(widget.product.id.toString());
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      _markAsLoaded('benefits');
    } catch (e) {
      _markAsLoaded('benefits');
    }
  }

  Future<void> _loadHowToUse() async {
    try {
      // Your how to use API call here
      // await YourHowToUseAPI.fetch(widget.product.id.toString());
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      _markAsLoaded('howToUse');
    } catch (e) {
      _markAsLoaded('howToUse');
    }
  }

  Future<void> _loadIngredients() async {
    try {
      // Your ingredients API call here (if product id is 14)
      if (widget.product.id == 14) {
        // await YourIngredientsAPI.fetch();
        await Future.delayed(Duration(seconds: 1)); // Simulate API call
      }
      _markAsLoaded('ingredients');
    } catch (e) {
      _markAsLoaded('ingredients');
    }
  }

  Future<void> _loadReviews() async {
    try {
      // Your reviews API call here
      // await YourReviewsAPI.fetch(widget.product.id.toString());
      await Future.delayed(Duration(seconds: 3)); // Simulate API call
      _markAsLoaded('reviews');
    } catch (e) {
      _markAsLoaded('reviews');
    }
  }

  Future<void> _loadFAQ() async {
    try {
      // Your FAQ API call here
      // await YourFAQAPI.fetch(widget.product.id.toString());
      await Future.delayed(Duration(seconds: 1)); // Simulate API call
      _markAsLoaded('faq');
    } catch (e) {
      _markAsLoaded('faq');
    }
  }

  void _markAsLoaded(String key) {
    if (mounted) {
      setState(() {
        _loadingStates[key] = false;
      });
    }
  }

  void _updateTabBasedOnScroll() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    int mostVisibleIndex = 0;
    double maxVisibility = 0;

    for (final position in positions) {
      final sectionIndex = _getSectionIndexFromItemIndex(position.index);
      if (sectionIndex != -1) {
        final visibility = position.itemTrailingEdge - position.itemLeadingEdge;
        if (visibility > maxVisibility) {
          maxVisibility = visibility;
          mostVisibleIndex = sectionIndex;
        }
      }
    }

    if (_tabController.index != mostVisibleIndex &&
        _lastTabIndex != mostVisibleIndex) {
      _lastTabIndex = mostVisibleIndex;
      _tabController.animateTo(mostVisibleIndex);
    }
  }

  int _getSectionIndexFromItemIndex(int itemIndex) {
    for (int i = 0; i < sectionIndices.length; i++) {
      if (i == sectionIndices.length - 1 || itemIndex < sectionIndices[i + 1]) {
        return i;
      }
    }
    return -1;
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

  void _scrollToSection(int tabIndex) async {
    if (tabIndex >= 0 && tabIndex < sectionIndices.length && !_isLoading) {
      _isProgrammaticScroll = true;
      _isUserScrolling = false;
      _lastTabIndex = tabIndex;

      await itemScrollController.scrollTo(
        index: sectionIndices[tabIndex],
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _isProgrammaticScroll = false;
          _isUserScrolling = true;
        }
      });
    }
  }

// Or simply:
  Widget _buildLoadingWidget() {
    return AnimatedLoadingScreen(
      message: 'Loading product details...',
      primaryColor: Acolors.primary,
      animationDuration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const BackButton(color: Colors.black),
        title: widget.product.name,
      ),
      body: _isLoading
          ? _buildLoadingWidget()
          : Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      _isUserScrolling = true;
                    }
                    return false;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: ScrollablePositionedList.builder(
                      itemCount: 7,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Column(
                              children: [
                                const SizedBox(height: 10),
                                ProductDescriptionScreen(
                                  product: widget.product,
                                ),
                              ],
                            );
                          case 1:
                            return const SizedBox(height: 20);
                          case 2:
                            return Benefits(
                              productId: widget.product.id.toString(),
                            );
                          case 3:
                            return Column(
                              children: [
                                HowToUseSection(
                                  productId: widget.product.id.toString(),
                                ),
                                if (widget.product.id == 1)
                                  ThreeMonthPlan()
                                else
                                  const SizedBox.shrink(),
                                if (widget.product.id == 1)
                                  FoodsToAvoidSection()
                                else
                                  const SizedBox.shrink(),
                              ],
                            );
                          case 4:
                            return widget.product.id == 1
                                ? Ingredients()
                                : const SizedBox.shrink();
                          case 5:
                            return Column(
                              children: [
                                CustomerReviewSection(
                                    productId: widget.product.id.toString()),
                                FAQPage(
                                  productId: widget.product.id.toString(),
                                ),
                              ],
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  ),
                ),

                // Fixed tab bar
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
                        onTap: _scrollToSection,
                        indicatorColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            icon: const Icon(Icons.info),
                            text: AppLocalizations.of(context)!.tabDetails,
                          ),
                          Tab(
                            icon: const Icon(Icons.health_and_safety),
                            text: AppLocalizations.of(context)!.tabBenefits,
                          ),
                          Tab(
                            icon: const Icon(Icons.eco),
                            text: AppLocalizations.of(context)!.tabUsage,
                          ),
                          Tab(
                            icon: const Icon(Icons.reviews),
                            text: AppLocalizations.of(context)!.keyIngredients,
                          ),
                          Tab(
                            icon: const Icon(Icons.star),
                            text: AppLocalizations.of(context)!.customerReviews,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // WhatsApp FAB
                Positioned(
                  bottom: 85,
                  right: 20,
                  child: FloatingActionButton(
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
    );
  }
}


/// without loader 
/*
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/3_months_plan.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_benefits.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/foods_to_avoid.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_how_to_use_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_ingredients.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/products_faq.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_description_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailNewPage extends StatefulWidget {
  final Product product;
  const ProductDetailNewPage({super.key, required this.product});

  @override
  State<ProductDetailNewPage> createState() => ProductDetailNewPageState();
}

class ProductDetailNewPageState extends State<ProductDetailNewPage>
    with SingleTickerProviderStateMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late TabController _tabController;

  final List<int> sectionIndices = [0, 2, 3, 4, 5];

  // Add these variables to prevent feedback loops
  bool _isUserScrolling = true;
  bool _isProgrammaticScroll = false;
  int _lastTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 5, vsync: this);

    // Improved listener with debouncing and feedback loop prevention
    itemPositionsListener.itemPositions.addListener(() {
      // Only update tab if user is scrolling (not programmatic scroll)
      if (!_isProgrammaticScroll && _isUserScrolling) {
        _updateTabBasedOnScroll();
      }
    });
  }

  void _updateTabBasedOnScroll() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the most visible section
    int mostVisibleIndex = 0;
    double maxVisibility = 0;

    for (final position in positions) {
      final sectionIndex = _getSectionIndexFromItemIndex(position.index);
      if (sectionIndex != -1) {
        final visibility = position.itemTrailingEdge - position.itemLeadingEdge;
        if (visibility > maxVisibility) {
          maxVisibility = visibility;
          mostVisibleIndex = sectionIndex;
        }
      }
    }

    // Only update if the tab actually changed
    if (_tabController.index != mostVisibleIndex &&
        _lastTabIndex != mostVisibleIndex) {
      _lastTabIndex = mostVisibleIndex;
      _tabController.animateTo(mostVisibleIndex);
    }
  }

  int _getSectionIndexFromItemIndex(int itemIndex) {
    for (int i = 0; i < sectionIndices.length; i++) {
      if (i == sectionIndices.length - 1 || itemIndex < sectionIndices[i + 1]) {
        return i;
      }
    }
    return -1;
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

  // Improved scroll to section method
  void _scrollToSection(int tabIndex) async {
    if (tabIndex >= 0 && tabIndex < sectionIndices.length) {
      _isProgrammaticScroll = true;
      _isUserScrolling = false;
      _lastTabIndex = tabIndex;

      await itemScrollController.scrollTo(
        index: sectionIndices[tabIndex],
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1, // Scroll to near the top
      );

      // Re-enable user scrolling detection after a delay
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _isProgrammaticScroll = false;
          _isUserScrolling = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.product.name,
      ),
      body: Stack(
        children: [
          // Add NotificationListener to detect user scrolling
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _isUserScrolling = true;
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ScrollablePositionedList.builder(
                itemCount: 7,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          ProductDescriptionScreen(
                            product: widget.product,
                          ),
                        ],
                      );
                    case 1:
                      return const SizedBox(height: 20);
                    case 2:
                      return Benefits(
                        productId: widget.product.id.toString(),
                      );
                    case 3:
                      return Column(
                        children: [
                          HowToUseSection(
                            productId: widget.product.id.toString(),
                          ),
                          if (widget.product.id == 14)
                            ThreeMonthPlan()
                          else
                            const SizedBox.shrink(),
                          if (widget.product.id == 14)
                            FoodsToAvoidSection()
                          else
                            const SizedBox.shrink(),
                        ],
                      );
                    case 4:
                      return widget.product.id == 14
                          ? Ingredients()
                          : const SizedBox.shrink();
                    case 5:
                      return Column(
                        children: [
                          CustomerReviewSection(
                              productId: widget.product.id.toString()),
                          FAQPage(
                            productId: widget.product.id.toString(),
                          ),
                        ],
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ),

          // Fixed tab bar
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
                  onTap: _scrollToSection, // Use the improved method
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.info),
                      text: AppLocalizations.of(context)!.tabDetails,
                    ),
                    Tab(
                      icon: const Icon(Icons.health_and_safety),
                      text: AppLocalizations.of(context)!.tabBenefits,
                    ),
                    Tab(
                      icon: const Icon(Icons.eco),
                      text: AppLocalizations.of(context)!.tabUsage,
                    ),
                    Tab(
                      icon: const Icon(Icons.reviews),
                      text: AppLocalizations.of(context)!.keyIngredients,
                    ),
                    Tab(
                      icon: const Icon(Icons.star),
                      text: AppLocalizations.of(context)!.customerReviews,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // WhatsApp FAB
          Positioned(
            bottom: 85,
            right: 20,
            child: FloatingActionButton(
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
    );
  }
}


*/

//old one with scrolling issue 

/*
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/3_months_plan.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_benefits.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/foods_to_avoid.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_how_to_use_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_ingredients.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/products_faq.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_description_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailNewPage extends StatefulWidget {
  final Product product;
  const ProductDetailNewPage({super.key, required this.product});

  @override
  State<ProductDetailNewPage> createState() => ProductDetailNewPageState();
}

class ProductDetailNewPageState extends State<ProductDetailNewPage>
    with SingleTickerProviderStateMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late TabController _tabController; // Use late initialization

  final List<int> sectionIndices = [0, 2, 3, 4, 5];

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

  // Add this method to launch WhatsApp
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.product.name,
      ),
      body: Stack(
        children: [
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
                        const SizedBox(height: 10),
                        // Carousel(),
                        // SizedBox(height: 10),
                        ProductDescriptionScreen(
                          product: widget.product,
                        ),
                      ],
                    );
                  case 1:
                    return const SizedBox(height: 20);
                  case 2:
                    return Benefits(
                      productId: widget.product.id.toString(),
                    );
                  case 3:
                    return Column(
                      children: [
                        HowToUseSection(
                          productId: widget.product.id.toString(),
                        ),
                        if (widget.product.id == 14)
                          ThreeMonthPlan()
                        else
                          SizedBox.shrink(),
                        if (widget.product.id == 14)
                          FoodsToAvoidSection()
                        else
                          SizedBox.shrink(),
                      ],
                    );
                  //  return HowToUseSection();
                  case 4:
                    return widget.product.id == 14
                        ? Ingredients()
                        : SizedBox.shrink();
                  case 5:
                    return Column(
                      children: [
                        CustomerReviewSection(
                            productId: widget.product.id.toString()),
                        FAQPage(
                          productId: widget.product.id.toString(),
                        ),
                      ],
                    );

                  // return Column(
                  //   children: [
                  //     SizedBox(height: 35),
                  //     WhyA5Section(),
                  //     const SizedBox(height: 20),
                  //     WhyUsScreen(),
                  //     SizedBox(height: 35),
                  //     FeaturesSection(),
                  //   ],
                  // );
                  // return AnimatedCountersScreen();
                  // case 5:
                  //   return FooterNew();
                  // return Column(
                  //   children: [
                  //     SizedBox(height: 35),
                  //     WhyA5Section(),
                  //     const SizedBox(height: 20),
                  //     WhyUsScreen(),
                  //     SizedBox(height: 35),
                  //     FeaturesSection(),
                  //   ],
                  // );
                  // case 6:
                  //   return FooterNew();

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
                      text: '${AppLocalizations.of(context)!.keyIngredients}',
                      // 'Reviews',
                    ),
                    Tab(
                      icon: Icon(Icons.star),
                      text: '${AppLocalizations.of(context)!.customerReviews}',
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
    );
  }
}



*/