import 'dart:convert';
// import 'package:ONO/screens/internet/InternetUi.dart';
// import 'package:ONO/screens/profile_screen/profit_screen.dart';
// import 'package:ONO/screens/profile_screen/ticket_screen.dart';
// import 'package:ONO/screens/profile_screen/withdraw_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:ONO/screens/bottom_nav.dart';
// import 'package:ONO/screens/proile_screen/news_screen.dart';
// import 'package:ONO/screens/profile_screen/payment_screen.dart';
// import 'package:ONO/screens/welcome_screen/signin_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/internet/internet.dart';
import 'package:ambrosia_ayurved/profile/edit_password_screen.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ambrosia_ayurved/profile/forgot_screen.dart';
import 'package:ambrosia_ayurved/profile/edit_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  SharedPreferences? _prefs;
  String? _imageUrl;
  bool _isVisible = true; // Example flag for animation
  final String apiUrl = 'https://ambrosiaayurved.in/api/fetch_user_detail';
  // final String apiUrl = 'https://mmm.klizardtechnology.com/signup/get_profile';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animateWidgets();
    //  _fetchUserProfile();
    fetchUserDetailsss();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic>? userData;

  Future<void> fetchUserDetailsss() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String loggedInUserId = userProvider.id;

    final response = await http.get(
      Uri.parse('https://ambrosiaayurved.in/api/fetch_user_detail'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['status'] == true) {
        final users = data['data'] as List;
        final loggedInUser = users.firstWhere(
          (user) => user['user_id'] == loggedInUserId,
          orElse: () => null,
        );

        setState(() {
          userData = loggedInUser;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load user details');
    }
  }

//   Future<XFile?> compressImage(File imageFile) async {
//     final dir = Directory.systemTemp;

//     // Create a target path with a .jpg extension
//     final targetPath =
//         '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

//     var result = await FlutterImageCompress.compressAndGetFile(
//       imageFile.absolute.path,
//       targetPath,
//       quality: 85,
//     );

//     return result;
//   }

//   Future<void> _handleRemoveImage() async {
//     final user = Provider.of<UserProvider>(context, listen: false).user;
//     if (user?.email != null) {
//       await resetToDefaultImage(user!.email);
//       setState(() {
//         _image = null; // Reset local image to null
//       });
//     } else {
//       print('User email is null');
//     }
//   }

//   Future<void> _removeImage() async {
//     // Check if user email is available
//     final email = Provider.of<UserProvider>(context, listen: false).user?.email;
//     if (email == null || email.isEmpty) {
//       print('Error: Email not provided');
//       return; // Exit if email is not available
//     }
//     print(email);
//     setState(
//       () {
//         _image = null;
//       },
//     );
// // Print the image path before removing it
//     if (_image != null) {
//       print('Image path: ${_image!.path}');
//     } else {
//       print('No image selected');
//     }

//     setState(() {
//       _image = null;
//     });
//     _prefs = await SharedPreferences.getInstance();
//     await _prefs?.remove('imagePath');

//     // Notify the server to revert to the default image
//     await resetToDefaultImage(email);
//   }

//   Future<void> resetToDefaultImage(String email) async {
//     final uri =
//         Uri.parse('https://mmm.klizardtechnology.com/Signup/update_profile');
//     var request = http.MultipartRequest('POST', uri);

//     request.fields['email'] = email;
//     request.fields['remove_image'] = '1'; // Send removeimage with value 1

//     try {
//       var response = await request.send();

//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         var jsonResponse = json.decode(responseData);

//         if (jsonResponse['status'] == true) {
//           print('Profile image removed successfully');
//         } else {
//           print('Error: ${jsonResponse['message']}');
//         }
//       } else {
//         print('Failed to remove profile image: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error removing profile image: $e');
//     }
//   }

/*
  Future<String?> fetchReferralLink(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://mmm.klizardtechnology.com/Signup/generate_referral_link'),
        body: jsonEncode({
          "email": email,
          "selection": "",
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final data = jsonDecode(response.body);

        // Extract the referral link directly from the response
        if (data['status'] == true) {
          final referralLink = data['referral_link'];
          return referralLink;
        } else {
          print('API error: ${data['message']}');
          return null;
        }
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching referral link: $e');
      return null;
    }
  }
*/
  void _animateWidgets() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  // Future<void> _fetchUserProfile() async {
  //   try {
  //     final user = Provider.of<UserProvider>(context, listen: false).user;
  //     final email = user?.email;

  //     if (email == null || email.isEmpty) {
  //       print('Error: User email is missing');
  //       return;
  //     }

  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{'email': email}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);

  //       if (data['status']) {
  //         final userData = data['data'];

  //         if (userData is Map<String, dynamic>) {
  //           final imageName = userData['image'];
  //           if (imageName != null && imageName.isNotEmpty) {
  //             final url =
  //                 'https://mmm.klizardtechnology.com/uploads/$imageName';

  //             if (mounted) {
  //               setState(() {
  //                 // Adding a key to force the Image widget to refresh
  //                 _imageUrl = '$url?${DateTime.now().millisecondsSinceEpoch}';
  //               });
  //             }
  //           } else {
  //             if (mounted) {
  //               setState(() {
  //                 _imageUrl = null;
  //               });
  //             }
  //           }
  //         }
  //       } else {
  //         print('Error: ${data['message']}');
  //       }
  //     } else {
  //       print('Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception: $e');
  //   }
  // }

  // Future<void> uploadProfileImage(File imageFile, String email) async {
  //   // Compress the image before uploading
  //   final compressedImage = await compressImage(imageFile);

  //   final uri =
  //       Uri.parse('https://mmm.klizardtechnology.com/Signup/update_profile');
  //   var request = http.MultipartRequest('POST', uri);
  //   request.files
  //       .add(await http.MultipartFile.fromPath('image', compressedImage!.path));
  //   request.fields['email'] = email;

  //   try {
  //     // Show loading indicator
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     var client = http.Client();
  //     var response = await client.send(request).timeout(Duration(seconds: 60));

  //     if (response.statusCode == 200) {
  //       var responseData = await response.stream.bytesToString();
  //       var jsonResponse = json.decode(responseData);
  //       print('Full API Response: $jsonResponse');

  //       if (jsonResponse['status'] == true) {
  //         if (jsonResponse['data'] is int) {
  //           print('Image uploaded successfully but no image URL provided.');
  //           await _fetchUserProfile();
  //         } else if (jsonResponse['data'] is Map) {
  //           String updatedImageUrl = jsonResponse['data']['image'];
  //           print('Image uploaded: $updatedImageUrl');

  //           String fullImageUrl =
  //               'https://mmm.klizardtechnology.com/uploads/$updatedImageUrl';
  //           // Provider.of<UserProvider>(context, listen: false)
  //           //     .updateImage(updatedImageUrl);

  //           if (mounted) {
  //             setState(() {
  //               _imageUrl = fullImageUrl;
  //             });
  //           }
  //           await _fetchUserProfile();
  //         } else {
  //           print('Error: Data is not in expected format');
  //         }
  //       } else {
  //         print('Error: ${jsonResponse['message']}');
  //       }
  //     } else {
  //       print('Failed to upload image: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //   } finally {
  //     // Hide loading indicator
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _pickImage() async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //       });

  //       await _prefs?.setString('imagePath', pickedFile.path);

  //       // Upload the image to the server and save it to the database
  //       await uploadProfileImage(File(pickedFile.path),
  //           Provider.of<UserProvider>(context, listen: false).user!.email);
  //     } else {
  //       print('No image selected');
  //     }
  //   } catch (e) {
  //     print('Error picking image: ${e.toString()}'); // Detailed error
  //   }
  // }

  // /// Handle the back button functionality
  // Future<bool> _onWillPop() async {
  //   Navigator.of(context).pop(); // Pop the current screen
  //   return false; // Prevent the default behavior
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user != null) {
      // Print the user's email and image if available
      print('User email in build: ${user.email}');
      // print('User image in build: ${user.image}');
    }

    return BasePage(
      fetchDataFunction: () async {},
      child: SafeArea(
        child: Scaffold(
          /*  appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(5),
              child: Material(
                color: Colors.black.withOpacity(0.21),
                borderRadius: BorderRadius.circular(12),
                child: BackButton(),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          */
          body: FadeInDown(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 255, 255, 255),
                    Acolors.primary,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 70,
                    color: Acolors.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                                fontSize: 24,
                                color: Acolors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  userData == null
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //  crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ));
                                },
                                child: Text(
                                  'Click to login',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        )
                      // SizedBox(height: 20),
                      // Padding(
                      //   padding: const EdgeInsets.all(50),
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Acolors.primary,
                      //         foregroundColor: Acolors.white,
                      //       ),
                      //       onPressed: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) =>
                      //                   SignInScreen(),
                      //             ));
                      //       },
                      //       child: Text('Click here to Login')),
                      // ),

                      : Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              // SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  // AnimatedContainer(
                                  //   duration: Duration(milliseconds: 500),
                                  //   curve: Curves.easeInOut,
                                  //   transform: _isVisible
                                  //       ? Matrix4.translationValues(0, 0, 0)
                                  //       : Matrix4.translationValues(0, 50, 0),
                                  //   child: GestureDetector(
                                  //     onTap: _pickImage,
                                  //     child: CircleAvatar(
                                  //       radius: 60,
                                  //       backgroundImage: _imageUrl != null
                                  //           ? NetworkImage(_imageUrl!)
                                  //           : const AssetImage(
                                  //                   'assets/images/default_profile.png')
                                  //               as ImageProvider,
                                  //       backgroundColor: Colors
                                  //           .grey, // Set a background color for better visibility
                                  //     ),
                                  //   ),
                                  // ),
                                  //     _imageUrl != null
                                  //         ? TextButton(
                                  //             onPressed: () async {
                                  //               final user = Provider.of<UserProvider>(
                                  //                       context,
                                  //                       listen: false)
                                  //                   .user;
                                  //               if (user?.email != null &&
                                  //                   user!.email.isNotEmpty) {
                                  //                 await resetToDefaultImage(user.email);

                                  //                 // Update user object and trigger a rebuild
                                  //                 setState(() {
                                  //                   _imageUrl =
                                  //                       null; // Clear the image URL
                                  //                 });
                                  //               } else {
                                  //                 ScaffoldMessenger.of(context)
                                  //                     .showSnackBar(
                                  //                   const SnackBar(
                                  //                       content: Text(
                                  //                           'User email is missing')),
                                  //                 );
                                  //               }
                                  //             },
                                  //             child: const Text(
                                  //               'Remove Image',
                                  //               style: TextStyle(
                                  //                 color: Color(0xFF272829),
                                  //                 //  fontSize: 10,
                                  //               ),
                                  //             ),
                                  //           )
                                  //         : TextButton.icon(
                                  //             onPressed: _pickImage,
                                  //             icon: const Icon(Icons.edit),
                                  //             label: const Text(
                                  //               'Change Profile',
                                  //               style:
                                  //                   TextStyle(color: Color(0xFF272829)),
                                  //             ),
                                  //           ),
                                  //   ],
                                  // ),

                                  //             AnimatedContainer(
                                  //               duration: Duration(milliseconds: 1100),
                                  //               curve: Curves.easeInOut,
                                  //               // transform: _isVisible
                                  //               //     ? Matrix4.translationValues(0, 0, 0)
                                  //               //     : Matrix4.translationValues(0, 50, 0),
                                  //               child: ListTile(
                                  //                 leading:
                                  //                     Icon(Icons.person_pin_circle_outlined),
                                  //                 title: Text(
                                  //                     '${userData!['fname']} ${userData!['lname']}'
                                  //                         .toUpperCase(),
                                  //                     style: TextStyle(fontSize: 20)),
                                  //                 onTap: () {
                                  //                   // Navigator.push(
                                  //                   //   context,
                                  //                   //   MaterialPageRoute(
                                  //                   //       builder: (context) => EditPasswordScreen(
                                  //                   //           //  id: widget.id,
                                  //                   //           )),
                                  //                   // );
                                  //                 },
                                  //               ),
                                  //             ),
                                  //             Divider(),
                                  //             AnimatedContainer(
                                  //               duration: Duration(milliseconds: 1100),
                                  //               curve: Curves.easeInOut,
                                  //               transform: _isVisible
                                  //                   ? Matrix4.translationValues(0, 0, 0)
                                  //                   : Matrix4.translationValues(0, 50, 0),
                                  //               child: ListTile(
                                  //                 leading: Icon(Icons.email),
                                  //                 title: Text('${userData!['email']}'),
                                  //                 onTap: () {
                                  //                   // Navigator.push(
                                  //                   //   context,
                                  //                   //   MaterialPageRoute(
                                  //                   //       builder: (context) => EditPasswordScreen(
                                  //                   //           //  id: widget.id,
                                  //                   //           )),
                                  //                   // );
                                  //                 },
                                  //               ),
                                  //             ),
                                  //             /*
                                  //                     AnimatedContainer(
                                  // duration: Duration(milliseconds: 1100),
                                  // curve: Curves.easeInOut,
                                  // transform: _isVisible
                                  //     ? Matrix4.translationValues(0, 0, 0)
                                  //     : Matrix4.translationValues(0, 50, 0),
                                  // child: ListTile(
                                  //   leading: Icon(Icons.password),
                                  //   title: Text('Edit Password'),
                                  //   onTap: () {
                                  //     // Navigator.push(
                                  //     //   context,
                                  //     //   MaterialPageRoute(
                                  //     //       builder: (context) => EditPasswordScreen(
                                  //     //           //  id: widget.id,
                                  //     //           )),
                                  //     // );
                                  //   },
                                  // ),
                                  //                     ),
                                  //                     */
                                  //             Divider(),
                                  //             AnimatedContainer(
                                  //               duration: Duration(milliseconds: 1100),
                                  //               curve: Curves.easeInOut,
                                  //               transform: _isVisible
                                  //                   ? Matrix4.translationValues(0, 0, 0)
                                  //                   : Matrix4.translationValues(0, 50, 0),
                                  //               child: ListTile(
                                  //                 leading: Icon(Icons.verified_user_outlined),
                                  //                 title: Text('${userData!['user_id']}'),
                                  //               ),
                                  //             ),

                                  //             Divider(),
                                  //             AnimatedContainer(
                                  //               duration: Duration(milliseconds: 1100),
                                  //               curve: Curves.easeInOut,
                                  //               transform: _isVisible
                                  //                   ? Matrix4.translationValues(0, 0, 0)
                                  //                   : Matrix4.translationValues(0, 50, 0),
                                  //               child: ListTile(
                                  //                 leading: Icon(Icons.phone),
                                  //                 title: Text('${userData!['mobile']}'),
                                  //                 onTap: () {
                                  //                   // Navigator.push(
                                  //                   //   context,
                                  //                   //   MaterialPageRoute(
                                  //                   //       builder: (context) => EditPasswordScreen(
                                  //                   //           //  id: widget.id,
                                  //                   //           )),
                                  //                   // );
                                  //                 },
                                  //               ),
                                  //             ),
                                  //             /*    Divider(),
                                  //                     AnimatedContainer(
                                  // duration: Duration(milliseconds: 1100),
                                  // curve: Curves.easeInOut,
                                  // transform: _isVisible
                                  //     ? Matrix4.translationValues(0, 0, 0)
                                  //     : Matrix4.translationValues(0, 50, 0),
                                  // child: ListTile(
                                  //   leading: Icon(Icons.share),
                                  //   title: Text('Invite'),
                                  //   onTap: () async {
                                  //     final userProvider =
                                  //         Provider.of<UserProvider>(context, listen: false);
                                  //     final user = userProvider.user;

                                  //     if (user != null) {
                                  //       final userEmail = user.email;

                                  //       String? referralLink =
                                  //           await fetchReferralLink(userEmail);

                                  //       if (referralLink != null) {
                                  //         Share.share(
                                  //             'Hey! Check out this new app: $referralLink');
                                  //       } else {
                                  //         print('Could not fetch referral link');
                                  //       }
                                  //     } else {
                                  //       print(
                                  //           'User or email is null. Cannot fetch referral link.');
                                  //     }
                                  //   },
                                  // ),
                                  //                     ),
                                  //                     */
                                  //             Divider(),
                                  //             AnimatedContainer(
                                  //               duration: Duration(milliseconds: 1100),
                                  //               curve: Curves.easeInOut,
                                  //               transform: _isVisible
                                  //                   ? Matrix4.translationValues(0, 0, 0)
                                  //                   : Matrix4.translationValues(0, 50, 0),
                                  //               child: ListTile(
                                  //                 leading: Icon(Icons.location_city),
                                  //                 title: Text('${userData!['address']}'),
                                  //                 onTap: () {},
                                  //               ),
                                  //             ),
                                  //             Divider(),
                                  //              // Profile Details

                                  _buildProfileCard(
                                    icon: Icons.person,
                                    title:
                                        '${userData!['fname']} ${userData!['lname']}'
                                            .toUpperCase(),
                                    context: context,
                                  ),
                                  _buildProfileCard(
                                    icon: Icons.email,
                                    title: userData!['email'],
                                    context: context,
                                  ),
                                  _buildProfileCard(
                                    icon: Icons.verified_user_outlined,
                                    title: 'User ID: ${userData!['user_id']}',
                                    context: context,
                                  ),

                                  _buildProfileCard(
                                    icon: Icons.phone,
                                    title: userData!['mobile'],
                                    context: context,
                                  ),
                                  _buildProfileCard(
                                    icon: Icons.location_city,
                                    title: 'Address : ${userData!['address']}',
                                    context: context,
                                  ),
                                  SizedBox(height: 30),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 1200),
                                    curve: Curves.easeInOut,
                                    transform: _isVisible
                                        ? Matrix4.translationValues(0, 0, 0)
                                        : Matrix4.translationValues(0, 50, 0),
                                    child: Container(
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Logout"),
                                                content: Text(
                                                    "Are you sure you want to logout?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .logout(context);
                                                    },
                                                    child: Text("Logout"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Logout',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                  // bottomNavigationBar: BottomNav(
                  //   selectedIndex: 4,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Profile Card Widget
Widget _buildProfileCard({
  required IconData icon,
  required String title,
  required BuildContext context,
}) {
  return AnimatedContainer(
    duration: const Duration(seconds: 3),
    curve: Curves.easeInOut,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(icon, color: Acolors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
    ),
  );
}



/*

// code of cosmetics to fetch user details
  // Function to fetch user profile
  Future<List<ProfileModel>> fetchUserProfiless() async {
    try {
      // Replace with your actual API call and response handling
      final responseBody = await fetchDataFromApi(); // Your API call
      print(responseBody);
      if (responseBody.containsKey('message') &&
          responseBody['message'] == 'user details fetched sucesfully') {
        List<ProfileModel> profiles = (responseBody['data'] as List)
            .map((item) => ProfileModel.fromJson(item))
            .toList();
        return profiles;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      throw Exception('Something went wrong in fetching user details');
    }
  }

  Future<Map<String, dynamic>> fetchDataFromApi() async {
    final url =
        'http://192.168.1.9/klizard/api/fetch_user_detail'; // Replace with your actual API URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Parse the JSON response
    } else {
      throw Exception('Failed to load data');
    }
  }

*/