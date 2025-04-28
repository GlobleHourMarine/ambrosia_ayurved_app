import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Links: ',
            style: TextStyle(
              fontSize: 24,
              color: Acolors.primary,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButton(
                  FontAwesomeIcons.phone, 'tel:01762-458122', Colors.blue),
              // _buildIconButton(FontAwesomeIcons.envelope,
              //     'mailto:care@ambrosiaayurved.in', Colors.red),
              // _buildIconButton(
              //     FontAwesomeIcons.mapMarkerAlt,
              //     'https://www.google.com/maps?q=3rd+floor+Motia,+MOTIAZ+ROYAL+BUSINESS+PARK,+28-B,+Zirakpur,+Punjab+140603',
              //     Colors.blue),
              _buildIconButton(
                FontAwesomeIcons.squareFacebook,
                'https://www.facebook.com/profile.php?id=61574148759468',
                Colors.blue,
              ),
              // _buildIconButton(FontAwesomeIcons.instagram,
              //     'https://www.instagram.com/ambrosia.ayurved', Colors.orange),
              _buildIconButton(
                FontAwesomeIcons.earth,
                'https://ambrosiaayurved.in/',
                Colors.green,
              ),
              // _buildIconButton(FontAwesomeIcons.twitter,
              //     'https://x.com/AmbrosiaAyurved', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String url, Color color) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: FadeInLeft(
        duration: Duration(milliseconds: 800),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Icon(icon, color: color, size: 60),
        ),
      ),
    );
  }
}
