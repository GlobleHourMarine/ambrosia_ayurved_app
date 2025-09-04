// import 'dart:convert';
// import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_message.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/privacy_policy.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/terms&conditions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/login&register/login_screen.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/login&register/models/user_model.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class RegisterService {
//   void showRegistrationBottomSheet(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     TextEditingController fnameController = TextEditingController();
//     TextEditingController lnameController = TextEditingController();
//     TextEditingController emailController = TextEditingController();
//     TextEditingController passwordController = TextEditingController();
//     TextEditingController confirmPasswordController = TextEditingController();
//     TextEditingController phoneController = TextEditingController();
//     bool isLoading = false;
//     bool _agreedToPolicy = false;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       isDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setSheetState) {
//             return Container(
//               padding: EdgeInsets.only(
//                 left: 20,
//                 right: 20,
//                 top: 20,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 10,
//               ),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFFA5DD9F), Colors.white],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 40,
//                         height: 5,
//                         margin: EdgeInsets.only(bottom: 20),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       Text(
//                         "${AppLocalizations.of(context)!.registertoaddproduct} ",
//                         //  'Register to add product to cart',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 20),
//                       buildTextFormField(emailController,
//                           "${AppLocalizations.of(context)!.email} ", (value) {
//                         if (value!.isEmpty)
//                           return "${AppLocalizations.of(context)!.enterEmail} ";
//                         // 'Email cannot be empty';
//                         if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+com')
//                             .hasMatch(value)) {
//                           return "${AppLocalizations.of(context)!.pleaseEnterValidEmail}";
//                           // 'Enter a valid email';
//                         }
//                         return null;
//                       }),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: buildTextFormField(
//                               fnameController,
//                               "${AppLocalizations.of(context)!.firstName} ",
//                               //'First Name',
//                               (value) {
//                                 if (value!.isEmpty)
//                                   return "${AppLocalizations.of(context)!.pleaseEnterFirstName} ";
//                                 //  'First name cannot be empty';
//                                 return null;
//                               },
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'[a-zA-Z]')),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 7),
//                           Expanded(
//                             child: buildTextFormField(
//                               lnameController,
//                               "${AppLocalizations.of(context)!.lastName} ",
//                               //  'Last Name',
//                               (value) {
//                                 if (value!.isEmpty)
//                                   return "${AppLocalizations.of(context)!.pleaseEnterLastName} ";
//                                 //'Last name cannot be empty';
//                                 return null;
//                               },

//                               inputFormatters: [
//                                 FilteringTextInputFormatter.allow(
//                                     RegExp(r'[a-zA-Z]')),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       buildTextFormField(
//                         phoneController,
//                         "${AppLocalizations.of(context)!.phone} ",
//                         //'Mobile Number',
//                         (value) {
//                           if (value == null || value.isEmpty) {
//                             return "${AppLocalizations.of(context)!.pleaseEnterPhone}";
//                             //'Please enter Phone no.';
//                           } else if (!RegExp(r'^\d{10,13}$').hasMatch(value)) {
//                             return "${AppLocalizations.of(context)!.pleaseEnterValidPhone}";
//                             //'Please enter a valid Phone no.';
//                           }
//                           return null;
//                         },
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(13),
//                         ],
//                       ),
//                       //     (value) {
//                       //   if (value!.isEmpty)
//                       //     return "${AppLocalizations.of(context)!.validMobile} ";
//                       //   //'Mobile cannot be empty';
//                       //   return null;
//                       // }),
//                       buildTextFormField(passwordController,
//                           "${AppLocalizations.of(context)!.password} ",
//                           //'Password',
//                           (value) {
//                         if (value == null || value.isEmpty) {
//                           return "${AppLocalizations.of(context)!.pleaseEnterPassword} ";
//                           // 'Please enter Password';
//                         } else if (value.length < 8) {
//                           return "${AppLocalizations.of(context)!.passwordMinLength} ";
//                           //'Password must be at least 8 characters';
//                         } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
//                             .hasMatch(value)) {
//                           return "${AppLocalizations.of(context)!.passwordSpecialChar} ";
//                           //'Password must contain a special character';
//                         }
//                         return null;
//                       }, isObscure: true),
//                       buildTextFormField(confirmPasswordController,
//                           "${AppLocalizations.of(context)!.confirmPassword} ",
//                           //'Confirm Password',
//                           (value) {
//                         if (value!.isEmpty)
//                           return "${AppLocalizations.of(context)!.pleaseConfirmPassword} ";
//                         //'Confirm Password cannot be empty';
//                         if (value != passwordController.text)
//                           return "${AppLocalizations.of(context)!.passwordsDoNotMatch} ";
//                         //'Passwords do not match';
//                         return null;
//                       }, isObscure: true),
//                       SizedBox(height: 5),
//                       Row(
//                         //   crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Checkbox(
//                             value: _agreedToPolicy,
//                             onChanged: (bool? value) {
//                               setSheetState(() {
//                                 _agreedToPolicy = value ?? false;
//                               });
//                             },
//                           ),

