import 'package:flutter/material.dart';
import 'package:wordwizz/models/quiz_model.dart';

class QuizLevelsScreen extends StatelessWidget {
  QuizLevelsScreen({super.key});

  final List<Quiz> quizzes = [
    Quiz(title: 'Podstawowe słówka', description: 'Podstawowe słówka dla poziomu A1', category: 'Słownictwo', level: 'A1'),
    Quiz(title: 'Podstawy gramatyki', description: 'Zasady gramatyki dla początkujących A1', category: 'Gramatyka', level: 'A1'),
    Quiz(title: 'Rozbudowane słownictwo', description: 'Rozbudowane słownictwo dla poziomu A2', category: 'Słownictwo', level: 'A2'),
    // Dodaj więcej quizów...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Levels'),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return ListTile(
            title: Text(quiz.title),
            subtitle: Text(quiz.description),
            onTap: () {
              // Działanie po kliknięciu na quiz
            },
          );
        },
      ),
    );
  }
}

