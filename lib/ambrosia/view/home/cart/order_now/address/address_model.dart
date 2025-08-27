class Address {
  final String id;
  final String userId;
  final String fname;
  final String lname;
  final String mobile;
  final String address;
  final String city;
  final String district;
  final String state;
  final String country;
  final String pincode;
  final String addressType;
  final String status;

  Address({
    required this.id,
    required this.userId,
    required this.fname,
    required this.lname,
    required this.mobile,
    required this.address,
    required this.city,
    required this.district,
    required this.state,
    required this.country,
    required this.pincode,
    required this.addressType,
    required this.status,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      pincode: json['pincode'] ?? '',
      addressType: json['address_type'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