//                           Text(
//                             // 'I agree to ',
//                             "${AppLocalizations.of(context)!.iagreeto} ", // 'I agree to '
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => PrivacyPolicyScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               "${AppLocalizations.of(context)!.privacyPolicy}",
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                           Text(
//                               //' and'
//                               "${AppLocalizations.of(context)!.and} "), // ' and '
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         TermsAndConditionsScreen()),
//                               );
//                             },
//                             child: Text(
//                               "${AppLocalizations.of(context)!.termsConditions}",
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       isLoading
//                           ? CircularProgressIndicator()
//                           : Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Acolors.primary,
//                                     foregroundColor: Colors.white,
//                                     padding: EdgeInsets.symmetric(vertical: 12),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(20)),
//                                   ),
//                                   onPressed: _agreedToPolicy
//                                       ? () {
//                                           if (_formKey.currentState!
//                                               .validate()) {
//                                             setSheetState(
//                                                 () => isLoading = true);

//                                             registerUser(
//                                               email: emailController.text,
//                                               phone: phoneController.text,
//                                               fname: fnameController.text,
//                                               lname: lnameController.text,
//                                               password: passwordController.text,
//                                               confirmPassword:
//                                                   confirmPasswordController
//                                                       .text,
//                                               context: context,
//                                               setLoading: (bool loading) {
//                                                 // This function will be called to update loading state
//                                                 setSheetState(
//                                                     () => isLoading = loading);
//                                               },
//                                             );
//                                           }
//                                         }
//                                       : null,
//                                   child: Text(
//                                     // 'Sign Up',
//                                     "${AppLocalizations.of(context)!.signUp} ",
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget buildTextFormField(
//     TextEditingController controller,
//     String labelText,
//     String? Function(String?) validator, {
//     bool isObscure = false,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3),
//       child: SizedBox(
//         height: 70,
//         child: TextFormField(
//           controller: controller,
//           obscureText: isObscure,
//           decoration: InputDecoration(
//             labelText: labelText,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           ),
//           validator: validator,
//           inputFormatters: inputFormatters,
//         ),
//       ),
//     );
//   }

//   Future<void> registerUser({
//     required String email,
//     required String phone,
//     required String fname,
//     required String lname,
//     required String password,
//     required String confirmPassword,
//     required BuildContext context,
//     required Function(bool) setLoading,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://ambrosiaayurved.in/api/userregister'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'fname': fname,
//           'lname': lname,
//           'mobile': phone,
//           'email': email,
//           'password': password,
//           'ConfirmPassword': confirmPassword,
//         }),
//       );

//       final responseBody = json.decode(response.body);
//       if (response.statusCode == 200 &&
//           responseBody['message'] == 'Record added successfully.') {
//         // Registration successful
//         User user = User.fromJson(responseBody['data'][0]);
//         final userProvider = Provider.of<UserProvider>(context, listen: false);
//         userProvider.setUser(user);
//         await userProvider.saveUserData(user);

//         SuccessPopup.show(
//           context: context,
//           title: "${AppLocalizations.of(context)!.loginSuccess}",
//           subtitle:
//               "${AppLocalizations.of(context)!.youHaveBeenredirectedtohomescreen}",
//           icon: Icons.verified_user,
//           iconColor: Acolors.primary,
//           //   iconColor: Colors.blue,
//           navigateToScreen: HomeScreen(),
//           autoCloseDuration: 2,
//         );
//         // Get.snackbar(
//         //   "${AppLocalizations.of(context)!.loginSuccess}",
//         //   "${AppLocalizations.of(context)!.loginSuccessMsg}",
//         //   snackPosition: SnackPosition.BOTTOM,
//         //   backgroundColor: Acolors.primary,
//         //   colorText: Colors.white,
//         //   duration: Duration(seconds: 2),
//         //   titleText: Text(
//         //     "${AppLocalizations.of(context)!.loginSuccess}",
//         //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         //   ),
//         //   messageText: Text(
//         //     "${AppLocalizations.of(context)!.loginSuccessMsg}",
//         //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         //   ),
//         // );

//         // Navigator.of(context).pop(); // Close the bottom sheet
//         // Navigator.pushReplacement(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (context) => HomeScreen(),
//         //     ));
//       } else if (responseBody.containsKey('message') &&
//           responseBody['message'] == "User already exists.") {
//         // User already exists - SHOW DIALOG INSTEAD OF JUST CONSOLE LOG
//         setLoading(false); // Update loading state first

//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(
//                 "${AppLocalizations.of(context)!.registrationFailed}",
//               ),
//               content: Text(
//                 "${AppLocalizations.of(context)!.userExists}",
//               ),
//               actions: <Widget>[
//                 ElevatedButton(
//                   onPressed: () {
//                     // Navigator.of(context).pop();
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SignInScreen(),
//                       ),
//                       //  (route) => false,
//                     );
//                   },
//                   child: Text("${AppLocalizations.of(context)!.ok}",
//                       style: TextStyle(
//                           // color: Colors.grey
//                           )),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         // Other API errors
//         setLoading(false); // Update loading state first

//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: Text(AppLocalizations.of(context)!.registrationFailed),
//             content: Text(
//                 '${AppLocalizations.of(context)!.registrationFailed} ${response.statusCode}'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(
//                   "${AppLocalizations.of(context)!.ok}",
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       // Network or other errors
//       print('Error occurred while making the API request: $e');

//       // Reset loading state
//       setLoading(false);

//       // Show error in UI, not just console
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: Text(AppLocalizations.of(context)!.error),
//           content: Text('${e.toString()}'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(AppLocalizations.of(context)!.ok),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
