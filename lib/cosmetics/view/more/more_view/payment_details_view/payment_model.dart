class Payment {
  final String paymentId;
  final String userId;
  final String paymentMethod;
  final int status;
  final String? transactionId;
  final String? screenshot;
  final String amount;
  final String date;

  Payment({
    required this.paymentId,
    required this.userId,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    this.screenshot,
    required this.amount,
    required this.date,
  });

  // Factory method to create a Payment object from a JSON map
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'] ?? '',
      userId: json['user_id'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      status: int.tryParse(json['status'].toString()) ??
          -1, // Convert to int safely, default to -1 if invalid
      transactionId: json['transaction_id'],
      screenshot: json['screenshot'] ?? '',
      amount: json['amount'] ?? '',
      date: json['date'] ?? '',
    );
  }

  // Method to convert a Payment object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'user_id': userId,
      'payment_method': paymentMethod,
      'status': status,
      'transaction_id': transactionId,
      'screenshot': screenshot,
      'amount': amount,
      'date': date,
    };
  }
}
