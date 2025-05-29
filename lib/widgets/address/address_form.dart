// import 'package:ambrosia_ayurved/widgets/address/address_model.dart';
// import 'package:ambrosia_ayurved/widgets/address/address_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddressForm extends StatefulWidget {
//   @override
//   _AddressFormState createState() => _AddressFormState();
// }

// class _AddressFormState extends State<AddressForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _pincodeController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _pincodeController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchAddressDetails(String pincode) async {
//     if (pincode.length != 6) return;

//     setState(() {
//       _isLoading = true;
//     });

//     final address = Provider.of<Address>(context, listen: false);
//     final result = await AddressService.fetchAddressDetails(pincode);

//     setState(() {
//       _isLoading = false;
//     });

//     if (result['status'] == 'success') {
//       address.state = result['state'];
//       address.district = result['district'];
//       // Typically city/district are the same in India
//       address.city = result['district'];
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? 'Invalid pincode')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final address = Provider.of<Address>(context);

//     return Form(
//       key: _formKey,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Add a new address',
//               //  style: Theme.of(context).textTheme.headline6,
//             ),
//             const SizedBox(height: 20),
//             _buildNameField(address),
//             const SizedBox(height: 16),
//             _buildMobileField(address),
//             const SizedBox(height: 16),
//             _buildPincodeField(address),
//             const SizedBox(height: 16),
//             _buildLocalityField(address),
//             const SizedBox(height: 16),
//             _buildAddressField(address),
//             const SizedBox(height: 16),
//             _buildCityDistrictStateFields(address),
//             const SizedBox(height: 16),
//             _buildLandmarkField(address),
//             const SizedBox(height: 16),
//             _buildAlternatePhoneField(address),
//             const SizedBox(height: 16),
//             _buildAddressTypeRadio(address),
//             const SizedBox(height: 24),
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNameField(Address address) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: 'Full Name',
//         border: OutlineInputBorder(),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your name';
//         }
//         return null;
//       },
//       onSaved: (value) => address.name = value!,
//     );
//   }

//   Widget _buildMobileField(Address address) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: 'Mobile Number',
//         border: OutlineInputBorder(),
//       ),
//       keyboardType: TextInputType.phone,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter mobile number';
//         }
//         if (value.length != 10) {
//           return 'Enter a valid 10-digit mobile number';
//         }
//         return null;
//       },
//       onSaved: (value) => address.mobileNumber = value!,
//     );
//   }

//   Widget _buildPincodeField(Address address) {
//     return TextFormField(
//       controller: _pincodeController,
//       decoration: InputDecoration(
//         labelText: 'Pincode',
//         border: OutlineInputBorder(),
//         suffixIcon: _isLoading
//             ? Padding(
//                 padding: EdgeInsets.all(10),
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               )
//             : null,
//       ),
//       keyboardType: TextInputType.number,
//       maxLength: 6,
//       onChanged: (value) {
//         if (value.length == 6) {
//           _fetchAddressDetails(value);
//         }
//       },
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter pincode';
//         }
//         if (value.length != 6) {
//           return 'Enter a valid 6-digit pincode';
//         }
//         return null;
//       },
//       onSaved: (value) => address.pincode = value!,
//     );
//   }

//   Widget _buildLocalityField(Address address) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: 'Locality/Area',
//         border: OutlineInputBorder(),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter locality';
//         }
//         return null;
//       },
//       onSaved: (value) => address.locality = value!,
//     );
//   }

//   Widget _buildAddressField(Address address) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: 'Address (House No, Building, Street)',
//         border: OutlineInputBorder(),
//       ),
//       maxLines: 3,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter address';
//         }
//         return null;
//       },
//       onSaved: (value) => address.address = value!,
//     );
//   }

//   Widget _buildCityDistrictStateFields(Address address) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             decoration: InputDecoration(
//                 labelText: 'City', border: OutlineInputBorder()),
//             controller: TextEditingController(text: address.city),
//             readOnly: true,
//           ),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: TextFormField(
//             decoration: InputDecoration(
//                 labelText: 'District', border: OutlineInputBorder()),
//             controller: TextEditingController(text: address.district),
//             readOnly: true,
//           ),
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: TextFormField(
//             decoration: InputDecoration(
//                 labelText: 'State', border: OutlineInputBorder()),
//             controller: TextEditingController(text: address.state),
//             readOnly: true,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLandmarkField(Address address) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: 'Landmark (Optional)',
//         border: OutlineInputBorder(),
//       ),
//       onSaved: (value) => address.landmark = value ?? '',
//     );
//   }

//   Widget _buildAlternatePhoneField(Address address) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: 'Alternate Phone (Optional)',
//         border: OutlineInputBorder(),
//       ),
//       keyboardType: TextInputType.phone,
//       onSaved: (value) => address.alternatePhone = value ?? '',
//     );
//   }

//   Widget _buildAddressTypeRadio(Address address) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Address Type', style: TextStyle(fontSize: 16)),
//         Row(
//           children: [
//             Radio(
//               value: 'Home',
//               groupValue: address.addressType,
//               onChanged: (value) {
//                 setState(() {
//                   address.addressType = value.toString();
//                 });
//               },
//             ),
//             Text('Home'),
//             Radio(
//               value: 'Work',
//               groupValue: address.addressType,
//               onChanged: (value) {
//                 setState(() {
//                   address.addressType = value.toString();
//                 });
//               },
//             ),
//             Text('Work'),
//             Radio(
//               value: 'Other',
//               groupValue: address.addressType,
//               onChanged: (value) {
//                 setState(() {
//                   address.addressType = value.toString();
//                 });
//               },
//             ),
//             Text('Other'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState!.validate()) {
//             _formKey.currentState!.save();
//             // Save the address or navigate back
//             Navigator.pop(context);
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 16),
//         ),
//         child: Text('SAVE ADDRESS'),
//       ),
//     );
//   }
// }

// class AddAddressScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<Address>(
//       create: (context) => Address(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Add New Address'),
//         ),
//         body: SingleChildScrollView(
//           child: AddressForm(),
//         ),
//       ),
//     );
//   }
// }

import 'package:ambrosia_ayurved/widgets/address/address_model.dart';
import 'package:ambrosia_ayurved/widgets/address/mappayindia/map_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key}) : super(key: key);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _pincodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _fetchPincodeDetails() async {
    if (_pincodeController.text.length != 6) return;

    setState(() => _isLoading = true);
    final address = Provider.of<Address>(context, listen: false);

    final result =
        await MapmyIndiaService.fetchPincodeData(_pincodeController.text);

    setState(() => _isLoading = false);

    if (result['status'] == 'success') {
      address.state = result['state'];
      address.district = result['district'];
      address.city = result['city'];
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = Provider.of<Address>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _pincodeController,
            decoration: InputDecoration(
              labelText: 'Pincode',
              suffixIcon: _isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _fetchPincodeDetails,
                    ),
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            onChanged: (value) {
              if (value.length == 6) {
                _fetchPincodeDetails();
              }
            },
          ),
          const SizedBox(height: 20),
          _buildReadOnlyField('State', address.state),
          _buildReadOnlyField('District', address.district),
          _buildReadOnlyField('City', address.city),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: value),
    );
  }
}

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Address(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Enter Address')),
        body: const SingleChildScrollView(
          child: AddressForm(),
        ),
      ),
    );
  }
}
