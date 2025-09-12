import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox(
            //  height: 300,
            width: double.infinity,
            child: Lottie.asset(
              'assets/images/login_1.json',
              //  fit: BoxFit.fill,
              repeat: true,
              errorBuilder: (context, error, stackTrace) => Lottie.network(
                'https://assets5.lottiefiles.com/packages/lf20_ktwnwv5m.json', // Fallback animation
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
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
