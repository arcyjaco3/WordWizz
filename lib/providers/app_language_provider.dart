import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  Locale _appLocale = const Locale("en");

  Locale get appLocale => _appLocale;

  Future<void> fetchLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');

    // Ustaw język domyślny na angielski, jeśli brak zapisanej preferencji
    if (languageCode == null) {
      _appLocale = const Locale('en');
    } else {
      _appLocale = Locale(languageCode);
    }

    notifyListeners();
  }

  Future<void> changeLanguage(Locale type) async {
    final prefs = await SharedPreferences.getInstance();

    if (_appLocale == type) {
      return; // Jeśli język już jest ustawiony, nic nie rób
    }

    // Obsługa języków: polski, angielski, hiszpański
    if (type == const Locale("pl")) {
      _appLocale = const Locale("pl");
      await prefs.setString('language_code', 'pl');
      await prefs.setString('countryCode', 'PL');
    } else if (type == const Locale("es")) {
      _appLocale = const Locale("es");
      await prefs.setString('language_code', 'es');
      await prefs.setString('countryCode', 'ES');
    } else {
      _appLocale = const Locale("en"); // Domyślnie angielski
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }

    notifyListeners();
  }
}
