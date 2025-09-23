// import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class RegisterModalSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Authentication'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => AuthBottomSheet.show(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(
//             'Login / Sign Up',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AuthBottomSheet extends StatefulWidget {
//   static void show(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => AuthBottomSheet(),
//     );
//   }

//   @override
//   _AuthBottomSheetState createState() => _AuthBottomSheetState();
// }

// class _AuthBottomSheetState extends State<AuthBottomSheet>
//     with TickerProviderStateMixin {
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();

//   late AnimationController _animationController;
//   late Animation<double> _slideAnimation;

//   AuthStep _currentStep = AuthStep.mobile;
//   bool _isLoading = false;
//   String? _sessionId;
//   String? _errorMessage;
//   bool _userExists = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _slideAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _mobileController.dispose();
//     _otpController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _sendOTP() async {
//     if (_mobileController.text.length != 10) {
//       setState(() {
//         _errorMessage = 'Please enter a valid 10-digit mobile number';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('https://ambrosiaayurved.in/api/userLoginRegister'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'mobile': _mobileController.text,
//         }),
//       );

//       final data = json.decode(response.body);

//       if (data['success']) {
//         _sessionId = data['session_id'];
//         _userExists = data['user_exist'] ?? false;
//         print('Send otp data : $data');
//         setState(() {
//           _currentStep = AuthStep.otp;
//         });
//       } else {
//         print('Send otp data : $data');
//         setState(() {
//           _errorMessage = data['message'] ?? 'Failed to send OTP';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         print('Send otp data : $e');
//         _errorMessage = 'Network error. Please try again.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _verifyOTP() async {
//     if (_otpController.text.length != 6) {
//       setState(() {
//         _errorMessage = 'Please enter a valid 6-digit OTP';
//       });
//       return;
//     }

//     if (!_userExists && _nameController.text.trim().isEmpty) {
//       setState(() {
//         _errorMessage = 'Please enter your name';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       Map<String, dynamic> requestBody = {
//         'mobile': _mobileController.text,
//         'session_id': _sessionId,
//         'otp': _otpController.text,
//       };

//       if (!_userExists) {
//         requestBody['name'] = _nameController.text.trim();
//       }

//       final response = await http.post(
//         Uri.parse('https://ambrosiaayurved.in/api/userLoginRegister'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(requestBody),
//       );

//       final data = json.decode(response.body);

//       if (data['success']) {
//         Navigator.pop(context);
//         print('Send otp data : $data');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 _userExists ? 'Login Successful!' : 'Registration Successful!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       } else {
//         print('Send otp data : $data');
//         setState(() {
//           _errorMessage = data['message'] ?? 'Verification failed';
//         });
//       }
//     } catch (e) {
//       print('Send otp data : $e');
//       setState(() {
//         _errorMessage = 'Network error. Please try again.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _goBack() {
//     setState(() {
//       _currentStep = AuthStep.mobile;
//       _errorMessage = null;
//       _otpController.clear();
//       _nameController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _slideAnimation,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - _slideAnimation.value) * 400),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.all(24),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Handle
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 24),

//                       // Header
//                       Row(
//                         children: [
//                           if (_currentStep != AuthStep.mobile)
//                             GestureDetector(
//                               onTap: _goBack,
//                               child: Icon(Icons.arrow_back, size: 24),
//                             ),
//                           if (_currentStep != AuthStep.mobile)
//                             SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _getHeaderTitle(),
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 Text(
//                                   _getHeaderSubtitle(),
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 32),

//                       _buildContent(),

//                       SizedBox(height: 24),

//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: _isLoading ? null : _getButtonAction(),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Acolors.primary,
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: _isLoading
//                               ? SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.white,
//                                     ),
//                                   ),
//                                 )
//                               : Text(
//                                   _getButtonText(),
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ),

//                       if (_errorMessage != null) ...[
//                         SizedBox(height: 16),
//                         Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.red[50],
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(color: Colors.red[200]!),
//                           ),
//                           child: Text(
//                             _errorMessage!,
//                             style: TextStyle(color: Colors.red[700]),
//                           ),
//                         ),
//                       ],

//                       SizedBox(height: 16),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildContent() {
//     switch (_currentStep) {
//       case AuthStep.mobile:
//         return _buildMobileStep();
//       case AuthStep.otp:
//         return _buildOTPStep();
//     }
//   }

//   Widget _buildMobileStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Mobile Number',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//           ),
//         ),
//         SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey[300]!),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     right: BorderSide(color: Colors.grey[300]!),
//                   ),
//                 ),
//                 child: Text(
//                   '+91',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),

//               Expanded(
//                 child: TextField(
//                   controller: _mobileController,
//                   keyboardType: TextInputType.phone,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(10),
//                   ],
//                   decoration: InputDecoration(
//                     hintText: 'Enter mobile number',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16),
//                   ),
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOTPStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.blue[100]!),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.phone_android, color: Colors.blue, size: 20),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   '+91 ${_mobileController.text}',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blue[800],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 24),
//         Text(
//           'Enter OTP',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//           ),
//         ),
//         SizedBox(height: 8),
//         TextField(
//           controller: _otpController,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.digitsOnly,
//             LengthLimitingTextInputFormatter(6),
//           ],
//           decoration: InputDecoration(
//             hintText: 'Enter 6-digit OTP',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey[300]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Acolors.primary, width: 2),
//             ),
//             contentPadding: EdgeInsets.all(16),
//           ),
//           style: TextStyle(fontSize: 16, letterSpacing: 2),
//         ),
//         if (!_userExists) ...[
//           SizedBox(height: 24),
//           Text(
//             'Full Name',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[700],
//             ),
//           ),
//           SizedBox(height: 8),
//           TextField(
//             controller: _nameController,
//             textCapitalization: TextCapitalization.words,
//             decoration: InputDecoration(
//               hintText: 'Enter your full name',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Acolors.primary, width: 2),
//               ),
//               contentPadding: EdgeInsets.all(16),
//             ),
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//         SizedBox(height: 16),
//         GestureDetector(
//           onTap: _sendOTP,
//           child: Text(
//             'Resend OTP',
//             style: TextStyle(
//               color: Acolors.primary,
//               fontWeight: FontWeight.w600,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   String _getHeaderTitle() {
//     switch (_currentStep) {
//       case AuthStep.mobile:
//         return 'Login or Sign up';
//       case AuthStep.otp:
//         return _userExists ? 'Verify OTP' : 'Complete Sign up';
//     }
//   }

//   String _getHeaderSubtitle() {
//     switch (_currentStep) {
//       case AuthStep.mobile:
//         return 'Enter your mobile number to continue';
//       case AuthStep.otp:
//         return _userExists
//             ? 'We\'ve sent an OTP to your mobile number'
//             : 'Enter OTP and your name to create account';
//     }
//   }

//   String _getButtonText() {
//     switch (_currentStep) {
//       case AuthStep.mobile:
//         return 'Continue';
//       case AuthStep.otp:
//         return _userExists ? 'Login' : 'Sign Up';
//     }
//   }

//   VoidCallback _getButtonAction() {
//     switch (_currentStep) {
//       case AuthStep.mobile:
//         return _sendOTP;
//       case AuthStep.otp:
//         return _verifyOTP;
//     }
//   }
// }

// enum AuthStep { mobile, otp }
