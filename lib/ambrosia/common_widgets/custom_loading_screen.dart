import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatelessWidget {
  final String? message;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? strokeWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;

  const CustomLoadingScreen({
    Key? key,
    this.message,
    this.primaryColor,
    this.backgroundColor,
    this.strokeWidth,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: borderRadius ?? BorderRadius.circular(15),
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                    ),
                  ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    primaryColor ?? Theme.of(context).primaryColor,
                  ),
                  strokeWidth: strokeWidth ?? 3,
                ),
                if (message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    message!,
                    style: TextStyle(
                      fontSize: fontSize ?? 16,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      color: textColor ?? Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: More advanced version with animation
class AnimatedLoadingScreen extends StatefulWidget {
  final String? message;
  final Color? primaryColor;
  final Color? backgroundColor;
  final double? strokeWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;
  final Duration? animationDuration;

  const AnimatedLoadingScreen({
    Key? key,
    this.message,
    this.primaryColor,
    this.backgroundColor,
    this.strokeWidth,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.boxShadow,
    this.animationDuration,
  }) : super(key: key);

  @override
  State<AnimatedLoadingScreen> createState() => _AnimatedLoadingScreenState();
}

class _AnimatedLoadingScreenState extends State<AnimatedLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration ?? const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: widget.padding ?? const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Colors.white,
                      borderRadius:
                          widget.borderRadius ?? BorderRadius.circular(15),
                      boxShadow: widget.boxShadow ??
                          [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 15,
                            ),
                          ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.primaryColor ??
                                Theme.of(context).primaryColor,
                          ),
                          strokeWidth: widget.strokeWidth ?? 3,
                        ),
                        if (widget.message != null) ...[
                          const SizedBox(height: 20),
                          Text(
                            widget.message!,
                            style: TextStyle(
                              fontSize: widget.fontSize ?? 16,
                              fontWeight: widget.fontWeight ?? FontWeight.w500,
                              color: widget.textColor ?? Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Preset loading screens for common use cases
class LoadingScreenPresets {
  // Simple loading
  static Widget simple({String? message}) {
    return CustomLoadingScreen(message: message);
  }

  // Product loading
  static Widget product() {
    return const CustomLoadingScreen(
      message: 'Loading product details...',
    );
  }

  // Order tracking
  static Widget orderTracking() {
    return const CustomLoadingScreen(
      message: 'Tracking your order...',
    );
  }

  // Cart loading
  static Widget cart() {
    return const CustomLoadingScreen(
      message: 'Loading your cart...',
    );
  }

  // Profile loading
  static Widget profile() {
    return const CustomLoadingScreen(
      message: 'Loading profile...',
    );
  }

  // Custom with primary color
  static Widget withPrimaryColor(BuildContext context, {String? message}) {
    return CustomLoadingScreen(
      message: message,
      primaryColor: Theme.of(context).primaryColor,
    );
  }

  // Dark theme loading
  static Widget dark({String? message}) {
    return CustomLoadingScreen(
      message: message,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      primaryColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 15,
        ),
      ],
    );
  }

  // Minimal loading (no container)
  static Widget minimal({String? message, Color? color}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.blue),
          ),
          if (message != null) ...[
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
