import 'dart:ui';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';

class SkincareScreen extends StatelessWidget {
  final Map<String, dynamic> product = {
    "name": "Face Creame",
    "image": "assets/images/creame.png",
    "explanation":
        "Face cream is an essential skincare product used to moisturize, nourish, and protect the skin. It comes in various formulations, designed to address different skin concerns such as dryness, aging, acne, hyperpigmentation, and sun protection. Regular use of a good face cream helps maintain a healthy, youthful, and glowing complexion.",
    "usage":
        "Apply a small amount to clean skin and gently massage until fully absorbed. Can be used as a moisturizer, after-sun treatment, or overnight mask.",
    "ingredients": [
      {
        "name": "Olive Extract",
        "image": "assets/images/category_amala.png",
        "description":
            "Aloe vera hydrates and soothes skin, reducing irritation and redness.",
      },
      {
        "name": "Vitamin E",
        "image": "assets/images/category_vitmen_e.png",
        "description":
            "Vitamin E is an antioxidant that protects the skin from damage and keeps it nourished.",
      },
      {
        "name": "Green Tea Extract",
        "image": "assets/images/category_leaf.png",
        "description":
            "Green tea has anti-aging properties and helps in controlling acne.",
      },
      {
        "name": "Black Pepper",
        "image": "assets/images/category_black_pepper.png",
        "description":
            "Black pepper locks in moisture, keeping your skin soft and hydrated.",
      },
      {
        "name": "Essential Oils",
        "image": "assets/images/category_amala.png",
        "description":
            "Essential oils provide a natural fragrance and have therapeutic benefits for the skin.",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const BackButton(color: Colors.black),
        title: 'Skin care',
      ),
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   height: 70,
                //   color: Acolors.primary,
                //   child: Padding(
                //     padding: const EdgeInsets.all(12),
                //     child: Row(
                //       children: [
                //         Material(
                //           color: Colors.white.withOpacity(0.21),
                //           borderRadius: BorderRadius.circular(12),
                //           child: const BackButton(
                //             color: Acolors.white,
                //           ),
                //         ),
                //         const SizedBox(width: 30),
                //         const Text(
                //           'Skin Care',
                //           style:
                //               TextStyle(fontSize: 24, color: Acolors.white),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              product["image"],
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Product Name
                          Text(
                            product["name"],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Explanation
                          Text(
                            product["explanation"],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),

                          // Usage Instructions
                          const Text(
                            "How to Use:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product["usage"],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),

                          // Ingredients Section
                          const Text(
                            "Ingredients:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Column(
                            children: product["ingredients"]
                                .map<Widget>((ingredient) {
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      ingredient["image"],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    ingredient["name"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    ingredient["description"],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    /*
                    // Blur Overlay with "Coming Soon" Text
                    Positioned.fill(
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            color: Colors.black
                                .withOpacity(0.5), // Dark overlay effect
                            alignment: Alignment.center,
                            child: const Text(
                              "Coming Soon",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    */
                  ],
                ),
              ],
            ),
          ),

          // Blur Overlay with "Coming Soon" Text
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Dark overlay effect
                  alignment: Alignment.center,
                  child: const Text(
                    "Coming Soon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
