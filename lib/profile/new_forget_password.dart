import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  // Function to launch URL
  _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to send email
  _sendEmail(String email) async {
    Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch email';
    }
  }

  // Function to make a phone call
  _makePhoneCall(String phoneNumber) async {
    Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not make phone call';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the size for responsive UI
    final Size size = MediaQuery.of(context).size;

    // Main container for the entire screen
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: 20.0), // Horizontal padding
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A1B9A), // Deep purple
              Color(0xFF3F51B5), // Indigo
            ],
          ),
        ),
        child: SingleChildScrollView(
          // Make the content scrollable
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center content horizontally
            children: <Widget>[
              // Spacing at the top
              SizedBox(height: size.height * 0.1),

              // App Logo (SVG)
              SvgPicture.asset(
                'assets/contact_us.svg', // Replace with your SVG asset path
                height: size.height * 0.2, // Responsive height
                semanticsLabel: 'Contact Us Logo', // Accessibility label
              ),

              // Spacing after the logo
              SizedBox(height: 20),

              // Contact Us Title
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // Subtitle
              Text(
                'Get in touch with us',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),

              // Spacing before contact options
              SizedBox(height: 30),

              // Contact Options
              _buildContactOption(
                context: context,
                title: 'Website',
                subtitle: 'Visit our website',
                icon: Icons.language,
                onTap: () => _launchURL(
                    'https://www.example.com'), // Replace with your website
              ),
              _buildContactOption(
                context: context,
                title: 'Email',
                subtitle: 'Send us an email',
                icon: Icons.email,
                onTap: () => _sendEmail(
                    'support@example.com'), // Replace with your email
              ),
              _buildContactOption(
                context: context,
                title: 'Phone',
                subtitle: 'Call us',
                icon: Icons.phone,
                onTap: () => _makePhoneCall(
                    '+1234567890'), // Replace with your phone number
              ),
              _buildContactOption(
                context: context,
                title: 'Address',
                subtitle: 'Our Location',
                icon: Icons.location_on,
                onTap: () {
                  // Example: Open Google Maps
                  _launchURL(
                      'https://www.google.com/maps/search/?api=1&query=Your+Address'); // Replace
                },
              ),
              // Add more contact options as needed

              // Spacing at the bottom
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build a contact option tile
  Widget _buildContactOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white, // Background color for the card
        child: ListTile(
          leading: Icon(
            icon,
            color: Color(0xFF3F51B5), // Icon color
            size: 30,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[600],
            size: 20,
          ),
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 10), // Adjust padding
        ),
      ),
    );
  }
}
