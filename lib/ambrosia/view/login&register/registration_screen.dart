import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/login_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common/internet/internet.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/models/user_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController CountryController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;

  Future<void> registerUser(BuildContext context) async {
    final String enteredEmail = emailController.text;
    final String enteredPassword = passwordController.text;
    final String enteredConfirmPassword = ConfirmPasswordController.text;
    final String enteredfName = fnameController.text;
    final String enteredlName = lnameController.text;
    final String enteredPhone = phoneController.text;
    final String enteredOtp = otpController.text;
    //  final String enteredReferralCode = referralCodeController.text;

    if (enteredEmail.isEmpty ||
            enteredPassword.isEmpty ||
            enteredConfirmPassword.isEmpty ||
            enteredfName.isEmpty ||
            enteredlName.isEmpty ||
            enteredPhone.isEmpty ||
            enteredOtp.isEmpty
        // selectedCountry == null
        ) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${AppLocalizations.of(context)!.fillAllFields}",
          //  'Please fill in all fields'
        ),
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/userregister'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fname': enteredfName,
          'lname': enteredlName,
          'mobile': enteredPhone,
          'email': enteredEmail,
          'password': enteredPassword,
          'ConfirmPassword': enteredConfirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (responseBody.containsKey('message') &&
            responseBody['message'] == 'Record added successfully.') {
          User user = User.fromJson(responseBody['data'][0]);
          // Set the user in the UserProvider
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);

          // Save the user data to shared_preferences
          await userProvider.saveUserData(user);

          print(responseBody['message']);

          print(responseBody['data']);

          SuccessPopup.show(
            context: context,
            title: "${AppLocalizations.of(context)!.loginSuccess}",
            subtitle:
                "${AppLocalizations.of(context)!.youHaveBeenredirectedtohomescreen}",
            icon: Icons.verified_user,
            iconColor: Acolors.primary,
            //   iconColor: Colors.blue,
            navigateToScreen: HomeScreen(),
            autoCloseDuration: 3,
          );
        } else if (responseBody.containsKey('message') &&
            responseBody['message'] == "User already exists.") {
          print(responseBody['message']);

          print(responseBody['data']);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                //  backgroundColor: Acolors.primary,
                title: Text(
                  "${AppLocalizations.of(context)!.registrationFailed}",
                  //  'Registration Failed',
                ),
                content: Text(
                  "${AppLocalizations.of(context)!.userExists}",
                  //  'User already exists. Please try with a different email or phone.'
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("${AppLocalizations.of(context)!.ok}",
                        // 'OK',
                        style: TextStyle(color: Colors.grey)),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "${AppLocalizations.of(context)!.registrationFailed}",
                    //  'Registration Failed'
                  ),
                  content: Text(
                    "${AppLocalizations.of(context)!.registrationFailed} ${response.statusCode}",
                    // 'Failed to register. Please try again. Status code: ${response.statusCode}'
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "${AppLocalizations.of(context)!.ok}",
                        // 'OK'
                      ),
                    ),
                  ],
                );
              });
        }
      }
    } catch (e) {
      print('Error occurred while making the API request: $e');
      SnackbarMessage.showSnackbar(
        context,
        "${AppLocalizations.of(context)!.error} : $e",
        // 'Error: $e'
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  //send otp function

  String? sessionId; // Store this when sending OTP

  Future<void> sendOtpRequest(BuildContext context) async {
    final phone = phoneController.text.trim();
    final url = Uri.parse(
        'https://2factor.in/API/V1/7febeab1-6c5f-11f0-a562-0200cd936042/SMS/+91$phone/AUTOGEN/OTP1');
    final request = http.Request('GET', url);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);
        sessionId = json['Details']; // Store session ID
        print('✅ OTP Sent, session ID: $sessionId');
        SnackbarMessage.showSnackbar(context, 'OTP sent Successfully');
      } else {
        print('❌ Error: ${response.reasonPhrase}');
        SnackbarMessage.showSnackbar(context, 'Failed to send OTP');
      }
    } catch (e) {
      print('⚠️ Exception occurred: $e');
      SnackbarMessage.showSnackbar(context, 'Something went Wrong');
    }
  }

