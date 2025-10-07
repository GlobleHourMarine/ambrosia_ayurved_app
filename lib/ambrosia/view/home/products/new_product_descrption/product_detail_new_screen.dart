import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_cached_image.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_loading_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/users_cart/cart_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/3_months_plan.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_benefits.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/ambrosia_static_details/foods_to_avoid.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_how_to_use_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_ingredients.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_specification_section.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/products_faq.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_description_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/products_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/review_section/review_section_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// New Model Classes
class ProductDetailResponse {
  final bool status;
  final String message;
  final ProductData data;

  ProductDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ProductData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProductData {
  final String productId;
  final String productName;
  final String title;
  final String description;
  final String slug;
  final String price;
  final List<String> images;
  final List<ReviewItem> reviews;
  final List<BenefitItem> benefits;
  final List<HowToUseStep> howToUse;
  final List<FAQItem> faq;

  ProductData({
    required this.productId,
    required this.productName,
    required this.title,
    required this.description,
    required this.slug,
    required this.price,
    required this.images,
    required this.reviews,
    required this.benefits,
    required this.howToUse,
    required this.faq,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      title: json['tittle'] ?? '',
      description: json['discription'] ?? '',
      slug: json['slug'] ?? '',
      price: json['price'] ?? '',
      images: List<String>.from(json['image'] ?? []),
      reviews: (json['reviews'] as List? ?? [])
          .map((r) => ReviewItem.fromJson(r))
          .toList(),
      benefits: (json['benefits'] as List? ?? [])
          .map((b) => BenefitItem.fromJson(b))
          .toList(),
      howToUse: (json['how_to_use'] as List? ?? [])
          .map((h) => HowToUseStep.fromJson(h))
          .toList(),
      faq: (json['f_and_q'] as List? ?? [])
          .map((f) => FAQItem.fromJson(f))
          .toList(),
    );
  }
}

class ReviewItem {
  final String reviewId;
  final String userId;
  final String rating;
  final List<String> filePath;
  final String message;
  final String date;
  final String fname;

  ReviewItem({
    required this.reviewId,
    required this.userId,
    required this.rating,
    required this.filePath,
    required this.message,
    required this.date,
    required this.fname,
  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      reviewId: json['review_id'] ?? '',
      userId: json['user_id'] ?? '',
      rating: json['rating'] ?? '0',
      filePath: List<String>.from(json['file_path'] ?? []),
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      fname: json['fname'] ?? '',
    );
  }
}

class BenefitItem {
  final String id;
  final String title;
  final String image;
  final String description;

