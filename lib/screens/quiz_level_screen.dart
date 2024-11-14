import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizz/models/quiz_model.dart';
import 'package:wordwizz/screens/quiz_screen.dart';
import '../providers/font_size_provider.dart';

class QuizLevelsScreen extends StatelessWidget {
  QuizLevelsScreen({super.key});

  final List<Quiz> quizzes = [
    Quiz(title: 'Quiz angielski B1', description: 'Quiz angielski B1', category: 'Słownictwo', language: 1, level: 1),
    Quiz(title: 'Quiz angielski B2', description: 'Quiz angielski B2', category: 'Słownictwo', language: 1, level: 2),
    Quiz(title: 'Quiz angielski C1', description: 'Quiz angielski C1', category: 'Słownictwo', language: 1, level: 3),
    Quiz(title: 'Quiz hiszpański B1', description: 'Quiz hiszpański B1', category: 'Słownictwo', language: 2, level: 1),
    Quiz(title: 'Quiz hiszpański B2', description: 'Quiz hiszpański B2', category: 'Słownictwo', language: 2, level: 2),
    Quiz(title: 'Quiz hiszpański C1', description: 'Quiz hiszpański C1', category: 'Słownictwo', language: 2, level: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Levels',
          style: TextStyle(fontSize: fontSizeProvider.fontSize),
        ),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return ListTile(
            title: Text(
              quiz.title,
              style: TextStyle(fontSize: fontSizeProvider.fontSize),
            ),
            subtitle: Text(
              quiz.description,
              style: TextStyle(fontSize: fontSizeProvider.fontSize),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(quiz: quiz),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