// verify otp

  Future<bool> verifyOtp(BuildContext context) async {
    final otp = otpController.text.trim();

    if (sessionId == null) {
      SnackbarMessage.showSnackbar(context, 'Please send OTP first');
      print("❌ Session ID missing. Please send OTP first.");
      return false;
    }

    final url = Uri.parse(
        'https://2factor.in/API/V1/7febeab1-6c5f-11f0-a562-0200cd936042/SMS/VERIFY/$sessionId/$otp');
    final request = http.Request('GET', url);

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final json = jsonDecode(responseBody);
      if (response.statusCode == 200 && json['Details'] == 'OTP Matched') {
        print('✅ OTP verified successfully!');
        SnackbarMessage.showSnackbar(context, 'OTP Verfied Successfully');
        return true;
      } else {
        SnackbarMessage.showSnackbar(context, 'Invaild OTP');
        print(json);
        return false;
      }
    } catch (e) {
      SnackbarMessage.showSnackbar(context, 'Something Went Wrong');
      print('⚠️ Exception occurred: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      fetchDataFunction: () async {},
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formSignupKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //  const SizedBox(height: 40),
                  // Header with logo
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/logo_final_aa_r.png', // Replace with your logo
                        height: 220,
                        width: 200,
                      ),
                      Text(
                        AppLocalizations.of(context)!.createAccount,
                        // 'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.fillInDetails,
                        // 'Fill in your details to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // First Name and Last Name in a row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fnameController,
                          decoration: InputDecoration(
                            labelText:
                                "${AppLocalizations.of(context)!.firstName}",
                            //  'First Name',
                            prefixIcon: const Icon(Icons.person_outline),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${AppLocalizations.of(context)!.pleaseEnterFirstName}";
                              //  'Please enter your first name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z]')),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: lnameController,
                          decoration: InputDecoration(
                            labelText:
                                "${AppLocalizations.of(context)!.lastName}",
                            // 'Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${AppLocalizations.of(context)!.pleaseEnterLastName}";
                              //'Please enter your last name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z]')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Email field
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "${AppLocalizations.of(context)!.email}",
                      //'Email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${AppLocalizations.of(context)!.pleaseEnterEmail}";
                        //  'Please enter Email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return "${AppLocalizations.of(context)!.pleaseEnterValidEmail}";
                        // 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  // Phone number field
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13),
                    ],
                    decoration: InputDecoration(
                      labelText: "${AppLocalizations.of(context)!.phone}",
                      //  'Phone Number',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      suffixIcon: _isSendingOtp
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : TextButton(
                              onPressed: () async {
                                setState(() {
                                  _isSendingOtp = true;
                                });
                                await sendOtpRequest(context);

                                setState(() {
                                  _isSendingOtp = false;
                                });
                              },
                              child: Text(
                                "Send OTP",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),

                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${AppLocalizations.of(context)!.pleaseEnterPhone}";
                        //'Please enter Phone no.';
                      } else if (!RegExp(r'^\d{1,13}$').hasMatch(value)) {
                        return "${AppLocalizations.of(context)!.pleaseEnterValidPhone}";
                        //'Please enter a valid Phone no.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: "OTP",
                      // "${AppLocalizations.of(context)!.otp}", // e.g. 'OTP'
                      prefixIcon: const Icon(Icons.lock_outline),
                      // suffixIcon: _isVerifyingOtp
                      //     ? Padding(
                      //         padding: const EdgeInsets.all(10),
                      //         child: SizedBox(
                      //           height: 20,
                      //           width: 20,
                      //           child:
                      //               CircularProgressIndicator(strokeWidth: 2),
                      //         ),
                      //       )
                      //     : TextButton(
                      //         onPressed: () async {
                      //           setState(() {
                      //             _isVerifyingOtp = true;
                      //           });
                      //           await verifyOtp(context);

                      //           setState(() {
                      //             _isVerifyingOtp = false;
                      //           });
                      //         },
                      //         child: Text(
                      //           "Verify",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //       ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter OTP";
                        //"${AppLocalizations.of(context)!.pleaseEnterOtp}";
                      } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                        return "Please Enter a valid OTP";
                        //"${AppLocalizations.of(context)!.pleaseEnterValidOtp}";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Password field
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: "${AppLocalizations.of(context)!.password}",
                      // 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          !_isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${AppLocalizations.of(context)!.pleaseEnterPassword}";
                        //   'Please enter Password';
                      } else if (value.length < 8) {
                        return "${AppLocalizations.of(context)!.passwordMinLength}";
                        //  'Password must be at least 8 characters';
                      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(value)) {
                        return "${AppLocalizations.of(context)!.passwordSpecialChar}";
                        // 'Password must contain at least one special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Confirm Password field
                  TextFormField(
                      controller: ConfirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText:
                            "${AppLocalizations.of(context)!.confirmPassword}",
                        //'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            !_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.pleaseConfirmPassword}";
                          //  'Please confirm your password';
                        } else if (value != passwordController.text) {
                          return "${AppLocalizations.of(context)!.passwordMismatch}";
                          // 'Passwords do not match';
                        }
                      }),
                  const SizedBox(height: 30),

                  // Register button
                  ElevatedButton(
                    onPressed: () async {
                      if (_formSignupKey.currentState!.validate()) {
                        // Form is valid, proceed with registration
                        bool isVerified = await verifyOtp(context);
                        if (isVerified) {
                          registerUser(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "${AppLocalizations.of(context)!.signUp}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Already have an account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.alreadyHaveAccount}",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ));
                        },
                        child: Text(
                          "${AppLocalizations.of(context)!.signIn}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
