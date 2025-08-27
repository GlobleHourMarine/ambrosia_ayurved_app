import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/login_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/common/internet/internet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPasswordScreen extends StatefulWidget {
  final String id;

  const EditPasswordScreen({Key? key, required this.id}) : super(key: key);
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordVisible = !_isNewPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  Future<void> updatePassword(BuildContext context) async {
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.error}",
              //  'Error'
            ),
            content: Text(
              "${AppLocalizations.of(context)!.fillAllFields}",
              // 'Please fill in all fields.'
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "${AppLocalizations.of(context)!.ok}",
                  // 'OK'
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

    if (newPassword != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.error}",
              // 'Error'
            ),
            content: Text(
              "${AppLocalizations.of(context)!.newPassword}",
              //  'New password and confirm password do not match.'
            ),
            actions: <Widget>[
              TextButton(
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
      return;
    }

    final String apiUrl = 'https://ambrosiaayurved.in/api/setnewpassword';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': widget.id,
          'password': newPassword,
          'confirm_password': confirmPassword
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response data: $responseData');
        if (responseData.containsKey('message') &&
            responseData['message'] == 'Password updated succesfully') {
          print('Password updated successfully');

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "${AppLocalizations.of(context)!.success}",
                  //  'Success',
                  style: TextStyle(color: Color(0xFF272829)),
                ),
                content: Text(
                  "${AppLocalizations.of(context)!.passwordUpdated}",
                  //  'Your password has been updated successfully.',
                  style: TextStyle(color: Color(0xFF272829)),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "${AppLocalizations.of(context)!.ok}",
                      // 'OK'
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignInScreen(), // Navigate to the home screen
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Password update failed: ${responseData['message']}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "${AppLocalizations.of(context)!.error}",
                  // 'Error'
                ),
                content: Text(responseData['message'] ??
                        "${AppLocalizations.of(context)!.failedToUpdatePassword}"
                    //  'Failed to update password. Please try again.'
                    ),
                actions: <Widget>[
                  TextButton(
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
      }
    } catch (e) {
      print('An error occurred while updating the password \n $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.error}",
              // 'Error'
            ),
            content: Text(
              "${AppLocalizations.of(context)!.passwordUpdateError}",
              // 'An error occurred while updating the password.'
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "${AppLocalizations.of(context)!.ok}",
                  // 'OK'
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
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
        fetchDataFunction: () async {},
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 100),
                  // FadeInUp(
                  //   duration: Duration(milliseconds: 1000),
                  //   child: CircleAvatar(
                  //     radius: 90,
                  //     backgroundColor: Colors.white,
                  //     child: Image.asset('assets/images/img2.png'),
                  //   ),
                  // ),

                  Expanded(
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Container(
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "${AppLocalizations.of(context)!.editPassword}",
                                //  'Edit Your Password',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF272829)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.0),
                              SizedBox(height: 20.0),
                              _buildPasswordTextField(
                                controller: newPasswordController,
                                label:
                                    "${AppLocalizations.of(context)!.newPassword}",
                                //  'New Password',
                                isPasswordVisible: _isNewPasswordVisible,
                                toggleVisibility: _toggleNewPasswordVisibility,
                              ),
                              SizedBox(height: 20.0),
                              _buildPasswordTextField(
                                controller: confirmPasswordController,
                                label:
                                    "${AppLocalizations.of(context)!.confirmNewPassword}",
                                //'Confirm New Password',
                                isPasswordVisible: _isConfirmPasswordVisible,
                                toggleVisibility:
                                    _toggleConfirmPasswordVisibility,
                              ),
                              SizedBox(height: 20.0),
                              FadeInUp(
                                duration: Duration(milliseconds: 1200),
                                child: ElevatedButton(
                                  onPressed: () => updatePassword(context),
                                  child: Text(
                                      "${AppLocalizations.of(context)!.updatePassword}",
                                      //'Update Password',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Acolors.primary),
                                  ),
                                ),
                              ),
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
        ));
  }

  Widget _buildPasswordTextField({
    required TextEditingController controller,
    required String label,
    required bool isPasswordVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF202E5A)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(Icons.lock, color: Color(0xFF202E5A)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF202E5A),
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
