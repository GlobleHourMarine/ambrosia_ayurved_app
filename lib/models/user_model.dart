/*

class User {
  final int id;
  final String userId;
  final String username;
  final String email;
  final String password;
  double income_wallet;
  double activation_wallet;
  final String mobile;
  String
      wallet_balance; // Keep it as String, but handle the conversion from double
  final String createdAt;
  final String reffer_code;
  final String rank;
  String image;

  User({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.income_wallet,
    required this.activation_wallet,
    required this.mobile,
    required this.wallet_balance,
    required this.createdAt,
    required this.reffer_code,
    required this.rank,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      userId: json['user'] != null ? json['user'].toString() : '',
      username: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',

      // Convert activation_wallet to double
      activation_wallet: json['activation_wallet'] == null
          ? 0.0
          : (json['activation_wallet'] is String)
              ? double.tryParse(json['activation_wallet']) ?? 0.0
              : (json['activation_wallet'] as num).toDouble(),

      // Convert income_wallet to double
      income_wallet: (json['income_wallet'] == null)
          ? 0.0
          : (json['income_wallet'] is String)
              ? double.tryParse(json['income_wallet']) ?? 0.0
              : (json['income_wallet'] as num).toDouble(),

      // Keep wallet_balance as String, converting it if necessary
      wallet_balance: json['activation_wallet'] != null
          ? (json['activation_wallet'] is num
              ? json['activation_wallet'].toString()
              : json['activation_wallet'].toString())
          : '',

      createdAt: json['created_at'] ?? '',
      reffer_code: json['reffer_code'] ?? '',
      rank: json['rank'] ?? '',
      image: json['image'] ?? '',
    );
  }

  void updateImage(String newImageUrl) {
    image = newImageUrl;
  }
}
*/

class User {
  final String id;
  //final String userId;
  final String fname;
  final String lname;
  // final String username;
  final String email;
  final String password;
  // double income_wallet;
  // double activation_wallet;
  final String mobile;
  // String
  //     wallet_balance; // Keep it as String, but handle the conversion from double
  final String createdAt;
  // final String reffer_code;
  // final String rank;
  String image;
  String otp;
  String address;

  User({
    required this.id,
    //  required this.userId,
    required this.fname,
    required this.lname,
    //  required this.username,
    required this.email,
    required this.password,
    // required this.income_wallet,
    // required this.activation_wallet,
    required this.mobile,
    // required this.wallet_balance,
    required this.createdAt,
    // required this.reffer_code,
    // required this.rank,
    this.image = '',
    required this.otp,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'].toString(),
      // id: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id']),
      // userId: json['user'] != null ? json['user'].toString() : '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      // username: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      otp: json['otp'].toString(),
      address: json['address'] ?? '',

      // Convert activation_wallet to double
      // activation_wallet: json['activation_wallet'] == null
      //     ? 0.0
      //     : (json['activation_wallet'] is String)
      //         ? double.tryParse(json['activation_wallet']) ?? 0.0
      //         : (json['activation_wallet'] as num).toDouble(),

      // // Convert income_wallet to double
      // income_wallet: (json['income_wallet'] == null)
      //     ? 0.0
      //     : (json['income_wallet'] is String)
      //         ? double.tryParse(json['income_wallet']) ?? 0.0
      //         : (json['income_wallet'] as num).toDouble(),

      // // Keep wallet_balance as String, converting it if necessary
      // wallet_balance: json['activation_wallet'] != null
      //     ? (json['activation_wallet'] is num
      //         ? json['activation_wallet'].toString()
      //         : json['activation_wallet'].toString())
      //     : '',

      createdAt: json['created_at'] ?? '',
      // reffer_code: json['reffer_code'] ?? '',
      // rank: json['rank'] ?? '',
      image: json['image'] ?? '',
    );
  }

// Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'password': password,
      'mobile': mobile,
      'otp': otp,
      'address': address,
      'image': image,
    };
  }

  void updateImage(String newImageUrl) {
    image = newImageUrl;
  }
}
