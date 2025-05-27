import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutMessageView extends StatefulWidget {
  const CheckoutMessageView({Key? key}) : super(key: key);

  @override
  _CheckoutMessageViewState createState() => _CheckoutMessageViewState();
}

class _CheckoutMessageViewState extends State<CheckoutMessageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translationAnimation;

  @override
  void initState() {
    super.initState();

    // Increased duration for slower animations
    _animationController = AnimationController(
      duration:
          const Duration(milliseconds: 2000), // Increased from 1200 to 2000
      vsync: this,
    );

    // Opacity Animation with slower curve
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve:
            const Interval(0.0, 0.8, curve: Curves.decelerate), // Changed curve
      ),
    );

    // Translation Animation with slower movement
    _translationAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.ease), // Changed curve
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _translationAnimation.value),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      SizedBox(height: 100),

                      // Lottie Animation with Slower Scale Transition
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.0, 0.8,
                                curve: Curves.slowMiddle), // Slower curve
                          ),
                        ),
                        child: Lottie.asset(
                          'assets/images/animation_for_order_plac.json',
                        ),
                      ),

                      // Animated Elements with Slower Staggered Entrance
                      _buildAnimatedText(
                        child: Text(
                          "${AppLocalizations.of(context)!.thankYou}",
                          //  'Thank You!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        interval: const Interval(0.4, 0.7,
                            curve: Curves.easeOut), // Slower interval
                      ),

                      const SizedBox(height: 10),

                      _buildAnimatedText(
                        child: Text(
                          "${AppLocalizations.of(context)!.orderPlaced}",
                          //  "Your order has been placed successfully",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Acolors.primaryText.withOpacity(0.8),
                            fontSize: 18,
                          ),
                        ),
                        interval: const Interval(0.5, 0.8,
                            curve: Curves.easeOut), // Slower interval
                      ),

                      const SizedBox(height: 20),

                      _buildAnimatedText(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            AppLocalizations.of(context)!
                                .orderProcessingMessage,
                            //   "We're processing your order and will notify you when it's on the way.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Acolors.primaryText.withOpacity(0.7),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                        interval: const Interval(0.6, 0.9,
                            curve: Curves.easeOut), // Slower interval
                      ),

                      const SizedBox(height: 20),

                      // Animated Continue Shopping Button with Slower Animation
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.7, end: 1.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.7, 1.0,
                                curve: Curves.slowMiddle), // Slower curve
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.continueShopping,
                            //   'Continue Shopping',
                            style: TextStyle(
                              fontSize: 18,
                              color: Acolors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to create animated text widgets with slower animation
  Widget _buildAnimatedText(
      {required Widget child, required Interval interval}) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: interval,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: interval,
          ),
        ),
        child: child,
      ),
    );
  }
}

/*
 
 import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/new_bottom_nav_bar.dart';

*/
class CheckoutMessageView1 extends StatefulWidget {
  const CheckoutMessageView1({super.key});

  @override
  State<CheckoutMessageView1> createState() => _CheckoutMessageView1State();
}

class _CheckoutMessageView1State extends State<CheckoutMessageView1>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        width: media.width,
        decoration: BoxDecoration(
          color: Acolors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 30),
              Image.asset(
                "assets/images/thank_you.png",
                width: media.width * 0.55,
              ),
              const SizedBox(height: 20),
              Text(
                "Thank You!",
                style: TextStyle(
                  color: Acolors.primaryText,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your order has been placed successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Acolors.primaryText.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "We're processing your order and will notify you when it's on the way.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Acolors.primaryText.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: media.width * 0.6,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    // backgroundColor: Acolors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Back To Home",
                    style: TextStyle(
                      //  color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
