import 'package:flutter/material.dart';

class ShippingAndDeliveryPolicyScreen1 extends StatelessWidget {
  const ShippingAndDeliveryPolicyScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Effective Date: [12 April 2025]',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(
          'We are committed to delivering your orders safely and on time at Ambrosia Ayurved. Below is a detailed outline of our shipping and delivery process to help you understand how your orders are processed.',
        ),
        SizedBox(height: 20),
        Text(
          'Order Processing Time',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text:
                      'All orders placed on our website are typically processed within '),
              TextSpan(
                text: '1–2 business days.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    '\nYou will receive a confirmation email or SMS once your order has been processed and shipped.',
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Shipping Within India',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: 'We currently offer shipping across all '),
              TextSpan(
                text: 'serviceable PIN codes in India.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        BulletPoint(
          text:
              'Estimated Delivery Time: 3 to 7 working days\n(depending on your location, courier availability, and other factors)',
        ),
        BulletPoint(
          text:
              'Delivery timelines may vary slightly for remote or non-metro areas.',
        ),
        SizedBox(height: 20),
        Text(
          'Shipping Charges',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Shipping charges are calculated at checkout based on multiple factors such as:',
        ),
        SizedBox(height: 6),
        BulletPoint(text: 'Package weight and dimensions'),
        BulletPoint(text: 'Delivery location (zone-wise)'),
        BulletPoint(
            text: 'Delivery mode (Standard / Express, where applicable)'),
        SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: 'We offer '),
              TextSpan(
                text: 'free shipping',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    ' on select orders based on cart value, promotional offers, or active discounts.',
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Tracking Your Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'You will receive tracking details once your order is shipped via email/SMS.\nYou can track your order anytime using the link shared or directly through our website’s “Track Order” section (if available).',
        ),
        SizedBox(height: 20),
        Text(
          'Delivery Partners',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),

        //
        //
        //
        //

        Text(
          'We work with reputed courier and logistics companies to ensure your products reach you safely and on time. However, delays may occur due to unforeseen circumstances such as weather, local holidays, or courier disruptions.',
        ),
        SizedBox(height: 20),
        Text(
          'International Shipping',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(text: 'We currently '),
              TextSpan(
                text: 'do not offer international shipping.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      '\nHowever, this may be introduced in the future — stay tuned by subscribing to our newsletter or following us on social media.'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Incomplete or Incorrect Address',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
            'Please ensure the delivery address and contact details entered are accurate.'),
        RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text:
                    'Ambrosia Ayurved is not responsible for failed deliveries ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text:
                      'due to incorrect/incomplete address details provided at checkout.'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Delivery Delays or Exceptions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
            'While we strive to deliver your order within the promised time frame, delivery may occasionally be delayed due to:'),
        SizedBox(height: 8),
        BulletPoint(text: 'Natural calamities, weather, or regional lockdowns'),
        BulletPoint(
            text: 'Operational or logistical issues at the courier level'),
        BulletPoint(text: 'Unreachable or incorrect delivery location'),
        SizedBox(height: 12),
        Text('In such cases, we appreciate your patience and cooperation.'),
        SizedBox(height: 20),
        Text(
          'Need Help?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
            'If you haven’t received your order within the expected time frame or have any queries regarding shipping, feel free to contact our support team:'),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.email, size: 20),
            SizedBox(width: 8),
            Text(
              'care@ambrosiaayurved.in',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '📞 01762-458122',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        RichText(
          text: TextSpan(style: TextStyle(color: Colors.black), children: [
            TextSpan(
              text: 'Thank you for shopping with Ambrosia Ayurved.\n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  'We’re working every day to bring you authentic Ayurvedic solutions — safely and swiftly.',
            ),
          ]),
        ),
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


/*

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShippingAndDeliveryPolicyScreen1 extends StatelessWidget {
  const ShippingAndDeliveryPolicyScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          local.shippingAndDeliveryPolicy_effectiveDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(local.shippingAndDeliveryPolicy_intro),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_orderProcessingTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_orderProcessingBody),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_shippingWithinIndiaTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_shippingWithinIndiaBody),
        const SizedBox(height: 8),
        BulletPoint(text: local.shippingAndDeliveryPolicy_estimatedDelivery),
        BulletPoint(text: local.shippingAndDeliveryPolicy_deliveryTimelines),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_shippingChargesTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_shippingChargesBody),
        const SizedBox(height: 6),
        BulletPoint(text: local.shippingAndDeliveryPolicy_shippingChargesList1),
        BulletPoint(text: local.shippingAndDeliveryPolicy_shippingChargesList2),
        BulletPoint(text: local.shippingAndDeliveryPolicy_shippingChargesList3),
        const SizedBox(height: 12),
        Text(local.shippingAndDeliveryPolicy_freeShipping),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_trackingOrderTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_trackingOrderBody),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_deliveryPartnersTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Text(local.shippingAndDeliveryPolicy_deliveryPartnersBody),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_internationalShippingTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_internationalShippingBody),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_incorrectAddressTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_incorrectAddressBody),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: local.shippingAndDeliveryPolicy_incorrectAddressDisclaimer,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_deliveryDelaysTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_deliveryDelaysBody),
        const SizedBox(height: 8),
        BulletPoint(text: local.shippingAndDeliveryPolicy_deliveryDelaysList1),
        BulletPoint(text: local.shippingAndDeliveryPolicy_deliveryDelaysList2),
        BulletPoint(text: local.shippingAndDeliveryPolicy_deliveryDelaysList3),
        const SizedBox(height: 12),
        Text(local.shippingAndDeliveryPolicy_deliveryDelaysNote),
        const SizedBox(height: 20),
        Text(
          local.shippingAndDeliveryPolicy_needHelpTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(local.shippingAndDeliveryPolicy_needHelpBody),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.email, size: 20),
            const SizedBox(width: 8),
            Text(
              local.shippingAndDeliveryPolicy_emailContact,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          local.shippingAndDeliveryPolicy_phoneContact,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(style: const TextStyle(color: Colors.black), children: [
            TextSpan(
              text: local.shippingAndDeliveryPolicy_thankYou,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: local.shippingAndDeliveryPolicy_thankYouBody,
            ),
          ]),
        ),
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