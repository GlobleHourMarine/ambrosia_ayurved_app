import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_description_loader.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_briefs/product_models/how_to_use_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HowToUseSection extends StatefulWidget {
  final String productId;

  const HowToUseSection({super.key, required this.productId});

  @override
  State<HowToUseSection> createState() => _HowToUseSectionState();
}

class _HowToUseSectionState extends State<HowToUseSection> {
  List<HowToUseStep> _steps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSteps();
  }

  Future<void> fetchSteps() async {
    final response = await http.get(
      Uri.parse(
          'https://ambrosiaayurved.in/api/how_to_use?product_id=${widget.productId}'),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        final List data = jsonData['data'];
        setState(() {
          _steps = data.map((e) => HowToUseStep.fromJson(e)).toList()
            ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
          _isLoading = false;
        });
      } else {
        setState(() {
          _steps = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Get the provider state
    // final shouldShowLoader =
    //     Provider.of<ProductLoadingProvider>(context).showIndividualLoaders;
    // if (shouldShowLoader && _isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }
    // // If data is empty and not loading, return empty container
    // if (_steps.isEmpty && !_isLoading) {
    //   return SizedBox();
    // }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _steps.isEmpty
                  ? SizedBox()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.howToUse,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: _steps
                              .map((step) => Column(
                                    children: [
                                      _buildStep(
                                        title: step.title,
                                        description: step.description,
                                        imageUrl: step.image,
                                      ),
                                      Divider(
                                        color: Colors.brown[300],
                                        thickness: 1.5,
                                        height: 25,
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String description,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 110);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// static one 
/* 
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/foods_to_avoid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/products/product_briefs/3_months_plan.dart';

class HowToUseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            t.howToUse,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/mix_powder.jpg',
                width: MediaQuery.of(context).size.width * 0.9,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildStep(
            stepTitle: t.howToUseStep1Title,
            description: t.howToUseStep1Desc,
          ),
          _buildStep(
            stepTitle: t.howToUseStep2Title,
            description: t.howToUseStep2Desc,
          ),
          _buildStep(
            stepTitle: t.howToUseStep3Title,
            description: t.howToUseStep3Desc,
          ),
          _buildStep(
            stepTitle: t.howToUseStep4Title,
            description: t.howToUseStep4Desc,
          ),
          //   ThreeMonthPlan(),
          // SizedBox(height: 25),
          // FoodsToAvoidSection(),
        ],
      ),
    );
  }

  Widget _buildStep({required String stepTitle, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          Divider(
            color: Colors.brown[300],
            thickness: 1.5,
            height: 20,
          ),
        ],
      ),
    );
  }
}

*/

/*

class HowToUseSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          t.howToUse,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/mix_powder.jpg',
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20),
        _buildStep(
          stepTitle: t.howToUseStep1Title,
          description: t.howToUseStep1Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep2Title,
          description: t.howToUseStep2Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep3Title,
          description: t.howToUseStep3Desc,
        ),
        _buildStep(
          stepTitle: t.howToUseStep4Title,
          description: t.howToUseStep4Desc,
        ),
        ThreeMonthPlan(),
      ],
    );
  }
  */