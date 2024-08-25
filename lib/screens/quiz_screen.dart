import 'package:flutter/material.dart';
import 'package:wordwizz/models/quiz_model.dart';

class QuizScreen extends StatelessWidget {
  final Quiz quiz;

  QuizScreen({Key? key, required this.quiz}) : super(key: key);

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
