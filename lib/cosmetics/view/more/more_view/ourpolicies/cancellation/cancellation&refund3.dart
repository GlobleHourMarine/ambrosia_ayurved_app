/*
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


*/

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationRefundPolicyScreen3 extends StatelessWidget {
  const CancellationRefundPolicyScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.policyUpdatesTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text(loc.policyUpdatesDesc),
        SizedBox(height: 24),
        Text(loc.needHelpTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text(loc.needHelpDesc),
        SizedBox(height: 8),
        Text(loc.emailCare, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(loc.phoneNumber, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text(loc.thankYou, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(loc.commitment),
        SizedBox(height: 24),
        Text(loc.nextSession, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 24),
        Text(loc.faqsTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(loc.designNote),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: '❓ ', style: TextStyle(fontSize: 18)),
              TextSpan(
                  text: '${loc.faq1Title}\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq1Part1),
              TextSpan(
                  text: loc.faq1Highlight,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq1Part2),
              TextSpan(
                  text: loc.faq1Email,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq1Part3),
              TextSpan(
                  text: loc.faq1Phone,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq1Part4),
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
                  text: '${loc.faq2Title}\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq2AnswerPart1),
              TextSpan(
                  text: loc.faq2AnswerBold,
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                  text: '${loc.faq3Title}\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq3Part1),
              TextSpan(
                  text: loc.faq3Time,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq3Part2),
              TextSpan(
                  text: loc.faq3Media,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq3Part3),
              TextSpan(
                  text: loc.faq3Action,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq3Part4),
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
                  text: '${loc.faq4Title}\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq4Part1),
              TextSpan(
                  text: loc.faq4Time,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: loc.faq4Part2),
            ],
          ),
        ),
        BulletPoint(text: loc.bulletPointText, boldText: loc.bulletPointBold),
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
