import 'dart:convert';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:animate_do/animate_do.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';

import 'package:ambrosia_ayurved/ambrosia/view/login&register/login_screen.dart';

import 'package:lottie/lottie.dart';

import 'package:ambrosia_ayurved/ambrosia/view/login&register/forget_password/otp_screen.dart';
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
          } else {
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Lottie.asset(
                    'assets/lottie/forget_password_2.json',
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
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "${AppLocalizations.of(context)!.forgotPassword}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Don\'t worry! It happens. Please enter the email address associated with your account.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8F9BB3),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
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
                    padding: const EdgeInsets.symmetric(horizontal: 80),
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
    );
  }
}
