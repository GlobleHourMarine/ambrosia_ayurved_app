/*

import 'package:flutter/material.dart';

class TermsAndConditionsScreen2 extends StatelessWidget {
  const TermsAndConditionsScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4. Shipping & Delivery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'All orders are processed and shipped within the timeline mentioned on the product page. Delivery is usually completed within 3–7 business days, depending on the location.',
        ),
        SizedBox(height: 8),
        Text(
          'Please refer to our Shipping Policy for more details.',
        ),
        SizedBox(height: 20),
        Text(
          '5. Cancellations & Refunds',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Orders once placed can only be canceled or refunded under specific conditions. Please refer to our detailed Cancellation & Refund Policy to understand eligibility and timelines.',
        ),
        SizedBox(height: 20),
        Text(
          '6. Intellectual Property',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text:
                    'All content on this website — including text, graphics, product names, logos, and images — is the ',
              ),
              TextSpan(
                text: 'exclusive property of Ambrosia Ayurved',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' and is protected under copyright and trademark laws.',
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Unauthorized use or reproduction of our content is strictly prohibited and may result in legal action.',
        ),
        SizedBox(height: 20),
        Text(
          '7. Account Responsibility',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'If you create an account on our website, you are responsible for maintaining the confidentiality of your login details and for restricting access to your device. You agree to accept responsibility for all activities that occur under your account.',
        ),
        SizedBox(height: 20),
        Text(
          '8. Limitation of Liability',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Ambrosia Ayurved shall not be liable for any direct, indirect, incidental, or consequential damages arising from:',
        ),
        SizedBox(height: 10),
        BulletPoint(text: 'The use or inability to use the website'),
        SizedBox(height: 3),
        BulletPoint(text: 'Delay in delivery'),
        SizedBox(height: 3),
        BulletPoint(text: 'Inaccurate information submitted by the user'),
        SizedBox(height: 3),
        BulletPoint(text: 'Any third-party issues (e.g., courier delays)'),
        SizedBox(height: 20),
        Text(
          '9. Governing Law & Jurisdiction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
            'These Terms and Conditions shall be governed by and construed in accordance with the laws of India. Any disputes arising out of or in connection with these Terms shall be subject to the exclusive jurisdiction of the competent courts in India.'),
        SizedBox(height: 20),
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
      padding: const EdgeInsets.only(bottom: 4.0, left: 15),
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

class TermsAndConditionsScreen2 extends StatelessWidget {
  const TermsAndConditionsScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          local.termsAndConditions_shippingTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_shippingText),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_shippingPolicy),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_cancellationsRefundsTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_cancellationsRefundsText),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_intellectualPropertyTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: local.termsAndConditions_intellectualPropertyText),
              TextSpan(
                text: local.termsAndConditions_exclusiveProperty,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: local.termsAndConditions_propertyProtection),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_unauthorizedUse),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_accountResponsibilityTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_accountResponsibilityText),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_limitationOfLiabilityTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_limitationOfLiabilityText),
        const SizedBox(height: 10),
        BulletPoint(text: local.termsAndConditions_useInabilityToUseWebsite),
        const SizedBox(height: 3),
        BulletPoint(text: local.termsAndConditions_delayInDelivery),
        const SizedBox(height: 3),
        BulletPoint(text: local.termsAndConditions_inaccurateInformation),
        const SizedBox(height: 3),
        BulletPoint(text: local.termsAndConditions_thirdPartyIssues),
        const SizedBox(height: 20),
        Text(
          local.termsAndConditions_governingLawTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.termsAndConditions_governingLawText),
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
      padding: const EdgeInsets.only(bottom: 4.0, left: 15),
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
