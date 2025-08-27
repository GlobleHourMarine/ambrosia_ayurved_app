import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_fetch_service.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/cart/order_now/address/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({Key? key}) : super(key: key);

  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  List<Address> addresses = [];
  String? selectedAddressId;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final fetchedAddresses =
          await AddressFetchService.fetchAddresses(context);
      setState(() {
        addresses = fetchedAddresses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.selectDeliveryAddress,
          //'Select Delivery Address'
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (addresses.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noAddressesForUser,
          //'No addresses found for this user.'
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _buildAddressCard(address);
            },
          ),
        ),
        if (selectedAddressId != null) _buildProceedButton(),
      ],
    );
  }

  Widget _buildAddressCard(Address address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selectedAddressId == address.id
              ? Colors.green
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedAddressId = address.id;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<String>(
                value: address.id,
                groupValue: selectedAddressId,
                onChanged: (value) {
                  setState(() {
                    selectedAddressId = value;
                  });
                },
                activeColor: Colors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${address.fname} ${address.lname}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(address.mobile),
                    const SizedBox(height: 8),
                    Text(
                      '${address.address}, ${address.city}, ${address.district}, ${address.state}, ${address.country} - ${address.pincode}',
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        address.addressType,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProceedButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle proceed with selected address
            final selectedAddress = addresses.firstWhere(
              (address) => address.id == selectedAddressId,
            );
            _showConfirmationDialog(selectedAddress);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.deliverToThisAddress,
            // 'Deliver to this Address',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.confirmDeliveryAddress,
          // 'Confirm Delivery Address'
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${address.fname} ${address.lname}'),
            const SizedBox(height: 4),
            Text(address.mobile),
            const SizedBox(height: 8),
            Text(
              '${address.address}, ${address.city}\n${address.district}, ${address.state}\n${address.country} - ${address.pincode}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,

              //'Cancel'
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Proceed with the selected address
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.addressSelected,
                    //'Address selected successfully!'
                  ),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.confirm
                //'Confirm'
                ),
          ),
        ],
      ),
    );
  }
}
