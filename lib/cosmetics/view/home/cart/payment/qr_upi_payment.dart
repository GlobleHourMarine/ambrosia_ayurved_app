import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/payment_verfication_page.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QrUpiPayment extends StatelessWidget {
  final String addressId;
  const QrUpiPayment({Key? key, required this.addressId}) : super(key: key);

  final String upiId = '7006900393@ptsbi';

  // Function to copy UPI ID to clipboard
  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: upiId));
    SnackbarMessage.showSnackbar(
        context,
        // "${AppLocalizations.of(context)!.upi}",
        'UPI ID copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.upiPayment}",
        // 'UPI payment',
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // QR Code
            // Container(
            //   height: 70,
            //   color: Acolors.primary,
            //   child: Padding(
            //     padding: const EdgeInsets.all(12),
            //     child: Row(
            //       children: [
            //         Material(
            //           color: Colors.white.withOpacity(0.21),
            //           borderRadius: BorderRadius.circular(12),
            //           child: const BackButton(
            //             color: Acolors.white,
            //           ),
            //         ),
            //         const SizedBox(width: 30),
            //         const Text(
            //           'Payment',
            //           style: TextStyle(fontSize: 24, color: Acolors.white),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Text(
              "${AppLocalizations.of(context)!.pleasePayToThisUpiId}",
              //  'Please pay to this UPI ID',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: QrImageView(
                data: upiId, // UPI ID data for QR code
                size: 300.0,
              ),
            ),
            SizedBox(height: 50),
            // UPI ID Display
            Text(
              "${AppLocalizations.of(context)!.upiId} : $upiId ",
              //'UPI ID: $upiId',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Copy Button
            ElevatedButton(
              //  style: ElevatedButton.styleFrom(backgroundColor: Acolors.primary),
              onPressed: () => copyToClipboard(context),
              child: Text("${AppLocalizations.of(context)!.copyUpiId}"

                  /// 'Copy UPI ID'
                  ),
            ),
            Spacer(),

            Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                width: 350,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Acolors.primary,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentVerificationPage(
                            addressId: addressId,
                          ),
                        ));
                  },
                  child: Text(
                    "${AppLocalizations.of(context)!.clickHereIfYouAlreadyPaid}",
                    //  'Click here if you already paid',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
