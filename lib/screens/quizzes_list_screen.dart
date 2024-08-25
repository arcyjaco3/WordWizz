import 'package:flutter/material.dart';
import 'package:wordwizz/models/quiz_model.dart';
import 'package:wordwizz/screens/quiz_screen.dart';

class QuizzesListScreen extends StatelessWidget {
  final String level;

  QuizzesListScreen({super.key, required this.level});

  // Przechowywanie listy quizów wewnątrz tej klasy
  final List<Quiz> quizzes = [
    Quiz(title: 'Podstawowe słówka', description: 'Podstawowe słówka dla poziomu A1', category: 'Słownictwo', level: 'A1'),
    Quiz(title: 'Podstawy gramatyki', description: 'Zasady gramatyki dla początkujących', category: 'Gramatyka', level: 'A1'),
    Quiz(title: 'Rozbudowane słownictwo', description: 'Rozbudowane słownictwo dla poziomu A2', category: 'Słownictwo', level: 'A2'),
    // Dodaj więcej quizów...
  ];

  @override
  Widget build(BuildContext context) {
    final List<Quiz> quizzesForLevel = getQuizzesForLevel(level);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes for $level'),
      ),
      body: ListView.builder(
        itemCount: quizzesForLevel.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(quizzesForLevel[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen(quiz: quizzesForLevel[index])),
              );
            },
          );
        },
      ),
    );
  }

  List<Quiz> getQuizzesForLevel(String level) {
    // Filtracja quizów według poziomu
    return quizzes.where((quiz) => quiz.level == level).toList();
  }
}
