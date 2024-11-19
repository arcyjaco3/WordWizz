import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wordwizz/screens/settings_screen.dart';
import 'package:wordwizz/screens/course_screen.dart';
import 'package:wordwizz/screens/quiz_level_screen.dart'; 

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const Text('Home Screen'),
    CourseListScreen(),
    QuizLevelsScreen(), 
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
             label: 'navigation.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'navigation.courses'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'navigation.quizzes'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'navigation.settings'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800], 
        unselectedItemColor: isDarkMode ? Colors.white : Colors.black, 
        onTap: _onItemTapped,
        backgroundColor: isDarkMode ? Colors.black : Colors.white, 
        type: BottomNavigationBarType.fixed, 
      ),
    );
  }
}
