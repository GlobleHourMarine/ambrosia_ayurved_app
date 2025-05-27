/*

import 'package:flutter/material.dart';

class CancellationRefundPolicyScreen4 extends StatelessWidget {
  const CancellationRefundPolicyScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Previous Section ...
        BulletPoint(text: 'The packaging is intact'),
        BulletPoint(text: 'You have the original invoice/order ID'),
        SizedBox(height: 24),

        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: 'Are all products returnable?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '🚫 No. We do not '),
              TextSpan(
                  text: 'accept returns',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' if:'),
            ],
          ),
        ),
        BulletPoint(text: 'The product has been ', boldText: 'opened or used'),
        BulletPoint(text: 'It’s past ', boldText: '5 days since delivery'),
        BulletPoint(
            text: 'You return it ', boldText: 'without the original packaging'),
        BulletPoint(
            text: 'It’s a ',
            boldText: 'sample/trial pack or promotional freebie'),

        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: 'What is the refund timeline?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      '🟢 Once your return is approved and inspected, refunds are processed within '),
              TextSpan(
                  text: '5–7 business days',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' to your original payment method.')
            ],
          ),
        ),

        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text:
                      'How will I get a refund if I paid via Cash on Delivery (COD)?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '🟢 We’ll contact you for your '),
              TextSpan(
                  text: 'bank or UPI details',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ', and the refund will be processed through '),
              TextSpan(
                  text: 'bank transfer',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' within '),
              TextSpan(
                  text: '5–7 working days.',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),

        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: 'Do I have to pay for return shipping?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '🟡 It depends on the reason:'),
            ],
          ),
        ),
        BulletPoint(
            text: 'If the issue is from our side (wrong/damaged product), the ',
            boldText: 'return is free'),
        BulletPoint(
            text: 'For other reasons, ',
            boldText: 'return shipping charges may apply'),

        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text:
                      'What if I entered the wrong address or phone number?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '🚫 Ambrosia Ayurved is '),
              TextSpan(
                  text: 'not responsible',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      ' for failed deliveries due to incorrect address or contact details entered during checkout. Please double-check your info before placing the order.')
            ],
          ),
        ),

        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: 'Can I exchange my product?\n',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      '🔄 Exchanges are not currently supported. You may return the item (if eligible) and place a new order.')
            ],
          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationRefundPolicyScreen4 extends StatelessWidget {
  const CancellationRefundPolicyScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BulletPoint(text: AppLocalizations.of(context)!.packagingIntact),
        BulletPoint(text: AppLocalizations.of(context)!.haveInvoiceOrOrderId),
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: AppLocalizations.of(context)!.areAllProductsReturnable,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: AppLocalizations.of(context)!.noReturnConditionsIntro),
            ],
          ),
        ),
        BulletPoint(
            text: AppLocalizations.of(context)!.productHasBeen,
            boldText: AppLocalizations.of(context)!.openedOrUsed),
        BulletPoint(
            text: AppLocalizations.of(context)!.itsPast,
            boldText: AppLocalizations.of(context)!.fiveDaysSinceDelivery),
        BulletPoint(
            text: AppLocalizations.of(context)!.youReturnIt,
            boldText: AppLocalizations.of(context)!.withoutOriginalPackaging),
        BulletPoint(
            text: AppLocalizations.of(context)!.itsA,
            boldText: AppLocalizations.of(context)!.sampleOrFreebie),
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: AppLocalizations.of(context)!.refundTimeline,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.refundProcessedInfo),
              TextSpan(
                  text: AppLocalizations.of(context)!.fiveToSevenDays,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.toOriginalMethod),
            ],
          ),
        ),
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: AppLocalizations.of(context)!.codRefundQuestion,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.weWillContact),
              TextSpan(
                  text: AppLocalizations.of(context)!.bankOrUpiDetails,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.refundThrough),
              TextSpan(
                  text: AppLocalizations.of(context)!.bankTransfer,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: AppLocalizations.of(context)!.withinFiveToSevenDays,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: AppLocalizations.of(context)!.payReturnShipping,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.dependsOnReason),
            ],
          ),
        ),
        BulletPoint(
          text: AppLocalizations.of(context)!.issueFromOurSide,
          boldText: AppLocalizations.of(context)!.returnIsFree,
        ),
        BulletPoint(
          text: AppLocalizations.of(context)!.otherReasons,
          boldText: AppLocalizations.of(context)!.chargesMayApply,
        ),
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: AppLocalizations.of(context)!.wrongAddressQuestion,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.notResponsible),
              TextSpan(
                  text: AppLocalizations.of(context)!.failedDeliveryDisclaimer),
            ],
          ),
        ),
        SizedBox(height: 24),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '❓ ',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
              TextSpan(
                  text: AppLocalizations.of(context)!.exchangeProductQuestion,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: AppLocalizations.of(context)!.exchangePolicyNote),
            ],
          ),
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
