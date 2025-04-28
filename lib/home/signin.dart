import 'dart:convert';
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
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/model/user_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${AppLocalizations.of(context)!.pleaseEnterEmail}";
                              //   'Please enter Email';
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
                        const SizedBox(
                          height: 10.0,
                        ),
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
