import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/products/product_fetch/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedCountersScreen extends StatefulWidget {
  @override
  _AnimatedCountersScreenState createState() => _AnimatedCountersScreenState();
}

class _AnimatedCountersScreenState extends State<AnimatedCountersScreen>
    with WidgetsBindingObserver {
  List<int> finalCounts = [258, 145, 2, 345]; // Target numbers
  List<int> currentCounts = [0, 0, 0, 0]; // Initial values
  List<IconData> icons = [
    Icons.emoji_events, // Happy Clients
    Icons.group, // Team Members
    Icons.workspace_premium, // Experience
    Icons.fact_check, // Deliver Result
  ];

  bool _hasStartedCounting = false; // Flag to prevent multiple triggers
  final Key _visibilityKey =
      UniqueKey(); // Unique key for the visibility detector

  List<Timer> _timers = []; // Keep track of all timers
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check visibility after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVisibilityAndStartIfNeeded();
    });
    //   _startCounting();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Cancel all timers when widget is disposed
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkVisibilityAndStartIfNeeded();
    }
  }

  void checkVisibilityAndStartIfNeeded() {
    // Check if widget is already in viewport on initial load
    if (!_hasStartedCounting && mounted) {
      // Try to start counting immediately if widget is visible
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject != null && renderObject is RenderBox) {
        final viewportHeight = MediaQuery.of(context).size.height;
        final position = renderObject.localToGlobal(Offset.zero);

        // If widget is in viewport
        if (position.dy < viewportHeight &&
            position.dy + renderObject.size.height > 0) {
          _startCounting();
        }
      }
    }
  }

  void _startCounting() {
    if (_hasStartedCounting) return; // Prevent multiple triggers

    print("Starting counter animation!"); // Debug print

    setState(() {
      _hasStartedCounting = true;
    });

    for (int i = 0; i < finalCounts.length; i++) {
      final int index =
          i; // Create a local variable to capture the current index

      // Calculate duration based on final count to make all animations finish around the same time
      final int steps = finalCounts[index];
      final int incrementInterval =
          (2000 / steps).ceil(); // 2 seconds total animation

      final timer =
          Timer.periodic(Duration(milliseconds: incrementInterval), (timer) {
        if (mounted) {
          setState(() {
            if (currentCounts[index] < finalCounts[index]) {
              // Increment by calculated amount to finish in roughly the same time
              currentCounts[index] = currentCounts[index] + 1;
            } else {
              timer.cancel();
            }
          });
        } else {
          timer.cancel();
        }
      });

      _timers.add(timer);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> labels = [
      "${AppLocalizations.of(context)!.happyClients}",
      "${AppLocalizations.of(context)!.teamMembers}",
      "${AppLocalizations.of(context)!.yearsExperience}",
      "${AppLocalizations.of(context)!.deliverResult}",
      // "Happy Clients",
      // "Team Members",
      // "Years Experience",
      // "Deliver Result"
    ];

    final productNotifier = Provider.of<ProductNotifier>(context);

    if (productNotifier.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final productId = productNotifier.products.first.id;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (visibilityInfo) {
        // Debug print to see visibility changes
        print("Visibility changed: ${visibilityInfo.visibleFraction}");

        // Start counting when widget becomes at least 10% visible
        if (visibilityInfo.visibleFraction >= 0.1 &&
            !_hasStartedCounting &&
            mounted) {
          _startCounting();
        }
      },
      child: Column(
        children: [
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(finalCounts.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.7, // Set a fixed width
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align to the left
                    children: [
                      CustomHexagon(icon: icons[index]), // Hexagon with Icon
                      SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Align text to left
                          children: [
                            Text(
                              "${currentCounts[index]} +",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          // SizedBox(height: 30),
          // Card(
          //   color: Acolors.gradientss,
          //   child: Padding(
          //     padding: const EdgeInsets.all(12.0),
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.circular(20),
          //         child: Image.asset('assets/images/A5_aboutus.webp')),
          //   ),
          // ),
          // SizedBox(height: 30),
          // CustomerReviewSection(productId: productId.toString()),
        ],
      ),
    );
  }
}

// Custom Hexagon Widget
class CustomHexagon extends StatelessWidget {
  final IconData icon;
  CustomHexagon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Hexagon (Shadow)
        CustomPaint(
          size: Size(100, 100),
          painter: HexagonPainter(Acolors.primary.withOpacity(0.1)),
        ),
        // Foreground Hexagon with Gradient Border
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.purple, Acolors.primary],
            ).createShader(bounds);
          },
          child: CustomPaint(
            size: Size(90, 90),
            painter: HexagonBorderPainter(),
          ),
        ),
        // Icon in Center
        Icon(
          icon,
          size: 40,
          color: Acolors.primary,
        ),
      ],
    );
  }
}

// Painter for Solid Hexagon (Shadow Effect)
class HexagonPainter extends CustomPainter {
  final Color color;
  HexagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = createHexagonPath(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Painter for Hexagon Border (Gradient)
class HexagonBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = LinearGradient(
        colors: [Colors.purple, Acolors.primary],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = createHexagonPath(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Function to Generate Hexagon Path
Path createHexagonPath(Size size) {
  double width = size.width;
  double height = size.height;
  double side = width / 2;
  double centerHeight = height / 2;

  return Path()
    ..moveTo(side, 0)
    ..lineTo(width, centerHeight / 2)
    ..lineTo(width, centerHeight + centerHeight / 2)
    ..lineTo(side, height)
    ..lineTo(0, centerHeight + centerHeight / 2)
    ..lineTo(0, centerHeight / 2)
    ..close();
}
