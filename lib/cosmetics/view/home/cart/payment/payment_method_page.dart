import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/place_order/place_order_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/qr_upi_payment.dart';
import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/payment_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
  }) : super(key: key);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = "UPI";
  bool isLoading = false;
  Future<bool> showOrderConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.confirmOrder}",
              //   "Confirm Order"
            ),
            content: Text(
              "${AppLocalizations.of(context)!.confirmOrderPrompt}",
              // "Are you sure you want to place this order?"
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "${AppLocalizations.of(context)!.cancel}",
                  // "Cancel"
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "${AppLocalizations.of(context)!.yes}",
                  // "Yes"
                ),
              ),
            ],
          ),
        ) ??
        false; // Return false if dialog is dismissed
  }

  Future<void> handlePaymentAndOrder(
    BuildContext context,
  ) async {
    // Validate transaction ID and screenshot

    // Show Order Confirmation Dialog
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "${AppLocalizations.of(context)!.confirmOrder}",
              //  "Confirm Order"
            ),
            content: Text(
              "${AppLocalizations.of(context)!.confirmOrderPrompt}",
              // "Are you sure you want to place this order?"
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "${AppLocalizations.of(context)!.cancel}",
                  // "Cancel"
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  "${AppLocalizations.of(context)!.yes}",
                  // "Yes"
                ),
              ),
            ],
          ),
        ) ??
        false; // If dialog is dismissed, default to false

    // If user confirms, place order and clear cart
    if (confirm) {
      final placeOrderProvider =
          Provider.of<PlaceOrderProvider>(context, listen: false);

      await placeOrderProvider.placeOrder(context);

      // Ensure order ID is available after placing the order
      final orderId = placeOrderProvider.orderId;
      await Provider.of<PaymentProvider>(context, listen: false).processPayment(
        context,
        orderId.toString(),
      );
      // place order
    }
    // Process Payment
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.paymentMethod}",
        //  'Payment method',
      ),
      body: Column(children: [
        // Container(
        //   height: 80,
        //   color: Acolors.primary,
        //   child: Padding(
        //     padding: const EdgeInsets.all(12),
        //     child: Row(
        //       children: [
        //         Material(
        //           color: Colors.white.withOpacity(0.21),
        //           borderRadius: BorderRadius.circular(12),
        //           child: const BackButton(
        //             color: Colors.white,
        //           ),
        //         ),
        //         const SizedBox(width: 30),
        //         const Text(
        //           'Payment Page',
        //           style: TextStyle(fontSize: 24, color: Colors.white),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child:
              Text("${AppLocalizations.of(context)!.selectYourPaymentMethod}",
                  // 'Select your payment method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
        Card(
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  SizedBox(height: 3),

              //  paymentOptionTile("Credit/Debit Card", Icons.credit_card),
              //   const Divider(color: Colors.grey),
              paymentOptionTile(
                  "${AppLocalizations.of(context)!.upi}",
                  // "UPI",
                  Icons.account_balance_wallet),
              const Divider(color: Colors.grey),
              //   paymentOptionTile("Wallet", Icons.wallet_giftcard),
              //  const Divider(color: Colors.grey),
              paymentOptionTile(
                  "${AppLocalizations.of(context)!.cod}",
                  // "COD",
                  Icons.money),

              //const Divider(color: Colors.grey),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 7),
              //   child: Text(
              //     'Other Methods',
              //     style: TextStyle(fontWeight: FontWeight.w600),
              //   ),
              // ),
              // Divider(color: Colors.grey),
              SizedBox(height: 5),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Text(widget.grandTotal.toString()),
        // ElevatedButton.icon(
        //   style: ElevatedButton.styleFrom(
        //       backgroundColor: Acolors.primary,
        //       foregroundColor: Colors.white),
        //   onPressed: () {},
        //   label: const Text('Add another Credit/Debit Card'),
        //   icon: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        // ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final paymentMethod =
                    paymentProvider.selectedPaymentMethod; // Get latest value

                if (paymentMethod == "${AppLocalizations.of(context)!.upi}") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QrUpiPayment(),
                    ),
                  );
                } else if (paymentMethod ==
                    "${AppLocalizations.of(context)!.cod}") {
                  handlePaymentAndOrder(
                    context,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Acolors.primary,
                foregroundColor: Acolors.white,
                padding: EdgeInsets.symmetric(vertical: 0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: paymentProvider.isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Text(
                      "${AppLocalizations.of(context)!.clickToProceed}",
                      //   "Click to Proceed"
                    )),
            ),
          ),
        ),
        //  SizedBox(height: 20),
      ]),
    );
  }

  Widget paymentOptionTile(String method, IconData icon) {
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        return ListTile(
          leading: Icon(icon, color: Acolors.primary),
          title: Text(method),
          trailing: Radio(
            value: method,
            groupValue:
                paymentProvider.selectedPaymentMethod, // Get from provider
            onChanged: (value) {
              paymentProvider
                  .setPaymentMethod(value as String); // Update provider
            },
          ),
        );
      },
    );
  }
}

/*

  Widget _buildRadioTile(String option) {
    return RadioListTile(
      title: Text(option),
      value: option,
      groupValue: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value.toString();
        });
      },
    );
  }
*/
