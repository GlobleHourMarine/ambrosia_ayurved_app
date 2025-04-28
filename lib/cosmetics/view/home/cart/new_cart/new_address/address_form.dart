// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddressForm extends StatelessWidget {
//   final GlobalKey<FormState> formKey;

//   const AddressForm({super.key, required this.formKey});

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AddressProvider>(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Form(
//         key: formKey,
//         child: Column(
//           children: [
//             _buildField("First Name", provider.fnameController),
//             _buildField("Last Name", provider.lnameController),
//             _buildField("Email", provider.emailController),
//             _buildField("Mobile", provider.mobileController),
//             _buildField("Address", provider.addressController),
//             _buildField("City", provider.cityController),
//             _buildField("State", provider.stateController),
//             _buildField("Country", provider.countryController),
//             _buildField("Pincode", provider.pincodeController),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         validator: (value) =>
//             value == null || value.isEmpty ? "Please enter $label" : null,
//       ),
//     );
//   }
// }
