import 'package:flutter/material.dart';

class CancellationRefundPolicyScreen3 extends StatelessWidget {
  const CancellationRefundPolicyScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Policy Updates',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text(
            'Ambrosia Ayurved reserves the right to modify this policy at any time. Changes will be posted on this page with an updated effective date. We encourage you to review the policy periodically.'),
        SizedBox(height: 24),
        Text('Need Help?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text(
            "We're here to assist you with any questions regarding your order, returns, or refunds:"),
        SizedBox(height: 8),
        Text('📧 care@ambrosiaayurved.in',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('📞 01762-458122', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text('Thank you for choosing Ambrosia Ayurved.',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(
            "We're committed to your well-being and satisfaction at every step."),
        SizedBox(height: 24),
        Text('Next session on the same',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 24),
        Text('FAQs – Cancellation, Returns & Refunds',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('(When making this section before please talk about design)'),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: 'How can I cancel my order?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: 'You can cancel your order within '),
              TextSpan(
                  text: '12 hours of placing it',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' by emailing us at '),
              TextSpan(
                  text: 'care@ambrosiaayurved.in',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' or calling '),
              TextSpan(
                  text: '01762-458122',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' with your Order ID.')
            ],
          ),
        ),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: 'Can I cancel the order after it has been shipped?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      'Unfortunately, once the order is processed and shipped, it cannot be '),
              TextSpan(
                  text: 'canceled.',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: 'What if I receive a damaged or wrong product?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      'No worries! If you receive a damaged or incorrect item, please contact us within '),
              TextSpan(
                  text: '24 hours',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' of delivery with '),
              TextSpan(
                  text: 'photos or videos',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' of the product. We’ll offer a '),
              TextSpan(
                  text: 'replacement or refund,',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' no questions asked.')
            ],
          ),
        ),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: 'How do I return a product?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'Simply reach out to us via email or call within '),
              TextSpan(
                  text: '5 days of delivery',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ', and ensure that:'),
            ],
          ),
        ),
        BulletPoint(text: 'The product is ', boldText: 'unused & unopened'),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String? text;
  final String? boldText;
  final String? suffix;

  const BulletPoint({super.key, this.text, this.boldText, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, height: 1.5),
                children: [
                  if (text != null) TextSpan(text: text),
                  if (boldText != null)
                    TextSpan(
                      text: boldText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (suffix != null) TextSpan(text: suffix),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}



/*

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationRefundPolicyScreen3 extends StatelessWidget {
  const CancellationRefundPolicyScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.policyUpdates,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.policyUpdatesDescription),
        const SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.needHelp,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.helpDescription),
        const SizedBox(height: 8),
        Text('📧 ${AppLocalizations.of(context)!.email}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('📞 ${AppLocalizations.of(context)!.phoneNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(AppLocalizations.of(context)!.thankYou,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(AppLocalizations.of(context)!.commitment),
        const SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.nextSession,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Text(AppLocalizations.of(context)!.faqs,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(AppLocalizations.of(context)!.faqDesignNote),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: '${AppLocalizations.of(context)!.faq1Title}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq1Text1),
              TextSpan(
                  text: AppLocalizations.of(context)!.faq1Text2,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq1Text3),
              TextSpan(
                  text: AppLocalizations.of(context)!.email,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq1Text4),
              TextSpan(
                  text: AppLocalizations.of(context)!.phoneNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq1Text5)
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: '${AppLocalizations.of(context)!.faq2Title}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq2Text1),
              TextSpan(
                  text: AppLocalizations.of(context)!.faq2Text2,
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              const TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: '${AppLocalizations.of(context)!.faq3Title}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq3Text1),
              TextSpan(
                  text: AppLocalizations.of(context)!.faq3Text2,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq3Text3),
              TextSpan(
                  text: AppLocalizations.of(context)!.faq3Text4,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq3Text5),
              TextSpan(
                  text: AppLocalizations.of(context)!.faq3Text6,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq3Text7)
            ],
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: const TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: '${AppLocalizations.of(context)!.faq4Title}\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq4Text1),
              TextSpan(
                  text: AppLocalizations.of(context)!.faq4Text2,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.faq4Text3),
            ],
          ),
        ),
        BulletPoint(
          text: AppLocalizations.of(context)!.faq4Bullet,
          boldText: AppLocalizations.of(context)!.faq4BulletBold,
        )
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String? text;
  final String? boldText;
  final String? suffix;

  const BulletPoint({super.key, this.text, this.boldText, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, height: 1.5),
                children: [
                  if (text != null) TextSpan(text: text),
                  if (boldText != null)
                    TextSpan(
                      text: boldText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  if (suffix != null) TextSpan(text: suffix),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


*/