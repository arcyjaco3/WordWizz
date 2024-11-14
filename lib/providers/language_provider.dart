import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
    Locale _applocale = const Locale("en");

    Locale get appLocal => _appLocale;
    fetchLocale() async {
      
    }
}
