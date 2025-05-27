import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/privacy_policy.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/ourpolicies/terms&conditions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/internet/internet.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/new_bottom_nav_bar.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/theme/theme.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController CountryController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  bool _isPasswordVisible = false;
  // ignore: unused_field
  bool _isLoading = false;
  bool _agreedToPolicy = false;

  final List<Map<String, String>> countries = [
    {"name": "India", "code": "+91"},
    {"name": "United States", "code": "+1"},
    {"name": "United Kingdom", "code": "+44"},
    // Add more countries and their codes here
  ];

  String? selectedCountry;

  bool _isEmailValid(String email) {
    // Regular expression for validating email addresses
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> registerUser(BuildContext context) async {
    final String enteredEmail = emailController.text;
    final String enteredPassword = passwordController.text;
    final String enteredConfirmPassword = ConfirmPasswordController.text;
    final String enteredfName = fnameController.text;
    final String enteredlName = lnameController.text;
    final String enteredPhone = phoneController.text;
    //  final String enteredReferralCode = referralCodeController.text;

    if (enteredEmail.isEmpty ||
            enteredPassword.isEmpty ||
            enteredConfirmPassword.isEmpty ||
            enteredfName.isEmpty ||
            enteredlName.isEmpty ||
            enteredPhone.isEmpty
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
            //   iconColor: Colors.blue,
            navigateToScreen: HomeScreen(),
            autoCloseDuration: 3,
          );

          // Get.snackbar(
          //   "${AppLocalizations.of(context)!.loginSuccess}",
          //   "${AppLocalizations.of(context)!.loginSuccessMsg}",
          //   // 'Login Successfull',
          //   // 'You have successfully logged in.',
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Acolors.primary,
          //   colorText: Colors.white,
          //   duration: Duration(seconds: 2),
          //   titleText: Text(
          //     "${AppLocalizations.of(context)!.loginSuccess}",
          //     // 'Login Successfull',
          //     style:
          //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //   ),
          //   messageText: Text(
          //     "${AppLocalizations.of(context)!.loginSuccessMsg}",
          //     // 'You have successfully logged in.',
          //     style:
          //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //   ),
          // );
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => HomeScreen(),
          //     ));
          // Call login API after successful registration
          // await loginUser(emailController, passwordController, context);
          /*     if (response.statusCode == 200 &&
                responseBody['message'] == 'Record added successfully.') {
              if (responseBody.containsKey('data') &&
                  responseBody['data'] != null) {
                User user = User.fromJson(responseBody['data']);
                Provider.of<UserProvider>(context, listen: false).setUser(user);
              } else {
                print('Record added, but no user data was provided.');
              }
            */

          /*
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Theme(
                  data: ThemeData(
                    dialogBackgroundColor: Colors.red,
                  ),
                  child: AlertDialog(
                    backgroundColor: Acolors.primary,
                    title: const Text('Registration Successful',
                        style: TextStyle(color: Colors.white)),
                    content: const Text('You have successfully registered.',
                        style: TextStyle(color: Colors.white)),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()),
                            );
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ))
                    ],
                  ),
                );
              },
            );*/
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

    /*
          // print('Success:${responseBody['message']}');
          // SnackbarMessage.showSnackbar(context, '${responseBody['message']}');
          // if (responseBody['message'] == 'User registered successfully') {
          //   print('Success:${responseBody['message']}');
          //   SnackbarMessage.showSnackbar(
          //       context, 'User Registered Successfully');
          // }
          // if (responseBody['message'] == 'User already exists') {
          //   print(' ${responseBody['message']}');
          //   SnackbarMessage.showSnackbar(context, ' User already exists');
          // }

          /* if (response.statusCode != 200) {
            final responseBody = json.decode(response.body);
            SnackbarMessage.showSnackbar(
                context, 'Error: ${responseBody['message']}');
          }*/
        } 
        
        else {
          print('Failed to register user. Status code: ${response.statusCode}');
          SnackbarMessage.showSnackbar(context,
              'Failed to register user. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred while making the API request: $e');
        SnackbarMessage.showSnackbar(context, 'Error: $e');
      }


      // old commented
  */
    // try {
    //   final response = await http.post(
    //     Uri.parse('http://192.168.1.8/klizard/api/userregister'),
    //     body: {
    //       'email': enteredEmail,
    //       'password': enteredPassword,
    //       'ConfirmPassword': enteredConfirmPassword,
    //       'fname': enteredfName,
    //       'lname': enteredlName,
    //       'mobile': enteredPhone,
    //       //  'country': selectedCountry, // Send the country name to backend
    //       //  'reffer_id': enteredReferralCode,
    //     },
    //   );

    //   if (response.statusCode == 200) {
    //     Map<String, dynamic> responseBody = json.decode(response.body);
    //     print('Response status: ${response.statusCode}');
    //     print('Response body: ${response.body}');
    //     if (responseBody.containsKey('message') &&
    //         responseBody['message'] == 'User registered successfully') {
    //       print(responseBody['message']);
    //       print(responseBody['data']);

    //       User user = User.fromJson(responseBody['data']);
    //       Provider.of<UserProvider>(context, listen: false).setUser(user);

    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return Theme(
    //             data: ThemeData(
    //               dialogBackgroundColor: Color.fromARGB(255, 21, 121, 222),
    //             ),
    //             child: AlertDialog(
    //               title: Text('Registration Successful',
    //                   style: TextStyle(color: Colors.white)),
    //               content: Text('You have successfully registered.',
    //                   style: TextStyle(color: Colors.white)),
    //             ),
    //           );
    //        },
    //    );

    // //       Future.delayed(Duration(seconds: 2), () {
    // //         Navigator.of(context).pop();
    // //         Navigator.pushReplacement(
    // //           context,
    // //           MaterialPageRoute(builder: (context) => SignInScreen()),
    // //         );
    // //       });
    // //     }
    // // else if (responseBody.containsKey('message') &&
    // //         responseBody['message'] == 'User already exists') {
    // //       showDialog(
    // //         context: context,
    // //         builder: (BuildContext context) {
    // //           return AlertDialog(
    // //             title: Text('Registration Failed'),
    // //             content: Text(
    // //                 'User already exists. Please try with a different email or phone.'),
    // //             actions: <Widget>[
    // //               TextButton(
    // //                 onPressed: () {
    // //                   Navigator.of(context).pop();
    // //                 },
    // //                 child: Text('OK'),
    // //               ),
    // //             ],
    // //           );
    // //         },
    // //       );
    // //     } else {
    // //       showDialog(
    // //         context: context,
    // //         builder: (BuildContext context) {
    // //           return AlertDialog(
    // //             title: Text('Registration Failed'),
    // //             content: Text('Failed to register. Please try again.'),
    // //             actions: <Widget>[
    // //               TextButton(
    // //                 onPressed: () {
    // //                   Navigator.of(context).pop();
    // //                 },
    // //                 child: Text('OK'),
    // //               ),
    // //             ],
    // //           );
    // //         },
    // //       );
    // //     }
    // //   } else {
    // //     ScaffoldMessenger.of(context).showSnackBar(
    // //       SnackBar(
    // //         content: Text('Error: Failed to register'),
    // //       ),
    // //     );
    // //   }
    // // } catch (e) {
    // //   print('Error: $e');
    // //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // //     content: Text('Error: Failed to register'),
    // //   ));
    // }
    // finally {
    setState(() {
      _isLoading = false;
    });
  }

  /*
    Future<String> checkUserExists(BuildContext context) async {
      final String email = emailController.text;
      final String phone = phoneController.text;

      try {
        final response = await http.post(
          Uri.parse('https://mmm.klizardtechnology.com/Signup/check_user_exists'),
          body: {
            'email': email,
            'mobile': phone,
          },
        );

        if (response.statusCode == 200) {
          // Decode the response body
          Map<String, dynamic> responseBody = json.decode(response.body);

          // Check if the response contains a message
          if (responseBody.containsKey('message')) {
            print(responseBody['message']);
            return responseBody['message'];
          } else {
            return '';
          }
        } else {
          return '';
        }
      } catch (e) {
        return '';
      }
    }
  */

  // Future<void> loginUser(email, password, BuildContext context) async {
  //   final String email = emailController.text;
  //   final String password = passwordController.text;
  //   final response = await http.post(
  //     Uri.parse('https://ambrosiaayurved.in/api/userlogin'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({'email': email, 'password': password}),
  //   );

  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     Map<String, dynamic> responseBody = jsonDecode(response.body);
  //     print(responseBody);
  //     if (responseBody.containsKey('message') &&
  //         responseBody['message'] == 'Login Successfull') {
  //       print(responseBody['message']);
  //       print(responseBody['data']);

  //       // Save the user data to shared_preferences
  //       User user = User.fromJson(responseBody['data'][0]);
  //       // Set the user in the UserProvider
  //       final userProvider = Provider.of<UserProvider>(context, listen: false);
  //       userProvider.setUser(user);

  //       // Save the user data to shared_preferences
  //       await userProvider.saveUserData(user);

  //       Get.snackbar(
  //         "${AppLocalizations.of(context)!.loginSuccess}",
  //         "${AppLocalizations.of(context)!.loginSuccessMsg}",
  //         // 'Login Successfull',
  //         // 'You have successfully logged in.',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Acolors.primary,
  //         colorText: Colors.white,
  //         duration: Duration(seconds: 2),
  //         titleText: Text(
  //           "${AppLocalizations.of(context)!.loginSuccess}",
  //           // 'Login Successfull',
  //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //         ),
  //         messageText: Text(
  //           "${AppLocalizations.of(context)!.loginSuccessMsg}",
  //           // 'You have successfully logged in.',
  //           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
  //         ),
  //       );
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => HomeScreen(),
  //           ));
  //     } else {
  //       SnackbarMessage.showSnackbar(
  //           context, 'Login failed! Please try manually.');
  //       Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => SignInScreen(),
  //           ));
  //     }
  //   }
  // }

  bool _isPasswordValid(String password) {
    // Define regular expressions for special characters, numeric characters, and uppercase letters
    RegExp specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp numericChar = RegExp(r'[0-9]');
    RegExp upperCaseChar = RegExp(r'[A-Z]');

    // Check if password contains at least one special character, one numeric character, and one uppercase letter
    return specialChar.hasMatch(password) &&
        numericChar.hasMatch(password) &&
        upperCaseChar.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      fetchDataFunction: () async {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScaffold(
          child: Column(
            children: [
              const Expanded(
                flex: 2,
                child: SizedBox(height: 10),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formSignupKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.getStarted}",
                            //  'Get Started',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: lightColorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 40.0),

                          // Full Name Input
                          Row(
                            children: [
                              Expanded(
                                child: makeInput(
                                  hint:
                                      "${AppLocalizations.of(context)!.firstName}",
                                  // 'First Name',
                                  icon: Icons.person_outline,
                                  controller: fnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context)!.pleaseEnterFirstName}";
                                      //  'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: makeInput(
                                  hint:
                                      "${AppLocalizations.of(context)!.lastName}",
                                  //   'Last Name',
                                  icon: Icons.person_outline,
                                  controller: lnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context)!.pleaseEnterLastName}";
                                      // 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25.0),

                          // Email Input with Email Validation
                          makeInput(
                            hint: "${AppLocalizations.of(context)!.email}",
                            //   'Email',
                            icon: Icons.email_outlined,
                            controller: emailController,
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
                          /*   SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            icon: Icon(Icons.flag_sharp),
                            value: selectedCountry,
                            hint: Text('Select Country'),
                            items: countries.map((country) {
                              return DropdownMenuItem<String>(
                                value: country['name'],
                                child: Text(country['name']!),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value;

                                // Get the selected country code
                                String countryCode = countries.firstWhere(
                                    (country) =>
                                        country['name'] == value)['code']!;

                                // Automatically update the CountryController with the country code
                                CountryController.text = countryCode;

                                // Update the phone controller with the country code if it is not already added
                                if (!phoneController.text
                                    .startsWith(countryCode)) {
                                  phoneController.text =
                                      countryCode; // Set the country code in phone number
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a country';
                              }
                              return null;
                            },
                          ),
*/
                          const SizedBox(height: 25.0),

                          makeInput(
                            hint: "${AppLocalizations.of(context)!.phone}",
                            //  'Phone no.',
                            icon: Icons.phone,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "${AppLocalizations.of(context)!.pleaseEnterPhone}";
                                //'Please enter Phone no.';
                              } else if (!RegExp(r'^\d{1,13}$')
                                  .hasMatch(value)) {
                                return "${AppLocalizations.of(context)!.pleaseEnterValidPhone}";
                                //'Please enter a valid Phone no.';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 25.0),

                          // makeInput(
                          //   hint: 'Country Code',
                          //   icon: Icons.code,
                          //   controller: CountryController,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Please select a country';
                          //     }
                          //     return null;
                          //   },
                          // ),

                          // Password Input with Password Validation
                          makeInput(
                            hint: "${AppLocalizations.of(context)!.password}",
                            // 'Password',
                            icon: Icons.lock_outline,
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
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
                          const SizedBox(height: 25),
                          makeInput(
                              hint:
                                  "${AppLocalizations.of(context)!.confirmPassword}",
                              //  'Confirm Password',
                              icon: Icons.lock_outline,
                              controller: ConfirmPasswordController,
                              obscureText: !_isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
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
                          const SizedBox(height: 25.0),
                          // Agree to Privacy Policy and Terms Section
                          Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreedToPolicy,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _agreedToPolicy = value ?? false;
                                  });
                                },
                              ),

                              Text(
                                // 'I agree to ',
                                "${AppLocalizations.of(context)!.iagreeto} ",
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrivacyPolicyScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "${AppLocalizations.of(context)!.privacyPolicy}",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(
                                  //'and'
                                  "${AppLocalizations.of(context)!.and} "), // ' and '
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsAndConditionsScreen()),
                                  );
                                },
                                child: Text(
                                  "${AppLocalizations.of(context)!.termsConditions}",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          // Optional Section for Referral Code
                          /*   Container(
                            alignment: Alignment.centerLeft,
                          ),
                          makeInput(
                            hint: 'Referred By',
                            icon: Icons.share,
                            controller: referralCodeController,
                            validator: (value) {
                              return null;
                            },
                          ),

                          const SizedBox(height: 25.0),
*/
                          // Sign Up Button
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                            width: 250,
                            child: MaterialButton(
                              height: 50,
                              onPressed: () {
                                if (_formSignupKey.currentState!.validate()) {
                                  if (!_agreedToPolicy) {
                                    SnackbarMessage.showSnackbar(context,
                                        "${AppLocalizations.of(context)!.agreePrivacyTerms}");
                                    return;
                                  }
                                  registerUser(context);
                                }
                              },
                              color: Acolors.primary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${AppLocalizations.of(context)!.signUp}",
                                // "Sign up",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25.0),

                          // Sign in Option
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.alreadyHaveAccount}",
                                // 'Already have an account? ',
                                style: TextStyle(
                                  color: Color.fromARGB(207, 241, 8, 8),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInScreen()),
                                  );
                                },
                                child: Text(
                                  "${AppLocalizations.of(context)!.signIn}",
                                  //  'Sign in',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Acolors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          icon,
          color: lightColorScheme.primary,
        ),
        suffixIcon: suffixIcon,

        // Add errorStyle to change the error message color to red
        errorStyle: const TextStyle(
          color: Color.fromARGB(255, 162, 11, 0),
          fontSize: 12.0,
        ),

        // Customize borders for focused and error states
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Acolors.primary,
            width: 2.0,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
