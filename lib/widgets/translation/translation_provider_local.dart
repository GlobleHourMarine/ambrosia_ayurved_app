import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; // Import Get if not already imported

class LanguageProvider extends ChangeNotifier {
  static const List<Map<String, dynamic>> languages = [
    {
      'name': 'English',
      'locale': 'en',
    },
    {
      'name': 'Malyasia',
      'locale': 'ms',
    },
  ];

  late Locale _selectedLocale;

  Locale get selectedLocale => _selectedLocale;

  LanguageProvider() {
    _selectedLocale = Locale('en');
    loadSavedLocale();
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('selected_locale');
    if (savedLocale != null) {
      _selectedLocale = Locale(savedLocale);
      // Also update Get.locale to keep both systems in sync
      Get.updateLocale(_selectedLocale);
      notifyListeners();
    }
  }

  void changeLanguage(String language) async {
    // print("🌐 Changing language to: $language");
    _selectedLocale = Locale(language);

    // Update Get.locale to keep both systems in sync
    Get.updateLocale(_selectedLocale);

    // Make sure to notify listeners before saving to SharedPreferences
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_locale', language);

    // Force rebuild of the entire app
    Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
