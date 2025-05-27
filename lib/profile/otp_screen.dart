import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/profile/edit_password_screen.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'dart:convert';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/profile/forgot_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPScreen extends StatefulWidget {
  final String id;
  const OTPScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> verifyOTP(String otp) async {
    final String apiUrl = 'https://ambrosiaayurved.in/api/verifyotp';

    print('Sending OTP verification request: id=${widget.id}, otp=$otp');
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'otp': otp,
          'id': widget.id,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          print('OTP verified successfully.');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Acolors.primary,
                title: Text(
                  "${AppLocalizations.of(context)!.success}",
                  style: TextStyle(color: Acolors.white),
                ),
                content: Text(
                  "${AppLocalizations.of(context)!.otpVerified}",
                  style: TextStyle(color: Acolors.white),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text("${AppLocalizations.of(context)!.ok}"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditPasswordScreen(id: widget.id),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else if (responseData['status'] == 'failed' &&
            responseData['message'] == 'Invalid OTP.') {
          _showErrorDialog("${AppLocalizations.of(context)!.invalidOtp}");
        } else {
          _showErrorDialog(responseData['message'] ?? 'Verification failed.');
        }
      } else {
        _showErrorDialog('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "${AppLocalizations.of(context)!.error}",
            //'Error'
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(
                "${AppLocalizations.of(context)!.ok}",
                //   'OK'
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
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Acolors.primary,
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60),
            topRight: Radius.circular(60),
          ),
        ),
        // margin: const EdgeInsets.symmetric(horizontal: 25),
        // alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/images/img2.png',
                //   width: 150,
                //   height: 150,
                // ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Acolors.primary.withOpacity(0.21),
                    borderRadius: BorderRadius.circular(12),
                    child: const BackButton(
                      color: Acolors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 100),

                Text(
                  "${AppLocalizations.of(context)!.phoneVerification}",
                  // "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "${AppLocalizations.of(context)!.enterOtpMsg}",
                  // "Enter OTP sent to your email address!",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onCompleted: (pin) {
                    print('Entered OTP: $pin');
                    verifyOTP(pin);
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.editEmail}",
                        //  "Edit Email Address?",
                        style:
                            TextStyle(color: Color(0xFF272829), fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.signIn}",
                        //  "Sign in",
                        style:
                            TextStyle(color: Color(0xFF272829), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
