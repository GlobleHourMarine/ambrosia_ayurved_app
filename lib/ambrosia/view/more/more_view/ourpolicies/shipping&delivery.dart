import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/shipping&delivery/shipping&delivery1.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShippingAndDeliveryPolicyScreen extends StatelessWidget {
  const ShippingAndDeliveryPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          leading: const BackButton(color: Colors.black),
          title: '${AppLocalizations.of(context)!.shippingPolicy}'
          // 'Shipping & Delivery Policy'

          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShippingAndDeliveryPolicyScreen1(),
            ],
          ),
        ),
      ),
    );
  }
}
