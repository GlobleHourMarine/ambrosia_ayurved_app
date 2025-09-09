import 'dart:convert';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_model.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/newaddresssection.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressFetchService {
  static Future<List<Address>> fetchAddresses(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userid = userProvider.id;

    final url = Uri.parse(
        'https://ambrosiaayurved.in/api/fetch_all_address?user_id=$userid');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('Request sent to: ${url.toString()}');
      print('Request body: ${jsonEncode({'user_id': userid})}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          return (data['data'] as List)
              .map((item) => Address.fromJson(item))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'API returned false status');
        }
      } else {
        throw Exception('HTTP error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network request failed: $e');
    }
  }

  static Future<void> deleteAddress(
      BuildContext context, String addressId) async {
    final url = Uri.parse('https://ambrosiaayurved.in/api/delete_any_address');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': addressId,
        }),
      );

      print('Request body: ${jsonEncode({'id': addressId})}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] != true) {
          throw Exception(data['message'] ?? 'Failed to delete address');
        }
      } else {
        throw Exception('HTTP error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network request failed: $e');
    }
  }
}

class AddressSelectionWidget extends StatefulWidget {
  final Function(Address) onAddressSelected;
  final String? title;
  final double? height;

  const AddressSelectionWidget({
    Key? key,
    required this.onAddressSelected,
    this.title,
    this.height,
  }) : super(key: key);

  @override
  State<AddressSelectionWidget> createState() => _AddressSelectionWidgetState();
}

class _AddressSelectionWidgetState extends State<AddressSelectionWidget> {
  List<Address> addresses = [];
  String? selectedAddressId;
  bool isLoading = true;
  String? errorMessage;
  bool showAllAddresses = false;
  static const int maxVisibleAddresses = 2;

  @override
  void initState() {
    super.initState();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userid = userProvider.id;
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(
        Uri.parse(
            'https://ambrosiaayurved.in/api/fetch_all_address?user_id=$userid'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> addressData = jsonResponse['data'];
          setState(() {
            addresses =
                addressData.map((item) => Address.fromJson(item)).toList();

            // Sort addresses by ID in descending order (latest first)
            addresses.sort((a, b) => b.id.compareTo(a.id));

            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage =
                jsonResponse['message'] ?? 'Failed to fetch addresses';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  void _showDeleteDialog(String addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteAddress,
            // 'Delete Address'
          ),
          content: Text(AppLocalizations.of(context)!.confirmDeleteAddress
              //  'Are you sure you want to delete this address?'
              ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel
                  //'Cancel'
                  ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await AddressFetchService.deleteAddress(context, addressId);
                  // Update the state immediately
                  setState(() {
                    addresses.removeWhere((address) => address.id == addressId);
                  });

                  // Show success message
                  SnackbarMessage.showSnackbar(
                    context,
                    AppLocalizations.of(context)!.addressDeleted,
                    // 'Address deleted successfully'
                  );
                } catch (e) {
                  SnackbarMessage.showSnackbar(
                      context, AppLocalizations.of(context)!.serverErrorDelete
                      // 'Server Error : Failed to delete address'
                      );
                }
              },
              child: Text(AppLocalizations.of(context)!.delete,
                  //  'Delete',
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddressSection() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressSection(),
        )).then((_) {
      // Refresh addresses when returning from add address screen
      fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: widget.height ?? 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noAddresses,
              // 'No addresses found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.addFirstAddress,
              //  'Add your first address to continue',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressSection(),
                    ));
              },
              icon: const Icon(Icons.add_location_alt),
              label: Text(
                AppLocalizations.of(context)!.addAddress,
                //'Add Address'
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchAddresses,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              itemCount: _getDisplayItemCount(),
              itemBuilder: (context, index) {
                if (index < _getVisibleAddressCount()) {
                  final address = addresses[index];
                  return _buildAddressCard(address);
                } else {
                  return _buildShowMoreButton();
                }
              },
            ),
          ),
          if (addresses.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _navigateToAddressSection,
                  icon: const Icon(Icons.add),
                  label: Text(
                    AppLocalizations.of(context)!.addNewAddress,
                    //'Add New Address'
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green[600],
                    side: BorderSide(color: Colors.green[600]!),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  int _getVisibleAddressCount() {
    if (showAllAddresses || addresses.length <= maxVisibleAddresses) {
      return addresses.length;
    }
    return maxVisibleAddresses;
  }

  int _getDisplayItemCount() {
    final visibleCount = _getVisibleAddressCount();
    if (addresses.length > maxVisibleAddresses && !showAllAddresses) {
      return visibleCount + 1; // +1 for show more button
    }
    return visibleCount;
  }

  Widget _buildShowMoreButton() {
    final remainingCount = addresses.length - maxVisibleAddresses;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            showAllAddresses = !showAllAddresses;
          });
        },
        icon: Icon(
          showAllAddresses ? Icons.expand_less : Icons.expand_more,
          color: Colors.green[600],
        ),
        label: Text(
          showAllAddresses
              ? AppLocalizations.of(context)!.showLess
              //   'Show Less'
              : '${AppLocalizations.of(context)!.show} $remainingCount ${AppLocalizations.of(context)!.moreAddress} ', // ${remainingCount > 1}
          style: TextStyle(
            color: Colors.green[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
    final isSelected = selectedAddressId == address.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedAddressId = address.id;
          });
          widget.onAddressSelected(address);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.8,
                child: Radio<String>(
                  value: address.id,
                  groupValue: selectedAddressId,
                  onChanged: (String? value) {
                    setState(() {
                      selectedAddressId = value;
                    });
                    widget.onAddressSelected(address);
                  },
                  activeColor: Colors.green[600],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${address.fname} ${address.lname}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            address.addressType,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address.mobile,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${address.address},${address.city}, ${address.district}, ${address.state}, ${address.country} - ${address.pincode}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(address.id),
                icon: Icon(Icons.delete_outline_rounded),
                color: Colors.red[400],
              )
            ],
          ),
        ),
      ),
    );
  }
}
