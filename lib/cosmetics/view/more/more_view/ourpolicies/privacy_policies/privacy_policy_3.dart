/*
import 'package:flutter/material.dart';

class PrivacyPolicyPart3 extends StatelessWidget {
  const PrivacyPolicyPart3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 25),
        Text(
          "8. Data Retention",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "We retain your information only for as long as it is needed to fulfill your orders or provide "
          "support. Once the purpose is served, we delete or anonymize your data, unless retention is required by law.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          "9. Sensitive Personal Data",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: "We "),
              TextSpan(
                text: "do not collect any sensitive personal data",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      ", such as your health records, biometric data, or financial information. Our collection is limited strictly to what’s necessary for communication and delivery."),
            ],
          ),
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          "10. Children’s Privacy",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "Our website is not intended for individuals under the age of 18. We do not knowingly collect "
          "personal information from minors. If we become aware of such data being collected, we will delete it promptly.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          "11. Third-Party Links",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text:
                      "Our website may contain links to third-party websites. Please note that we are "),
              TextSpan(
                text: "not responsible",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      " for the privacy practices of those websites. We encourage you to review their policies before sharing any information."),
            ],
          ),
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          "12. Policy Updates",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "We may update this Privacy Policy as necessary to reflect changes in legal requirements or "
          "business practices. All changes will be posted here, along with the updated effective date.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 12),
        Text(
          "Thank you for choosing Ambrosia Ayurved.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          "We respect your trust and are committed to keeping your personal information secure.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}


*/

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPart3 extends StatelessWidget {
  const PrivacyPolicyPart3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Text(
          local.privacyPart3_section8Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          local.privacyPart3_section8Body,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          local.privacyPart3_section9Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: local.privacyPart3_section9BodyStart),
              TextSpan(
                text: local.privacyPart3_section9Bold,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.privacyPart3_section9BodyEnd),
            ],
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          local.privacyPart3_section10Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          local.privacyPart3_section10Body,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          local.privacyPart3_section11Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: local.privacyPart3_section11BodyStart),
              TextSpan(
                text: local.privacyPart3_section11Bold,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.privacyPart3_section11BodyEnd),
            ],
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          local.privacyPart3_section12Title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          local.privacyPart3_section12Body,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 12),
        Text(
          local.privacyPart3_thankYouBold,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          local.privacyPart3_thankYouBody,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
