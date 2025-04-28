/*

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String _email = '';
  // double _walletBalance = 0.0;
  // String _userId = '';
  String _id = '';

  // double get incomewallet => _user?.income_wallet ?? 0.0;
  // double get activationWallet => _user?.activation_wallet ?? 0.0;
  User? get user => _user;
  String get email => _email;
//  double get walletBalance => _walletBalance;
  // String? get userEmail => _user?.email;
  bool get isLoggedIn => _user != null;
  // String get userId => _userId;
  String get id => _id;

  void setUser(User user) {
    _user = user;
    // _walletBalance = double.tryParse(user.wallet_balance as String) ?? 0.0;
    // _userId = user.userId;
    // _id = user.id.toString(); // Assume 'id' is part of the 'user' model
    //  print('UserId from API: ${userId}');
    print('Database ID: ${_id}');
    notifyListeners();
  }

  void setid(String id) {
    _id = id;
    notifyListeners();
  }

  // void setUserId(String userId) {
  //   // Keep as String
  //   _userId = userId;
  //   notifyListeners();
  // }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void clearUser() {
    _user = null; // Clear the user data
    notifyListeners();
  }
/*
  void updateActivationWallet(double newAmount) {
    if (user != null) {
      user!.activation_wallet = newAmount;
      notifyListeners(); // Notify listeners so the UI updates
    }
  }

  void updateIncomeWallet(double amount) {
    if (_user != null) {
      _user!.income_wallet -= amount; // Deduct the amount from income_wallet
      notifyListeners(); // Notify listeners to update the UI
    }
  }

 */
//

  // void updateWalletBalance(double newBalance) {
  //   _walletBalance = newBalance;
  //   notifyListeners();
  // }

  //

/*
  Future<void> fetchWalletBalance() async {
    print('Fetching wallet balance...');
    try {
      if (_user == null) {
        print('User or email is null. Cannot fetch results.');
        return;
      }

      final userEmail = _user!.email;

      final response = await http.post(
        Uri.parse(
            'https://app.klizardtechnology.com/Signup/fetch_wallet_balance'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": userEmail}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> &&
            data.containsKey('data') &&
            data['data'] is Map<String, dynamic> &&
            data['data'].containsKey('wallet_balance')) {
          final walletBalance =
              double.tryParse(data['data']['wallet_balance']) ?? 0.0;
          updateWalletBalance(walletBalance);
        } else {
          print('Unexpected data format: ${data.runtimeType}');
        }
      } else {
        print(
            'Failed to load wallet balance. Status code: ${response.statusCode}');
        throw Exception('Failed to load wallet balance');
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
  }
*/
  void setName(String s) {
    // Implement this method if needed
  }
  // void updateImage(String newImageUrl) {
  //   if (_user != null) {
  //     _user = User(
  //       userId: _user!.userId,
  //       username: _user!.username,
  //       email: _user!.email,
  //       password: _user!.password,
  //       mobile: _user!.mobile,
  //       wallet_balance: _user!.wallet_balance,
  //       createdAt: _user!.createdAt,
  //       reffer_code: _user!.reffer_code,
  //       image: newImageUrl, // Update the image URL
  //     );
  //     notifyListeners();
  //   }
  // }
  void updateImage(String? imageUrl) {
    if (_user != null) {
      _user!.image = imageUrl ?? ''; // Update the user object
      notifyListeners(); // Notify listeners to trigger rebuilds
    }
  }
}


*/

//// old one without shared preference

/*


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/new_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String _email = '';
  String _fname = '';
  String _lname = '';
  // double _walletBalance = 0.0;
  // String _userId = '';
  String _id = '';

  // double get incomewallet => _user?.income_wallet ?? 0.0;
  // double get activationWallet => _user?.activation_wallet ?? 0.0;
  User? get user => _user;
  String get email => _email;
  String get fname => _fname;
  String get lname => _lname;
//  double get walletBalance => _walletBalance;
  // String? get userEmail => _user?.email;
  bool get isLoggedIn => _user != null;

  // String get userId => _userId;
  String get id => _id;

  void setUser(User user) {
    _user = user;
    // _walletBalance = double.tryParse(user.wallet_balance as String) ?? 0.0;
    // _userId = user.userId;
    //  _id = user.id.toString(); // Assume 'id' is part of the 'user' model
    //   print('UserId from API: ${userId}');
    _id = user.id;
    _email = user.email;
    _fname = user.fname;
    _lname = user.lname;
    print('Database ID: ${_id}');
    notifyListeners();
  }

  void setid(String id) {
    _id = id;
    notifyListeners();
  }

  void setfname(String fname) {
    _fname = fname;

    void setLname(String lname) {
      _lname = lname;
      notifyListeners();
    }

    // void setUserId(String userId) {
    //   // Keep as String
    //   _userId = userId;
    //   notifyListeners();
    // }

    void setEmail(String email) {
      _email = email;
      notifyListeners();
    }

    void clearUser() {
      _user = null; // Clear the user data
      notifyListeners();
    }
/*
  void updateActivationWallet(double newAmount) {
    if (user != null) {
      user!.activation_wallet = newAmount;
      notifyListeners(); // Notify listeners so the UI updates
    }
  }

  void updateIncomeWallet(double amount) {
    if (_user != null) {
      _user!.income_wallet -= amount; // Deduct the amount from income_wallet
      notifyListeners(); // Notify listeners to update the UI
    }
  }

 */