  BenefitItem({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory BenefitItem.fromJson(Map<String, dynamic> json) {
    return BenefitItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class HowToUseStep {
  final String id;
  final String title;
  final String stepNumber;
  final String description;
  final String image;

  HowToUseStep({
    required this.id,
    required this.title,
    required this.stepNumber,
    required this.description,
    required this.image,
  });

  factory HowToUseStep.fromJson(Map<String, dynamic> json) {
    return HowToUseStep(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      stepNumber: json['step_number'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class FAQItem {
  final String id;
  final String productId;
  final String question;
  final String answer;

  FAQItem({
    required this.id,
    required this.productId,
    required this.question,
    required this.answer,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class ProductDetailNewPage1 extends StatefulWidget {
  final Product product;
  const ProductDetailNewPage1({super.key, required this.product});

  @override
  State<ProductDetailNewPage1> createState() => ProductDetailNewPage1State();
}

class ProductDetailNewPage1State extends State<ProductDetailNewPage1>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys for each section
  final GlobalKey _descriptionKey = GlobalKey();
  final GlobalKey _benefitsKey = GlobalKey();
  final GlobalKey _howToUseKey = GlobalKey();
  final GlobalKey _ingredientsKey = GlobalKey();
  final GlobalKey _reviewsKey = GlobalKey();

  // Loading state
  bool _isLoading = true;
  bool _isProgrammaticScroll = false;

  // Store fetched data
  ProductData? _productData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchProductData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchProductData() async {
    try {
      final url = Uri.parse(
          'https://ambrosiaayurved.in/api/fetch_products_data?product_id=${widget.product.id}');
      final response = await http.get(url);
      final jsonResponse = json.decode(response.body);
      print('product description reponse : $jsonResponse');
      if (response.statusCode == 200) {
        //   final jsonResponse = json.decode(response.body);
        final productResponse = ProductDetailResponse.fromJson(jsonResponse);

        if (productResponse.status) {
          setState(() {
            _productData = productResponse.data;
            _isLoading = false;
          });
        } else {
          throw Exception(productResponse.message);
        }
      } else {
        throw Exception('Failed to load product data');
      }
    } catch (e) {
      print('Error fetching product data: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_isProgrammaticScroll) return;

    double scrollOffset = _scrollController.offset;

    double descOffset = _getOffsetFromGlobalKey(_descriptionKey) ?? 0.0;
    double benefitsOffset = _getOffsetFromGlobalKey(_benefitsKey) ?? 0.0;
    double howToUseOffset = _getOffsetFromGlobalKey(_howToUseKey) ?? 0.0;
    double ingredientsOffset =
        _getOffsetFromGlobalKey(_ingredientsKey) ?? double.infinity;
    double reviewsOffset =
        _getOffsetFromGlobalKey(_reviewsKey) ?? double.infinity;

    int newIndex = 0;

    if (scrollOffset >= reviewsOffset - 100) {
      newIndex = 4;
    } else if (scrollOffset >= ingredientsOffset - 100) {
      newIndex = 3;
    } else if (scrollOffset >= howToUseOffset - 100) {
      newIndex = 2;
    } else if (scrollOffset >= benefitsOffset - 100) {
      newIndex = 1;
    } else {
      newIndex = 0;
    }

    if (_tabController.index != newIndex) {
      _tabController.animateTo(newIndex);
    }
  }

  void _scrollToSection(int tabIndex) {
    double targetOffset = 0;

    switch (tabIndex) {
      case 0:
        targetOffset = _getOffsetFromGlobalKey(_descriptionKey) ?? 0;
        break;
      case 1:
        targetOffset = _getOffsetFromGlobalKey(_benefitsKey) ?? 0;
        break;
      case 2:
        targetOffset = _getOffsetFromGlobalKey(_howToUseKey) ?? 0;
        break;
      case 3:
        targetOffset = _getOffsetFromGlobalKey(_ingredientsKey) ?? 0;
        break;
      case 4:
        targetOffset = _getOffsetFromGlobalKey(_reviewsKey) ?? 0;
        break;
    }

    _isProgrammaticScroll = true;
    _scrollController
        .animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    )
        .then((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _isProgrammaticScroll = false;
      });
    });
  }

  double? _getOffsetFromGlobalKey(GlobalKey key) {
    try {
      final RenderBox? box =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        double y = box.localToGlobal(Offset.zero).dy;
        double appBarHeight = kToolbarHeight;
        double statusBarHeight = MediaQuery.of(context).padding.top;
        return _scrollController.offset + y - (appBarHeight + statusBarHeight);
      }
    } catch (_) {}
    return null;
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

  Widget _buildLoadingWidget() {
    return AnimatedLoadingScreen(
      message: 'Loading product details...',
      primaryColor: Acolors.primary,
      animationDuration: Duration(milliseconds: 1000),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load product details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          //   Text(_errorMessage ?? 'Unknown error'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _fetchProductData();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
          : _errorMessage != null
              ? _buildErrorWidget()
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              key: _descriptionKey,
                              child: ProductDescriptionScreen(
                                product: widget.product,
                                productData: _productData!,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              key: _benefitsKey,
                              child: BenefitsWidget(
                                benefits: _productData!.benefits,
                              ),
                            ),
                            Container(
                              key: _howToUseKey,
                              child: HowToUseSectionWidget(
                                steps: _productData!.howToUse,
                              ),
                            ),
                            if (widget.product.slug == 'a5-herbal-supplement')
                              FoodsToAvoidSection(),
                            Container(
                              key: _ingredientsKey,
                              child:
                                  widget.product.slug == 'a5-herbal-supplement'
                                      ? Ingredients()
                                      : SizedBox.shrink(),
                            ),
                            Container(
                              key: _reviewsKey,
                              child: Column(
                                children: [
                                  if (widget.product.slug ==
                                      'a5-herbal-supplement')
                                    ProductSpecificationsSection(),
                                  CustomerReviewSectionWidget(
                                    reviews: _productData!.reviews,
                                  ),
                                  // FAQWidget(
                                  //   faqs: _productData!.faq,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 100),
                          ],
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
                                text: AppLocalizations.of(context)!
                                    .keyIngredients,
                              ),
                              Tab(
                                icon: const Icon(Icons.star),
                                text: AppLocalizations.of(context)!
                                    .customerReviews,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 110,
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

class HowToUseSectionWidget extends StatelessWidget {
  List<HowToUseStep> steps = [];
  //final List<HowToUseStep> how_to_use;
  HowToUseSectionWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (steps.isEmpty) {
      return SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.howToUse,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: steps
                    .map((step) => Column(
                          children: [
                            _buildStep(
                              title: step.title,
                              description: step.description,
                              imageUrl: step.image,
                            ),
                            Divider(
                              color: Colors.brown[300],
                              thickness: 1.5,
                              height: 25,
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String description,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://ambrosiaayurved.in/${imageUrl}',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 110);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BenefitsWidget extends StatelessWidget {
  final List<BenefitItem> benefits;

  const BenefitsWidget({super.key, required this.benefits});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (benefits.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            t.benefits,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        Column(
          children: benefits.map((item) {
            return _buildBenefitItem(
              imagePath: 'https://ambrosiaayurved.in/${item.image}',
              boldText: item.title,
              description: item.description,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBenefitItem({
    required String imagePath,
    required String boldText,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 250,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 300,
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              boldText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}

class CustomerReviewSectionWidget extends StatefulWidget {
  final List<ReviewItem> reviews;

  const CustomerReviewSectionWidget({super.key, required this.reviews});

  @override
  State<CustomerReviewSectionWidget> createState() =>
      _CustomerReviewSectionWidgetState();
}

class _CustomerReviewSectionWidgetState
    extends State<CustomerReviewSectionWidget> {
  int visibleReviewCount = 4;
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    calculateAverageRating();
  }

  void calculateAverageRating() {
    if (widget.reviews.isNotEmpty) {
      double totalRating = widget.reviews
          .map((review) => double.tryParse(review.rating) ?? 0.0)
          .fold(0.0, (prev, rating) => prev + rating);
      averageRating = totalRating / widget.reviews.length;
    }
  }

  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.green,
          size: 24,
        );
      }),
    );
  }

  bool isVideoFile(String path) {
    final videoExtensions = [
      '.mp4',
      '.avi',
      '.mov',
      '.mkv',
      '.flv',
      '.wmv',
      '.webm',
      '.m4v'
    ];
    String lowerPath = path.toLowerCase();
    return videoExtensions.any((ext) => lowerPath.contains(ext));
  }

  bool isImageFile(String path) {
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.svg'
    ];
    String lowerPath = path.toLowerCase();
    return imageExtensions.any((ext) => lowerPath.contains(ext));
  }

  Widget _buildMediaWidget(
      String path, BuildContext context, List<String> allPaths) {
    if (isVideoFile(path)) {
      // Use your existing VideoThumbnailWidget
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey[300],
        child: Center(
          child: Icon(Icons.play_circle_outline, size: 50, color: Colors.green),
        ),
      );
    } else if (isImageFile(path)) {
      return GestureDetector(
        onTap: () {
          List<String> imagePaths =
              allPaths.where((p) => isImageFile(p)).toList();
          int initialIndex = imagePaths.indexOf(path);

          if (initialIndex >= 0) {
            _showImageSlider(context, imagePaths, initialIndex);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://ambrosiaayurved.in/$path',
            fit: BoxFit.cover,
            width: 150,
            height: 150,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                width: 150,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 50),
              );
            },
          ),
        ),
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey[300],
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 100,
        ),
      );
    }
  }

  void _showImageSlider(
      BuildContext context, List<String> imageUrls, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
          backgroundColor: Colors.black,
          child: Stack(children: [
            PageView.builder(
              itemCount: imageUrls.length,
              controller: PageController(initialPage: initialIndex),
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Image.network(
                    'https://ambrosiaayurved.in/${imageUrls[index]}',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    int reviewsToShow = visibleReviewCount.clamp(0, widget.reviews.length);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  '${AppLocalizations.of(context)!.customerReviews}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          buildStarRating(averageRating.toInt()),
                          const SizedBox(width: 10),
                          Text(
                            "${averageRating.toStringAsFixed(1)} / 5.0",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                          '${AppLocalizations.of(context)!.basedOnReviews(widget.reviews.length)}'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.reviews.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('${AppLocalizations.of(context)!.noReviewsYet}',
                        style: TextStyle(fontSize: 16)),
                  )
                else
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviewsToShow,
                        itemBuilder: (context, index) {
                          final review = widget.reviews[index];
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.fname,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    review.date,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  if (review.filePath.isNotEmpty) ...[
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: review.filePath
                                            .map<Widget>(
                                              (path) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: _buildMediaWidget(path,
                                                    context, review.filePath),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                  buildStarRating(int.parse(review.rating)),
                                  const SizedBox(height: 5),
                                  Text(
                                    review.message,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      if (widget.reviews.length > 4)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (visibleReviewCount + 4 <
                                  widget.reviews.length) {
                                visibleReviewCount += 4;
                              } else if (visibleReviewCount <
                                  widget.reviews.length) {
                                visibleReviewCount = widget.reviews.length;
                              } else {
                                visibleReviewCount = 4;
                              }
                            });
                          },
                          child: Text(
                            visibleReviewCount >= widget.reviews.length
                                ? '${AppLocalizations.of(context)!.showLess}'
                                : '${AppLocalizations.of(context)!.readMore}',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class ProductDescriptionScreen extends StatefulWidget {
  final Product product;
  final ProductData productData;

  const ProductDescriptionScreen({
    super.key,
    required this.product,
    required this.productData,
  });

  @override
  _ProductDescriptionScreenState createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen>
    with TickerProviderStateMixin {
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    return _buildProductDetailsPage(context);
  }

  Widget _buildProductDetailsPage(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildProductImagesWidgets(),
              _buildProductTitleWidget(),
              SizedBox(height: 12.0),
              _buildPriceWidgets(),
              SizedBox(height: 12.0),
              _buildDivider(screenSize),
              SizedBox(height: 12.0),
              _buildStyleNoteData(),
              SizedBox(height: 12),
              // if (widget.product.id == 1) ...[
              //   _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit1),
              //   _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit2),
              //   _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit3),
              //   _buildBenefitRow(AppLocalizations.of(context)!.a5Benefit4),
              // ],
              SizedBox(height: 20.0),
            ],
          ),
        ),
        bottomCartSection(),
      ],
    );
  }

  Widget _buildProductImagesWidgets() {
    List<String> imageList = widget.productData.images;
    PageController _pageController = PageController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 400.0,
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                return CustomCachedImage(
                  imageUrl: 'https://ambrosiaayurved.in/${imageList[index]}',
                  fit: BoxFit.contain,
                  shimmerWidth: 250,
                  shimmerHeight: 250,
                );
                // Image.network(
                //   'https://ambrosiaayurved.in/${imageList[index]}',
                //   fit: BoxFit.contain,
                //   loadingBuilder: (context, child, progress) {
                //     if (progress == null) return child;
                //     return Center(child: CircularProgressIndicator());
                //   },
                //   errorBuilder: (context, error, stackTrace) {
                //     return const Icon(
                //       Icons.image_not_supported,
                //       color: Colors.grey,
                //       size: 100,
                //     );
                //   },
                // );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(imageList.length, (index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double selected = (_pageController.page ?? 0).roundToDouble();
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: selected == index ? 12.0 : 8.0,
                    height: selected == index ? 12.0 : 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected == index ? Colors.grey : Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTitleWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            widget.productData.productName,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: <Widget>[
          Text(
            "\Rs ${widget.productData.price}",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Size screenSize) {
    return Container(
      color: Colors.grey[600],
      width: screenSize.width,
      height: 0.25,
    );
  }

  Widget _buildStyleNoteData() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        widget.productData.description,
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 47, 47, 47)),
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomCartSection() {
    final cart = Provider.of<CartProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 160,
            width: screenWidth * 0.25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              color: Acolors.primary,
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 10, right: 20),
                  height: 120,
                  width: screenWidth - 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      topLeft: Radius.circular(35),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Acolors.primary)
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          widget.productData.productName,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '\Rs ${widget.productData.price}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      SizedBox(
                        height: 30,
                        width: screenWidth * 0.45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Acolors.primary,
                          ),
                          onPressed: _isAddingToCart
                              ? null
                              : () async {
                                  setState(() {
                                    _isAddingToCart = true;
                                  });

                                  await Provider.of<CartProvider>(context,
                                          listen: false)
                                      .addToCart(
                                    widget.product.id.toString(),
                                    widget.productData.productName,
                                    context,
                                  );

                                  setState(() {
                                    _isAddingToCart = false;
                                  });
                                },
                          child: _isAddingToCart
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Acolors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.addtocart,
                                      style: TextStyle(color: Acolors.white),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Acolors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              color: Acolors.primary,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Acolors.primary,
                        ),
                      ),
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
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
