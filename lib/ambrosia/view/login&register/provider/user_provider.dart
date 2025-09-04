import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/ambrosia/view/home/home_screen.dart';
import 'package:ambrosia_ayurved/ambrosia/view/login&register/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // _email = user.email;
    _fname = user.fname;
    // _lname = user.lname;
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
