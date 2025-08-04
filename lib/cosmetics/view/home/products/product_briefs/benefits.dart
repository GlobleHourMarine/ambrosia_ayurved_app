import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/benefits/benefits_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Benefits extends StatefulWidget {
  final String productId;

  const Benefits({super.key, required this.productId});

  @override
  State<Benefits> createState() => _BenefitsState();
}

class _BenefitsState extends State<Benefits> {
  List<BenefitItem> _fetchedBenefits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBenefits();
  }

  Future<void> fetchBenefits() async {
    final url = Uri.parse(
        'https://ambrosiaayurved.in/api/fetch_all_benefits?product_id=${widget.productId}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          setState(() {
            _fetchedBenefits = List<BenefitItem>.from(
              jsonResponse['data'].map((item) => BenefitItem.fromJson(item)),
            );
          });
        }
      }
    } catch (e) {
      print("Error fetching benefits: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // Only show the entire section if productId == '14'
    // if (widget.productId != '14') {
    //   return SizedBox.shrink(); // return nothing
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Text(
        //     t.benefits,
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.green,
        //     ),
        //   ),
        // ),
        // if (widget.productId == '14') ...[
        //   _buildBenefit(t.completelyEliminatesSugar, t.naturallyControlsSugar),
        //   _buildBenefit(t.boostsInsulinSensitivity, t.helpsProcessGlucose),
        //   _buildBenefit(t.enhancesEnergyLevels, t.reducesFatigue),
        //   _buildBenefit(
        //       t.improvesDigestionMetabolism, t.aidsNutrientAbsorption),
        //   _buildBenefit(t.supportsHeartLiverHealth, t.helpsCirculationDetox),
        //   _buildBenefit(t.herbalAndNatural, t.safeAndChemicalFree),
        //   const SizedBox(height: 5),
        // ],

        /// ✅ Fetched dynamic benefits
        _isLoading
            ? Center(child: CircularProgressIndicator())
            : _fetchedBenefits.isEmpty
                ? SizedBox()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      if (widget.productId == '14') ...[
                        _buildBenefit(t.completelyEliminatesSugar,
                            t.naturallyControlsSugar),
                        _buildBenefit(
                            t.boostsInsulinSensitivity, t.helpsProcessGlucose),
                        _buildBenefit(t.enhancesEnergyLevels, t.reducesFatigue),
                        _buildBenefit(t.improvesDigestionMetabolism,
                            t.aidsNutrientAbsorption),
                        _buildBenefit(t.supportsHeartLiverHealth,
                            t.helpsCirculationDetox),
                        _buildBenefit(
                            t.herbalAndNatural, t.safeAndChemicalFree),
                        const SizedBox(height: 5),
                      ],
                      Column(
                        children: _fetchedBenefits.map((item) {
                          return _buildBenefitItem(
                            imagePath: item.image,
                            boldText: item.title,
                            description: item.description,
                          );
                        }).toList(),
                      ),
                    ],
                  ),

        // _buildBenefitItem(
        //   imagePath: 'assets/images/blood_sugar_management.png',
        //   boldText: t.bloodSugarManagement,
        //   description: t.manageSugarHba1c,
        // ),
        // _buildBenefitItem(
        //   imagePath: 'assets/images/kap_blood_sugar_2.webp',
        //   boldText: t.herbsImproveInsulinRelease,
        //   description: t.vijaysaarRegeneratesInsulin,
        // ),
        // _buildBenefitItem(
        //   imagePath: 'assets/images/kap_blood_sugar_3.webp',
        //   boldText: t.preventComplications,
        //   description: t.naturalControlPreventsIssues,
        // ),
      ],
    );
  }
}

//
Widget _buildBenefit(String boldText, String normalText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$boldText ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextSpan(
                  text: normalText,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

//
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
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const ShimmerEffect(width: 250, height: 250);
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Benefits extends StatelessWidget {
  const Benefits({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            AppLocalizations.of(context)!.benefits,
            // "Benefits",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        _buildBenefit(
            "${AppLocalizations.of(context)!.completelyEliminatesSugar}",
            //    "Completely eliminates sugar from the body",
            "${AppLocalizations.of(context)!.naturallyControlsSugar}"
            //  "– Naturally controls blood sugar levels.",
            ),
        _buildBenefit(
            "${AppLocalizations.of(context)!.boostsInsulinSensitivity}",
            // "Boosts insulin sensitivity",
            "${AppLocalizations.of(context)!.helpsProcessGlucose}"
            //    "– Helps the body process glucose more efficiently.",
            ),
        _buildBenefit(
            "${AppLocalizations.of(context)!.enhancesEnergyLevels}",
            // "Enhances energy levels",
            "${AppLocalizations.of(context)!.reducesFatigue}"
            // "– Reduces fatigue and keeps you active.",
            ),
        _buildBenefit(
            "${AppLocalizations.of(context)!.improvesDigestionMetabolism}",
            //  "Improves digestion & metabolism",
            "${AppLocalizations.of(context)!.aidsNutrientAbsorption}"
            //   "– Aids in proper absorption of nutrients.",
            ),
        _buildBenefit(
            "${AppLocalizations.of(context)!.supportsHeartLiverHealth}",
            //    "Supports heart & liver health",
            "${AppLocalizations.of(context)!.helpsCirculationDetox}"
            //    "– Helps with blood circulation and detoxification.",
            ),
        _buildBenefit(
            "${AppLocalizations.of(context)!.herbalAndNatural}",
            //   "100% Herbal & Natural",
            "${AppLocalizations.of(context)!.safeAndChemicalFree}"
            //   "– Free from harmful chemicals and completely safe.",
            ),
        const SizedBox(height: 5),
        _buildBenefitItem(
          imagePath: 'assets/images/blood_sugar_management.png',
          boldText: "${AppLocalizations.of(context)!.bloodSugarManagement}",
          // "Blood Sugar Management",
          description: "${AppLocalizations.of(context)!.manageSugarHba1c}",
          //     "Naturally helps manage blood sugar and HbA1c levels on consuming as advised for at least 3 Months",
        ),
        _buildBenefitItem(
          imagePath: 'assets/images/kap_blood_sugar_2.webp',
          boldText:
              "${AppLocalizations.of(context)!.herbsImproveInsulinRelease}",
          //   "Has Herbs to Improve Insulin Release",
          description:
              "${AppLocalizations.of(context)!.vijaysaarRegeneratesInsulin}",
          //    "Vijaysaar helps regenerate insulin-producing cells & Gudmar, Giloy, etc. help improve insulin release in the body [*As per published scientific literature]",
        ),
        _buildBenefitItem(
          imagePath: 'assets/images/kap_blood_sugar_3.webp',
          boldText: "${AppLocalizations.of(context)!.preventComplications}",

          //   "Prevent Other Related Complications",
          description:
              "${AppLocalizations.of(context)!.naturalControlPreventsIssues}",
          //  "Naturally controlling Blood Sugar can prevent other health complications like BP and kidney issues",
        ),
        // Usage Instructions
      ],
    );
  }
}

Widget _buildBenefit(String boldText, String normalText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 20),
        SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "$boldText ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextSpan(
                  text: normalText,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
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
*/
