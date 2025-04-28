import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OurMissionSection extends StatefulWidget {
  const OurMissionSection({super.key});

  @override
  State<OurMissionSection> createState() => _OurMissionSectionState();
}

class _OurMissionSectionState extends State<OurMissionSection> {
  List<bool> _visible = List.generate(8, (_) => false);

  @override
  void initState() {
    super.initState();
    _startFadeIn();
  }

  void _startFadeIn() async {
    for (int i = 0; i < _visible.length; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _visible[i] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.ourMissionTitle,
            //  '🎯 Our Mission',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006666), // teal color
            ),
          ),
          SizedBox(height: 4), // Space between text and underline
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Container(
              height: 2,
              width: 160, // adjust as needed
              color: Color(0xFF006666),
            ),
          ),
        ],
      ),
      Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/our_mission.webp',
            fit: BoxFit.fill,
          ),
        ),
      ),
      Text(
        AppLocalizations.of(context)!.ourMissionIntro,
        // 'We’re not here to sell quick fixes.\nWe bring back real, natural healing.',
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      Text(AppLocalizations.of(context)!.ourMissionStatement,
          //'Our mission is to:',
          style: TextStyle(fontSize: 16, height: 1.8)),
      _buildBullet(AppLocalizations.of(context)!.missionPoint1),
      _buildBullet(AppLocalizations.of(context)!.missionPoint2),
      _buildBullet(AppLocalizations.of(context)!.missionPoint3),
      _buildBullet(AppLocalizations.of(context)!.missionPoint4),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(texts.length, (i) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _visible[i] ? 1.0 : 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: texts[i],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBullet(String text) {
    final parts = text.split('**');
    List<InlineSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          fontWeight: i.isOdd ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
          height: 1.5,
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.circle, size: 6),
            ),
          ),
          ...spans
        ],
      ),
    );
  }
}
