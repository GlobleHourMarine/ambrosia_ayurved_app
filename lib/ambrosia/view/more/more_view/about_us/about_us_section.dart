import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutUsShortSection extends StatefulWidget {
  const AboutUsShortSection({super.key});

  @override
  State<AboutUsShortSection> createState() => _AboutUsShortSectionState();
}

class _AboutUsShortSectionState extends State<AboutUsShortSection> {
  List<bool> _visible = List.generate(7, (_) => false);

  @override
  void initState() {
    super.initState();
    _startFadeIn();
  }

  void _startFadeIn() async {
    for (int i = 0; i < _visible.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _visible[i] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = [
      Row(
        children: [
          Icon(Icons.groups, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.aboutUsTitle}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006666),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 2,
                  width: 355,
                  color: Color(0xFF006666),
                ),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('assets/images/story_behind_ambrosia.webp'),
        ),
      ),
      Text(
        AppLocalizations.of(context)!.aboutUsPara1,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.5),
      ),
      Text(
        AppLocalizations.of(context)!.aboutUsPara2,
        style:
            TextStyle(fontStyle: FontStyle.italic, fontSize: 16, height: 1.5),
      ),
      Text(
        AppLocalizations.of(context)!.aboutUsPara3,
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
      Text(
        AppLocalizations.of(context)!.aboutUsPara4,
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
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
}
