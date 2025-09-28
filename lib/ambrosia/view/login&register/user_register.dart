import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_message.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/models/user_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/new_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterService {
  void showModalBottomSheetregister(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const RegistrationModal(),
      backgroundColor: Colors.transparent,
    );
  }
}

class RegistrationFlowScreen extends StatefulWidget {
  const RegistrationFlowScreen({super.key});

  @override
  State<RegistrationFlowScreen> createState() => _RegistrationFlowScreenState();
}

class _RegistrationFlowScreenState extends State<RegistrationFlowScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRegistrationModal();
    });
  }

  void _showRegistrationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const RegistrationModal(),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Registration Flow will appear in a modal sheet.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------
// Modal Content: The core UI and logic for the flow
// ------------------------------------------------------------------

class RegistrationModal extends StatefulWidget {
  const RegistrationModal({super.key});

  @override
  State<RegistrationModal> createState() => _RegistrationModalState();
}

enum RegistrationState {
  enterMobile,
  enterOtp,
}

class _RegistrationModalState extends State<RegistrationModal> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  RegistrationState _currentState = RegistrationState.enterMobile;
  bool _isLoading = false;
  String _errorMessage = '';
  String _sessionId = '';
  bool _isNewUser = false;

  final String _apiUrl = 'https://ambrosiaayurved.in/api/userLoginRegister';

  Future<void> _checkUser() async {
    if (_mobileController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter mobile number.';
      });
      return;
    }
    if (_mobileController.text.length != 10) {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit mobile number.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile': _mobileController.text}),
      );

      final responseBody = jsonDecode(response.body);
      debugPrint('Response from _checkUser: $responseBody');

      if (response.statusCode == 200 && responseBody['success']) {
        setState(() {
          _sessionId = responseBody['session_id'];
          _isNewUser = !(responseBody['user_exist'] ?? false);
          _currentState = RegistrationState.enterOtp;
        });
        // _otpController.text =
        //     responseBody['OTP'] ?? ''; // Pre-fill OTP for testing
      } else {
        setState(() {
          _errorMessage = responseBody['message'] ??
              'Failed to send OTP. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the OTP.';
      });
      return;
    }

    if (_isNewUser && _nameController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Name is required for new users.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final Map<String, dynamic> requestBody = {
        'mobile': _mobileController.text,
        'otp': _otpController.text,
        'session_id': _sessionId,
      };

      if (_isNewUser) {
        requestBody['name'] = _nameController.text;
      }

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final responseBody = jsonDecode(response.body);

      print('Response from _submitOtp: $responseBody');
      debugPrint('Response from _submitOtp: $responseBody');

      if (response.statusCode == 200 && responseBody['success']) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        User user = User.fromJson(responseBody['user'][0]);
        print('user : $responseBody');

        // Save data to SharedPreferences
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(user);
        await userProvider.saveUserData(user);

        Navigator.of(context).pop();
        SuccessPopup.show(
          context: context,
          title: "${AppLocalizations.of(context)!.loginSuccess}",
          subtitle:
              "${AppLocalizations.of(context)!.youHaveBeenredirectedtohomescreen}",
          icon: Icons.verified_user,
          iconColor: Acolors.primary,
          navigateToScreen: MainTabView(),
          autoCloseDuration: 2,
        );
      } else {
        setState(() {
          print('user : $responseBody');
          _errorMessage =
              responseBody['message'] ?? 'Invalid OTP or an error occurred.';
        });
      }
    } catch (e) {
      setState(() {
        print('Response from _submitOtp: $e');
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 27,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Acolors.primary.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Acolors.primary.withOpacity(0.3),
                      blurRadius: 100,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.phone_outlined,
                    color: Acolors
                        .primary, // Keep the icon color as your primary green
                    size: 30.0,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                _currentState == RegistrationState.enterMobile
                    ? 'Enter your mobile number'
                    : _isNewUser
                        ? 'Register with OTP'
                        : 'Login with OTP',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ll send a one-time password to this number.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _CustomInputField(
                controller: _mobileController,
                hintText: 'Mobile Number',
                keyboardType: TextInputType.phone,
                icon: Icons.phone_android,
                readOnly: _currentState == RegistrationState.enterOtp,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              if (_currentState == RegistrationState.enterOtp) ...[
                const SizedBox(height: 16),
                _buildOtpField(),
                if (_isNewUser) ...[
                  const SizedBox(height: 16),
                  _buildNameField(),
                ],
              ],
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const SizedBox(height: 5),
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileField() {
    return _CustomInputField(
      controller: _mobileController,
      hintText: 'Mobile Number',
      keyboardType: TextInputType.phone,
      icon: Icons.phone_android,
    );
  }

  Widget _buildOtpField() {
    return _CustomInputField(
      controller: _otpController,
      hintText: 'Enter OTP',
      keyboardType: TextInputType.number,
      icon: Icons.dialpad,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }

  Widget _buildNameField() {
    return _CustomInputField(
      controller: _nameController,
      hintText: 'Enter Full Name',
      keyboardType: TextInputType.name,
      icon: Icons.person,
    );
  }

  Widget _buildActionButton() {
    final gradient = LinearGradient(
      colors: [
        const Color.fromARGB(255, 116, 205, 108),
        const Color.fromARGB(255, 79, 157, 72),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading
              ? null
              : () {
                  if (_currentState == RegistrationState.enterMobile) {
                    _checkUser();
                  } else {
                    _submitOtp();
                  }
                },
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    _currentState == RegistrationState.enterMobile
                        ? 'Continue'
                        : 'Submit',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
// ------------------------------------------------------------------
// Reusable UI Component for Input Fields
// ------------------------------------------------------------------

class _CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final IconData icon;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const _CustomInputField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.icon,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Acolors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
