import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
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
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // ✅ Play success sound when screen opens
    _playSuccessSound();
    _animationController = AnimationController(
      duration:
          const Duration(milliseconds: 2000), // Increased from 1200 to 2000
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve:
            const Interval(0.0, 0.8, curve: Curves.decelerate), // Changed curve
      ),
    );

    _translationAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.ease), // Changed curve
      ),
    );

    _animationController.forward();
  }

  // ✅ play sound function
  Future<void> _playSuccessSound() async {
    try {
      await _player.play(AssetSource('sounds/payment_done.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
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
                          'assets/lottie/animation_for_order_plac.json',
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
