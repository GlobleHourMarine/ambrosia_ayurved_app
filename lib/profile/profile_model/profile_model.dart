// class ProfileModel {
//   final String userId; // User ID (not shown to user)
//   final String otp; // OTP (not shown to user)
//   final String password; // Password (not shown to user)
//   final String fname; // First Name
//   final String lname; // Last Name
//   final String mobile; // Mobile number
//   final String email; // Email
//   final String address; // Address

//   ProfileModel({
//     required this.userId,
//     required this.otp,
//     required this.password,
//     required this.fname,
//     required this.lname,
//     required this.mobile,
//     required this.email,
//     required this.address,
//   });

//   factory ProfileModel.fromJson(Map<String, dynamic> json) {
//     return ProfileModel(
//       userId: json['userId'] ?? '',
//       otp: json['otp'] ?? '',
//       password: json['password'] ?? '',
//       fname: json['fname'] ?? '',
//       lname: json['lname'] ?? '',
//       mobile: json['mobile'] ?? '',
//       email: json['email'] ?? '',
//       address: json['address'] ?? '',
//     );
//   }
// }
