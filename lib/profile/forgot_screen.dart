import 'dart:convert';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
// import 'package:ONO/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
// import 'package:ONO/screens/welcome_screen/otp_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/internet/internet.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/theme/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/profile/otp_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  // TextEditingController identifierController = TextEditingController();

  Future<void> initiatePasswordReset(BuildContext context) async {
    final String enteredEmail = emailController.text;

    // final id = Provider.of<UserProvider>(context, listen: false).id;

    // if (id.isEmpty) {
    //   print('id not found ');
    //   return;
    // }

    // if (user == null) {
    //   print('User is null. Cannot fetch indirect income.');
    //   return;
    // }

    // final userId = user.userId;

    final String apiUrl = 'https://ambrosiaayurved.in/api/forgotPassword';

    // added this
    if (enteredEmail.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.error}",
              //'Error'
            ),
            content: Text(
              "${AppLocalizations.of(context)!.pleaseEnterEmail}",
              // 'Please enter your email.'
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  "${AppLocalizations.of(context)!.ok}",
                  //  'OK',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': enteredEmail}),
      );

      // Close the loading dialog
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData.containsKey('message') &&
              responseData['message'] == 'OTP sent successfully.') {
            String id = responseData['id']; // Extract user ID
            // String otp = responseData['otp'];
            print(responseData['id']);
            print(responseData['message']);
            print(responseData['status']);
            print(responseData['otp']);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Acolors.primary,
                  title: Text("${AppLocalizations.of(context)!.success}",
                      //  'Success',
                      style: TextStyle(color: Acolors.white)),
                  content: Text(responseData['message'],
                      style: TextStyle(color: Acolors.white)),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(
                        "${AppLocalizations.of(context)!.ok}",
                        // 'OK'
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(id: id),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }

          // if (responseData.containsKey('message') &&
          //     responseData['message'] == 'Email not exist.') {
          //   print(responseData['message']);
          //   print(responseData['status']);
          //   // Show the success dialog immediately
          //   showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AlertDialog(
          //         title: Text(
          //           "${AppLocalizations.of(context)!.failedToSendOTP}",
          //           //   'Failed to send OTP'
          //         ),
          //         content: Text(
          //           "${AppLocalizations.of(context)!.userNotFound}",
          //           // 'User with this email does not exist.'
          //         ),
          //         actions: <Widget>[
          //           TextButton(
          //             child: Text(
          //               "${AppLocalizations.of(context)!.ok}",
          //               // 'OK'
          //             ),
          //             onPressed: () {
          //               Navigator.of(context).pop();
          //             },
          //           ),
          //         ],
          //       );
          //     },
          //   );
          // }
          else {
            print(responseData);
            showErrorDialog(
                context, "${AppLocalizations.of(context)!.failedToSendOTP}"
                // 'Failed to send OTP.'
                );
          }
        } catch (e) {
          showErrorDialog(
            context,
            "${AppLocalizations.of(context)!.serverResponseError}",
            // 'Unexpected response from server.\n Please try again after sometime'
          );
        }
      }
    } catch (error) {
      Navigator.of(context).pop(); // Close loading dialog
      showErrorDialog(
        context,
        "${AppLocalizations.of(context)!.serverResponseError}",
        //   'An error occurred while sending OTP.\n Please try again after sometime'
      );
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${AppLocalizations.of(context)!.error}",
            // 'Error'
          ),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                "${AppLocalizations.of(context)!.ok}",
                //  'OK'
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

/*
  Future<bool> checkUserExists(BuildContext context) async {
    final String enteredEmail = emailController.text;
    final String apiUrl =
        'https://mmm.klizardtechnology.com/Signup/check_user_exists';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': enteredEmail,
          // 'identifier': enteredEmail,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // If the status code is 200, check the body content
      if (response.statusCode == 200) {
        // Assuming the response body contains a simple true/false string or a JSON object
        final responseBody = jsonDecode(response.body);

        // Handle cases where the response is a simple boolean string
        if (responseBody.toString().toLowerCase() == 'true') {
          return true;
        } else if (responseBody.toString().toLowerCase() == 'false') {
          return false;
        }

        // Handle cases where the response is a JSON object
        if (responseBody.containsKey('data') && responseBody['data'] != null) {
          User user = User.fromJson(responseBody['data']);
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          return true; // Indicating that the user exists
        } else {
          print('User does not exist or data field is missing in the response');
          return false;
        }
      } else {
      
        print('Failed to check user existence: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error checking user existence: $error');
      return false;
    }
  }
*/

/*
  void _handleResetPassword(BuildContext context) async {
    String enteredEmail = emailController.text;

    if (enteredEmail.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter your email.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

*/

  //  final bool userExists = await checkUserExists(context);
/*
    if (userExists) {
      await initiatePasswordReset(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('User with this email does not exist.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Forget Password',
      ),
      resizeToAvoidBottomInset: true,

      //  backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Expanded(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  SizedBox(
                    // height: 300,
                    child: Lottie.asset(
                      'assets/images/forget_password_2.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) =>
                          Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_ktwnwv5m.json', // Fallback animation
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  //
                  //

                  // Title and subtitle
                  SizedBox(height: 50),
                  // Spacer(),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${AppLocalizations.of(context)!.forgotPassword}",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3E5C),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Don\'t worry! It happens. Please enter the email address associated with your account.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8F9BB3),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  //

                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${AppLocalizations.of(context)!.pleaseEnterEmail}";
                        //    'Please enter Email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text(
                        "${AppLocalizations.of(context)!.email}",
                        //  'Email'
                      ),
                      hintText: "${AppLocalizations.of(context)!.enterEmail}",

                      // 'Enter Email',
                      hintStyle: const TextStyle(
                        color: Acolors.primary,
                      ),
                      prefixIcon: const Icon(Icons.email_outlined),

                      ///

                      //
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Acolors.primary // Default border color
                            ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Acolors.primary, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Acolors.primary, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor:
                          const Color(0xFFFFFFFF), // White background color
                    ),
                    style: const TextStyle(
                      color: Color(0xFF272829), // Text color red
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: ElevatedButton(
                        onPressed: () => initiatePasswordReset(context),
                        child: Text(
                          "${AppLocalizations.of(context)!.resetPassword}",
                          //  'Reset Password',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Acolors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.alreadyHaveAccount}",
                        //    'Already have an account? ',
                        style: TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "${AppLocalizations.of(context)!.signIn}",
                          // 'Sign in',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Acolors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      //   ],
      // ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        home: ForgetPasswordScreen(),
      ),
    ),
  );
}
