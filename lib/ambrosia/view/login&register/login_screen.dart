import 'dart:async';
import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common/internet/internet.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/models/user_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/forget_password/forgot_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Organic color palette
  static const Color primary = Color(0xFF48AD3F);
  static const Color lightGreen = Color(0xFFCFFABB);
  static const Color seaGreen = Color(0xFF2E8B57);
  static const Color oliveGreen = Color(0xFF6B8E23);
  static const Color paleGreen = Color(0xFF98FB98);

  Future<void> loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final requestBody = json.encode({
        'email': emailController.text,
        'password': passwordController.text,
      });

      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/userlogin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('message') &&
            responseBody['message'] == 'Login Successfull') {
          User user = User.fromJson(responseBody['data'][0]);
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);
          await userProvider.saveUserData(user);
          // Show message if flag is true
          // Show success message
          SuccessPopup.show(
            context: context,
            title: "${AppLocalizations.of(context)!.loginSuccess}",
            subtitle:
                "${AppLocalizations.of(context)!.youHaveBeenredirectedtohomescreen}",
            icon: Icons.verified_user,
            iconColor: Acolors.primary,
            navigateToScreen: HomeScreen(),
            autoCloseDuration: 2,
          );
        } else {
          Get.snackbar(
            "${AppLocalizations.of(context)!.invalidCredentials}",
            "${AppLocalizations.of(context)!.invalidCredentialsMsg}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "${AppLocalizations.of(context)!.error}",
          "${AppLocalizations.of(context)!.loginFailed}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        "${AppLocalizations.of(context)!.error}",
        "${AppLocalizations.of(context)!.loginError} : Server Error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void shakePasswordField() {
    setState(() {
      passwordController.clear();
    });
    passwordController.selection =
        TextSelection.fromPosition(TextPosition(offset: 0));
    HapticFeedback.vibrate();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BasePage(
      fetchDataFunction: () async {},
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(166, 207, 250, 187),
                  seaGreen,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.37,
                            child: Lottie.asset(
                              'assets/lottie/login_1.json',
                              fit: BoxFit.contain,
                              repeat: true,
                              errorBuilder: (context, error, stackTrace) =>
                                  Lottie.network(
                                'https://assets5.lottiefiles.com/packages/lf20_ktwnwv5m.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // SizedBox(height: screenHeight * 0.01),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.welcomeMessage12}",
                                //  'Welcome to Ambrosia Ayurved',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                                //  textAlign: TextAlign.start,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                "${AppLocalizations.of(context)!.signtodiabbeticfreejourney}",
                                // 'Sign in to your diabetic free journey',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9),
                                  fontSize: screenWidth * 0.04,
                                ),
                                //   textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    label: Text(
                                        "${AppLocalizations.of(context)!.email}"),
                                    hintText:
                                        "${AppLocalizations.of(context)!.enterEmail}",
                                    labelStyle: TextStyle(color: seaGreen),
                                    prefixIcon:
                                        Icon(Icons.email, color: seaGreen),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: seaGreen),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context)!.pleaseEnterEmail}";
                                    } else if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                        .hasMatch(value)) {
                                      return "${AppLocalizations.of(context)!.pleaseEnterValidEmail}";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    label: Text(
                                        "${AppLocalizations.of(context)!.password}"),
                                    hintText:
                                        "${AppLocalizations.of(context)!.enterPassword}",
                                    labelStyle: TextStyle(color: seaGreen),
                                    prefixIcon:
                                        Icon(Icons.lock, color: seaGreen),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: seaGreen,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: seaGreen),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  obscureText: _obscureText,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context)!.pleaseEnterPassword}";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: oliveGreen,
                                          ),
                                          child: Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value!;
                                              });
                                            },
                                            activeColor: seaGreen,
                                          ),
                                        ),
                                        Text(
                                          "${AppLocalizations.of(context)!.rememberMe}",
                                          style: TextStyle(color: oliveGreen),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "${AppLocalizations.of(context)!.forgotPassword}",
                                        style: TextStyle(color: seaGreen),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.025),
                                SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.05,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: seaGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              loginUser(context);
                                            }
                                          },
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            "${AppLocalizations.of(context)!.signIn}",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationScreen(),
                                //   SignUpScreen(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "${AppLocalizations.of(context)!.dontHaveAccount}",
                              style: TextStyle(color: Colors.white),
                              children: [
                                TextSpan(
                                  text:
                                      "${AppLocalizations.of(context)!.signUp}",
                                  style: TextStyle(
                                    color: paleGreen,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: screenHeight * 0.001),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showLoginSuccessPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      // Start timer after showing dialog
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the dialog
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
      });

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            Text(
              'Login Successful!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back to Ambrosia Ayurved!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    },
  );
}

//
//
void showLoginSuccessPopup1(BuildContext context) {
  // Show the popup
  showDialog(
    context: context,
    barrierDismissible: false, // User must not close it manually
    builder: (BuildContext context) {
      // Start a timer to navigate after 3 seconds
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pop(); // Close the popup
        Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
      });

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated checkmark
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade100,
                ),
                child: const Icon(
                  Icons.check,
                  size: 50,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              // Success message
              const Text(
                'Login Successful!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You are being redirected to the home screen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ],
          ),
        ),
      );
    },
  );
}
