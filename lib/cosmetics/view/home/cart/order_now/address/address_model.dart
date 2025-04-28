class AddressModel {
  final String userId;
  final String address;

  AddressModel({required this.userId, required this.address});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      userId: json['user_id'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "address": address,
    };
  }
}
