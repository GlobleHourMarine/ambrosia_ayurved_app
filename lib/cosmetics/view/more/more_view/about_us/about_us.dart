import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_2.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/why_us/why_us_screen.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/about_us/about_us_section.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/about_us/ourjourney.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/about_us/ourmission.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/about_us/ourvision.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '${AppLocalizations.of(context)!.aboutUs}'
          // 'About Us',
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AboutUsShortSection(),
                    OurJourneySection(),
                    OurMissionSection(),
                    OurVisionSection(),
                    SizedBox(height: 30),
                    FeaturesSection(),
                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
