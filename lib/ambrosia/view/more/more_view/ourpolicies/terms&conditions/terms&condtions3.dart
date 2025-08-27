/*


import 'package:flutter/material.dart';

class TermsAndConditionsScreen3 extends StatelessWidget {
  const TermsAndConditionsScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Previous Sections...
        Text(
          '10. Changes to Terms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Ambrosia Ayurved reserves the right to modify or update these Terms & Conditions at any time. Changes will be posted on this page with an updated effective date. Continued use of the site after changes implies acceptance of the revised terms.',
        ),
        SizedBox(height: 20),
        Text(
          '11. Contact Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'If you have any questions about these Terms & Conditions, feel free to contact us:',
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.email, size: 16),
            SizedBox(width: 6),
            Text(
              'care@ambrosiaayurved.in',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.phone, size: 16),
            SizedBox(width: 6),
            Text('01762-458122'),
          ],
        ),
        SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Thank you for choosing Ambrosia Ayurved.\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    'We value your trust and are committed to offering safe and effective Ayurvedic wellness solutions.',
              ),
            ],
          ),
        ),
        SizedBox(height: 40),
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
      padding: const EdgeInsets.only(bottom: 4.0),
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsScreen3 extends StatelessWidget {
  const TermsAndConditionsScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Previous Sections...

        Text(
          local.termsAndConditions_changesToTermsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_changesToTermsText),
        const SizedBox(height: 20),

        Text(
          local.termsAndConditions_contactUsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_contactUsText),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.email, size: 16),
            const SizedBox(width: 6),
            Text(
              local.termsAndConditions_email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.phone, size: 16),
            const SizedBox(width: 6),
            Text(local.termsAndConditions_phone),
          ],
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: local.termsAndConditions_thankYouText + '\n',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: local.termsAndConditions_valueYourTrustText,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
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
      padding: const EdgeInsets.only(bottom: 4.0),
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
