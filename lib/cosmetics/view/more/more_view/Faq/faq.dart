import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';

class FAQSection extends StatelessWidget {
  final List<Map<String, String>> faqData = [
    {
      "question":
          "What is A5, and how is it different from other Ayurvedic medicines for diabetes?",
      "answer":
          "A5 is a uniquely formulated ayurvedic medicine for diabetes made from a potent blend of 25+ herbs sourced from India and Malaysia. Unlike generic remedies, A5 works at the root level by rejuvenating the pancreas, restoring insulin sensitivity, and naturally regulating blood sugar without side effects.",
    },
    {
      "question": "Can A5 completely reverse Type 2 Diabetes?",
      "answer":
          "Yes. A5 is clinically designed to manage and eliminate Type 2 Diabetes within 3 months of consistent use. It detoxifies the body, repairs insulin pathways, and helps regenerate beta cells, which makes reversal possible in many cases, depending on the severity and lifestyle adherence.",
    },
    {
      "question": "How long does it take to see results with A5?",
      "answer":
          "Most users start seeing improvements in fasting and postprandial sugar levels within the first 2 to 4 weeks. However, for full reversal, a minimum of 3 months of regular use is recommended, as per the A5 protocol.",
    },
    {
      "question": "Is A5 safe for long-term use?",
      "answer":
          "Absolutely. A5 is a 100% natural and herbal formula with no steroids, chemicals, or preservatives. It is non-addictive and safe for prolonged use — making it one of the most trusted ayurvedic medicines for diabetes available today.",
    },
    {
      "question":
          "Does A5 interact with allopathic medicines like Metformin or insulin?",
      "answer":
          "No harmful interactions have been reported. Many users gradually reduce or completely stop allopathic medications under medical supervision after starting A5. However, we recommend consulting your doctor before making any changes to your current prescription.",
    },
    {
      "question": "Can A5 be used alongside a regular diet and lifestyle?",
      "answer":
          "Yes. While A5 works effectively on its own, combining it with a diabetes-friendly diet and daily exercise enhances the reversal process. A5 supports your body's natural ability to heal, making it a holistic ayurvedic medicine for diabetes.",
    },
    {
      "question":
          "Is A5 effective for both early-stage and long-term diabetes?",
      "answer":
          "Yes, A5 has shown positive results in both newly diagnosed and long-term diabetic individuals. The formulation is adaptive — it targets the metabolic root causes regardless of how long you've had diabetes.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'FAQ',
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 7),
        child: Container(
          child: ListView.builder(
            //   shrinkWrap: true,
            //  physics: NeverScrollableScrollPhysics(),
            itemCount: faqData.length,
            itemBuilder: (context, index) {
              final faq = faqData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    title: Text(
                      "Q${index + 1}. ${faq["question"]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
