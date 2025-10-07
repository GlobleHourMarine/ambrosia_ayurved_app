import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common/contact_info.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Widget _buildContactCard(
      String title, IconData icon, String url, String subtitle, Color color) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => _launchURL(url),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 24,
                child: FaIcon(icon, color: color, size: 20),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: const BackButton(color: Colors.black),
        title: AppLocalizations.of(context)!.contactUs,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        //  height: 300,
                        width: double.infinity,
                        child: Lottie.asset(
                          'assets/lottie/contact_us_1.json',

                          //  fit: BoxFit.fill,
                          repeat: true,
                          errorBuilder: (context, error, stackTrace) =>
                              Lottie.network(
                            'https://assets5.lottiefiles.com/packages/lf20_ktwnwv5m.json', // Fallback animation
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${AppLocalizations.of(context)?.contactUs} : ',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildContactCard(
                      AppLocalizations.of(context)?.phone ?? "Phone",
                      FontAwesomeIcons.phone,
                      ContactInfo.phoneUrl,
                      ContactInfo.phoneNumber,

                      // 'tel:+918000057233',
                      // '+918000057233',
                      Acolors.primary,
                    ),
                    _buildContactCard(
                      AppLocalizations.of(context)?.email ?? "Email",
                      FontAwesomeIcons.envelope,
                      ContactInfo.emailUrl,
                      //'mailto:care@ambrosiaayurved.in',
                      //  AppLocalizations.of(context)?.emailAddress ??
                      ContactInfo.emailAddress,
                      //  "care@ambrosiaayurved.in",
                      Colors.red,
                    ),
                    _buildContactCard(
                      AppLocalizations.of(context)?.location ?? "Location",
                      FontAwesomeIcons.mapMarkerAlt,
                      ContactInfo.locationUrl,
                      ContactInfo.locationAddress,
                      // 'https://www.google.com/maps?q=3rd+floor+Motia,+MOTIAZ+ROYAL+BUSINESS+PARK,+28-B,+Zirakpur,+Punjab+140603',
                      // 'Ambrosia Ayurved, 28-B, 3rd floor Motia, MOTIAZ ROYAL BUSINESS PARK, Zirakpur, Punjab 140603, India',
                      Acolors.primary,
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppLocalizations.of(context)?.followUs ?? "Follow Us",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildContactCard(
                      AppLocalizations.of(context)?.facebook ?? "Facebook",
                      FontAwesomeIcons.squareFacebook,
                      ContactInfo.facebookUrl,
                      ContactInfo.facebookName,
                      //    'https://www.facebook.com/profile.php?id=61575172705272&sk=photos',
                      //  AppLocalizations.of(context)?.facebookLink ??
                      //    "facebook.com/Ambrosia ayurved",
                      Colors.blue,
                    ),
                    _buildContactCard(
                      AppLocalizations.of(context)?.instagram ?? "Instagram",
                      FontAwesomeIcons.instagram,
                      ContactInfo.instagramUrl,
                      ContactInfo.instagramName,
                      //   'https://www.instagram.com/ambrosia.ayurved',
                      //  'Ambrosia Ayurved',
                      Colors.orange,
                    ),
                    _buildContactCard(
                      'Youtube',
                      // AppLocalizations.of(context)?.website ?? "Website",
                      FontAwesomeIcons.youtube,
                      ContactInfo.youtubeUrl,
                      ContactInfo.youtubeName,
                      // 'https://ambrosiaayurved.in/',
                      // 'www.ambrosiaayurved.in',
                      Colors.red,
                    ),
                    _buildContactCard(
                      AppLocalizations.of(context)?.website ?? "Website",
                      FontAwesomeIcons.earth,
                      ContactInfo.websiteUrl,
                      ContactInfo.websiteName,
                      // 'https://ambrosiaayurved.in/',
                      // 'www.ambrosiaayurved.in',
                      Colors.blue,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
