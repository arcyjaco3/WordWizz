import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizz/screens/settings_screen.dart';
import 'package:wordwizz/screens/course_screen.dart';
import 'package:wordwizz/screens/quiz_level_screen.dart';
import '../providers/font_size_provider.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    _widgetOptions = <Widget>[
      Center(
        child: Text(
          'Home Screen',
          style: TextStyle(fontSize: fontSizeProvider.fontSize),
        ),
      ),
      CourseListScreen(),
      QuizLevelsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: isDarkMode ? Colors.white : Colors.black,
        onTap: _onItemTapped,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: fontSizeProvider.fontSize),
        unselectedLabelStyle: TextStyle(fontSize: fontSizeProvider.fontSize - 2),
      ),
    );
  }
}
