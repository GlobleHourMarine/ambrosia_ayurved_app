/*

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen1 extends StatelessWidget {
  const TermsAndConditionsScreen1({super.key});
  void _launchCamikaraURL() async {
    final Uri url = Uri.parse('https://ambrosiaayurved.in/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text:
                    'Welcome to Ambrosia Ayurved. By accessing or using our website ',
              ),
              TextSpan(
                text: 'https://ambrosiaayurved.in',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = _launchCamikaraURL,
              ),
              TextSpan(
                text:
                    ', you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '1. Eligibility',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: 'To place an order on our website, you must be '),
              TextSpan(
                text: 'at least 18 years of age.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      ' By using this site, you confirm that you meet this requirement.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '2. Product Disclaimer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Our product A5 is an Ayurvedic formulation made with a blend of 25+ herbs from India and Malaysia. While we stand by its quality and effectiveness, results may vary from person to person depending on lifestyle, health condition, and usage.',
        ),
        const SizedBox(height: 5),
        const Text(
          '⚠️ Disclaimer:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        const Text(
          ' Our Ayurvedic formulation A5 is designed to help reverse diabetes naturally, provided the recommended protocol is followed consistently. Individual results may vary based on body type, lifestyle, and adherence to the regimen. We advise consulting with a qualified healthcare provider if you have any existing medical conditions or are on medication.',
        ),
        const SizedBox(height: 20),
        const Text(
          '3. Orders & Payment Terms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: 'We offer the following payment options:'),
            ],
          ),
        ),
        SizedBox(height: 10),
        BulletPoint(
          text:
              'Prepaid (via Razorpay – UPI, Netbanking, Credit/Debit Cards, Wallets)',
        ),
        SizedBox(height: 1),
        BulletPoint(
          text: 'Cash on Delivery (COD) — available for selected pin codes',
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text:
                      'Ambrosia Ayurved reserves the right to cancel orders if:'),
            ],
          ),
        ),
        SizedBox(height: 10),
        BulletPoint(text: 'The product is unavailable'),
        SizedBox(height: 1),
        BulletPoint(text: 'The shipping address is not serviceable'),
        SizedBox(height: 1),
        BulletPoint(
            text: 'There is a payment-related issue or suspected fraud'),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: 'In such cases, refunds will be initiated as per our '),
              TextSpan(
                text: 'Cancellation & Refund Policy.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.5)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen1 extends StatelessWidget {
  const TermsAndConditionsScreen1({super.key});

  void _launchCamikaraURL() async {
    final Uri url = Uri.parse('https://ambrosiaayurved.in/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: local.termsAndConditions_welcome,
              ),
              TextSpan(
                text: local.termsAndConditions_website,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = _launchCamikaraURL,
              ),
              TextSpan(
                text: local.termsAndConditions_agreement,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_eligibilityTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: local.termsAndConditions_eligibilityText),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_productDisclaimerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_productDisclaimerText),
        const SizedBox(height: 5),
        Text(
          local.termsAndConditions_disclaimer,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(local.termsAndConditions_ayurvedicDisclaimer),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_ordersAndPaymentTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: local.termsAndConditions_paymentOptions),
            ],
          ),
        ),
        const SizedBox(height: 10),
        BulletPoint(text: local.termsAndConditions_paymentMethod1),
        const SizedBox(height: 1),
        BulletPoint(text: local.termsAndConditions_paymentMethod2),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: local.termsAndConditions_orderCancellation),
            ],
          ),
        ),
        const SizedBox(height: 10),
        BulletPoint(text: local.termsAndConditions_unavailableProduct),
        const SizedBox(height: 1),
        BulletPoint(text: local.termsAndConditions_unserviceableAddress),
        const SizedBox(height: 1),
        BulletPoint(text: local.termsAndConditions_paymentIssue),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: local.termsAndConditions_refundPolicy),
              TextSpan(
                text: local.termsAndConditions_refundPolicyLink,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.5)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
