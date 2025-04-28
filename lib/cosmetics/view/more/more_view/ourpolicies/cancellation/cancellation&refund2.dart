// import 'package:flutter/material.dart';

// class CancellationRefundPolicyScreen2 extends StatelessWidget {
//   const CancellationRefundPolicyScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         BulletPoint(
//             text: 'The product is returned ',
//             boldText: 'without original packaging'),
//         BulletPoint(
//             text: 'Items returned ', boldText: 'after 5 days of delivery'),
//         BulletPoint(text: 'Free promotional items, trial packs, or samples'),
//         SizedBox(height: 16),
//         Text(
//           'Please note: Due to the nature of Ayurvedic products, once opened or used, we cannot accept returns for hygiene and safety reasons.',
//         ),
//         SizedBox(height: 24),
//         Text('Refund Process & Timeline',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         SizedBox(height: 8),
//         BulletPoint(
//             text:
//                 'Once your return is received and inspected, we will notify you via email or phone about the approval or rejection of your refund.'),
//         BulletPoint(
//             text:
//                 'If approved, the refund will be processed to your original payment method within ',
//             boldText: '5–7 business days.'),
//         BulletPoint(
//             text: 'For ',
//             boldText: 'Cash on Delivery (COD)',
//             suffix:
//                 ' orders, refunds will be made via bank transfer or UPI — you’ll be contacted to share your bank details securely.'),
//         SizedBox(height: 24),
//         Text('How to Initiate a Return or Refund',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         SizedBox(height: 8),
//         Text(
//           'Please email us at ',
//         ),
//         Text('care@ambrosiaayurved.in',
//             style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(
//           ' or call ',
//         ),
//         Text('01762-458122', style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(' within 5 days of receiving the product. Kindly include:'),
//         BulletPoint(boldText: 'Your Order ID'),
//         BulletPoint(text: 'Reason for return or refund'),
//         BulletPoint(
//             text: 'Supporting ',
//             boldText: 'images (if applicable)',
//             suffix: ' for damaged/wrong item'),
//         SizedBox(height: 8),
//         Text(
//           'Our support team will respond within ',
//         ),
//         Text('24–48 hours', style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(' and guide you through the next steps.'),
//         SizedBox(height: 24),
//         Text('Damaged or Wrong Item Delivered?',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         SizedBox(height: 8),
//         Text(
//             'We sincerely apologize if you received a damaged or incorrect product. In such '),
//         Text('cases', style: TextStyle(fontWeight: FontWeight.bold)),
//         Text(':'),
//         BulletPoint(
//             text: 'Please reach out to us ',
//             boldText: 'within 24 hours',
//             suffix: ' of delivery.'),
//         BulletPoint(
//             text: 'Share ',
//             boldText: 'photos or videos',
//             suffix: ' of the received product along with your Order ID.'),
//       ],
//     );
//   }
// }

// class BulletPoint extends StatelessWidget {
//   final String? text;
//   final String? boldText;
//   final String? suffix;

//   const BulletPoint({super.key, this.text, this.boldText, this.suffix});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('• '),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(color: Colors.black, height: 1.5),
//                 children: [
//                   if (text != null) TextSpan(text: text),
//                   if (boldText != null)
//                     TextSpan(
//                       text: boldText,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   if (suffix != null) TextSpan(text: suffix),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationRefundPolicyScreen2 extends StatelessWidget {
  const CancellationRefundPolicyScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BulletPoint(
            text: loc.returnNoPackaging,
            boldText: loc.returnWithoutOriginalPackaging),
        BulletPoint(text: loc.returnAfterDays, boldText: loc.returnAfter5Days),
        BulletPoint(text: loc.returnPromoItems),
        const SizedBox(height: 16),
        Text(loc.returnNote),
        const SizedBox(height: 24),
        Text(loc.refundTimelineTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        BulletPoint(text: loc.refundInspectNotify),
        BulletPoint(text: loc.refundApproved, boldText: loc.refundTimeWindow),
        BulletPoint(
            text: loc.refundCod,
            boldText: loc.refundCodMethod,
            suffix: loc.refundCodNote),
        const SizedBox(height: 24),
        Text(loc.howToReturn,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(loc.contactEmailPrefix),
        Text(loc.contactEmail,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(loc.contactPhonePrefix),
        Text(loc.contactPhone,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(loc.contactInstruction),
        BulletPoint(boldText: loc.contactOrderId),
        BulletPoint(text: loc.contactReason),
        BulletPoint(
          text: loc.contactImages,
          boldText: loc.contactImagesNote,
          suffix: loc.contactImagesSuffix,
        ),
        const SizedBox(height: 8),
        Text(loc.supportResponseTimePrefix),
        Text(loc.supportResponseTime,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(loc.supportResponseSteps),
        const SizedBox(height: 24),
        Text(loc.damageTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(loc.damageApology),
        Text(loc.damageCase,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(loc.damageColon),
        BulletPoint(
            text: loc.damageReachOut,
            boldText: loc.damageTimeWindow,
            suffix: loc.damageTimeSuffix),
        BulletPoint(
            text: loc.damageProof,
            boldText: loc.damageProofNote,
            suffix: loc.damageProofSuffix),
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
