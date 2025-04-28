import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/cancellation/cancellation&refund1.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/cancellation/cancellation&refund2.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/cancellation/cancellation&refund3.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/cancellation/cancellation&refund4.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancellationRefundPolicyScreen extends StatelessWidget {
  const CancellationRefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: '${AppLocalizations.of(context)!.cancellationRefundPolicy}'
          // 'Cancellation, Return & Refund Policy',
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CancellationRefundPolicyScreen1(),
              CancellationRefundPolicyScreen2(),
              CancellationRefundPolicyScreen3(),
              CancellationRefundPolicyScreen4(),
            ],
          ),
        ),
      ),
    );
  }
}
