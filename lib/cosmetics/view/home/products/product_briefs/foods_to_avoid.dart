/* 
import 'package:flutter/material.dart';

class FoodsToAvoidSection extends StatelessWidget {
  const FoodsToAvoidSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFCF8F1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Foods to Avoid While Using A5',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF997D00),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'For best results with A5, aligning your diet with your healing is important. These foods can spike blood sugar levels and reduce the effectiveness of your reversal journey:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              _foodCard(
                imagePath: 'assets/images/white_Sugar.webp',
                title: 'White Sugar',
                description:
                    'Avoid: sweets, candies, cakes, pastries, cold drinks, sweet tea/coffee.',
                description2:
                    '🔵 Even a small amount can cause sudden sugar spikes and insulin resistance.',
              ),
              const SizedBox(height: 10),
              _foodCard(
                imagePath: 'assets/images/white_Rice.webp',
                title: 'White Rice',
                description:
                    'High in starch and carbohydrates, it converts quickly into glucose in the body.',
                description2:
                    '🔵 Instead, opt for brown rice or millets for a healthier alternative.',
              ),
              const SizedBox(height: 10),
              _foodCard(
                imagePath: 'assets/images/potato.webp',
                title: 'Potatoes',
                description:
                    'Also rich in starch, they spike blood sugar levels rapidly.',
                description2:
                    '🔵 Replace them with green vegetables to maintain better glucose control.',
              ),
              SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _foodCard({
    required String imagePath,
    required String title,
    required String description,
    required String description2,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            // Image with X overlay
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                const Icon(
                  Icons.close,
                  size: 60,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Description section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description2,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodsToAvoidSection extends StatelessWidget {
  const FoodsToAvoidSection({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      color: const Color(0xFFFCF8F1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            local.foodsToAvoidTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF997D00),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            local.foodsToAvoidIntro,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              _foodCard(
                imagePath: 'assets/images/white_Sugar.webp',
                title: local.foodWhiteSugarTitle,
                description: local.foodWhiteSugarDesc1,
                description2: local.foodWhiteSugarDesc2,
              ),
              const SizedBox(height: 10),
              _foodCard(
                imagePath: 'assets/images/white_Rice.webp',
                title: local.foodWhiteRiceTitle,
                description: local.foodWhiteRiceDesc1,
                description2: local.foodWhiteRiceDesc2,
              ),
              const SizedBox(height: 10),
              _foodCard(
                imagePath: 'assets/images/potato.webp',
                title: local.foodPotatoesTitle,
                description: local.foodPotatoesDesc1,
                description2: local.foodPotatoesDesc2,
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _foodCard({
    required String imagePath,
    required String title,
    required String description,
    required String description2,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imagePath,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                const Icon(
                  Icons.close,
                  size: 60,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description2,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
