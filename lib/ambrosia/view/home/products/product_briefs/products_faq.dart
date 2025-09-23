import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_description_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FAQPage extends StatefulWidget {
  final String productId;

  FAQPage({required this.productId});

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<FAQItem> faqs = [];
  bool isLoading = true;
  String errorMessage = '';
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    fetchFAQs();
  }

  Future<void> fetchFAQs() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://ambrosiaayurved.in/api/faq?product_id=${widget.productId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          setState(() {
            faqs = (data['data'] as List)
                .map((item) => FAQItem.fromJson(item))
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to load FAQs');
        }
      } else {
        throw Exception('Failed to load FAQs: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the provider state
    final shouldShowLoader =
        Provider.of<ProductLoadingProvider>(context).showIndividualLoaders;
    if (shouldShowLoader && isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    // If data is empty and not loading, return empty container

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green[50]!, Colors.white],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Get answers to common questions about our product',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            // if (isLoading)
            //   Center(child: CircularProgressIndicator())

            // else if (faqs.isEmpty)
            //   Center(
            //     child: Text(
            //       'No FAQs available for this product',
            //       style: TextStyle(color: Colors.grey),
            //     ),
            //   )
            // else

            if (faqs.isEmpty && !isLoading)
              Center(
                child: Text(
                  'No FAQs available for this product',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: faqs.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return FAQCard(
                    faq: faqs[index],
                    questionIndex: index,
                    isExpanded: expandedIndex == index,
                    onTap: () {
                      setState(() {
                        expandedIndex = expandedIndex == index ? null : index;
                      });
                    },
                  );
                },
              ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class FAQCard extends StatelessWidget {
  final FAQItem faq;
  final int questionIndex;
  final bool isExpanded;
  final VoidCallback onTap;

  const FAQCard({
    required this.faq,
    required this.questionIndex,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        // Add semantic properties here
        child: Semantics(
          button: true,
          label: 'FAQ question ${questionIndex + 1}',
          hint: isExpanded ? 'Double tap to collapse' : 'Double tap to expand',
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Semantics(
                      label: 'Question number ${questionIndex + 1}',
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Q${questionIndex + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Semantics(
                        label: 'Question content',
                        child: Text(
                          faq.question,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Semantics(
                      label: isExpanded ? 'Expanded' : 'Collapsed',
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  SizedBox(height: 12),
                  Divider(height: 1, color: Colors.grey[300]),
                  SizedBox(height: 12),
                  Semantics(
                    label: 'Answer to question ${questionIndex + 1}',
                    child: Text(
                      faq.answer,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FAQItem {
  final String id;
  final String productId;
  final String questionNumber;
  final String question;
  final String answer;
  final String status;
  final String createdAt;
  final String updatedAt;

  FAQItem({
    required this.id,
    required this.productId,
    required this.questionNumber,
    required this.question,
    required this.answer,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      questionNumber: json['question_number'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
