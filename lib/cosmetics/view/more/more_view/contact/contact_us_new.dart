import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUsScreenNew extends StatefulWidget {
  const ContactUsScreenNew({Key? key}) : super(key: key);

  @override
  _ContactUsScreenNewState createState() => _ContactUsScreenNewState();
}

class _ContactUsScreenNewState extends State<ContactUsScreenNew> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you! We\'ll get back to you soon.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Clear the form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      }
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
        title: AppLocalizations.of(context)!.contactUs,
      ),
      body: SingleChildScrollView(
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
                        'assets/images/contact_us_1.json',
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
                    'tel:01762-458122',
                    '01762-458122',
                    Acolors.primary,
                  ),
                  _buildContactCard(
                    AppLocalizations.of(context)?.email ?? "Email",
                    FontAwesomeIcons.envelope,
                    'mailto:care@ambrosiaayurved.in',
                    AppLocalizations.of(context)?.emailAddress ??
                        "care@ambrosiaayurved.in",
                    Colors.red,
                  ),
                  _buildContactCard(
                    AppLocalizations.of(context)?.location ?? "Location",
                    FontAwesomeIcons.mapMarkerAlt,
                    'https://www.google.com/maps?q=3rd+floor+Motia,+MOTIAZ+ROYAL+BUSINESS+PARK,+28-B,+Zirakpur,+Punjab+140603',
                    'Ambrosia Ayurved, 28-B, 3rd floor Motia, MOTIAZ ROYAL BUSINESS PARK, Zirakpur, Punjab 140603, India',
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
                    'https://www.facebook.com/profile.php?id=61575172705272&sk=photos',
                    AppLocalizations.of(context)?.facebookLink ??
                        "facebook.com/Ambrosia ayurved",
                    Colors.blue,
                  ),
                  _buildContactCard(
                    AppLocalizations.of(context)?.instagram ?? "Instagram",
                    FontAwesomeIcons.instagram,
                    'https://www.instagram.com/ambrosia.ayurved',
                    'Ambrosia Ayurved',
                    Colors.orange,
                  ),
                  _buildContactCard(
                    AppLocalizations.of(context)?.website ?? "Website",
                    FontAwesomeIcons.earth,
                    'https://ambrosiaayurved.in/',
                    'www.ambrosiaayurved.in',
                    Colors.blue,
                  ),
                  SizedBox(height: 24),

                  // Text(
                  //   'Send us a message',
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 16),
                  // Form(
                  //   key: _formKey,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     children: [
                  //       TextFormField(
                  //         controller: _nameController,
                  //         decoration: InputDecoration(
                  //           labelText: 'Name',
                  //           prefixIcon: Icon(Icons.person_outline),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //             borderSide: BorderSide.none,
                  //           ),
                  //           filled: true,
                  //           fillColor: Colors.grey.shade100,
                  //           contentPadding: EdgeInsets.symmetric(vertical: 16),
                  //         ),
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return 'Please enter your name';
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //       SizedBox(height: 16),
                  //       TextFormField(
                  //         controller: _emailController,
                  //         decoration: InputDecoration(
                  //           labelText: 'Email',
                  //           prefixIcon: Icon(Icons.email_outlined),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //             borderSide: BorderSide.none,
                  //           ),
                  //           filled: true,
                  //           fillColor: Colors.grey.shade100,
                  //           contentPadding: EdgeInsets.symmetric(vertical: 16),
                  //         ),
                  //         keyboardType: TextInputType.emailAddress,
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return 'Please enter your email';
                  //           }
                  //           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  //               .hasMatch(value)) {
                  //             return 'Please enter a valid email';
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //       SizedBox(height: 16),
                  //       TextFormField(
                  //         controller: _messageController,
                  //         decoration: InputDecoration(
                  //           labelText: 'Message',
                  //           prefixIcon: Icon(Icons.message_outlined),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //             borderSide: BorderSide.none,
                  //           ),
                  //           filled: true,
                  //           fillColor: Colors.grey.shade100,
                  //           contentPadding: EdgeInsets.symmetric(vertical: 16),
                  //           alignLabelWithHint: true,
                  //         ),
                  //         maxLines: 5,
                  //         validator: (value) {
                  //           if (value == null || value.isEmpty) {
                  //             return 'Please enter your message';
                  //           }
                  //           return null;
                  //         },
                  //       ),
                  //       SizedBox(height: 24),
                  //       ElevatedButton(
                  //         onPressed: _isSubmitting ? null : _submitForm,
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: Color(0xFF6A11CB),
                  //           foregroundColor: Colors.white,
                  //           padding: EdgeInsets.symmetric(vertical: 16),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           elevation: 0,
                  //         ),
                  //         child: _isSubmitting
                  //             ? SizedBox(
                  //                 width: 20,
                  //                 height: 20,
                  //                 child: CircularProgressIndicator(
                  //                   color: Colors.white,
                  //                   strokeWidth: 2,
                  //                 ),
                  //               )
                  //             : Text(
                  //                 'SEND MESSAGE',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 16,
                  //                 ),
                  //               ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 30),
                  // Social Media Links
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _socialButton(Icons.facebook, Colors.blue),
                  //     SizedBox(width: 16),
                  //     _socialButton(Icons.email, Colors.red),
                  //     SizedBox(width: 16),
                  //     _socialButton(Icons.messenger_outline, Colors.purple),
                  //     SizedBox(width: 16),
                  //     _socialButton(Icons.alternate_email, Colors.teal),
                  //   ],
                  // ),

                  /*
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.grey.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color(0xFF6A11CB).withOpacity(0.1),
                                  child: Icon(Icons.email_outlined,
                                      color: Color(0xFF6A11CB)),
                                ),
                                title: Text('Email'),
                                subtitle: Text('support@yourapp.com'),
                              ),
                              Divider(),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color(0xFF6A11CB).withOpacity(0.1),
                                  child: Icon(Icons.phone_outlined,
                                      color: Color(0xFF6A11CB)),
                                ),
                                title: Text('Phone'),
                                subtitle: Text('(123) 456-7890'),
                              ),
                              Divider(),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Color(0xFF6A11CB).withOpacity(0.1),
                                  child: Icon(Icons.location_on_outlined,
                                      color: Color(0xFF6A11CB)),
                                ),
                                title: Text('Address'),
                                subtitle: Text(
                                    '123 App Street, Silicon Valley, CA 94000'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}


// Example us
 /*


class ContactUsScreen2 extends StatefulWidget {
  const ContactUsScreen2({Key? key}) : super(key: key);

  @override
  _ContactUsScreen2State createState() => _ContactUsScreen2State();
}

class _ContactUsScreen2State extends State<ContactUsScreen2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            //  expandedHeight: 100,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Contact Us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Icon(
                Icons.contact_support_rounded,
                size: 40,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child:
                     Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Color(0xFF6A11CB).withOpacity(0.1),
                              child: Icon(Icons.email_outlined,
                                  color: Color(0xFF6A11CB)),
                            ),
                            title: Text('Email'),
                            subtitle: Text('support@yourapp.com'),
                          ),
                          Divider(),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Color(0xFF6A11CB).withOpacity(0.1),
                              child: Icon(Icons.phone_outlined,
                                  color: Color(0xFF6A11CB)),
                            ),
                            title: Text('Phone'),
                            subtitle: Text('(123) 456-7890'),
                          ),
                          Divider(),
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Color(0xFF6A11CB).withOpacity(0.1),
                              child: Icon(Icons.location_on_outlined,
                                  color: Color(0xFF6A11CB)),
                            ),
                            title: Text('Address'),
                            subtitle: Text(
                                '123 App Street, Silicon Valley, CA 94000'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Send us a message',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            prefixIcon: Icon(Icons.message_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding: EdgeInsets.symmetric(vertical: 16),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your message';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6A11CB),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'SEND MESSAGE',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Social Media Links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton(Icons.facebook, Colors.blue),
                      SizedBox(width: 16),
                      _socialButton(Icons.email, Colors.red),
                      SizedBox(width: 16),
                      _socialButton(Icons.messenger_outline, Colors.purple),
                      SizedBox(width: 16),
                      _socialButton(Icons.alternate_email, Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}

*/