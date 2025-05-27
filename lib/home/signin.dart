import 'dart:async';
import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/home/sign_up_new.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/sign_up.dart';
import 'package:ambrosia_ayurved/internet/internet.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/new_bottom_nav_bar.dart';
import 'package:ambrosia_ayurved/profile/forgot_screen.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/theme/theme.dart';
import 'package:ambrosia_ayurved/widgets/custom_scaffold.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/model/user_details.dart';
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
            navigateToScreen: HomeScreen(),
            autoCloseDuration: 3,
          );
          ///////  showLoginSuccessPopup1(context);
          // Get.snackbar(
          //   "${AppLocalizations.of(context)!.loginSuccess}",
          //   "${AppLocalizations.of(context)!.loginSuccessMsg}",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: Acolors.primary,
          //   colorText: Colors.white,
          //   duration: Duration(seconds: 2),
          //   titleText: Text(
          //     "${AppLocalizations.of(context)!.loginSuccess}",
          //     style:
          //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //   ),
          //   messageText: Text(
          //     "${AppLocalizations.of(context)!.loginSuccessMsg}",
          //     style:
          //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //   ),
          // );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
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
        "${AppLocalizations.of(context)!.loginError} : $e",
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

    return Scaffold(
      body: Container(
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
                          'assets/images/login_1.json',
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
                                prefixIcon: Icon(Icons.email, color: seaGreen),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: seaGreen),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey),
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
                                prefixIcon: Icon(Icons.lock, color: seaGreen),
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
                                  borderSide: BorderSide(color: Colors.grey),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        if (_formKey.currentState!.validate()) {
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
                              text: "${AppLocalizations.of(context)!.signUp}",
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
      Timer(const Duration(seconds: 3), () {
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

//
//
//

//message type enum
/*

// Message Type Enum
enum MessageType {
  success,
  error,
  warning,
  info,
}

// Message Display Utility Class
class MessageDisplay {
  // Private constructor to prevent instantiation
  MessageDisplay._();

  // Centralized method to show overlay message
  static OverlayEntry showMessage({
    required BuildContext context,
    required String message,
    MessageType messageType = MessageType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => _buildMessage(
        context, 
        message, 
        messageType, 
        () {
          // On close, remove the overlay
          overlayEntry.remove();
        },
      ),
    );

    // Insert the overlay
    Overlay.of(context).insert(overlayEntry);

    // Automatically remove after specified duration
    Future.delayed(duration, () {
      if (overlayEntry != null) {
        overlayEntry.remove();
      }
    });

    return overlayEntry;
  }

  // Private method for building message widget
  static Widget _buildMessage(
    BuildContext context, 
    String message, 
    MessageType messageType, 
    VoidCallback onClose
  ) {
    const String _fontFamily = 'Inter';

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16.0,
      left: 0,
      right: 0,
      child: Center(
        child: SafeArea(
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _getMessageColor(messageType),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getMessageIcon(messageType),
                  const SizedBox(width: 12.0),
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: _getMessageTextColor(messageType),
                        fontSize: 16.0,
                        fontFamily: _fontFamily,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      Icons.close,
                      color: Colors.grey[500],
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Get message icon based on type
  static Widget _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.success:
        return const Icon(Icons.check_circle, color: Colors.green, size: 24.0);
      case MessageType.error:
        return const Icon(Icons.error_outline, color: Colors.red, size: 24.0);
      case MessageType.warning:
        return const Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 24.0);
      case MessageType.info:
        return const Icon(Icons.info_outline, color: Colors.blue, size: 24.0);
    }
  }

  // Get message background color
  static Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green[100]!.withOpacity(0.9);
      case MessageType.error:
        return Colors.red[100]!.withOpacity(0.9);
      case MessageType.warning:
        return Colors.orange[100]!.withOpacity(0.9);
      case MessageType.info:
        return Colors.blue[100]!.withOpacity(0.9);
    }
  }

  // Get message text color
  static Color _getMessageTextColor(MessageType type) {
    switch (type) {
      case MessageType.success:
        return Colors.green[900]!;
      case MessageType.error:
        return Colors.red[900]!;
      case MessageType.warning:
        return Colors.orange[900]!;
      case MessageType.info:
        return Colors.blue[900]!;
    }
  }
}
*/







// old one 
//
//
//

/*
class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  // TextEditingController identifierController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //added email controller
  TextEditingController emailController = TextEditingController();
  //
  bool rememberPassword = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool isFetchingImages = false;
  List<dynamic> foruserId = [];
  List<String> carouselImages = [];
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> loginUser(BuildContext context) async {
    final String enteredEmail = emailController.text;
    // final String enteredIdentifier = identifierController.text;
    final String enteredPassword = passwordController.text;

    // Regular expression for basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (

        //enteredIdentifier.isEmpty ||
        enteredEmail.isEmpty || enteredPassword.isEmpty) {
      Get.snackbar(
        // "${AppLocalizations.of(context)!.}",
        "${AppLocalizations.of(context)!.error}",
        "${AppLocalizations.of(context)!.fillAllFields}",

        // 'Error',
        // 'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Determine if the identifier is an email or a user ID
    // final isEmail = emailRegex.hasMatch(enteredIdentifier);

    setState(() {
      _isLoading = true;
    });

    try {
      final requestBody = json.encode({
        //  'identifier': enteredIdentifier,
        'email': enteredEmail,
        'password': enteredPassword,
        // Send a flag to backend for identifier type
      });

      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/userlogin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('message') &&
            responseBody['message'] == 'Login Successfull') {
          print(responseBody['message']);
          print(responseBody['data']);
          // List<dynamic> userList = responseBody['data'];
          // Update UserProviders with the user data
          User user = User.fromJson(responseBody['data'][0]);
          // Set the user in the UserProvider
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);

          // Save the user data to shared_preferences
          await userProvider.saveUserData(user);

          // await Provider.of<UserProvider>(context, listen: false)
          //     .saveUserToPrefs();
          // await Provider.of<UserProvider>(context, listen: false)
          //     .loadUserFromPrefs();
          // // Save user data to SharedPreferences
          // await userProvider.saveUserToPrefs();

          // // Load user data from SharedPreferences
          // await userProvider.loadUserFromPrefs();

          final userId = user.id;
          print('User ID: $userId');
          // print('User Name: ${userProvider.user?.fname}');
          // print('User Email: ${userProvider.user?.email}');

          //  print(userId);

          //   if (user != null) {
          //   // Print user details if not null
          //   print('User Details from Preferences:');
          //   print('User ID: ${user.id}');
          //   print('First Name: ${user.fname}');
          //   print('Email: ${user.email}');
          // } else {
          //   print('No user data found in preferences');
          // }
          Get.snackbar(
            "${AppLocalizations.of(context)!.loginSuccess}",
            "${AppLocalizations.of(context)!.loginSuccessMsg}",
            // 'Login Successfull',
            // 'You have successfully logged in.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Acolors.primary,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            titleText: Text(
              "${AppLocalizations.of(context)!.loginSuccess}",
              // 'Login Successfull',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            messageText: Text(
              "${AppLocalizations.of(context)!.loginSuccessMsg}",
              //  'You have successfully logged in.',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        } else {
          Get.snackbar(
            "${AppLocalizations.of(context)!.invalidCredentials}",
            "${AppLocalizations.of(context)!.invalidCredentialsMsg}",
            // 'Invalid Credentials',
            // 'Please enter a valid email or user ID and password.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "${AppLocalizations.of(context)!.error}",
          "${AppLocalizations.of(context)!.loginFailed}",
          // 'Error',
          // 'Failed to log in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');

      Get.snackbar(
        "${AppLocalizations.of(context)!.error}",
        "${AppLocalizations.of(context)!.loginError} : $e",
        // 'Error',
        // 'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
/*
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey('message') &&
            responseBody['message'] == 'Login successfull') {
          // Successful login actions
          User user = User.fromJson(responseBody['data']);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          final userId = user.userId;
          print(userId);

          Get.snackbar(
            'Login Successful',
            'You have successfully logged in.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
            titleText: Text(
              'Login Successful',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),

            messageText: Text(
              'You have successfully logged in.',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );

          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          });
        } else {
          // Custom message for invalid credentials
          Get.snackbar(
            'Invalid Credentials',
            'Please enter a valid email or user ID and password.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }   
      else {
        Get.snackbar(
          'Error',
          'Failed to log in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      //

    
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    }
    */

    finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

/*
  Future<void> fetchUserId() async {
    final response = await http.get(Uri.parse(
        'https://mmm.klizardtechnology.com/mlmbussiness/Signup/fetchUserId/'));
    if (response.statusCode == 200) {
      setState(() {
        foruserId = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load home addresses');
    }
  }
  */
//
/*
  Future<void> fetchCarouselImages() async {
    setState(() {
      isFetchingImages = true;
    });

    try {
      final response = await http.get(
        Uri.parse(''),
      );
              
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> banners = data['data']['list'];

        setState(() {
          carouselImages = banners
              .map((item) {
                String imageFileName = item['banner_image'] ?? '';
                if (imageFileName.isNotEmpty) {
                  return 'https://app.klizardtechnology.com//uploads/$imageFileName';
                } else {
                  return ''; // Handle empty image file names
                }
              })
              .where((url) => url.isNotEmpty) // Remove empty URLs
              .toList();
        });
      } else {
        throw Exception('Failed to load carousel images');
      }
    } catch (e) {
      print('Error fetching carousel images: $e');
    } finally {
      setState(() {
        isFetchingImages = false;
      });
    }
  }
*/
  void shakePasswordField() {
    setState(() {
      // Clear the password field
      passwordController.clear();
    });

    // Trigger a shake animation
    passwordController.selection =
        TextSelection.fromPosition(TextPosition(offset: 0));
    HapticFeedback.vibrate();
  }

/*
  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
  }
*/
  @override
  Widget build(BuildContext context) {
    return BasePage(
      fetchDataFunction: () async {},
      child: CustomScaffold(
        child: Column(
          children: [
            const Expanded(
              flex: 3,
              child: SizedBox(height: 10),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.welcomeBack}",
                          // 'Welcome back',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: emailController,
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
                          decoration: InputDecoration(
                            label: Text(
                              "${AppLocalizations.of(context)!.email}",
                              //  'Email'
                            ),
                            hintText:
                                "${AppLocalizations.of(context)!.enterEmail}",
                            //  'Enter Email',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Acolors.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${AppLocalizations.of(context)!.pleaseEnterPassword}";
                              //   'Please enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text(
                              "${AppLocalizations.of(context)!.password}",
                              // 'Password'
                            ),
                            hintText:
                                "${AppLocalizations.of(context)!.enterPassword}",
                            //  'Enter Password',
                            hintStyle: const TextStyle(
                              color: Color.fromARGB(66, 12, 11, 11),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Acolors.primary),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black12 // Default border color
                                  ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 1.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value ?? false;
                                    });
                                  },
                                  activeColor: lightColorScheme.secondary,
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.rememberMe}",
                                  //   'Remember me',
                                  style: TextStyle(
                                    color: Color.fromARGB(115, 14, 2, 2),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
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
                                //   'Forget password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Acolors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    if (_formSignInKey.currentState!
                                        .validate()) {
                                      loginUser(context);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Acolors.primary // text color
                                ),
                            child: Text(
                              "${AppLocalizations.of(context)!.signIn}",
                              // 'Sign in'
                            ),
                          ),
                        ),

                        // GestureDetector(
                        //       onTap: () {
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) => HomeScreen(),
                        //           ),
                        //         );
                        //       },
                        //       child: Text(
                        //         'Sign in',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           color: lightColorScheme.primary,
                        //         ),
                        //       ),
                        //     ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.dontHaveAccount}",
                              // 'Don\'t have an account? ',
                              style: TextStyle(
                                color: Color.fromARGB(115, 27, 34, 35),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "${AppLocalizations.of(context)!.signUp}",

                                ///  'Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Acolors.primary,
                                  // color: Color.fromARGB(255, 77, 149, 220),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),

/*
                        if (carouselImages.isNotEmpty) // Add this check
                          CarouselSlider.builder(
                            itemCount: carouselImages.length,
                            itemBuilder: (context, index, realIndex) {
                              final imageUrl = carouselImages[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Image failed to load',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                            ),
                          ),
*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/