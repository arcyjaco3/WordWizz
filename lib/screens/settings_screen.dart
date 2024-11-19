import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/font_size_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final Map<String, double> fontSizeMap = {
    'small': 12.0,
    'medium': 16.0,
    'large': 20.0,
  };

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr()), // Tytuł z tłumaczenia
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sekcja: Tryb motywu
            ListTile(
              title: Text('settings.theme_mode'.tr()),
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                onChanged: (ThemeMode? newValue) {
                  if (newValue != null) {
                    themeProvider.toggleTheme(newValue);
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('settings.theme.system'.tr()),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('settings.theme.light'.tr()),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('settings.theme.dark'.tr()),
                  ),
                ],
              ),
            ),

            // Sekcja: Język
            ListTile(
              title: Text('settings.language'.tr()),
              trailing: DropdownButton<Locale>(
                value: context.locale,
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    context.setLocale(newLocale);
                  }
                },
                items: context.supportedLocales.map((locale) {
                  return DropdownMenuItem<Locale>(
                    value: locale,
                    child: Text(
                      locale.languageCode == 'en'
                          ? 'English'
                          : locale.languageCode == 'pl'
                              ? 'Polski'
                              : 'Español',
                    ),
                  );
                }).toList(),
              ),
            ),

            // Sekcja: Rozmiar czcionki
            ListTile(
              title: Text('settings.font_size'.tr()),
              trailing: DropdownButton<String>(
                value: fontSizeMap.keys.firstWhere(
                  (key) => fontSizeMap[key] == fontSizeProvider.fontSize,
                  orElse: () => 'medium', // Domyślnie "medium"
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    fontSizeProvider.setFontSize(fontSizeMap[newValue]!);
                  }
                },
                items: fontSizeMap.keys.map((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(
                      'settings.font_size.$key'.tr(),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Sekcja: Powiadomienia (przykład)
            ListTile(
              title: Text('settings.notifications'.tr()),
              trailing: Switch(
                value: true, // Placeholder
                onChanged: (bool value) {
                  // Obsługa przełącznika
                  print('Notifications toggled: $value');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
