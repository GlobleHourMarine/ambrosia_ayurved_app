// import 'package:flutter/foundation.dart';

// class Address extends ChangeNotifier {
//   String _name = '';
//   String _mobileNumber = '';
//   String _pincode = '';
//   String _locality = '';
//   String _address = '';
//   String _city = '';
//   String _state = '';
//   String _district = '';
//   String _landmark = '';
//   String _alternatePhone = '';
//   String _addressType = 'Home';

//   // Getters
//   String get name => _name;
//   String get mobileNumber => _mobileNumber;
//   String get pincode => _pincode;
//   String get locality => _locality;
//   String get address => _address;
//   String get city => _city;
//   String get state => _state;
//   String get district => _district;
//   String get landmark => _landmark;
//   String get alternatePhone => _alternatePhone;
//   String get addressType => _addressType;

//   // Setters with notifyListeners()
//   set name(String value) {
//     _name = value;
//     notifyListeners();
//   }

//   set mobileNumber(String value) {
//     _mobileNumber = value;
//     notifyListeners();
//   }

//   set pincode(String value) {
//     _pincode = value;
//     notifyListeners();
//   }

//   set locality(String value) {
//     _locality = value;
//     notifyListeners();
//   }

//   set address(String value) {
//     _address = value;
//     notifyListeners();
//   }

//   set city(String value) {
//     _city = value;
//     notifyListeners();
//   }

//   set state(String value) {
//     _state = value;
//     notifyListeners();
//   }

//   set district(String value) {
//     _district = value;
//     notifyListeners();
//   }

//   set landmark(String value) {
//     _landmark = value;
//     notifyListeners();
//   }

//   set alternatePhone(String value) {
//     _alternatePhone = value;
//     notifyListeners();
//   }

//   set addressType(String value) {
//     _addressType = value;
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';

class Address extends ChangeNotifier {
  String _pincode = '';
  String _state = '';
  String _district = '';
  String _city = '';

  // Getters
  String get pincode => _pincode;
  String get state => _state;
  String get district => _district;
  String get city => _city;

  // Setters
  set pincode(String value) {
    _pincode = value;
    notifyListeners();
  }

  set state(String value) {
    _state = value;
    notifyListeners();
  }

  set district(String value) {
    _district = value;
    notifyListeners();
  }

  set city(String value) {
    _city = value;
    notifyListeners();
  }
}
