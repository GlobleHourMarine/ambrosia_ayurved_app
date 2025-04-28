import 'package:flutter/material.dart';
import 'dart:math';

class HexagonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Hexagon (Shadow Effect)
        CustomPaint(
          size: Size(130, 130), // Adjust size
          painter: HexagonPainter(Colors.blue.withOpacity(0.1)),
        ),
        // Foreground Hexagon with Border
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ).createShader(bounds);
          },
          child: CustomPaint(
            size: Size(120, 120), // Slightly smaller to fit inside shadow
            painter: HexagonBorderPainter(),
          ),
        ),
        // Icon in Center
        Padding(
          padding: EdgeInsets.all(20), // Adjust spacing
          child: Icon(Icons.star, size: 40, color: Colors.purple),
        ),
      ],
    );
  }
}

// Painter for Solid Hexagon (Background Shadow)
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
        colors: [Colors.purple, Colors.blue],
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
