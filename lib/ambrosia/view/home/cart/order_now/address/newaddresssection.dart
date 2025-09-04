import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/order_now_page.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressSection extends StatefulWidget {
  final bool isFromManageAddress;
  const AddressSection({Key? key, this.isFromManageAddress = false})
      : super(key: key);

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  bool _isLoading = false;
  bool _isPinLoading = false;
  String? _addressType = 'Home';

  @override
  void initState() {
    super.initState();
    _pincodeController.addListener(_onPincodeChanged);
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  void _onPincodeChanged() {
    if (_pincodeController.text.length == 6) {
      _fetchLocationData(_pincodeController.text);
    }
  }

  Future<void> _fetchLocationData(String pincode) async {
    setState(() {
      _isPinLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data[0]['Status'] == 'Success') {
          final postOfficeData = data[0]['PostOffice'][0];

          setState(() {
            _stateController.text = postOfficeData['State'] ?? '';
            _districtController.text = postOfficeData['District'] ?? '';
            _cityController.text = postOfficeData['Name'] ?? '';
            _countryController.text = postOfficeData['Country'] ?? '';
          });
        } else {
          _showSnackBar(AppLocalizations.of(context)!.invalidPincode
              //'Invalid pincode. Please enter a valid pincode.'
              );
          _clearLocationFields();
        }
      } else {
        _showSnackBar(
          AppLocalizations.of(context)!.locationFetchFail,
          //  'Failed to fetch location data. Please try again.'
        );
        _clearLocationFields();
      }
    } catch (e) {
      _showSnackBar(
        AppLocalizations.of(context)!.locationError,
        //  'Error fetching location data. Please check your internet connection.'
      );
      _clearLocationFields();
    } finally {
      setState(() {
        _isPinLoading = false;
      });
    }
  }

  void _clearLocationFields() {
    setState(() {
      _stateController.clear();
      _districtController.clear();
      _cityController.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  // void _saveAddress() {
  //   if (_formKey.currentState!.validate()) {
  //     final addressData = {
  //       'first_name': _fnameController.text,
  //       'last_name': _lnameController.text,
  //       'mobile': _mobileController.text,
  //       'pincode': _pincodeController.text,
  //       'address': _addressController.text,
  //       'landmark': _landmarkController.text,
  //       'country': _countryController.text,
  //       'city': _cityController.text,
  //       'state': _stateController.text,
  //       'district': _districtController.text,
  //       'type': _addressType,
  //     };

  //     print('Address Data: $addressData');
  //     _showSnackBar('Address saved successfully!');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.addAddress
          //'Add Address',
          ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Information Section
              Card(
                elevation: 1,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.contactInformation,
                        // 'Contact Information',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _fnameController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.firstName,
                                // 'First Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person, size: 20),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pleaseEnterFirstName;
                                  //  'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _lnameController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.lastName,
                                //'Last Name',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person, size: 20),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .pleaseEnterLastName;
                                  // 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.phone,
                          //  'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone, size: 20),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "${AppLocalizations.of(context)!.enterMobile}";
                          } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return "${AppLocalizations.of(context)!.validMobile}";
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Address Information Section
              Card(
                elevation: 1,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addressInformation,
                        //  'Address Information',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),

                      // Pincode with loading indicator
                      TextFormField(
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.pincode,
                          // 'Pincode',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on, size: 20),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          suffixIcon: _isPinLoading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "${AppLocalizations.of(context)!.enterPincode}";
                          } else if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                            return "${AppLocalizations.of(context)!.validPincode}";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Auto-filled fields
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.cityTown,
                                //'City/Town',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterCity;
                                  // 'Please enter city/town';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _districtController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.district,
                                // 'District',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _stateController,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)!.state,
                                // 'State',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context)!.country,
                                //'Country',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterCountry;
                                  //'Please enter country';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.houseDetails,
                          //'House No, Building, Road, Area',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterAddress;
                            //'Please enter your address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Address Type Section
              Card(
                elevation: 1,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addressType,
                        // 'Address Type',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(AppLocalizations.of(context)!.home,
                                  // 'Home',
                                  style: TextStyle(fontSize: 14)),
                              value: AppLocalizations.of(context)!.home,
                              //'Home',
                              groupValue: _addressType,
                              onChanged: (value) {
                                setState(() {
                                  _addressType = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(AppLocalizations.of(context)!.work,
                                  //'Work',
                                  style: TextStyle(fontSize: 14)),
                              value: AppLocalizations.of(context)!.work,
                              //   'Work',
                              groupValue: _addressType,
                              onChanged: (value) {
                                setState(() {
                                  _addressType = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                //  height: 48,
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            final userId = userProvider.id;

                            final addressProvider =
                                Provider.of<AddressProvider>(context,
                                    listen: false);

                            bool success =
                                await addressProvider.saveCheckoutInformation(
                              address_type: _addressType.toString(),
                              district: _districtController.text,
                              userid: userId,
                              fname: _fnameController.text,
                              lname: _lnameController.text,
                              address: _addressController.text,
                              city: _cityController.text,
                              state: _stateController.text,
                              mobile: _mobileController.text,
                              country: _countryController.text,
                              pincode: _pincodeController.text,
                              context: context,
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            if (success) {
                              // FIXED: Navigate based on where this screen was opened from
                              if (widget.isFromManageAddress) {
                                // If opened from manage address screen, go back
                                Navigator.pop(context);
                              } else {
                                // If opened from checkout/order flow, go to order page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderNowPage()),
                                );
                              }
                            }
                          }
                        },

                  // if (success) {
                  //  _openRazorpayCheckout(grandTotalProvider.grandTotal);
                  // _startPhonePePayment(grandTotalProvider.grandTotal);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => OrderNowPage(),
                  //   ),
                  // );
                  //     }
                  // setState(() {
                  //   _isLoading = false;
                  // });

                  style: OutlinedButton.styleFrom(
                    // backgroundColor: Colors.blue[600],
                    foregroundColor: Acolors.primary,
                    side: BorderSide(color: Acolors.primary, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Acolors.primary),
                            ),
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.saveAddress,
                          //"Save Address"
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
