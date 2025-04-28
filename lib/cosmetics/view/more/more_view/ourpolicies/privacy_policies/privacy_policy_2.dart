import 'package:flutter/material.dart';

class PrivacyPolicyPart2 extends StatelessWidget {
  const PrivacyPolicyPart2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        const Text(
          "4. How We Use Your Data",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: "Your ",
              ),
              TextSpan(
                text: "personal information may be used for",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ":\n"),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Order confirmation and delivery"),
              Text("• Customer support"),
              Text("• Product and health-related updates (if you’ve opted in)"),
              Text("• Enhancing website experience"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "We never use your data for unethical marketing or unauthorized communication.\n",
        ),
        const SizedBox(height: 12),
        const Text(
          "5. Sharing Your Information",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(text: "We "),
              TextSpan(
                text: "do not sell or rent",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    " your data to third parties. However, to fulfill your orders, we may share relevant information with trusted ",
              ),
              TextSpan(
                text: "delivery partners",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    ". These partners are bound to maintain the confidentiality of your data.\n",
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "6. Data Security",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          "We take your data security seriously. All personal information is stored on secured servers, and we follow standard encryption and protection protocols to prevent unauthorized access, misuse, or disclosure.\n",
        ),
        const SizedBox(height: 12),
        const Text(
          "7. Your Rights",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text("You have the right to:\n"),
        const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• Access your personal information"),
              Text("• Correct or update your information"),
              Text("• Request the deletion of your data"),
            ],
          ),
        ),
        SizedBox(height: 25),
        Text(
          "To exercise these rights, reach out to us at:",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.email_outlined, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "care@ambrosiaayurved.in",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.phone, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "01762-458122",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          "We will respond to your request within 5–7 business days.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}


/*

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPart2 extends StatelessWidget {
  const PrivacyPolicyPart2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(
          loc.privacyPart2Heading4,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(text: loc.privacyPart2UsageIntro),
              TextSpan(
                text: loc.privacyPart2UsageBold,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ":\n"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.privacyPart2Bullet1),
              Text(loc.privacyPart2Bullet2),
              Text(loc.privacyPart2Bullet3),
              Text(loc.privacyPart2Bullet4),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(loc.privacyPart2NoUnethicalUse),
        const SizedBox(height: 12),
        Text(
          loc.privacyPart2Heading5,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(text: loc.privacyPart2ShareIntro1),
              TextSpan(
                text: loc.privacyPart2ShareBold,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: loc.privacyPart2ShareIntro2),
              TextSpan(
                text: loc.privacyPart2DeliveryPartners,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: loc.privacyPart2Confidentiality),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          loc.privacyPart2Heading6,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(loc.privacyPart2DataSecurity),
        const SizedBox(height: 12),
        Text(
          loc.privacyPart2Heading7,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(loc.privacyPart2RightIntro),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.privacyPart2Right1),
              Text(loc.privacyPart2Right2),
              Text(loc.privacyPart2Right3),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Text(
          loc.privacyPart2ReachOut,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.email_outlined, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              loc.privacyPart2Email,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.phone, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              loc.privacyPart2Phone,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          loc.privacyPart2ResponseTime,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}


*/