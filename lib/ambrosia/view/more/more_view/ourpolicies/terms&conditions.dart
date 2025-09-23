import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/terms&conditions/terms&conditions1.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/terms&conditions/terms&conditions2.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/terms&conditions/terms&condtions3.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const BackButton(color: Colors.black),
        title: '${AppLocalizations.of(context)!.termsConditions}'
            'Terms and Conditions',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TermsAndConditionsScreen1(),
              TermsAndConditionsScreen2(),
              TermsAndConditionsScreen3(),
            ],
          ),
        ),
      ),
    );
  }
}
