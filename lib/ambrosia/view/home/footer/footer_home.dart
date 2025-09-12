import 'package:ambrosia_ayurved/ambrosia/common/contact_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FooterHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      child: Footer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${AppLocalizations.of(context)!.quickLinks}",
                  // 'Quick Links: ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIcon(
                  FontAwesomeIcons.phone,
                  ContactInfo.phoneUrl,
                  // 'tel:+918000057233',
                  Acolors.primary,
                ), // Replace with actual phone number
                _buildIcons(
                  FontAwesomeIcons.envelope,
                  Colors.red,
                  // 'mailto:care@ambrosiaayurved.in',
                ), // Replace with actual email
                _buildIcon(
                  FontAwesomeIcons.earth,
                  ContactInfo.websiteUrl,
                  //  'https://ambrosiaayurved.in/',
                  Colors.lightGreen,
                ),
                _buildIcon(
                  FontAwesomeIcons.instagram,
                  ContactInfo.instagramUrl,

                  //'https://www.instagram.com/ambrosia.ayurved',
                  Colors.amber,
                ),
                _buildIcon(
                  FontAwesomeIcons.squareFacebook,
                  ContactInfo.facebookUrl,

                  // 'https://www.facebook.com/profile.php?id=61574148759468',
                  Colors.blue,
                ), // Replace with actual Facebook link
              ],
            ),
            SizedBox(height: 20),
            Text(
              "${AppLocalizations.of(context)!.copyright}",
              // 'Copyright ©2020, All Rights Reserved.',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                  color: Color(0xFF162A49)),
            ),
            Text(
              "${AppLocalizations.of(context)!.poweredBy}",
              //  'Powered by Ambrosia Aurved',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                  color: Color(0xFF162A49)),
            ),
            SizedBox(height: 25),
          ],
        ),
        padding: EdgeInsets.all(5.0),
      ),
    );
  }

  Widget _buildIcon(IconData icon, String url, Color iconColor) {
    return Container(
      height: 70.0,
      width: 70.0,
      child: Center(
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor, size: 30.0),
            color: Color(0xFF162A49),
            onPressed: () => _launchURL(url),
          ),
        ),
      ),
    );
  }

  Widget _buildIcons(
    IconData icon,
    Color iconColor,
    // String url
  ) {
    return Container(
      height: 70.0,
      width: 70.0,
      child: Center(
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor, size: 30.0),
            color: Color(0xFF162A49),
            onPressed: () => launchMailto(),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

launchMailto() async {
  final mailtoLink = Mailto(
    to: ['care@ambrosiaayurved.in'],
  );
  await launch('$mailtoLink');
}
