import 'dart:ui';

import 'package:flutter/material.dart';

class ClothesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clothes")),
      body: Stack(
        children: [
          Center(child: Text("Clothes")),
          // Blur Overlay with "Coming Soon" Text
          Positioned.fill(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.1), // Dark overlay effect
                  alignment: Alignment.center,
                  child: const Text(
                    "Coming Soon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
