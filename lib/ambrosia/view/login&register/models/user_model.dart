class User {
  final String id;

  final String fname;
  final String lname;

  final String email;
  final String password;

  final String mobile;

  final String createdAt;

  String image;
  String otp;
  String address;

  User({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    required this.mobile,
    required this.createdAt,
    this.image = '',
    required this.otp,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'].toString(),
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      mobile: json['mobile'] ?? '',
      otp: json['otp'].toString(),
      address: json['address'] ?? '',
      createdAt: json['created_at'] ?? '',
      image: json['image'] ?? '',
    );
  }

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
