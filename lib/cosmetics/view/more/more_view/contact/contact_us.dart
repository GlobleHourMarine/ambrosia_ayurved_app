import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/contact/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/*
///Class for adding contact details/profile details as a complete new page in your flutter app.
class ContactUs extends StatelessWidget {
  ///Logo of the Company/individual
  final ImageProvider? logo;

  ///Ability to add an image
  final Image? image;

  ///Phone Number of the company/individual
  final String? phoneNumber;

  ///Text for Phonenumber
  final String? phoneNumberText;

  ///Website of company/individual
  final String? website;

  ///Text for Website
  final String? websiteText;

  ///Email ID of company/individual
  final String email;

  ///Text for Email
  final String? emailText;

  ///Twitter Handle of Company/Individual
  final String? twitterHandle;

  ///Facebook Handle of Company/Individual
  final String? facebookHandle;

  ///Linkedin URL of company/individual
  final String? linkedinURL;

  ///Github User Name of the company/individual
  final String? githubUserName;

  ///Tiktok URL of the comapny/individual
  final String? tiktokUrl;

  ///Name of the Company/individual
  final String companyName;

  ///Font size of Company name
  final double? companyFontSize;

  ///TagLine of the Company or Position of the individual
  final String? tagLine;

  ///Instagram User Name of the company/individual
  final String? instagram;

  ///TextColor of the text which will be displayed on the card.
  final Color textColor;

  ///Color of the Card.
  final Color cardColor;

  ///Color of the company/individual name displayed.
  final Color companyColor;

  ///Color of the tagLine of the Company/Individual to be displayed.
  final Color taglineColor;

  /// font of text
  final String? textFont;

  /// font of the company/individul to be displayed
  final String? companyFont;

  /// font of the tagline to be displayed
  final String? taglineFont;

  /// divider color which is placed between the tagline & contact informations
  final Color? dividerColor;

  /// divider thickness which is placed between the tagline & contact informations

  final double? dividerThickness;

  ///font weight for tagline and company name
  final FontWeight? companyFontWeight;
  final FontWeight? taglineFontWeight;

  /// avatar radius will place the circularavatar according to developer/UI need
  final double? avatarRadius;

  /// a list of [CustomSocialField] which can be used to add custom socials which are
  /// not offered by default parameters
  final List<CustomSocialField>? customSocials;

  ///Constructor which sets all the values.
  ContactUs({
    required this.companyName,
    required this.textColor,
    required this.cardColor,
    required this.companyColor,
    required this.taglineColor,
    required this.email,
    this.emailText,
    this.logo,
    this.image,
    this.phoneNumber,
    this.phoneNumberText,
    this.website,
    this.websiteText,
    this.twitterHandle,
    this.facebookHandle,
    this.linkedinURL,
    this.githubUserName,
    this.tiktokUrl,
    this.tagLine,
    this.instagram,
    this.companyFontSize,
    this.textFont,
    this.companyFont,
    this.taglineFont,
    this.dividerColor,
    this.companyFontWeight,
    this.taglineFontWeight,
    this.avatarRadius,
    this.dividerThickness,
    this.customSocials,
  });

  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 8.0,
          contentPadding: EdgeInsets.all(18.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => launchUrl(Uri.parse('tel:' + phoneNumber!)),
                  child: Container(
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Text('Call'),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () => launchUrl(Uri.parse('sms:' + phoneNumber!)),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text('Message'),
                  ),
                ),
                Divider(),
                InkWell(
                  onTap: () {
                    final url = Uri.parse(
                      'https://wa.me/' +
                          phoneNumber!.substring(
                            1,
                            phoneNumber!.length,
                          ),
                    );
                    print(url);
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text('WhatsApp'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: logo != null,
                child: CircleAvatar(
                  radius: avatarRadius ?? 50.0,
                  backgroundImage: logo,
                ),
              ),
              Visibility(
                  visible: image != null, child: image ?? SizedBox.shrink()),
              Text(
                companyName,
                style: TextStyle(
                  fontFamily: companyFont ?? 'Pacifico',
                  fontSize: companyFontSize ?? 40.0,
                  color: companyColor,
                  fontWeight: companyFontWeight ?? FontWeight.bold,
                ),
              ),
              Visibility(
                visible: tagLine != null,
                child: Text(
                  tagLine ?? "",
                  style: TextStyle(
                    fontFamily: taglineFont ?? 'Pacifico',
                    color: taglineColor,
                    fontSize: 20.0,
                    letterSpacing: 2.0,
                    fontWeight: taglineFontWeight ?? FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: dividerColor ?? Colors.teal[200],
                thickness: dividerThickness ?? 4.0,
                indent: 50.0,
                endIndent: 50.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                visible: website != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.link),
                    title: Text(
                      websiteText ?? 'Website',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(Uri.parse(website!)),
                  ),
                ),
              ),
              Visibility(
                visible: phoneNumber != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.phone),
                    title: Text(
                      phoneNumberText ?? 'Phone Number',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => showAlert(context),
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                color: cardColor,
                child: ListTile(
                  leading: Icon(Typicons.mail),
                  title: Text(
                    emailText ?? 'Email ID',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: textFont,
                    ),
                  ),
                  onTap: () => launchUrl(Uri.parse('mailto:' + email)),
                ),
              ),
              Visibility(
                visible: twitterHandle != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.social_twitter),
                    title: Text(
                      'Twitter',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(
                        Uri.parse('https://twitter.com/' + twitterHandle!)),
                  ),
                ),
              ),
              Visibility(
                visible: facebookHandle != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.social_facebook),
                    title: Text(
                      'Facebook',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(Uri.parse(
                        'https://www.facebook.com/' + facebookHandle!)),
                  ),
                ),
              ),
              Visibility(
                visible: instagram != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.social_instagram),
                    title: Text(
                      'Instagram',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(
                        Uri.parse('https://instagram.com/' + instagram!)),
                  ),
                ),
              ),
              Visibility(
                visible: githubUserName != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.social_github),
                    title: Text(
                      'Github',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(
                        Uri.parse('https://github.com/' + githubUserName!)),
                  ),
                ),
              ),
              Visibility(
                visible: linkedinURL != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Typicons.social_linkedin),
                    title: Text(
                      'Linkedin',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(Uri.parse(linkedinURL!)),
                  ),
                ),
              ),
              Visibility(
                visible: tiktokUrl != null,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: Icon(Icons.tiktok),
                    title: Text(
                      'Tiktok',
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(Uri.parse(tiktokUrl!)),
                  ),
                ),
              ),
              ...(customSocials ?? []).map(
                (e) => Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: cardColor,
                  child: ListTile(
                    leading: e.icon,
                    title: Text(
                      e.name,
                      style: TextStyle(
                        color: textColor,
                        fontFamily: textFont,
                      ),
                    ),
                    onTap: () => launchUrl(Uri.parse(e.url)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Class for adding contact details of the developer in your bottomNavigationBar in your flutter app.
class ContactUsBottomAppBar extends StatelessWidget {
  ///Color of the text which will be displayed in the bottomNavigationBar
  final Color textColor;

  ///Color of the background of the bottomNavigationBar
  final Color backgroundColor;

  ///Email ID Of the company/developer on which, when clicked by the user, the respective mail app will be opened.
  final String email;

  ///Name of the company or the developer
  final String companyName;

  ///Size of the font in bottomNavigationBar
  final double fontSize;

  /// font of text
  final String? textFont;

  ContactUsBottomAppBar({
    required this.textColor,
    required this.backgroundColor,
    required this.email,
    required this.companyName,
    this.fontSize = 15.0,
    this.textFont,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledForegroundColor: Colors.grey.withOpacity(0.38),
        shadowColor: Colors.transparent,
      ),
      child: Text(
        'Designed and Developed by $companyName 💙\nWant to contact?',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: textColor, fontSize: fontSize, fontFamily: textFont),
      ),
      onPressed: () => launchUrl(Uri.parse('mailto:$email')),
    );
  }
}
*/

class ContactUsPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // void _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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
    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.contactUs}",
        //  'Contact Us',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 70,
              //   color: Acolors.primary,
              //   child: Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Row(
              //       children: [
              //         Material(
              //           color: Colors.white.withOpacity(0.21),
              //           borderRadius: BorderRadius.circular(12),
              //           child: const BackButton(
              //             color: Acolors.white,
              //           ),
              //         ),
              //         const SizedBox(width: 30),
              //         const Text(
              //           'Contact Us',
              //           style: TextStyle(fontSize: 24, color: Acolors.white),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              _buildContactInfo(context),
              SizedBox(height: 20),
              //  _buildContactForm(context),
            ],
          ),
        ),
      ),
    );
  }
// new refined code

  Widget _buildContactInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.of(context)!.getInTouch}",
            // 'Get in Touch',
            style:
                GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildContactCard(
              "${AppLocalizations.of(context)!.phone}",
              //  'Phone',
              FontAwesomeIcons.phone,
              'tel:01762-458122',
              '01762-458122',
              Acolors.primary),
          _buildContactCard(
              "${AppLocalizations.of(context)!.email}",
              // 'Email',
              FontAwesomeIcons.envelope,
              'mailto:care@ambrosiaayurved.in',
              "${AppLocalizations.of(context)!.emailAddress}",
              //'care@ambrosiaayurved.in',
              Colors.red),
          _buildContactCard(
              "${AppLocalizations.of(context)!.location}",
              //    'Location',
              FontAwesomeIcons.mapMarkerAlt,
              'https://www.google.com/maps?q=3rd+floor+Motia,+MOTIAZ+ROYAL+BUSINESS+PARK,+28-B,+Zirakpur,+Punjab+140603',
              //  "${AppLocalizations.of(context)!.locationoffice}",
              'Ambrosia Ayurved, 28-B, 3rd floor Motia, MOTIAZ ROYAL BUSINESS PARK, Zirakpur, Punjab 140603, India',
              Acolors.primary),
          SizedBox(height: 30),
          Text(
            "${AppLocalizations.of(context)!.followUs}",
            // 'Follow Us:',
            style:
                GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildContactCard(
            "${AppLocalizations.of(context)!.facebook}",
            //  'Facebook',
            FontAwesomeIcons.squareFacebook,
            'https://www.facebook.com/profile.php?id=61575172705272&sk=photos',
            "${AppLocalizations.of(context)!.facebookLink}",
            // 'facebook.com/Ambrosia ayurved',
            Colors.blue,
          ),
          _buildContactCard(
              "${AppLocalizations.of(context)!.instagram}",
              // 'Instagram',
              FontAwesomeIcons.instagram,
              'https://www.instagram.com/ambrosia.ayurved',
              'Ambrosia Ayurved',
              Colors.orange),
          _buildContactCard(
              "${AppLocalizations.of(context)!.website}",
              //  'Website',
              FontAwesomeIcons.earth,
              'https://ambrosiaayurved.in/',
              'www.ambrosiaayurved.in',
              Acolors.primary),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      String label, IconData icon, String url, String text, Color iconColor) {
    return GestureDetector(
      onTap: () {
        final Uri uri = Uri.parse(url);
        _launchURL(uri.toString());
      },
      child: FadeInLeft(
        duration: Duration(milliseconds: 800),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
  Widget _buildContactForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Your Name'),
              validator: (value) => value!.isEmpty ? 'Enter your name' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Your Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) =>
                  value!.isEmpty ? 'Enter a valid email' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Your Message'),
              maxLines: 4,
              validator: (value) => value!.isEmpty ? 'Enter a message' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Message Sent!')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  */
}
