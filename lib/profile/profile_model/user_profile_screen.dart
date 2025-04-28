// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:ambrosia_ayurved/provider/user_provider.dart';

// class UserProfileScreen extends StatefulWidget {
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   Map<String, dynamic>? userData;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserDetailss();
//   }

//   Future<void> fetchUserDetailss() async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final String loggedInUserId = userProvider.id;

//     final response = await http.get(
//       Uri.parse('http://192.168.1.9/klizard/api/fetch_user_detail'),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == true) {
//         final users = data['data'] as List;
//         final loggedInUser = users.firstWhere(
//           (user) => user['user_id'] == loggedInUserId,
//           orElse: () => null,
//         );

//         setState(() {
//           userData = loggedInUser;
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       throw Exception('Failed to load user details');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : userData != null
//               ? Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                           'Name: ${userData?['fname'] ?? ''} ${userData?['lname'] ?? ''}'),
//                       SizedBox(height: 10),
//                       Text('Email: ${userData!['email']}'),
//                       SizedBox(height: 10),
//                       Text('Mobile: ${userData!['mobile']}'),
//                       SizedBox(height: 10),
//                       Text('Address: ${userData!['address']}'),
//                     ],
//                   ),
//                 )
//               : Center(child: Text('User data not found')),
//     );
//   }
// }
