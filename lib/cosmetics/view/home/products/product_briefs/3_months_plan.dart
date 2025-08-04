import 'package:ambrosia_ayurved/cosmetics/view/home/products/products_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';

class ThreeMonthPlan extends StatelessWidget {
  // final String productId;
  const ThreeMonthPlan({
    Key? key,
  }) : super(key: key);

  TextSpan buildStyledMonth(String monthText) {
    return TextSpan(
      text: monthText,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.green[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 5),
          Text(
            t.threeMonthTitle,
            style: TextStyle(
              fontSize: 20,
              color: Acolors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/3_months_plan.png'),
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                buildStyledMonth(t.month1Title),
                TextSpan(text: t.month1Desc),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                buildStyledMonth(t.month2Title),
                TextSpan(text: t.month2Desc),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                buildStyledMonth(t.month3Title),
                TextSpan(text: t.month3Desc),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                buildStyledMonth(t.month4Title),
                TextSpan(text: t.month4Desc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



/*

import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';

class ThreeMonthPlan extends StatelessWidget {
  const ThreeMonthPlan({Key? key}) : super(key: key);

  TextSpan buildStyledMonth(String monthText) {
    return TextSpan(
      text: "$monthText: ",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        //  decoration: TextDecoration.underline,
        fontSize: 18,
        color: Colors.green[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            "3 Month plan of using A5",
            style: TextStyle(
              fontSize: 20,
              color: Acolors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/3_months_plan.png')),
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                buildStyledMonth("Month 1"),
                const TextSpan(
                  text:
                      "Take both diabetes medication and Ambrosia Ayurved together.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                buildStyledMonth("Month 2"),
                const TextSpan(
                  text:
                      "Skip conventional medicine once a week, but continue Ambrosia Ayurved.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, color: Colors.black),
              children: [
                buildStyledMonth("Month 3"),
                const TextSpan(
                  text:
                      "Take conventional medicine once every 15 days, and keep Ambrosia Ayurved regularly.",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                buildStyledMonth("After 3 Months"),
                const TextSpan(
                  text:
                      "If sugar levels stay stable, stop all diabetes medications.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


*/