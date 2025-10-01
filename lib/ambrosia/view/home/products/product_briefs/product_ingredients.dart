import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Ingredients extends StatelessWidget {
  const Ingredients({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> productDetail = {
      "name": "Face Creame",
      "image": "assets/images/creame.png",
      "tagline":
          "Reduced Blood Sugar by 80% in 3 Months* as per an ICMR-compliant clinical study on subjects with T2DM. Can consume with Allopathic Medicines also.",
      "explanation":
          "Face cream is an essential skincare product used to moisturize, nourish, and protect the skin. It comes in various formulations, designed to address different skin concerns such as dryness, aging, acne, hyperpigmentation, and sun protection. Regular use of a good face cream helps maintain a healthy, youthful, and glowing complexion.",
      "usage":
          "Sugar Medicine Powder is used to help regulate blood sugar levels, often for diabetes management. It is usually mixed with water or taken directly as per dosage instructions.",
      "ingredients": [
        {
          "name": "${AppLocalizations.of(context)!.gudmarName}",
          // "Gudmar (Gymnema Sylvestre)",
          "image": "assets/images/category_amala.png",
          "description": "${AppLocalizations.of(context)!.gudmarDesc}",
          // " Reduces sugar cravings and controls blood sugar levels.",
        },
        // {
        //   "name": "${AppLocalizations.of(context)!.jamunName}",
        //   // "Jamun (Black Plum) ",
        //   "image": "assets/images/incr_jamun.jpg",
        //   "description": "${AppLocalizations.of(context)!.jamunDesc}",
        //   //  " Enhances insulin production and helps maintain glucose balance.",
        // },
        {
          "name": "${AppLocalizations.of(context)!.methiName}",
          // "Methi (Fenugreek)",
          "image": "assets/images/category_leaf.png",
          "description": "${AppLocalizations.of(context)!.methiDesc}",
          // "Improves glucose tolerance and supports diabetes control.",
        },
        {
          "name": "${AppLocalizations.of(context)!.karelaName}",
          // "Karela (Bitter Gourd) ",
          "image": "assets/images/incr_karela.jpg",
          "description": "${AppLocalizations.of(context)!.karelaDesc}",
          //  "Acts as natural insulin and boosts metabolism.",
        },
        {
          "name": "${AppLocalizations.of(context)!.neemName}",
          //   "Neem",
          "image": "assets/images/incr_neem.jpg",
          "description": "${AppLocalizations.of(context)!.neemDesc}",
          //    "Purifies the blood and is highly beneficial for diabetics.",
        },
        // {
        //   "name": "${AppLocalizations.of(context)!.tulsiName}",
        //   //   "Tulsi (Holy Basil) ",
        //   "image": "assets/images/incr_tulsi.jpg",
        //   "description": "${AppLocalizations.of(context)!.tulsiDesc}",
        //   //   "Reduces oxidative stress and strengthens immunity.",
        // },
      ],
    };

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HowToUseSection(),
            // SizedBox(height: 20),
            // Ingredients Section
            Text(
              "${AppLocalizations.of(context)!.keyIngredients}",
              //  "Key Ingredients:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            Column(
              children: productDetail["ingredients"].map<Widget>((ingredient) {
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
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                );
              }).toList(),
            ),
          ]),
    );
  }
}
