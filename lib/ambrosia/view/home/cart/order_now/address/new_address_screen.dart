import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_fetch_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_model.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:ambrosia_ayurved/widgets/newaddresssection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressNewScreen extends StatefulWidget {
  const AddressNewScreen({Key? key}) : super(key: key);

  @override
  _AddressNewScreenState createState() => _AddressNewScreenState();
}

class _AddressNewScreenState extends State<AddressNewScreen> {
  List<Address> _addresses = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final addresses = await AddressFetchService.fetchAddresses(context);
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
        _addresses = [];
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to load addresses: $e')),
      // );
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    try {
      await AddressFetchService.deleteAddress(context, addressId);
      SnackbarMessage.showSnackbar(
          context, AppLocalizations.of(context)!.addressDeleted);

      _loadAddresses(); // Refresh the list after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete address: $e')),
      );
    }
  }

  void _navigateToAddAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddressSection(
                isFromManageAddress: true,
              )),
    ).then((_) => _loadAddresses()); // Refresh after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Address'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          // : _errorMessage.isNotEmpty
          //     ? Center(child: Text(_errorMessage))
          : Column(
              children: [
                Expanded(
                  child: _addresses.isEmpty
                      ? Center(
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
                        )
                      : ListView.builder(
                          itemCount: _addresses.length,
                          itemBuilder: (context, index) {
                            final address = _addresses[index];
                            return AddressCard(
                              address: address,
                              onDelete: () => _deleteAddress(address.id),
                            );
                          },
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _navigateToAddAddress,
                      icon: const Icon(Icons.add_location_alt),
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
}

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onDelete;

  const AddressCard({
    Key? key,
    required this.address,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.status == '1')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Default Address',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${address.fname} ${address.lname}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(address.mobile),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(address.address),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    '${address.city}, ${address.district}, ${address.state} - ${address.pincode}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(address.country),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Address'),
                      content: const Text(
                          'Are you sure you want to delete this address?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onDelete();
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
