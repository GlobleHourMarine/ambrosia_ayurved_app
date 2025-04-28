import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/cart_page.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_list.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MedicineScreen extends StatefulWidget {
  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  @override
  void initState() {
    super.initState();

    _fetchCartData();
  }

  void _fetchCartData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (userProvider.id != null) {
      cartProvider.fetchCartData(userProvider.id);
    }
  }

  final Map<String, dynamic> product = {
    "name": "A5",
    "image": "assets/images/mediciene.png",
    "explanation":
        "A5 Sugar Medicine Powder is a revolutionary health supplement designed to support balanced sugar levels naturally. Formulated with a blend of high-quality, safe, and effective ingredients, it promotes overall wellness while helping to manage sugar intake. Whether you’re looking to maintain a healthy lifestyle or need support for your health goals, A5 Sugar Medicine Powder is the perfect companion.",
    "usage":
        "Apply a small amount to clean skin and gently massage until fully absorbed. Can be used as a moisturizer, after-sun treatment, or overnight mask.",
    "ingredients": [
      {
        "name": "Olive Extract",
        "image": "assets/images/category_amala.png",
        "description":
            "Olive hydrates and soothes skin, reducing irritation and redness.",
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
    final cart = Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 70,
                color: Acolors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.white.withOpacity(0.21),
                        borderRadius: BorderRadius.circular(12),
                        child: const BackButton(
                          color: Acolors.white,
                        ),
                      ),
                      //  const SizedBox(width: 30),
                      const Text(
                        'Medicine',
                        style: TextStyle(fontSize: 24, color: Acolors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1),
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
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
