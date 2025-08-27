/*

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPart1 extends StatelessWidget {
  const PrivacyPolicyPart1({Key? key}) : super(key: key);

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
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              const TextSpan(
                text: "At ",
              ),
              const TextSpan(
                text: "Ambrosia Ayurved",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text:
                    ", your privacy is essential to us. We’re committed to protecting your personal information and being transparent about how we collect, use, and safeguard it. This Privacy Policy outlines your rights and our responsibilities regarding your data.\n\n"
                    "This Privacy Policy is published under the ",
              ),
              const TextSpan(
                text: "Information Technology Act, 2000",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text: ", and the rules made thereunder. By using our website ",
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
              const TextSpan(
                text: ", you agree to the terms outlined below.\n\n",
              ),
            ],
          ),
        ),
        const Text(
          "1. Information We Collect",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
            "When you visit or make a purchase through our website, we may collect the following information:\n"),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Full Name"),
              Text("• Email Address"),
              Text("• Phone Number"),
              Text("• Shipping and Billing Address"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "This data is essential for order processing, customer service, and communication purposes.\n",
        ),
        const SizedBox(height: 12),
        const Text(
          "2. Payment Information",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: "All payments on our website are securely processed via ",
              ),
              TextSpan(
                text: "Razorpay.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    " We do not store or retain your payment details, such as card numbers or CVV codes, on our servers.\n",
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "3. Use of Cookies",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          "We use ",
        ),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: "cookies and similar technologies",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: " to:\n"),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Understand how visitors use our website"),
              Text("• Improve website functionality and performance"),
              Text("• Provide a personalized browsing experience"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "You can disable cookies in your browser settings, but doing so may affect site functionality.",
        ),
      ],
    );
  }
}

*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPart1 extends StatelessWidget {
  const PrivacyPolicyPart1({Key? key}) : super(key: key);

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
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(text: local.privacyIntroPart1),
              TextSpan(
                text: local.privacyCompany,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.privacyIntroPart2),
              TextSpan(
                text: local.privacyPolicyLaw,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.privacyIntroPart3),
              TextSpan(
                text: 'https://ambrosiaayurved.in',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = _launchCamikaraURL,
              ),
              TextSpan(text: local.privacyIntroPart4),
            ],
          ),
        ),
        Text(
          local.section1Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(local.section1Description),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.section1Bullet1),
              Text(local.section1Bullet2),
              Text(local.section1Bullet3),
              Text(local.section1Bullet4),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(local.section1Closing),
        const SizedBox(height: 12),
        Text(
          local.section2Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(text: local.section2Part1),
              TextSpan(
                text: local.section2Razorpay,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.section2Part2),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          local.section3Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(local.section3Intro),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: local.section3Cookies,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.section3BulletsIntro),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.section3Bullet1),
              Text(local.section3Bullet2),
              Text(local.section3Bullet3),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(local.section3Closing),
      ],
    );
  }
}
