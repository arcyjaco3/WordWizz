import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Metoda do logowania za pomocą emaila i hasła
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Zwracamy zalogowanego użytkownika
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    }
  }

  // Metoda do rejestracji za pomocą emaila i hasła
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Zwracamy nowo utworzonego użytkownika
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email is already in use.');
      } else if (e.code == 'weak-password') {
        throw Exception('Password is too weak.');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    }
  }

  // Metoda do pobrania aktualnie zalogowanego użytkownika
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  // Metoda do wylogowania użytkownika
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners(); // Informujemy słuchaczy o zmianach
  }

  // Metoda do zresetowania hasła
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email.');
    }
  }
}
