import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhyUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            "${AppLocalizations.of(context)!.whyAmbrosiaAyurved}",
            // 'WHY Ambrosia Ayurved ?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        Center(
          child: Text(
            "${AppLocalizations.of(context)!.healthyInsideHappyOutside}",
            //   "Healthy Inside, Happy Outside",
            style: TextStyle(
              color: const Color.fromARGB(255, 207, 125, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //   SizedBox(height: 10),

        /// **Section 1**
        Padding(
          padding: const EdgeInsets.only(right: 1, left: 20),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// **Text Column**
                  Container(
                    width: screenWidth * 0.68,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "01",
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 207, 125, 1),
                          ),
                        ),
                        //  SizedBox(height: 10),
                        Text(
                          "${AppLocalizations.of(context)!.createdByAmbrosia}",
                          //   "CREATED BY AMBROSIA AYURVED",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "${AppLocalizations.of(context)!.createdByAmbrosiaDesc}",
                          // "All solutions at Ambrosia Ayurved are formulated by experts at the Ambrosia Ayurved of Ayurveda. "
                          // "Ambrosia is a body of expert Ayurveda doctors, PhD in food formulations, nutritionists, and food scientists.",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 0,
                child: Image.asset(
                  'assets/images/kap_flower_1.webp',
                  width: 120,
                ),
              ),
            ],
          ),
        ),

        /// **Section 2**
        Padding(
          padding: const EdgeInsets.only(left: 1, right: 20),
          child: Stack(
            children: [
              Positioned(
                top: 30,
                left: 0,
                child: Image.asset(
                  'assets/images/kap_flower_2.webp',
                  width: 100,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          /// **Text Column**
                          Container(
                            width: screenWidth * 0.68,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "02",
                                  style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 207, 125, 1),
                                  ),
                                ),
                                //  SizedBox(height: 10),
                                Text(
                                  "${AppLocalizations.of(context)!.section02Title}",
                                  // "THE BEST INGREDIENTS FOUND THE TOUGHEST WAY",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  "${AppLocalizations.of(context)!.section02Desc}",
                                  // "We do not pick ingredients which can be picked on the outskirts of a city, but we go to the depth of forests "
                                  // "to get it, pick it within the 3-day window in the year when its efficacy is at its maximum, and process it within "
                                  // "the 2-hour window when it's preserved at its very best.",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        /// **Section 3**
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 1),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// **Text Column**
                  Container(
                    width: screenWidth * 0.68,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "03",
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 207, 125, 1),
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.section03Title}",
                          //    "HOLISTIC SOLUTIONS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "${AppLocalizations.of(context)!.section03Desc}",
                          // "Be it Acne, Hairfall, or Diabetes, we don’t stop at just giving you products. Product is just one element of solving "
                          // "your problem. Get free health expert advice, personalized diet plans, and lifestyle recommendations including Yoga Asanas.",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 20,
                right: 0,
                child: Image.asset(
                  'assets/images/kap_flower_3.webp',
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
