import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:icons_plus/icons_plus.dart'; // Importujemy ikony

import 'package:wordwizz/screens/home_screen.dart';// Import ekranu głównego (musisz go stworzyć)

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _rememberMe = false;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Dodajemy instancję FirebaseAuth

  // Funkcja logowania
  Future<void> _signInUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Logowanie przy użyciu Firebase
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!,
          password: _password!,
        );

        // Po udanym logowaniu przekieruj użytkownika na ekran główny
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: userCredential.user)),
        );

      } on FirebaseAuthException catch (e) {
        // Obsługa błędów logowania Firebase
        String message;
        if (e.code == 'user-not-found') {
          message = 'Użytkownik z tym emailem nie istnieje.';
        } else if (e.code == 'wrong-password') {
          message = 'Nieprawidłowe hasło.';
        } else {
          message = 'Wystąpił błąd: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tło i powitanie
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg1.png"), // Zmień na odpowiednią ścieżkę tła
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            // Formularz logowania
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => _email = value,
                      validator: (value) => value!.isEmpty ? 'Podaj email' : null,
                    ),
                    const SizedBox(height: 20),
                    // Hasło
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => _password = value,
                      validator: (value) => value!.isEmpty ? 'Podaj hasło' : null,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Remember me i zapomniane hasło
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            const Text("Remember me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Funkcja resetu hasła
                          },
                          child: const Text("Forget password?"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Przycisk logowania
                    ElevatedButton(
                      onPressed: _signInUser,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.purple[200], // Zmień kolor zgodnie z projektem
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Separator dla logowania przez social media
                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Sign in with"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Ikony logowania przez social media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Facebook login
                          },
                          icon: const Icon(BoxIcons.bxl_facebook_circle), // Ikona Facebook z icons_plus
                          iconSize: 40,
                          color: Colors.blue,
                        ),
                        IconButton(
                          onPressed: () {
                            // Twitter login
                          },
                          icon: const Icon(BoxIcons.bxl_twitter), // Ikona Twitter z icons_plus
                          iconSize: 40,
                          color: Colors.lightBlue,
                        ),
                        IconButton(
                          onPressed: () {
                            // Google login
                          },
                          icon: const Icon(BoxIcons.bxl_google), // Ikona Google z icons_plus
                          iconSize: 40,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Link do rejestracji
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            // Nawigacja do ekranu rejestracji
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30), // Odstęp na dole
          ],
        ),
      ),
    );
  }
}
