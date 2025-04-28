import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "${AppLocalizations.of(context)!.balance}",
              // "4BΛLΛNCE",
              style: TextStyle(
                fontSize: 30, // Adjust based on design
                // fontWeight: FontWeight.w500, // Semi-bold for a premium look
                letterSpacing: 16, // Increased spacing for a wide look
                fontFamily: 'Sans', // Change this if you have an exact font
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              FeatureItem(
                imagePath: "assets/images/why_kap_1.webp",
                title: "${AppLocalizations.of(context)!.healthOutcomes}",
                //"Health Outcomes",
                description:
                    "${AppLocalizations.of(context)!.ayurvedicSolutionsDelivered}",
                // "Ayurvedic solutions delivered thoughtfully",
              ),
              FeatureItem(
                imagePath: "assets/images/why_kap_2.webp",
                title: "${AppLocalizations.of(context)!.bespokeAyurveda}",
                // "Bespoke Ayurveda",
                description: "${AppLocalizations.of(context)!.programsCrafted}",
                //  "Programs crafted by Ayurvedacharyas",
              ),
              FeatureItem(
                imagePath: "assets/images/why_kap_3.webp",
                title: "${AppLocalizations.of(context)!.realAssistance}",
                // "Real Assistance",
                description:
                    "${AppLocalizations.of(context)!.ayurvedicSolutionsDelivered}",
                // "Ayurvedic Health Experts",
              ),
              FeatureItem(
                imagePath: "assets/images/why_kap_4.webp",
                title: "${AppLocalizations.of(context)!.naturalIngredients}",
                //  "Natural Ingredients",
                description:
                    "${AppLocalizations.of(context)!.carefullySourced}",
                // "Carefully handpicked and sourced",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const FeatureItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
        ), // Asset Image
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
