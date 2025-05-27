import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
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
  TextEditingController CountryController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  bool _isPasswordVisible = false;
  // ignore: unused_field
  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formSignupKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Header with logo
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo_final_aa_r.png', // Replace with your logo
                    height: 220,
                    width: 200,
                  ),
                  //   const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.createAccount,
                    // 'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
              const SizedBox(height: 32),

              // First Name and Last Name in a row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fnameController,
                      decoration: InputDecoration(
                        labelText: "${AppLocalizations.of(context)!.firstName}",
                        //  'First Name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.pleaseEnterFirstName}";
                          //  'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: lnameController,
                      decoration: InputDecoration(
                        labelText: "${AppLocalizations.of(context)!.lastName}",
                        // 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${AppLocalizations.of(context)!.pleaseEnterLastName}";
                          //'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "${AppLocalizations.of(context)!.pleaseEnterEmail}";
                    //  'Please enter Email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "${AppLocalizations.of(context)!.pleaseEnterValidEmail}";
                    // 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone number field
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: "${AppLocalizations.of(context)!.phone}",
                  //  'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
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
              const SizedBox(height: 20),

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
              const SizedBox(height: 20),

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
              const SizedBox(height: 50),

              // Register button
              ElevatedButton(
                onPressed: () {
                  if (_formSignupKey.currentState!.validate()) {
                    // Form is valid, proceed with registration
                    registerUser(context);
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

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
    );
  }
}
