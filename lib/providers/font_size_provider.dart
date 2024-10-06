import 'package:flutter/material.dart';

class FontSizeProvider extends ChangeNotifier {
  double _fontSize = 16.0; // Domyślny rozmiar czcionki

  double get fontSize => _fontSize;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners();
  }
}