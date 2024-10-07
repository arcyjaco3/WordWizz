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
  void initState() {
    super.initState();
    final fontSizeProvider = Provider.of<FontSizeProvider>(context, listen: false);
    if (fontSizeProvider.fontSize == fontSizeMap['small']) {
      _selectedFontSize = 'small';
    } else if (fontSizeProvider.fontSize == fontSizeMap['medium']) {
      _selectedFontSize = 'medium';
    } else if (fontSizeProvider.fontSize == fontSizeMap['large']) {
      _selectedFontSize = 'large';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ustawienia',
          style: TextStyle(fontSize: fontSizeProvider.fontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Tryb motywu',
                style: TextStyle(fontSize: fontSizeProvider.fontSize),
              ),
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
                    child: Text('Systemowy'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Jasny'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Ciemny'),
                  ),
                ].map((DropdownMenuItem<ThemeMode> item) {
                  return DropdownMenuItem<ThemeMode>(
                    value: item.value,
                    child: Text(
                      (item.child as Text).data!,
                      style: TextStyle(fontSize: fontSizeProvider.fontSize),
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(
                'Język',
                style: TextStyle(fontSize: fontSizeProvider.fontSize),
              ),
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
                    child: Text(
                      value,
                      style: TextStyle(fontSize: fontSizeProvider.fontSize),
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(
                'Rozmiar Czcionki',
                style: TextStyle(fontSize: fontSizeProvider.fontSize),
              ),
              trailing: DropdownButton<String>(
                value: _selectedFontSize,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFontSize = newValue!;
                    fontSizeProvider.setFontSize(fontSizeMap[_selectedFontSize]!);
                  });
                },
                items: fontSizeMap.keys
                    .map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      key,
                      style: TextStyle(fontSize: fontSizeProvider.fontSize),
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(
                'Powiadomienia',
                style: TextStyle(fontSize: fontSizeProvider.fontSize),
              ),
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
