// import 'package:flutter/material.dart';

// class CancellationRefundPolicyScreen1 extends StatelessWidget {
//   const CancellationRefundPolicyScreen1({super.key});

// void _launchCamikaraURL() async {
//   final Uri url = Uri.parse('https://ambrosiaayurved.in/');
//   if (await canLaunchUrl(url)) {
//     await launchUrl(url, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text.rich(
//           TextSpan(
//             style: TextStyle(color: Colors.black),
//             children: [
//               TextSpan(
//                 text: 'At ',
//               ),
//               TextSpan(
//                 text: 'Ambrosia Ayurved',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               TextSpan(
//                 text:
//                     ', we value your satisfaction and aim to offer a smooth, transparent, and fair return and refund experience. Please read our policy below before placing your order.',
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Order Cancellation Policy',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         BulletPoint(
//             text: 'You can cancel your order within ',
//             boldText: '12 hours',
//             suffix: ' of placing it.'),
//         BulletPoint(
//             text: 'Cancellations requested ',
//             boldText: 'after the 12-hour window',
//             suffix:
//                 ' may not be accepted if the order has already been processed or shipped.'),
//         BulletPoint(
//             text: 'To cancel your order, please email us at ',
//             boldText: 'care@ambrosiaayurved.in',
//             suffix: ' or call us at 01762-458122 with your Order ID.'),
//         SizedBox(height: 20),
//         Text(
//           'Return & Replacement Policy',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Text('We accept returns only if the following conditions are met:'),
//         BulletPoint(
//             boldText:
//                 'The product is unused, unopened, and in original condition'),
//         BulletPoint(
//             boldText:
//                 'The return request is initiated within 5 days of delivery'),
//         BulletPoint(
//             boldText: 'The item is not damaged, and the packaging is intact'),
//         SizedBox(height: 8),
//         Text('You may also request a replacement in case:'),
//         BulletPoint(boldText: 'You received the wrong item'),
//         BulletPoint(boldText: 'The item was damaged during transit'),
//         SizedBox(height: 8),
//         Text(
//           'Return shipping charges may apply and will be evaluated on a case-by-case basis.',
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Non-Returnable Items',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         Text('We do not accept returns in the following cases:'),
//         BulletPoint(text: 'The product has been used or tampered with'),
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
//       padding: const EdgeInsets.only(bottom: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('• ', style: TextStyle(height: 1.5)),
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
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationRefundPolicyScreen1 extends StatelessWidget {
  const CancellationRefundPolicyScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: t.refundIntroPart1),
              TextSpan(
                text: t.refundIntroBrand,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: t.refundIntroPart2),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(t.orderCancellationTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        BulletPoint(
          text: t.orderCancellation1,
          boldText: t.orderCancellation1Bold,
          suffix: t.orderCancellation1Suffix,
        ),
        BulletPoint(
          text: t.orderCancellation2,
          boldText: t.orderCancellation2Bold,
          suffix: t.orderCancellation2Suffix,
        ),
        BulletPoint(
          text: t.orderCancellation3,
          boldText: t.orderCancellation3Bold,
          suffix: t.orderCancellation3Suffix,
        ),
        const SizedBox(height: 20),
        Text(
          t.returnReplacementTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(t.returnConditionsIntro),
        BulletPoint(boldText: t.returnCondition1),
        BulletPoint(boldText: t.returnCondition2),
        BulletPoint(boldText: t.returnCondition3),
        BulletPoint(boldText: t.replacementDeliveryInfo),
        const SizedBox(height: 8),
        Text(t.replacementIntro),
        BulletPoint(boldText: t.replacement1),
        BulletPoint(boldText: t.replacement2),
        const SizedBox(height: 8),
        Text(t.returnShippingNote),
        const SizedBox(height: 20),
        Text(
          t.nonReturnableTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(t.nonReturnableIntro),
        BulletPoint(text: t.nonReturnableItem),
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
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(height: 1.5)),
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
          ),
        ],
      ),
    );
  }
}
