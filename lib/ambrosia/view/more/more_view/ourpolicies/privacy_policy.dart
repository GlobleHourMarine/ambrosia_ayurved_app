import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/privacy_policies/privacy_policy_1.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/privacy_policies/privacy_policy_2.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/privacy_policies/privacy_policy_3.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title:
              //'Privacy Policy',
              '${AppLocalizations.of(context)!.privacyPolicy}'
          //   title: AppLocalizations.of(context)!.cart,
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PrivacyPolicyPart1(),
              PrivacyPolicyPart2(),
              PrivacyPolicyPart3(),
            ],
          ),
        ),
      ),
    );
  }
}
