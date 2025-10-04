// import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
// import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_model.dart';
// import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
// import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class EditAddressScreen extends StatefulWidget {
//   final Address address;
//   final VoidCallback onAddressUpdated;

//   const EditAddressScreen({
//     Key? key,
//     required this.address,
//     required this.onAddressUpdated,
//   }) : super(key: key);

//   @override
//   State<EditAddressScreen> createState() => _EditAddressScreenState();
// }

// class _EditAddressScreenState extends State<EditAddressScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _fnameController = TextEditingController();
//   final TextEditingController _lnameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _landmarkController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _districtController = TextEditingController();

//   bool _isLoading = false;
//   bool _isPinLoading = false;
//   String? _addressType = 'Home';

//   @override
//   void initState() {
//     super.initState();
//     _initializeFormData();
//     _pincodeController.addListener(_onPincodeChanged);
//   }

//   void _initializeFormData() {
//     _fnameController.text = widget.address.fname;
//     _lnameController.text = widget.address.lname;
//     _emailController.text = widget.address.email;
//     _mobileController.text = widget.address.mobile;
//     _pincodeController.text = widget.address.pincode;
//     _addressController.text = widget.address.address;
//     _countryController.text = widget.address.country;
//     _cityController.text = widget.address.city;
//     _stateController.text = widget.address.state;
//     _districtController.text = widget.address.district;
//     _addressType = widget.address.addressType;
//   }

//   @override
//   void dispose() {
//     _fnameController.dispose();
//     _lnameController.dispose();
//     _emailController.dispose();
//     _mobileController.dispose();
//     _countryController.dispose();
//     _pincodeController.dispose();
//     _addressController.dispose();
//     _landmarkController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _districtController.dispose();
//     super.dispose();
//   }

//   void _onPincodeChanged() {
//     if (_pincodeController.text.length == 6) {
//       _fetchLocationData(_pincodeController.text);
//     }
//   }

//   Future<void> _fetchLocationData(String pincode) async {
//     setState(() {
//       _isPinLoading = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         if (data[0]['Status'] == 'Success') {
//           final postOfficeData = data[0]['PostOffice'][0];

//           setState(() {
//             _stateController.text = postOfficeData['State'] ?? '';
//             _districtController.text = postOfficeData['District'] ?? '';
//             _cityController.text = postOfficeData['Name'] ?? '';
//             _countryController.text = postOfficeData['Country'] ?? '';
//           });
//         } else {
//           _showSnackBar(AppLocalizations.of(context)!.invalidPincode);
//           _clearLocationFields();
//         }
//       } else {
//         _showSnackBar(AppLocalizations.of(context)!.locationFetchFail);
//         _clearLocationFields();
//       }
//     } catch (e) {
//       _showSnackBar(AppLocalizations.of(context)!.locationError);
//       _clearLocationFields();
//     } finally {
//       setState(() {
//         _isPinLoading = false;
//       });
//     }
//   }

//   void _clearLocationFields() {
//     setState(() {
//       _stateController.clear();
//       _districtController.clear();
//       _cityController.clear();
//     });
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red[400],
//       ),
//     );
//   }

//   Future<void> _updateAddress() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final response = await http.patch(
//           Uri.parse('https://ambrosiaayurved.in/api/UpdateAddress'),
//           headers: {
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode({
//             "id": widget.address.id, // Use the address ID from the widget
//             "fname": _fnameController.text,
//             "lname": _lnameController.text,
//             "mobile": _mobileController.text,
//             "address": _addressController.text,
//             "district": _districtController.text,
//             "city": _cityController.text,
//             "email": _emailController.text,
//             "state": _stateController.text,
//             "pincode": _pincodeController.text,
//             "country": _countryController.text,
//           }),
//         );

//         final responseData = jsonDecode(response.body);
//         print('Update Address Response: $responseData');
//         if (response.statusCode == 200 && responseData['status'] == true) {
//           SnackbarMessage.showSnackbar(context, 'Address updated successfully');
//           widget.onAddressUpdated();
//           Navigator.pop(context);
//         } else {
//           SnackbarMessage.showSnackbar(
//             context,
//             responseData['message'] ?? 'Failed to update address',
//           );
//         }
//       } catch (e) {
//         SnackbarMessage.showSnackbar(context, 'Failed to update address: $e');
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         leading: BackButton(color: Colors.black),
//         title: 'Edit Address',
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Contact Information Section
//               Card(
//                 elevation: 1,
//                 margin: EdgeInsets.zero,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Contact Information',
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _fnameController,
//                               decoration: InputDecoration(
//                                 labelText: 'First Name',
//                                 border: OutlineInputBorder(),
//                                 prefixIcon: Icon(Icons.person, size: 20),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 12),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your first name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _lnameController,
//                               decoration: InputDecoration(
//                                 labelText: 'Last Name',
//                                 border: OutlineInputBorder(),
//                                 prefixIcon: Icon(Icons.person, size: 20),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 12),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your last name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _mobileController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: 'Phone Number',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.phone, size: 20),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter mobile number";
//                           } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                             return "Please enter valid mobile number";
//                           }
//                           return null;
//                         },
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(10),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.email, size: 20),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Address Information Section
//               Card(
//                 elevation: 1,
//                 margin: EdgeInsets.zero,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Address Information',
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       ),
//                       const SizedBox(height: 12),

