import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/shimmer_effect/shimmer_effect.dart'; // Replace with your shimmer class import

class Carousel extends StatefulWidget {
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> imageUrls = [
    // 'assets/images/c11.jpg',
    // 'assets/images/c22.jpg',
    // 'assets/images/c33.jpg',
    // 'assets/images/c44.jpg',
    // 'assets/images/c66.jpg',

    'assets/images/carosel.3.webp',
    'assets/images/carosel.4.webp',
    'assets/images/carosel.1.webp',
    'assets/images/carosel.2.webp',
    'assets/images/carosel.5.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider.builder(
        itemCount: imageUrls.length, // Use the length of imageUrls list
        itemBuilder: (BuildContext context, int index, int realIndex) {
          String imageUrl = imageUrls[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Rounded corners
              child: Stack(
                children: [
                  // Shimmer Effect
                  ShimmerEffect(
                    width: double.infinity,
                    height: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  // Image Network

                  Image.asset(
                    imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity, // Ensure it takes full width
                    height: double.infinity, // Ensure it takes full height
                    // loadingBuilder: (context, child, loadingProgress) {
                    //   if (loadingProgress == null) return child;
                    //   return Container(); // Keep shimmer visible until the image loads
                    // },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(); // Keep shimmer visible if image fails
                    },
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 260.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9, // Matches standard image aspect ratio
          enableInfiniteScroll: true,
          autoPlayInterval: Duration(seconds: 4),
          autoPlayAnimationDuration: Duration(milliseconds: 1200),
          viewportFraction: 0.8,
        ),
      ),
    );
  }
}
