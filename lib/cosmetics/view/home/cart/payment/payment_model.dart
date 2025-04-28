class PaymentDetails {
  final String userId;
  final String paymentMethod;
  final double amount;
  final String orderId;
  final String? transactionId; // Nullable
  final String? screenshot; // Nullable

  PaymentDetails({
    required this.userId,
    required this.paymentMethod,
    required this.amount,
    required this.orderId,
    this.transactionId, // Optional
    this.screenshot, // Optional
  });

  // Factory constructor to create an instance from JSON
  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      userId: json['user_id'].toString(),
      paymentMethod: json['payment_method'],
      amount: (json['amount'] as num).toDouble(),
      orderId: json['order_id'].toString(),
      transactionId: json['transaction_id'], // Nullable
      screenshot: json['screenshot'], // Nullable
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "payment_method": paymentMethod,
      "amount": amount,
      "order_id": orderId,
      if (transactionId != null)
        "transaction_id": transactionId, // Only include if not null
      if (screenshot != null)
        "screenshot": screenshot, // Only include if not null
    };
  }
}
