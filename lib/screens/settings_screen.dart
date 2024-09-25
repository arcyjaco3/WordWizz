import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/font_size_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'Polski';
  String _selectedFontSize = 'medium'; 

  final Map<String, double> fontSizeMap = {
    'small': 12.0,
    'medium': 16.0,
    'large': 20.0,
  };

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontSizeProvider = Provider.of<FontSizeProvider>(context); // Poprawne uzyskanie instancji

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ustawienia',
          style: TextStyle(fontSize: fontSizeProvider.fontSize), // Dynamiczny rozmiar tytułu
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wybór trybu motywu
            ListTile(
              title: const Text('Tryb motywu'),
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                onChanged: (ThemeMode? newValue) {
                  if (newValue != null) {
                    themeProvider.toggleTheme(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('Systemowy'
                    ), // Brak dynamicznej czcionki tutaj
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Jasny'), // Brak dynamicznej czcionki tutaj
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Ciemny'), // Brak dynamicznej czcionki tutaj
                  ),
                ],
              ),
            ),

            // Zmiana języka
            ListTile(
              title: const Text('Język'),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
                items: <String>['Polski', 'English', 'Español']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),

            // Zmiana rozmiaru czcionki (z przypisanymi wartościami)
            ListTile(
              title: const Text('Rozmiar Czcionki'),
              trailing: DropdownButton<String>(
                value: _selectedFontSize,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFontSize = newValue!;
                    fontSizeProvider.setFontSize(fontSizeMap[_selectedFontSize]!); // Aktualizacja FontSizeProvider
                  });
                },
                items: fontSizeMap.keys
                    .map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(key), // Wyświetl nazwy: small, medium, large
                  );
                }).toList(),
              ),
            ),

            // Włączenie/wyłączenie powiadomień
            ListTile(
              title: const Text('Powiadomienia'),
              trailing: Switch(
                value: true,
                onChanged: (bool value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
