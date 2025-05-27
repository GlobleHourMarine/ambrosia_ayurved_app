import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/new_bottom_nav_bar.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Use Future.delayed to ensure splash screen is visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToAppropriateScreen(userProvider);
        });

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/splash_new.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Center(
                  child: Image.asset(
                'assets/images/logo_final_aa_r.png',
                width: 150,
                height: 150,
              )),

              // Rest of your splash screen UI
            ],
          ),
        );
      },
    );
  }

  void _navigateToAppropriateScreen(UserProvider userProvider) async {
    print('Splash Screen - Is Logged In: ${userProvider.isLoggedIn}');
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
