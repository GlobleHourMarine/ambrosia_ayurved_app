import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/foods_to_avoid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/3_months_plan.dart';

class HowToUseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          t.howToUse,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/mix_powder.jpg',
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildStep(
          stepTitle: t.howToUseStep1Title,
          description: t.howToUseStep1Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep2Title,
          description: t.howToUseStep2Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep3Title,
          description: t.howToUseStep3Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep4Title,
          description: t.howToUseStep4Desc,
        ),
        ThreeMonthPlan(),
        SizedBox(height: 25),
        FoodsToAvoidSection(),
      ],
    );
  }

  Widget _buildStep({required String stepTitle, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Divider(
            color: Colors.brown[300],
            thickness: 1.5,
            height: 20,
          ),
        ],
      ),
    );
  }
}



/*

class HowToUseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          t.howToUse,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/mix_powder.jpg',
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildStep(
          stepTitle: t.howToUseStep1Title,
          description: t.howToUseStep1Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep2Title,
          description: t.howToUseStep2Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep3Title,
          description: t.howToUseStep3Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep4Title,
          description: t.howToUseStep4Desc,
        ),
        ThreeMonthPlan(),
      ],
    );
  }
  */