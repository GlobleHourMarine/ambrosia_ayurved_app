import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OurVisionSection extends StatefulWidget {
  const OurVisionSection({super.key});

  @override
  State<OurVisionSection> createState() => _OurVisionSectionState();
}

class _OurVisionSectionState extends State<OurVisionSection> {
  final List<bool> _visible = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _visible.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * i), () {
        if (mounted) {
          setState(() {
            _visible[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible[0] ? 1 : 0,
            child: Row(
              children: [
                Icon(Icons.public, size: 32, color: Colors.blue),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.ourVision,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006666),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 140,
                      color: Color(0xFF006666),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/our_vision.webp',
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 10),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible[1] ? 1 : 0,
            child: Text(
              locale.visionIntro,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          _buildBullet(2, locale.visionPoint1),
          _buildBullet(3, locale.visionPoint2),
          _buildBullet(4, locale.visionPoint3),
          _buildBullet(5, locale.visionPoint4),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible[5] ? 1 : 0,
            child: Text.rich(
              TextSpan(
                text: locale.visionWrap1,
                style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    text: locale.visionWrap2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: locale.visionWrap3),
                  TextSpan(
                    text: locale.visionWrap4,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: locale.visionWrap5),
                  TextSpan(
                    text: locale.visionWrap6,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: locale.visionWrap7),
                  TextSpan(
                    text: locale.visionWrap8,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(int index, String text) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _visible[index] ? 1 : 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 18)),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
