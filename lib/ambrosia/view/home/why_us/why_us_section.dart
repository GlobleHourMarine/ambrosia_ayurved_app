import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WhyA5Section extends StatelessWidget {
  const WhyA5Section({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    TextStyle headingStyle = const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.whyA5Heading, style: headingStyle),
          const SizedBox(height: 20),
          _featureTile(
            icon: Icons.check_box,
            iconColor: Colors.green,
            title: t.whyA5Point1Title,
            subtitle: t.whyA5Point1Subtitle,
          ),
          _featureTile(
            icon: Icons.eco,
            iconColor: Colors.green.shade800,
            title: t.whyA5Point2Title,
            subtitle: t.whyA5Point2Subtitle,
          ),
          _featureTile(
            icon: Icons.healing,
            iconColor: Colors.grey.shade700,
            title: t.whyA5Point3Title,
            subtitle: t.whyA5Point3Subtitle,
          ),
          _featureTile(
            icon: Icons.shield,
            iconColor: Colors.red,
            title: t.whyA5Point4Title,
            subtitle: t.whyA5Point4Subtitle,
          ),
          _featureTile(
            icon: Icons.bolt,
            iconColor: Colors.blue,
            title: t.whyA5Point5Title,
            subtitle: t.whyA5Point5Subtitle,
          ),
          _featureTile(
            icon: Icons.verified,
            iconColor: Colors.pink,
            title: t.whyA5Point6Title,
            subtitle: t.whyA5Point6Subtitle,
          ),
        ],
      ),
    );
  }

  Widget _featureTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