//                       // Pincode with loading indicator
//                       TextFormField(
//                         controller: _pincodeController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly,
//                           LengthLimitingTextInputFormatter(6),
//                         ],
//                         decoration: InputDecoration(
//                           labelText: 'Pincode',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.location_on, size: 20),
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 12),
//                           suffixIcon: _isPinLoading
//                               ? SizedBox(
//                                   width: 16,
//                                   height: 16,
//                                   child: Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: CircularProgressIndicator(
//                                         strokeWidth: 2),
//                                   ),
//                                 )
//                               : null,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return "Please enter pincode";
//                           } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
//                             return "Please enter valid pincode";
//                           }
//                           return null;
//                         },
//                       ),

//                       const SizedBox(height: 12),

//                       // Auto-filled fields
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _cityController,
//                               decoration: InputDecoration(
//                                 labelText: 'City/Town',
//                                 border: OutlineInputBorder(),
//                                 filled: true,
//                                 fillColor: Color(0xFFF5F5F5),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 12),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter city/town';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _districtController,
//                               decoration: InputDecoration(
//                                 labelText: 'District',
//                                 border: OutlineInputBorder(),
//                                 filled: true,
//                                 fillColor: Color(0xFFF5F5F5),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 12),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter District';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 12),

//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _stateController,
//                               decoration: InputDecoration(
//                                 labelText: 'State',
//                                 border: OutlineInputBorder(),
//                                 filled: true,
//                                 fillColor: Color(0xFFF5F5F5),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 12),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter State';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _countryController,
//                               decoration: InputDecoration(
//                                 labelText: 'Country',
//                                 border: OutlineInputBorder(),
//                                 filled: true,
//                                 fillColor: Color(0xFFF5F5F5),
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 12, horizontal: 12),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter country';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 12),

//                       TextFormField(
//                         controller: _addressController,
//                         maxLines: 2,
//                         decoration: InputDecoration(
//                           labelText: 'House No, Building, Road, Area',
//                           border: OutlineInputBorder(),
//                           alignLabelWithHint: true,
//                           contentPadding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your address';
//                           }
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 12),

//               // Address Type Section
//               Card(
//                 elevation: 1,
//                 margin: EdgeInsets.zero,
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Address Type',
//                         style:
//                             Theme.of(context).textTheme.titleMedium?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: RadioListTile<String>(
//                               title:
//                                   Text('Home', style: TextStyle(fontSize: 14)),
//                               value: 'Home',
//                               groupValue: _addressType,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _addressType = value;
//                                 });
//                               },
//                               contentPadding: EdgeInsets.zero,
//                               dense: true,
//                             ),
//                           ),
//                           Expanded(
//                             child: RadioListTile<String>(
//                               title:
//                                   Text('Work', style: TextStyle(fontSize: 14)),
//                               value: 'Work',
//                               groupValue: _addressType,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _addressType = value;
//                                 });
//                               },
//                               contentPadding: EdgeInsets.zero,
//                               dense: true,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(
//             left: 16,
//             right: 16,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 8,
//           ),
//           child: SizedBox(
//             child: ElevatedButton(
//               onPressed: _isLoading ? null : _updateAddress,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Acolors.primary,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//               child: _isLoading
//                   ? SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                       ),
//                     )
//                   : Text(
//                       'Update Address',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
