import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          Image.asset(
            'assets/images/backround2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
      // bottomNavigationBar: BottomNav(
      //   selectedIndex: 3, // Payment screen selected index
      // ),
    );
  }
}
