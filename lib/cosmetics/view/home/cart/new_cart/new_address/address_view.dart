// import 'package:flutter/material.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/new_address/address_model.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/new_address/address_service.dart';
// import 'package:ambrosia_ayurved/provider/user_provider.dart';
// import 'package:provider/provider.dart';

// class AddressForm extends StatefulWidget {
//   const AddressForm({super.key});

//   @override
//   State<AddressForm> createState() => _AddressFormState();
// }

// class _AddressFormState extends State<AddressForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _fnameController = TextEditingController();
//   final _lnameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _pincodeController = TextEditingController();

//   final userProvider = Provider.of<UserProvider>(context, listen: false),
//    final userId = userProvider
//   bool _isLoading = false;

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);

//       CheckoutInfoModel checkoutData = CheckoutInfoModel(
//         productId: "14", // pass dynamically if needed
//         fname: _fnameController.text,
//         lname: _lnameController.text,
//         userId: "4198", // pass dynamically if needed
//         email: _emailController.text,
//         address: _addressController.text,
//         city: _cityController.text,
//         state: _stateController.text,
//         mobile: _mobileController.text,
//         country: _countryController.text,
//         pincode: _pincodeController.text,
//       );

//       final result = await CheckoutService.saveCheckoutInfo(checkoutData);

//       setState(() => _isLoading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? 'Something went wrong')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                   Expanded(
//                       child: _buildTextField(_fnameController, 'First Name')),
//                   const SizedBox(width: 10),
//                   Expanded(child: _buildTextField(_lnameController, 'Last Name')),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               _buildTextField(_emailController, 'Email'),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(child: _buildTextField(_addressController, 'Address')),
//                   const SizedBox(width: 10),
//                   Expanded(child: _buildTextField(_mobileController, 'Mobile')),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(child: _buildTextField(_cityController, 'City')),
//                   const SizedBox(width: 10),
//                   Expanded(child: _buildTextField(_stateController, 'State')),
//                   const SizedBox(width: 10),
//                   Expanded(child: _buildTextField(_pincodeController, 'Pincode')),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               _buildTextField(_countryController, 'Country'),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _buildTextField(TextEditingController controller, String label) {
//       return TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//           isDense: true,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         ),
//         validator: (value) =>
//             value == null || value.isEmpty ? 'Enter $label' : null,
//       );
//     }
//   }
