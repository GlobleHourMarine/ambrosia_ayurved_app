import 'package:ambrosia_ayurved/widgets/address/gemini_address/pincodeservice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http for the API service

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({Key? key}) : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  final PincodeApiService _pincodeApiService = PincodeApiService();
  String? _pincodeErrorMessage;

  @override
  void initState() {
    super.initState();
    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.removeListener(_onPincodeChanged);
    _pincodeController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _onPincodeChanged() {
    // Implement debouncing here for a better user experience
    // For simplicity, we'll call immediately for this example.
    // In a real app, use a Timer to debounce.
    if (_pincodeController.text.length == 6) {
      _fetchLocationDetails(_pincodeController.text);
    } else {
      setState(() {
        _stateController.text = '';
        _districtController.text = '';
        _cityController.text = '';
        _pincodeErrorMessage = null;
      });
    }
  }

  Future<void> _fetchLocationDetails(String pincode) async {
    setState(() {
      _pincodeErrorMessage = null; // Clear previous error
    });

    final result = await _pincodeApiService.fetchLocationByPincode(pincode);

    if (result.containsKey('error')) {
      setState(() {
        _pincodeErrorMessage = result['error'];
        _stateController.text = '';
        _districtController.text = '';
        _cityController.text = '';
      });
    } else {
      setState(() {
        _stateController.text = result['state'] ?? '';
        _districtController.text = result['district'] ?? '';
        _cityController.text =
            result['city'] ?? ''; // Populate city if available
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the address data
      print('Name: ${_nameController.text}');
      print('Phone: ${_phoneController.text}');
      print('Pincode: ${_pincodeController.text}');
      print('Address Line 1: ${_addressLine1Controller.text}');
      print('Address Line 2: ${_addressLine2Controller.text}');
      print('City: ${_cityController.text}');
      print('State: ${_stateController.text}');
      print('District: ${_districtController.text}');

      // You would typically send this data to your backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address Saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pincodeController,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  border: const OutlineInputBorder(),
                  errorText: _pincodeErrorMessage, // Display API errors
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pincode';
                  }
                  if (value.length != 6) {
                    return 'Pincode must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                enabled: false, // Make this field non-editable
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(),
                ),
                enabled: false, // Make this field non-editable
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller:
                    _cityController, // Optional: for city if API provides
                decoration: const InputDecoration(
                  labelText: 'City/Town',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressLine1Controller,
                decoration: const InputDecoration(
                  labelText: 'Flat, House no., Building, Company, Apartment',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address line 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressLine2Controller,
                decoration: const InputDecoration(
                  labelText: 'Area, Street, Sector, Village (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Address',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