//

    // void updateWalletBalance(double newBalance) {
    //   _walletBalance = newBalance;
    //   notifyListeners();
    // }

    //

/*
  Future<void> fetchWalletBalance() async {
    print('Fetching wallet balance...');
    try {
      if (_user == null) {
        print('User or email is null. Cannot fetch results.');
        return;
      }

      final userEmail = _user!.email;

      final response = await http.post(
        Uri.parse(
            'https://app.klizardtechnology.com/Signup/fetch_wallet_balance'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"email": userEmail}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> &&
            data.containsKey('data') &&
            data['data'] is Map<String, dynamic> &&
            data['data'].containsKey('wallet_balance')) {
          final walletBalance =
              double.tryParse(data['data']['wallet_balance']) ?? 0.0;
          updateWalletBalance(walletBalance);
        } else {
          print('Unexpected data format: ${data.runtimeType}');
        }
      } else {
        print(
            'Failed to load wallet balance. Status code: ${response.statusCode}');
        throw Exception('Failed to load wallet balance');
      }
    } catch (e) {
      print('Error fetching wallet balance: $e');
    }
  }
*/
    void setName(String s) {
      // Implement this method if needed
    }
    // void updateImage(String newImageUrl) {
    //   if (_user != null) {
    //     _user = User(
    //       userId: _user!.userId,
    //       username: _user!.username,
    //       email: _user!.email,
    //       password: _user!.password,
    //       mobile: _user!.mobile,
    //       wallet_balance: _user!.wallet_balance,
    //       createdAt: _user!.createdAt,
    //       reffer_code: _user!.reffer_code,
    //       image: newImageUrl, // Update the image URL
    //     );
    //     notifyListeners();
    //   }
    // }
    void updateImage(String? imageUrl) {
      if (_user != null) {
        _user!.image = imageUrl ?? ''; // Update the user object
        notifyListeners(); // Notify listeners to trigger rebuilds
      }
    }
/*
  void updateImage(String? imageUrl) {
    if (_user != null) {
      _user = User(
        id: _user!.id,
        fname: _user!.fname,
        lname: _user!.lname,
        email: _user!.email,
        password: _user!.password,
        mobile: _user!.mobile,
        otp: _user!.otp,
        address: _user!.address,
        image: imageUrl ?? '',
      );
      notifyListeners();
    }
  }
*/
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');

    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
      print('User data loaded: $_user'); // Debug print
      notifyListeners(); // Ensure UI updates when data is loaded
    }
  }

  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    _user = user;
    notifyListeners(); // Notify UI
  }

  // // Clear user data from shared_preferences
  // Future<void> clearUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('user_data'); // Remove user data
  //   await prefs.remove('isLoggedIn'); // Remove login status
  // }

  // logout
  void logout(BuildContext context) async {
    // Clear user data from the provider
    _user = null;
    _email = '';
    _fname = '';
    _lname = '';
    _id = '';

    // Optionally, clear the data from SharedPreferences as well
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // This removes the saved user data

    // Notify listeners to update the UI
    notifyListeners();

    // You can also show a snackbar message on successful logout

    // Optionally, navigate to the login screen after logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}


*/

// new one with shared preference working

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/home/home_screen.dart';
import 'package:ambrosia_ayurved/home/signin.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/new_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String _id = '';
  String _email = '';
  String _fname = '';
  String _lname = '';

  // Getters with fallback values
  String get id {
    if (_id.isEmpty && _user != null) {
      _id = _user!.id;
    }
    return _id;
  }

  String get email {
    if (_email.isEmpty && _user != null) {
      _email = _user!.email;
    }
    return _email;
  }

  String get fname {
    if (_fname.isEmpty && _user != null) {
      _fname = _user!.fname;
    }
    return _fname;
  }

  String get lname {
    if (_lname.isEmpty && _user != null) {
      _lname = _user!.lname;
    }
    return _lname;
  }

  User? get user => _user;

  bool get isLoggedIn => _user != null && id.isNotEmpty;

  void setUser(User user) {
    _user = user;
    _id = user.id;
    _email = user.email;
    _fname = user.fname;
    _lname = user.lname;
    notifyListeners();
  }

  Future<void> loadUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');

      if (userData != null) {
        Map<String, dynamic> userMap = jsonDecode(userData);
        _user = User.fromJson(userMap);

        // Explicitly set all user details
        _id = _user?.id ?? '';
        _email = _user?.email ?? '';
        _fname = _user?.fname ?? '';
        _lname = _user?.lname ?? '';

        print('User data loaded successfully');
        print('User ID: $_id');
        print('User Email: $_email');

        notifyListeners();
      } else {
        print('No user data found in preferences');
        _user = null;
        _id = '';
        _email = '';
        _fname = '';
        _lname = '';
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
      _user = null;
      _id = '';
      _email = '';
      _fname = '';
      _lname = '';
      notifyListeners();
    }
  }

  Future<void> saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(user.toJson()));

      setUser(user);
      print('User data saved successfully');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  void logout(BuildContext context) async {
    // Clear user data from the provider
    _user = null;
    _id = '';
    _email = '';
    _fname = '';
    _lname = '';

    // Clear from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    notifyListeners();

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }
}
