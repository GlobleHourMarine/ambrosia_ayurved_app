import 'package:ambrosia_ayurved/ambrosia/common_widgets/custom_app_bar.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/cancellation&refund.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/privacy_policy.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/shipping&delivery.dart';
import 'package:ambrosia_ayurved/ambrosia/view/more/more_view/ourpolicies/terms&conditions.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/common/color_extension.dart';

class PoliciesScreen extends StatelessWidget {
  const PoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Our Policies',
        leading: const BackButton(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5FCF7), // Very light green
              Colors.white,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Please select a policy to view",
            //   style: TextStyle(
            //     color: Acolors.secondaryText,
            //     fontSize: 16,
            //   ),
            // ),
            //  const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: [
                  _buildPolicyTile(
                    context,
                    title: "Privacy Policy",
                    icon: Icons.privacy_tip_outlined,
                    color: const Color(0xFF4CAF50), // Green
                    onTap: () {
                      // Navigate to Privacy Policy screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivacyPolicyScreen()));
                    },
                  ),
                  _buildPolicyTile(
                    context,
                    title: "Terms & Conditions",
                    icon: Icons.description_outlined,
                    color: const Color(0xFF2196F3), // Blue
                    onTap: () {
                      // Navigate to Terms & Conditions screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TermsAndConditionsScreen()));
                    },
                  ),
                  _buildPolicyTile(
                    context,
                    title: "Shipping & Delivery",
                    icon: Icons.local_shipping_outlined,
                    color: const Color(0xFFFF9800), // Orange
                    onTap: () {
                      // Navigate to Shipping & Delivery Policy screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShippingAndDeliveryPolicyScreen()));
                    },
                  ),
                  _buildPolicyTile(
                    context,
                    title: "Cancellation & Refund",
                    icon: Icons.assignment_return_outlined,
                    color: const Color(0xFFF44336), // Red
                    onTap: () {
                      // Navigate to Cancellation & Refund Policy screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CancellationRefundPolicyScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Acolors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "View policy",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Acolors.secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
