/*
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Acolors.placeholder,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Stay Connected",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(Icons.email, "mailto:contact@klizard.com"),
              _buildIconButton(Icons.phone, "tel:+1234567890"),
              _buildIconButton(
                  Icons.location_on, "https://goo.gl/maps/example"),
              _buildIconButton(
                  Icons.camera_alt, "https://www.instagram.com/yourpage"),
              _buildIconButton(
                  Icons.facebook, "https://www.facebook.com/yourpage"),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white54, thickness: 0.5),
          const SizedBox(height: 10),
          const Text(
            "© 2025 Klizard Technologies",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(30),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
*/

/*
 // main from flutter 

import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:ambrosia_ayurved/widgets/appbar.dart';
import 'package:ambrosia_ayurved/widgets/custom_scaffold.dart';

class FooterNew extends StatelessWidget {
  // This widget is the root of your application.
  static Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };
  //MaterialColor myColor = MaterialColor(0xFF162A49, color);

  @override
  Widget build(BuildContext context) {
    return FooterPage();
  }
}

class FooterPage extends StatefulWidget {
  @override
  FooterPageState createState() {
    return new FooterPageState();
  }
}

class FooterPageState extends State<FooterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: new Text(
        'Flutter Footer View',
        style: TextStyle(fontWeight: FontWeight.w200),
      )),
      drawer: new Drawer(),
      body: FooterView(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 50, left: 70),
                  child: new Text('Scrollable View Section'),
                )
              ],
            ),
          ],
          footer: new Footer(
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Center(
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.audiotrack,
                                    size: 20.0,
                                  ),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )),
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.fingerprint,
                                    size: 20.0,
                                  ),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )),
                        new Container(
                            height: 45.0,
                            width: 45.0,
                            child: Center(
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      25.0), // half of height and width of Image
                                ),
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.call,
                                    size: 20.0,
                                  ),
                                  color: Color(0xFF162A49),
                                  onPressed: () {},
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    'Copyright ©2020, All Rights Reserved.',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Color(0xFF162A49)),
                  ),
                  Text(
                    'Powered by Nexsport',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        color: Color(0xFF162A49)),
                  ),
                ]),
            padding: EdgeInsets.all(5.0),
          )),
      floatingActionButton: new FloatingActionButton(
          elevation: 10.0,
          child: new Icon(Icons.chat),
          backgroundColor: Color(0xFF162A49),
          onPressed: () {}),
    );
  }
}
*/

// the working one
import 'package:ambrosia_ayurved/cosmetics/common/contact_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FooterNew extends StatelessWidget {
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
            SizedBox(height: 20)
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
    // subject: 'mailto example subject',
    // body: 'mailto example body',
  );
  await launch('$mailtoLink');
}

/*
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:ambrosia_ayurved/widgets/appbar.dart';
import 'package:ambrosia_ayurved/widgets/custom_scaffold.dart';

class FooterNew extends StatefulWidget {
  // This widget is the root of your application.
  static Map<int, Color> color = {
    50: Color.fromRGBO(4, 131, 184, .1),
    100: Color.fromRGBO(4, 131, 184, .2),
    200: Color.fromRGBO(4, 131, 184, .3),
    300: Color.fromRGBO(4, 131, 184, .4),
    400: Color.fromRGBO(4, 131, 184, .5),
    500: Color.fromRGBO(4, 131, 184, .6),
    600: Color.fromRGBO(4, 131, 184, .7),
    700: Color.fromRGBO(4, 131, 184, .8),
    800: Color.fromRGBO(4, 131, 184, .9),
    900: Color.fromRGBO(4, 131, 184, 1),
  };

  @override
  State<FooterNew> createState() => _FooterNewState();
}

class _FooterNewState extends State<FooterNew> {
  //MaterialColor myColor = MaterialColor(0xFF162A49, color);
  @override
  Widget build(BuildContext context) {
    return FooterView(
        children: <Widget>[],
        footer: new Footer(
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Center(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Container(
                          height: 45.0,
                          width: 45.0,
                          child: Center(
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // half of height and width of Image
                              ),
                              child: IconButton(
                                icon: new Icon(
                                  Icons.audiotrack,
                                  size: 20.0,
                                ),
                                color: Color(0xFF162A49),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      new Container(
                          height: 45.0,
                          width: 45.0,
                          child: Center(
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // half of height and width of Image
                              ),
                              child: IconButton(
                                icon: new Icon(
                                  Icons.fingerprint,
                                  size: 20.0,
                                ),
                                color: Color(0xFF162A49),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      new Container(
                          height: 45.0,
                          width: 45.0,
                          child: Center(
                            child: Card(
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    25.0), // half of height and width of Image
                              ),
                              child: IconButton(
                                icon: new Icon(
                                  Icons.call,
                                  size: 20.0,
                                ),
                                color: Color(0xFF162A49),
                                onPressed: () {},
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                Text(
                  'Copyright ©2020, All Rights Reserved.',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                      color: Color(0xFF162A49)),
                ),
                Text(
                  'Powered by Nexsport',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                      color: Color(0xFF162A49)),
                ),
              ]),
          padding: EdgeInsets.all(5.0),
        ));
  }
}
*/
