class CheckoutInfoModel {
  final String productId;
  final String fname;
  final String lname;
  final String userId;
  final String email;
  final String address;
  final String city;
  final String state;
  final String mobile;
  final String country;
  final String pincode;

  CheckoutInfoModel({
    required this.productId,
    required this.fname,
    required this.lname,
    required this.userId,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.mobile,
    required this.country,
    required this.pincode,
  });

  Map<String, String> toJson() {
    return {
      "product_id": productId,
      "fname": fname,
      "lname": lname,
      "user_id": userId,
      "email": email,
      "address": address,
      "city": city,
      "state": state,
      "mobile": mobile,
      "country": country,
      "pincode": pincode,
    };
  }
}
