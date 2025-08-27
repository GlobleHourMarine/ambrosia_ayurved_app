import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class OurJourneySection extends StatefulWidget {
  const OurJourneySection({super.key});

  @override
  State<OurJourneySection> createState() => _OurJourneySectionState();
}

class _OurJourneySectionState extends State<OurJourneySection>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  void _launchCamikaraURL() async {
    final Uri url = Uri.parse('https://camikaratradings.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    // Trigger animation after a slight delay
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.spa, color: Colors.green),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.ourJourneyTitle,
                      // 'Our Journey',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006666), // teal color
                      ),
                    ),

                    SizedBox(height: 4), // Space between text and underline
                    Container(
                      height: 2,
                      width: 160, // adjust as needed
                      color: Color(0xFF006666),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/our_journey.webp',
                  // fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text.rich(
              TextSpan(
                text: AppLocalizations.of(context)!.journeyIntro,
                //  'We started with one of the most common yet misunderstood conditions — ',
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyCondition,
                    // 'diabetes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyQuestionIntro,
                    //    '.\nInstead of just managing sugar levels, we asked:\n',
                  ),
                ],
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            SizedBox(height: 8),
            BulletPoint(text: AppLocalizations.of(context)!.journeyQ1),
            BulletPoint(text: AppLocalizations.of(context)!.journeyQ2),
            BulletPoint(text: AppLocalizations.of(context)!.journeyQ3),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: AppLocalizations.of(context)!.journeyProductIntro,
                children: [
                  TextSpan(
                    text: 'A5',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyProductDetails,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyHerbs,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyFrom,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyRegions,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeySupport,
                    // ', supporting sugar balance and body rejuvenation.\n\nThese herbs are ',
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeySourcing,
                    //  'sourced through our trusted partner, Camikara',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' Camikara',
                    style: const TextStyle(
                        color: Colors.blue,
                        // decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _launchCamikaraURL,
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyEnsuring,
                    //', ensuring ',
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyPurity,
                    // 'global-grade purity and potency',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.journeyClosing,
                    //   ' — from India’s forests to Malaysia’s hills.\n\nBut this is just the beginning.',
                  ),
                ],
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 18)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
