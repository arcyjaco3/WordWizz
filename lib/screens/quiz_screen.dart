import 'package:flutter/material.dart';
import 'package:wordwizz/models/quiz_model.dart';

class QuizScreen extends StatelessWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.title),
      ),
      body: Center(
        child: Text('Tutaj pojawi się quiz: ${quiz.title}'),
      ),
    );
  }
}
