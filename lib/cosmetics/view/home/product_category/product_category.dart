// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:ambrosia_ayurved/cosmetics/common_widgets/shimmer_effect/shimmer_effect.dart';

// class ProductCategory extends StatelessWidget {
//   final List<Map<String, String>> categories = [
//     {
//       'name': 'Pharma',
//       'image':
//           'https://cdn.pixabay.com/photo/2016/07/24/21/01/thermometer-1539191_1280.jpg',
//     },
//     {
//       'name': 'Skincare',
//       'image':
//           'https://cdn.pixabay.com/photo/2024/03/27/13/40/ai-generated-8659156_1280.jpg',
//     },
//     {
//       'name': 'Lips',
//       'image':
//           'https://cdn.pixabay.com/photo/2021/10/10/21/52/makeup-6698881_1280.jpg',
//     },
//     {
//       'name': 'Eyes',
//       'image':
//           'https://cdn.pixabay.com/photo/2019/11/22/18/21/cosmetics-4645407_1280.jpg',
//     },
//     {
//       'name': 'Face',
//       'image':
//           'https://cdn.pixabay.com/photo/2022/10/10/18/00/cosmetics-7512332_1280.jpg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Column(
//             children: [
//               Row(
//                 children: categories
//                     .map((category) => _buildCategoryItem(
//                           category['image']!,
//                           category['name']!,
//                         ))
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategoryItem(String imageUrl, String label) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     width: 70,
//                     height: 70,
//                     child: Image.network(
//                       imageUrl,
//                       fit: BoxFit.cover,
//                       width: 70,
//                       height: 70,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) {
//                           return ClipOval(child: child);
//                         } else {
//                           return const ShimmerEffect(
//                             width: 70,
//                             height: 70,
//                             shape: CircleBorder(),
//                           );
//                         }
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return const ShimmerEffect(
//                           width: 70,
//                           height: 70,
//                           shape: CircleBorder(),
//                         );
//                       },
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: ClipOval(
//                       // borderRadius: BorderRadius.circular(20),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//                         child: Container(
//                           color: Colors.black
//                               .withOpacity(0.2), // Dark overlay effect
//                           alignment: Alignment.center,
//                           child: const Text(
//                             "Coming Soon",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 style:
//                     const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           // Blur Overlay with "Coming Soon" Text
//         ],
//       ),
//     );
//   }
// }
