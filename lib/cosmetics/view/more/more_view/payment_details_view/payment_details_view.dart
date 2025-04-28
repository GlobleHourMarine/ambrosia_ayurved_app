import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/common/color_extension.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/payment_details_view/payment_details_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/payment_details_view/payment_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentDetailsView extends StatefulWidget {
  const PaymentDetailsView({super.key});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentDetailsProvider>(context, listen: false)
        .paymentDetailsView(context);
  }

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentDetailsProvider>(context);
    final payments = paymentProvider.paymentDetails;

    return Scaffold(
      appBar: CustomAppBar(
        title: "${AppLocalizations.of(context)!.paymentDetails}",
        // 'Payment Details',
      ),
      body: Column(
        children: [
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
          //           child: const BackButton(color: Acolors.white),
          //         ),
          //         const SizedBox(width: 30),
          //         const Text(
          //           'Payment Details',
          //           style: TextStyle(fontSize: 24, color: Acolors.white),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 10),
          Expanded(
            child: paymentProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : payments.isNotEmpty
                    ? ListView.builder(
                        itemCount: payments.length,
                        itemBuilder: (context, index) {
                          final payment = payments[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: Colors.black26,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(LucideIcons.creditCard,
                                          color: Acolors.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        "${AppLocalizations.of(context)!.paymentMethod}",
                                        //  'Payment Method',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        payment.paymentMethod,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(thickness: 1, height: 12),
                                  _buildInfoRow(
                                    LucideIcons.checkCircle,
                                    "${AppLocalizations.of(context)!.status}",
                                    //   "Status",
                                    getOrderStatusText(payment.status, context),
                                  ),
                                  _buildInfoRow(
                                      LucideIcons.user,
                                      "${AppLocalizations.of(context)!.userId}",
                                      //"User ID",
                                      payment.userId.toString()),
                                  _buildInfoRow(
                                      LucideIcons.dollarSign,
                                      "${AppLocalizations.of(context)!.amount}",
                                      '\Rs ${payment.amount}'
                                      //   "Amount", '\Rs ${payment.amount}'

                                      ),
                                  _buildInfoRow(
                                      LucideIcons.hash,
                                      "${AppLocalizations.of(context)!.transactionId}",
                                      //   "Transaction ID",
                                      payment.transactionId.toString()),
                                  _buildInfoRow(
                                      LucideIcons.receipt,
                                      "${AppLocalizations.of(context)!.paymentId}",
                                      //"Payment ID",

                                      payment.paymentId),
                                  _buildInfoRow(
                                      LucideIcons.calendar,
                                      "${AppLocalizations.of(context)!.date}",
                                      //  "Date",
                                      payment.date),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "${AppLocalizations.of(context)!.youhavenotdoneanypayment}",
                          // 'You have not done any payment.',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

// Helper function for aligned rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Acolors.primary),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Function to get order status text
String getOrderStatusText(int status, BuildContext context) {
  switch (status) {
    case 0:
      return "${AppLocalizations.of(context)!.cancelled}";
    // "Cancelled";
    case 1:
      return "${AppLocalizations.of(context)!.pending}";
    //  "Pending";
    case 2:
      return "${AppLocalizations.of(context)!.processing}";
    //  "Processing";
    case 3:
      return "${AppLocalizations.of(context)!.rejected}";
    //  "Rejected";
    default:
      return "${AppLocalizations.of(context)!.unknown}";
    // "Unknown";
  }
}

// Function to get order status color
Color getOrderStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.red; // Cancelled
    case 1:
      return Colors.orange; // Pending
    case 2:
      return Colors.green; // Processing
    case 3:
      return Colors.grey; // Rejected
    default:
      return Colors.black;
  }
}
