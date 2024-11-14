import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordwizz/components/navigation_menu.dart'; //  komponent nawigacji

class HomeScreen extends StatelessWidget {
  final User? user;

  const HomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Text(
          'Witaj ${user?.email}!',
          style: const TextStyle(fontSize: 20),
        ),
      ),

      bottomNavigationBar: BottomNavigationBarScreen(),
    );
  }
}
