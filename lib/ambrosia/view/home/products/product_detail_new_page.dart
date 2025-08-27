import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/3_months_plan.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_benefits.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/foods_to_avoid.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_how_to_use_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_ingredients.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/products_faq.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_description_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
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
