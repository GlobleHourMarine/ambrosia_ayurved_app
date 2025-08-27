import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';

class FAQSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final List<Map<String, String>> faqData = [
      {"question": loc.faqQ1, "answer": loc.faqA1},
      {"question": loc.faqQ2, "answer": loc.faqA2},
      {"question": loc.faqQ3, "answer": loc.faqA3},
      {"question": loc.faqQ4, "answer": loc.faqA4},
      {"question": loc.faqQ5, "answer": loc.faqA5},
      {"question": loc.faqQ6, "answer": loc.faqA6},
      {"question": loc.faqQ7, "answer": loc.faqA7},
    ];

    return Scaffold(
      appBar: CustomAppBar(title: loc.faqTitle),
      body: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: ListView.builder(
          itemCount: faqData.length,
          itemBuilder: (context, index) {
            final faq = faqData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Text(
                    "Q${index + 1}. ${faq["question"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        faq["answer"]!,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
